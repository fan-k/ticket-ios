//
//  RechargeController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "RechargeController.h"
#import "FanTextField.h"
#import "PassWordView.h"

@interface RechargeController ()
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UILabel *chanceTitleLb;
@property (nonatomic ,strong) UILabel *chanceDescLb;
@property (nonatomic ,strong) FanImageView *chanceImg;
@property (nonatomic ,strong) UILabel *chanceLineLb;
@property (nonatomic ,strong) UILabel *amountTitleLb;
@property (nonatomic ,strong) UILabel *amountIconLb;
@property (nonatomic ,strong) FanTextField *amountTextField;
@property (nonatomic ,strong) UILabel *amountLineLb;
@property (nonatomic ,strong) UILabel *cardDescLb;
@property (nonatomic ,strong) UILabel *alertcLb;
@property (nonatomic ,strong) UILabel *allCashLb;
@property (nonatomic ,strong) FanImageView *chargeImg;
@property (nonatomic ,strong) UILabel *chargeLb;

@property (nonatomic ,strong) UIButton *button;

@property (nonatomic ,strong) BankCardModel *bankModel;
@property (nonatomic ,strong) BankCardModel *currentModel;
@property (nonatomic ,strong) NSMutableDictionary *custom_params;


@property (nonatomic ,strong) ChanceBankView *chanceBankView;

@property (nonatomic ,strong) FanPayAlertView *payAlertView;


@end
@implementation RechargeController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = [self.type isEqualToString:@"recharge"]? @"余额充值" :@"余额提现";
    [self.view addSubview:self.bgView];
    if ([self.type isEqualToString:@"cash"]) {
        [self.view addSubview:self.chargeImg];
        [self.view addSubview:self.chargeLb];
    }
    [self.view addSubview:self.button];
    //1 先获取充值配置  2选择默认银行卡  3 构建银行卡列表选择器 4充值页面填充 5 充值提交 6充值结果
    [self initConfig];
}
- (void)initConfig{
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    [self requestWithUrl: [self.type isEqualToString:@"recharge"] ? FanUrlUserRechargeConfig :FanUrlUserCashConfig  loading:YES error:FanErrorTypeError];
}
- (void)buttonMethod{
     [self.view endEditing:YES];
    //1 判断是否选择了银行卡 _custom_params[@"bankid"]
    if (![_custom_params.allKeys containsObject:@"bankid"]) {
        [FanAlert alertErrorWithMessage:[NSString stringWithFormat:@"您尚未选择%@方式",[self.type isEqualToString:@"recharge"] ? @"充值" :@"提现"]];
        return;
    }
    //2 判断输入的金额 是否满足条件 已通过managerLimit 限制
    //3 判断网络
    if (![FanRequestTool net]) {
        [FanAlert alertErrorWithMessage:@"您网络连接不好,请稍后再试"];
        return;
    }
    //4 调取支付密码视图 填写密码  密码输入完成掉接口
    self.payAlertView  = [[FanPayAlertView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT) message:[self.type isEqualToString:@"cash"] ? @"提现金额":@"充值金额" money:self.amountTextField.text];
    [self.view addSubview:self.payAlertView];
    __weak RechargeController *weakSelf = self;
    self.payAlertView.customActionBlock = ^(id obj, cat_action_type idx) {
        if (idx == cat_forget) {//忘记密码
            [weakSelf pushViewControllerWithUrl:@"VerificateInfoController?type=card" transferData:nil hander:nil];
            [weakSelf.payAlertView removeFromSuperview];
             weakSelf.payAlertView = nil;
        }else if (idx == cat_close){
            [weakSelf.payAlertView removeFromSuperview];
            weakSelf.payAlertView = nil;
        }else if (idx == cat_input_password){
            //提交验证
            [weakSelf cashOrRechargeWithPwd:obj];
        }
    };
}
- (void)cashOrRechargeWithPwd:(NSString *)pwd{
    //bankid 默认已添加
    self.params[@"pwd"] = pwd;
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    self.params[@"amount"] = self.amountTextField.text;
    [self requestWithUrl:[self.type isEqualToString:@"cash"] ? FanUrlUserCash : FanUrlUserRecharge loading:NO];
}
/**全部提现*/
- (void)allCash{
     [self.view endEditing:YES];
    self.amountTextField.text = [FanWallet shareInstance].walletModel.balance;
}

