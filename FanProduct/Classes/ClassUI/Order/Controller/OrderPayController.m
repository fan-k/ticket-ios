//
//  OrderPayController.m
//  FanProduct
//
//  Created by 99epay on 2019/7/9.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "OrderPayController.h"
#import "BankController.h"
#import "PassWordView.h"

@interface OrderPayController ()
@property (nonatomic ,strong) FanTableView *tableView;
@property (nonatomic ,strong) OrderPayHeaderView *headerView;
@property (nonatomic ,strong) OrderPayCellModel *currentModel;
@property (nonatomic ,strong) FanPayAlertView *payAlertView;
@end

@implementation OrderPayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftImage  = @"nav_back";
    self.navTitle = @"支付订单";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initPayType) name:NotificationWalletInfoChanged object:nil];
    [self initPayType];
    // Do any additional setup after loading the view.
}
- (void)leftNavBtnClick{
    [FanAlert showAlertControllerWithTitle:@"提示" message:@"确认要放弃支付吗？" _cancletitle_:@"确定" _confirmtitle_:@"取消" handler1:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    } handler2:nil];
}
- (void)initPayType{
    OrderPayCellModel *wallet = [OrderPayCellModel modelWithJson:@{
                                                                   @"title":@"钱包支付",
                                                                   @"icon":@"order_wallet",
                                                                   @"discount":[FanWallet shareInstance].walletModel.balance,
                                                                   @"type":@"wallet",
                                                                   }];
    OrderPayCellModel *zhifubao =  [OrderPayCellModel modelWithJson: @{
                                                                       @"title":@"支付宝支付",
                                                                       @"icon":@"order_zhifubao",
                                                                       @"discount":@"",
                                                                       @"type":@"zfb",
                                                                       }];
    OrderPayCellModel *weixin = [OrderPayCellModel modelWithJson:@{
                                                                   @"title":@"微信支付",
                                                                   @"icon":@"order_weixin",
                                                                   @"discount":@"",
                                                                   @"type":@"weixin",
                                                                   }];
    NSString *price = DICTION_OBJECT(self.urlParams, @"price");
    if (price.floatValue <= [FanWallet shareInstance].walletModel.balance.floatValue) {
        wallet.selected = YES;//默认选中钱包
        self.currentModel = wallet;
    }else{
        //选支付宝
        zhifubao.selected = YES;
        self.currentModel = zhifubao;
    }
    [self.tableView.viewModel setList:@[wallet,zhifubao,weixin,[BankAddModel modelWithJson:@{@"title":@"支付订单",@"color":@"_yellow_color"}]] type:0];
    self.headerView.model = self.urlParams;
}
- (void)submitOrder{
    if ([self.currentModel.o_id isEqualToString:@"wallet"]) {
        [self payByWallet];
    }else{
        self.params[@"type"] = self.currentModel.o_id;
        self.params[@"number"] = DICTION_OBJECT(self.urlParams, @"number");
        self.params[@"token"] = [UserInfo shareInstance].userModel.token;
        [self requestWithUrl:FanUrlPay loading:NO error:FanErrorTypeTopAlert];
    }
}
/**支付成功*/
- (void)paysuccess:(FanRequestItem *)item{
    NSMutableArray *list = self.navigationController.viewControllers.mutableCopy;
    [list removeLastObject];
    UIViewController *lastVc = list.lastObject;
    if ([lastVc isKindOfClass:[NSClassFromString(@"OrderPlaceController") class]]) {
        [list removeLastObject];
    }
    self.navigationController.viewControllers = list;
    //支付成功 跳转到订单详情
    [self pushViewControllerWithUrl:[NSString stringWithFormat:@"OrderDetailController?number=%@",DICTION_OBJECT(item.params, @"number")] transferData:nil hander:nil];
}
/**支付宝*/
- (void)payByzhifubao:(FanRequestItem *)item{
    [[FanAliPay shareInstance] sendReqWithItem:item];
    __weak OrderPayController *weakSelf = self;
    [FanAliPay shareInstance].customActionBlock = ^(id obj, cat_action_type idx) {
        if (idx == cat_pay_unsure) {
            //查询下支付结果
            [weakSelf selectResultWithNumber:DICTION_OBJECT(item.params, @"number")];
        }else if (idx == cat_pay_success){
            [weakSelf paysuccess:item];
        }
    };
}
/**微信*/
- (void)payByWeixin:(FanRequestItem *)item{
    [[FanWeChat shareInstance] sendReqWithItem:item];
    __weak OrderPayController *weakSelf = self;
    [FanWeChat shareInstance].customActionBlock = ^(id obj, cat_action_type idx) {
        if (idx == cat_pay_unsure) {
            //查询下支付结果
            [weakSelf selectResultWithNumber:DICTION_OBJECT(item.params, @"number")];
        }else if (idx == cat_pay_success){
            [weakSelf paysuccess:item];
        }
    };
}
/**钱包*/
- (void)payByWallet{
    // 1判断余额  余额不足提醒去充值
    NSString *price = DICTION_OBJECT(self.urlParams, @"price");
    if (price.floatValue > [FanWallet shareInstance].walletModel.balance.floatValue) {
        [FanAlert showAlertControllerWithTitle:@"提示" message:@"钱包余额不足,请先充值" _cancletitle_:@"取消" _confirmtitle_:@"充值" handler1:nil handler2:^(UIAlertAction * _Nonnull action) {
            [self pushViewControllerWithUrl:@"RechargeController?type=recharge" transferData:nil hander:nil];
        }];
        return;
    }
    // 2 余额满足 做支付 先验证支付密码 密码提交到支付
    if (![FanRequestTool net]) {
        [FanAlert alertErrorWithMessage:@"您网络连接不好,请稍后再试"];
        return;
    }
    //4 调取支付密码视图 填写密码  密码输入完成掉接口
    self.payAlertView  = [[FanPayAlertView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT) message:DICTION_OBJECT(self.urlParams, @"title") money:price];
    [self.view addSubview:self.payAlertView];
    __weak OrderPayController *weakSelf = self;
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
            [weakSelf walletPayWithPwd:obj];
        }
    };
}
/**钱包支付*/
- (void)walletPayWithPwd:(NSString *)pwd{
    self.params[@"type"] = @"wallet";
    self.params[@"number"] = DICTION_OBJECT(self.urlParams, @"number");
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    [self requestWithUrl:FanUrlPay loading:YES];
}
/**查询支付结果*/
- (void)selectResultWithNumber:(NSString *)number{
    self.params[@"number"] = number;
    [self requestWithUrl:FanUrlPayResult loading:NO];
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlPayResult]){
        if ([DICTION_OBJECT(item.params, @"type") isEqualToString:@"wallet"]) {
            if ([DICTION_OBJECT(item.responseObject, @"code") isEqualToString:code_112]) {
                self.payAlertView.resultActionBlock(@"", cat_error_net);
            }else if ([DICTION_OBJECT(item.responseObject, @"code") isEqualToString:code_2001]) {
                self.payAlertView.resultActionBlock(@"", cat_error_pwd);
            }
        }else{
            [FanAlert alertMessage:DICTION_OBJECT(item.responseObject, @"msg") type:AlertMessageTypeNomal];
        }
    }
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlPay]) {
        //如果是支付宝微信 调起应用做支付 如果是钱包 输入密码确定支付
        if ([DICTION_OBJECT(item.params, @"type") isEqualToString:@"zfb"]) {
            [self payByzhifubao:item];
        }else  if ([DICTION_OBJECT(item.params, @"type") isEqualToString:@"weixin"]) {
            [self payByWeixin:item];
        }else  if ([DICTION_OBJECT(item.params, @"type") isEqualToString:@"wallet"]) {
            //更新钱包信息
            [FanWallet updateWalletWithCompleteBlock:nil];
            [self.payAlertView removeFromSuperview];
            self.payAlertView = nil;
             [self paysuccess:item];
        }
    }else if ([item.url isEqualToString:FanUrlPayResult]){
        [self paysuccess:item];
    }
}


- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT) style:UITableViewStylePlain];
        __weak OrderPayController * weakSelf = self;
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            if ([obj isKindOfClass:[OrderPayCellModel class]]) {
                OrderPayCellModel *model = obj;
                model.selected = YES;
                weakSelf.currentModel.selected = NO;
                weakSelf.currentModel = obj;
                [weakSelf.tableView reloadData];
            }else if ([obj isKindOfClass:[BankAddModel class]]){
                [weakSelf submitOrder];
            }
            
        };
        _tableView.tableHeaderView = self.headerView;
        [self.view addSubview:_tableView];
    }return _tableView;
}
- (OrderPayHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[OrderPayHeaderView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, 135)];
    }return _headerView;
}



@end





@implementation OrderPayCellModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    OrderPayCellModel *model = [OrderPayCellModel new];
    model.title =  DICTION_OBJECT(json, @"title");
    model.icon = DICTION_OBJECT(json, @"icon");
    model.o_id = DICTION_OBJECT(json, @"type");
    model.fanClassName = @"OrderPayCell";
    return model;
}
- (NSString *)descript{
    if (!_descript) {
        if ([self.o_id isEqualToString:@"wallet"]) {
            _descript = [NSString stringWithFormat:@"钱包余额:￥%@",[FanWallet shareInstance].walletModel.balance];
        }else{
            _descript = @"";
        }
    }return _descript;
}