/**选择银行卡*/
- (void)chanceBank{
    [self.view endEditing:YES];
    self.chanceBankView.hidden = NO;
}
/**处理限额*/
- (BOOL)managerLimit{
    if ([self.type isEqualToString:@"cash"]) {
        self.chargeImg.hidden = self.chargeLb.hidden  = !self.amountTextField.text.length;
    }
    if ([self.amountTextField.text floatValue] <= 0) {
        self.cardDescLb.hidden  = NO;
        self.alertcLb.hidden = YES;
        return NO;
    }
    
    if ([self.type isEqualToString:@"recharge"]) {
        //充值 额度不能超过卡牌的单次限额
        if ([self.amountTextField.text floatValue] > [self.currentModel.limitOnce floatValue]) {
            //超出额度
            self.alertcLb.text = @"输入的金额已超出可用额度";
            self.cardDescLb.hidden  = YES;
            self.alertcLb.hidden = NO;
            return NO;
        }else{
            self.cardDescLb.hidden  = NO;
            self.alertcLb.hidden = YES;
        }
    }else{
        //提现 提现金额不能超过钱包余额
        if([self.amountTextField.text floatValue] > [[FanWallet shareInstance].walletModel.balance floatValue]){
            //超出金额
            self.alertcLb.text = @"输入的金额已超出可提现金额";
            self.cardDescLb.hidden  = YES;
            self.alertcLb.hidden = NO;
            return NO;
        }else{
            self.cardDescLb.hidden  = NO;
            self.alertcLb.hidden = YES;
        }
        self.chargeLb.text = [NSString stringWithFormat:@"本次服务费￥%.2f",self.currentModel.chargeCount];
    }
    return YES;
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlUserCash] || [item.url isEqualToString:FanUrlUserRecharge]) {
        //密码错误 或无网络
        if ([DICTION_OBJECT(item.responseObject, @"code") isEqualToString:code_112]) {
            self.payAlertView.resultActionBlock(@"", cat_error_net);
        }else if ([DICTION_OBJECT(item.responseObject, @"code") isEqualToString:code_2001]) {
            self.payAlertView.resultActionBlock(@"", cat_error_pwd);
        }else{
            //如果是充值 判断银行卡余额
            if ([item.url isEqualToString:FanUrlUserRecharge]) {
                if ([DICTION_OBJECT(item.responseObject, @"code") isEqualToString:code_2002]) {
                    [FanAlert showAlertControllerWithTitle:@"此卡余额不足,请选择其他银行卡支付" message:nil _cancletitle_:@"知道了" _confirmtitle_:nil handler1:nil handler2:nil];
                    return;
                }
            }
            [self.payAlertView removeFromSuperview];
            self.payAlertView = nil;
            //进入结果页面
            [self pushViewControllerWithUrl:[NSString stringWithFormat:@"ResultController?type=%@",DICTION_OBJECT(self.urlParams, @"type")] transferData:item.responseObject hander:nil];
        }
    }
    
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlUserRechargeConfig]) {//充值配置
        self.bankModel = [BankCardModel modelWithJson:item.responseObject];
        _custom_params = [NSMutableDictionary dictionary];
        if (self.bankModel.contentList.count) {
            BankCardModel *first = self.bankModel.contentList[0];
            first.isSelected = YES;
            self.currentModel = first;
            self.chanceDescLb.text = first.title;
            _custom_params[@"bankid"] = first.o_id;
            _cardDescLb.text = [NSString stringWithFormat:@"此卡本次可充值￥%@",first.limitOnce];
        }
      
    }else if ([item.url isEqualToString:FanUrlUserCashConfig]) {//提现配置
        self.bankModel = [BankCardModel modelWithJson:item.responseObject];
        _custom_params = [NSMutableDictionary dictionary];
        if (self.bankModel.contentList.count) {
            BankCardModel *first = self.bankModel.contentList[0];
            first.isSelected = YES;
            self.currentModel = first;
            self.chanceDescLb.text = first.title;
            _custom_params[@"bankid"] = first.o_id;
        }
        _cardDescLb.text = [NSString stringWithFormat:@"可提现余额￥%@",[FanWallet shareInstance].walletModel.balance];
      
    }else if ([item.url isEqualToString:FanUrlUserCash] || [item.url isEqualToString:FanUrlUserRecharge]) {
        //更新钱包信息
        [FanWallet updateWalletWithCompleteBlock:nil];
        [self.payAlertView removeFromSuperview];
        self.payAlertView = nil;
        //进入结果页面
        [self pushViewControllerWithUrl:[NSString stringWithFormat:@"ResultController?type=%@",DICTION_OBJECT(self.urlParams, @"type")] transferData:item.responseObject hander:nil];
    }
}
- (FanImageView *)chargeImg{
    if (!_chargeImg) {
        _chargeImg = [[FanImageView alloc] initWithFrame:CGRectMake(15, _bgView.bottom + 10, 20, 20)];
        _chargeImg.image = IMAGE_WITH_NAME(@"home_order_img");
        _chargeImg.hidden = YES;
        __weak RechargeController *weakSelf = self;
        _chargeImg.viewClickBlock = ^(id obj, cat_action_type idx) {
            //服务费说明提示
            NSString *string  =[NSString stringWithFormat:@"您提现使用的银行卡需收取提现服务费\n 本次提现金额￥%.2f\n 本次服务费￥%.2f",weakSelf.currentModel.amountCount,weakSelf.currentModel.chargeCount];
            [FanAlert showAlertControllerWithTitle:@"温馨提示" message:string _cancletitle_:nil _confirmtitle_:@"知道了" handler1:nil handler2:nil];
        };
    }return _chargeImg;
}
- (UILabel *)chargeLb{
    if (!_chargeLb) {
        _chargeLb = [UILabel new];
        _chargeLb.textColor = COLOR_PATTERN_STRING(@"_212121_color");
        _chargeLb.font = FanFont(14);
        _chargeLb.frame = CGRectMake(_chargeImg.right, _chargeImg.top, 200, 20);
        _chargeLb.hidden = YES;
    }return _chargeLb;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.frame = CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, 215);
        _bgView.backgroundColor = COLOR_PATTERN_STRING(@"_ffffff_color");
        [_bgView addSubview:self.chanceTitleLb];
        [_bgView addSubview:self.chanceImg];
        [_bgView addSubview:self.chanceDescLb];
        [_bgView addSubview:self.chanceLineLb];
        [_bgView addSubview:self.amountTitleLb];
        [_bgView addSubview:self.amountIconLb];
        [_bgView addSubview:self.amountTextField];
        [_bgView addSubview:self.amountLineLb];
        [_bgView addSubview:self.cardDescLb];
        [_bgView addSubview:self.alertcLb];
        if ([self.type isEqualToString:@"cash"]) {
            [_bgView addSubview:self.allCashLb];
        }
        _bgView.height = _cardDescLb.bottom + 15;
    }return _bgView;
}
- (UILabel *)allCashLb{
    if (!_allCashLb) {
        _allCashLb = [UILabel new];
        _allCashLb.text = @"全部提现";
        _allCashLb.textColor = COLOR_PATTERN_STRING(@"_red_color");
        _allCashLb.font = FanFont(13);
        _allCashLb.frame = CGRectMake(FAN_SCREEN_WIDTH - 15 - 100, _amountLineLb.bottom + 15, 100, 20);
        _allCashLb.textAlignment = NSTextAlignmentRight;
        __weak RechargeController *weakSelf = self;
        _allCashLb.viewClickBlock = ^(id obj, cat_action_type idx) {
            [weakSelf allCash];
        };
    }return _allCashLb;
}
- (UILabel *)alertcLb{
    if (!_alertcLb) {
        _alertcLb = [UILabel new];
        _alertcLb.text = @"";
        _alertcLb.textColor = COLOR_PATTERN_STRING(@"_red_color");
        _alertcLb.font = FanFont(15);
        _alertcLb.frame = CGRectMake(15, _amountLineLb.bottom + 15, FAN_SCREEN_WIDTH - 130, 20);
        _alertcLb.hidden = YES;
    }return _alertcLb;
}
- (UILabel *)cardDescLb{
    if (!_cardDescLb) {
        _cardDescLb = [UILabel new];
        _cardDescLb.text = @"";
        _cardDescLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _cardDescLb.font = FanFont(15);
        _cardDescLb.frame = CGRectMake(15, _amountLineLb.bottom + 15, FAN_SCREEN_WIDTH - 130, 20);
    }return _cardDescLb;
}
- (FanTextField *)amountTextField{
    if (!_amountTextField) {
        _amountTextField = [[FanTextField alloc] initWithFrame:CGRectMake(self.amountIconLb.right + 5, self.amountTitleLb.bottom + 15, FAN_SCREEN_WIDTH - self.amountIconLb.right - 20, 45)];
        _amountTextField.font = FanBoldFont(36);
        _amountTextField.fan_placeholder = @"请输入金额";
        __weak RechargeController *weakSelf = self;
        _amountTextField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_textfield_content_changed_nil || idx  == cat_textfield_content_changed_unnil) {
                weakSelf.currentModel.amountCount = [weakSelf.amountTextField.text floatValue];
                //处理限额
                if ([weakSelf managerLimit]) {
                    [weakSelf.button setBackgroundColor:COLOR_PATTERN_STRING(@"_yellow_color")];
                    weakSelf.button.userInteractionEnabled = YES;
                }else{
                    [weakSelf.button setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
                    weakSelf.button.userInteractionEnabled = NO;
                }
            }
            
        };
    }return _amountTextField;
}
- (UILabel *)amountIconLb{
    if (!_amountIconLb) {
        _amountIconLb = [UILabel new];
        _amountIconLb.text = @"￥";
        _amountIconLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _amountIconLb.font = FanFont(30);
        _amountIconLb.frame = CGRectMake(15, _amountTitleLb.bottom + 25, 30, 30);
    }return _amountIconLb;
}
- (UILabel *)amountTitleLb{
    if (!_amountTitleLb) {
        _amountTitleLb = [UILabel new];
        _amountTitleLb.text = [self.type isEqualToString:@"cash"]? @"提现金额":@"充值金额";
        _amountTitleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _amountTitleLb.font = FanFont(13);
        _amountTitleLb.frame = CGRectMake(15, _chanceLineLb.bottom + 15, 100, 20);
    }return _amountTitleLb;
}
- (UILabel *)amountLineLb{
    if (!_amountLineLb) {
        _amountLineLb = [UILabel new];
        _amountLineLb.frame = CGRectMake(15, 155, FAN_SCREEN_WIDTH -  30, FAN_LINE_HEIGHT);
        _amountLineLb.backgroundColor = COLOR_PATTERN_STRING(@"_line_color");
    }return _amountLineLb;
}
- (UILabel *)chanceLineLb{
    if (!_chanceLineLb) {
        _chanceLineLb = [UILabel new];
        _chanceLineLb.frame = CGRectMake(15, 50, FAN_SCREEN_WIDTH -  30, FAN_LINE_HEIGHT);
        _chanceLineLb.backgroundColor = COLOR_PATTERN_STRING(@"_line_color");
    }return _chanceLineLb;
}
- (UILabel *)chanceTitleLb{
    if (!_chanceTitleLb) {
        _chanceTitleLb = [UILabel new];
        _chanceTitleLb.frame = CGRectMake(15, 15, 100, 20);
        _chanceTitleLb.font = FanFont(15);
        _chanceTitleLb.text = [self.type isEqualToString:@"cash"] ? @"提现方式":@"充值方式";
        _chanceTitleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
    }return _chanceTitleLb;
}
- (UILabel *)chanceDescLb{
    if (!_chanceDescLb) {
        _chanceDescLb = [UILabel new];
        _chanceDescLb.frame = CGRectMake(_chanceTitleLb.right, 15, _chanceImg.left - _chanceTitleLb.right - 10, 20);
        _chanceDescLb.font = FanFont(15);
        _chanceDescLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _chanceDescLb.textAlignment = NSTextAlignmentRight;
        __weak RechargeController *weakSelf = self;
        _chanceDescLb.viewClickBlock = ^(id obj, cat_action_type idx) {
            [weakSelf chanceBank];
        };
    }return _chanceDescLb;
}
- (FanImageView *)chanceImg{
    if (!_chanceImg) {
        _chanceImg = [FanImageView new];
        UIImage *image = [UIImage imageNamed:@"cell_accessView"];
        _chanceImg.frame = CGRectMake(FAN_SCREEN_WIDTH - 15 - image.size.width, 25 - image.size.height/2, image.size.width, image.size.height);
        _chanceImg.image = image;
        __weak RechargeController *weakSelf = self;
        _chanceImg.viewClickBlock = ^(id obj, cat_action_type idx) {
            [weakSelf chanceBank];
        };
    }return _chanceImg;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(15, _bgView.bottom + 50 , FAN_SCREEN_WIDTH - 30, 44);
        [_button setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        [_button  setTitle:[self.type isEqualToString:@"cash"]?@"两小时到账,确认提现":@"确认充值" forState:UIControlStateNormal];
        [_button setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:UIControlStateNormal];
        [_button.titleLabel setFont:FanFont(17)];
        _button.layer.cornerRadius = 3;
        _button.layer.masksToBounds = YES;
        [_button addTarget:self action:@selector(buttonMethod) forControlEvents:UIControlEventTouchUpInside];
        _button.userInteractionEnabled = NO;
    }return _button;
}
- (NSString *)type{
    if (!_type) {
        _type = [NSString stringWithFormat:@"%@",DICTION_OBJECT(self.urlParams, @"type")];
    }return _type;
}

- (ChanceBankView *)chanceBankView{
    if (!_chanceBankView) {
        _chanceBankView = [[ChanceBankView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT)];
        _chanceBankView.model = self.bankModel;
        __weak RechargeController *weakSelf = self;
        _chanceBankView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_cell_click) {
                weakSelf.chanceBankView.hidden = YES;
                if ([obj isKindOfClass:[AddBankModel class]]) {
                    //添加银行卡
                    [weakSelf pushViewControllerWithUrl:@"BankAddController" transferData:nil hander:nil];
                }else if ([obj isKindOfClass:[BankCardModel class]]){
                    //选中了某个银行卡
                    BankCardModel *model = obj;
                    weakSelf.currentModel = model;
                    [weakSelf.chanceBankView reloadCell:model];
                    //更新选择放手
                    weakSelf.chanceDescLb.text = model.title;
                    weakSelf.params[@"bankid"] = model.o_id;
                    
                    //更新充值时银行卡限额信息
                    if ([weakSelf.type  isEqualToString:@"recharge"]) {
                        weakSelf.cardDescLb.text = [NSString stringWithFormat:@"此卡本次可充值￥%@",model.limitOnce];
                    }
                }
            }else if (idx == cat_close){
                 weakSelf.chanceBankView.hidden = YES;
            }
        };
        [self.view addSubview:_chanceBankView];
        [self.view bringSubviewToFront:_chanceBankView];
    }return _chanceBankView;
}
@end