@end

@interface OrderPayCell()
@property (nonatomic ,strong) FanImageView *icon;
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) FanImageView *selectImg;
@property (nonatomic ,strong) UILabel *descriptLb;
@end
@implementation OrderPayCell

- (void)layoutSubviews{
    [super layoutSubviews];
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle15_15;
    self.icon.frame = CGRectMake(25, 15, 23, 22);
    self.titleLb.frame = CGRectMake(self.icon.right + 10, 15, 200, 20);
    self.descriptLb.frame = CGRectMake(self.titleLb.left, self.titleLb.bottom, self.titleLb.width, 20);
    self.selectImg.frame = CGRectMake(self.width - 40, self.icon.centerY - 8, 16, 16);
    OrderPayCellModel *model = self.cellModel;
    model.cellHeight = self.descriptLb.hidden ? self.titleLb.bottom + 15 : self.descriptLb.bottom + 15;
    
}
- (void)cellModel:(id)cellModel{
    OrderPayCellModel *model = cellModel;
    [self.icon setImageWithUrl:model.icon];
    [self.titleLb setText:model.title];
    [self.descriptLb setText:model.descript];
    self.descriptLb.hidden = ![model.descript isNotBlank];
    self.selectImg.image = model.selected ? IMAGE_WITH_NAME(@"order_select_1") :IMAGE_WITH_NAME(@"order_select_0");
}

- (FanImageView *)icon{
    if (!_icon) {
        _icon = [FanImageView new];
        [self addSubview:_icon];
    }return _icon;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font =  FanRegularFont(15);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}

- (UILabel *)descriptLb{
    if (!_descriptLb) {
        _descriptLb = [UILabel new];
        _descriptLb.font = FanRegularFont(11);
        _descriptLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        [self addSubview:_descriptLb];
    }return _descriptLb;
}
- (FanImageView *)selectImg{
    if (!_selectImg) {
        _selectImg = [FanImageView new];
        [self addSubview:_selectImg];
    }return _selectImg;
}

@end

@interface OrderPayHeaderView()
@property (nonatomic ,strong) UILabel *timeLb;
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *priceLb;
@end
@implementation OrderPayHeaderView
- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    self.titleLb.frame = CGRectMake(0, 30, self.width, 20);
    self.priceLb.frame = CGRectMake(0, self.titleLb.bottom + 5, self.width, 30);
    self.timeLb.frame = CGRectMake(0, self.priceLb.bottom, self.width, 20);
}
- (void)setModel:(NSDictionary *)model{
    _model = model;
    [self.titleLb setText:DICTION_OBJECT(model, @"title")];
    [self.priceLb setText:[NSString stringWithFormat:@"￥%@",DICTION_OBJECT(model, @"price")]];
    // 倒计时的时间
    NSString *deadlineStr =  [FanTime TimeIntervalIntoString:[NSString stringWithFormat:@"%@",DICTION_OBJECT(model, @"endTime")].integerValue formatter:@"YYYY-MM-dd HH:mm:ss"];;
    // 当前时间的时间戳
    NSString *nowStr = [FanTime getCurrentTimeyyyymmdd];
    // 计算时间差值
    NSInteger secondsCountDown = [FanTime getDateDifferenceWithNowDateStr:nowStr deadlineStr:deadlineStr];
    
    // 倒计时时间
    __block NSInteger timeOut = secondsCountDown;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        // 倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.timeLb setText:@"订单支付超时"];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                // 重新计算 时/分/秒
                NSString *str_hour = [NSString stringWithFormat:@"%02ld", timeOut / 3600];
                NSString *str_minute = [NSString stringWithFormat:@"%02ld", (timeOut % 3600) / 60];
                NSString *str_second = [NSString stringWithFormat:@"%02ld", timeOut % 60];
                NSString *format_time = [NSString stringWithFormat:@"%@ : %@ : %@", str_hour, str_minute, str_second];
                // 修改倒计时标签及显示内容
                self.timeLb.text = [NSString stringWithFormat:@"剩余支付时间: %@", format_time];
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
    
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanRegularFont(15);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _titleLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLb];
    }return _titleLb;
}

- (UILabel *)priceLb{
    if (!_priceLb) {
        _priceLb = [UILabel new];
        _priceLb.font = FanBoldFont(20);
        _priceLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _priceLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_priceLb];
    }return _priceLb;
}


- (UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.font = FanRegularFont(12);
        _timeLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _timeLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeLb];
    }return _timeLb;
}


@end