@interface ChanceBankView ()
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) FanTableView *tableView;
@property (nonatomic ,strong) UIView *sectionHeaderView;
@end

@implementation ChanceBankView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_PATTERN_STRING(@"_cover_color");
    }return self;
}
- (void)reloadCell:(BankCardModel *)cardModel{
    [self.tableView.viewModel.contentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BankCardModel class]]) {
            BankCardModel *model = obj;
            model.isSelected =  NO;
        }
    }];
    cardModel.isSelected = YES;
    [self.tableView reloadData];
}
- (void)setModel:(BankCardModel *)model{
    _model = model;
    __block NSMutableArray *arr = @[].mutableCopy;
    [model.contentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BankCardModel class]]) {
            BankCardModel *cardModel = obj;
            cardModel.cellHeight = 50;
            cardModel.fanClassName = @"ChanceBankCell";
            [arr addObject:cardModel];
        }
    }];
    [arr addObject:[AddBankModel new]];
    [self.tableView.viewModel setList:arr type:0];
    if (self.tableView.contentSize.height > FAN_SCREEN_HEIGHT/3 * 2) {
        self.tableView.height = FAN_SCREEN_HEIGHT/3 *2;
    }else if(self.tableView.contentSize.height < 100){
        self.tableView.height = 100;
    }else{
        self.tableView.height = self.tableView.contentSize.height;
    }
    self.bgView.height = self.tableView.height;
    self.bgView.centerY = FAN_SCREEN_HEIGHT/2;
}
- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, self.bgView.height) style:UITableViewStylePlain];
        __weak ChanceBankView *weakSelf = self;
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(obj, idx);
            }
        };
        _tableView.fanTableViewBlock = ^id(id obj, int idx) {
            if ([obj integerValue] == 0) {
                return weakSelf.sectionHeaderView;
            }else{
                return nil;
            }
        };
        _tableView.fanTableViewHeightBlock = ^CGFloat(id obj, int idx) {
            if ([obj integerValue] == 0) {
                return 55;
            }else{
                return 0;
            }
        };
        _tableView.layer.cornerRadius = 5;
        [self.bgView addSubview:_tableView];
    }return _tableView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(FanWidth(30), 100, FAN_SCREEN_WIDTH - FanWidth(60), 200)];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 5;
        [self addSubview:_bgView];
    }return _bgView;
}

- (UIView *)sectionHeaderView{
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH - 60, 55)];
        _sectionHeaderView.backgroundColor = COLOR_PATTERN_STRING(@"_ffffff_color");
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(_sectionHeaderView.width/2 - 50, 17.5, 100, 20)];
        [_sectionHeaderView addSubview:titleLb];
        titleLb.font = FanFont(16);
        titleLb.text = @"选择银行";
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        FanImageView *closeImg = [[FanImageView alloc] initWithFrame:CGRectMake(_sectionHeaderView.width - 30, 17.5, 15, 15)];
        closeImg.image = IMAGE_WITH_NAME(@"nav_close");
        [_sectionHeaderView addSubview:closeImg];
        __weak ChanceBankView *weakSelf = self;
        closeImg.viewClickBlock = ^(id obj, cat_action_type idx) {
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(weakSelf, cat_close);
            }
        };
        UILabel *lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 55 - FAN_LINE_HEIGHT, _sectionHeaderView.width, FAN_LINE_HEIGHT)];
        lineLb.backgroundColor = COLOR_PATTERN_STRING(@"_line_color");
        [_sectionHeaderView addSubview:lineLb];
    }return _sectionHeaderView;
}
@end



/**添加银行卡*/
@implementation AddBankModel
- (NSString *)fanClassName{
    return @"ChanceAddBankCell";
}
- (CGFloat)cellHeight{
    return 50;
}
@end

/**添加银行卡Cell*/
@interface ChanceAddBankCell()
@property (nonatomic ,strong) FanImageView *addIcon;
@property (nonatomic ,strong) UILabel *titleLb;
@end
@implementation ChanceAddBankCell
- (void)initView{
    [self addSubview:self.addIcon];
    [self addSubview:self.titleLb];
}

- (FanImageView *)addIcon{
    if (!_addIcon) {
        _addIcon = [FanImageView new];
        _addIcon.frame = CGRectMake(15, 15, 20, 20);
        _addIcon.image = IMAGE_WITH_NAME(@"bank_add");
    }return _addIcon;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb  = [UILabel new];
        _titleLb.frame = CGRectMake(_addIcon.right + 10, 15, 200, 20);
        _titleLb.text = @"添加银行卡";
        _titleLb.font = FanFont(15);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
    }return _titleLb;
}

@end
/*银行卡Cell*/
@interface ChanceBankCell()
@property (nonatomic ,strong) FanImageView *addIcon;
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) FanImageView *selectImg;
@end
@implementation ChanceBankCell
- (void)initView{
    [self addSubview:self.addIcon];
    [self addSubview:self.titleLb];
    [self addSubview:self.selectImg];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle15_15;
    _addIcon.frame = CGRectMake(15, 15, 20, 20);
    _titleLb.frame = CGRectMake(_addIcon.right + 10, 15, 200, 20);
    _selectImg.frame = CGRectMake(self.width - 35, 18, 20, 14);
}

- (void)cellModel:(id)cellModel{
    BankCardModel *model = cellModel;
    [self.addIcon setImageWithUrl:model.iconImg];
    [self.titleLb setText:model.title];
    self.selectImg.hidden = !model.isSelected;
}

- (FanImageView *)addIcon{
    if (!_addIcon) {
        _addIcon = [FanImageView new];
    }return _addIcon;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb  = [UILabel new];
        _titleLb.font = FanFont(15);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
    }return _titleLb;
}
- (FanImageView *)selectImg{
    if (!_selectImg) {
        _selectImg = [FanImageView new];
        _selectImg.image = IMAGE_WITH_NAME(@"bank_selected");
    }return _selectImg;
}
@end
