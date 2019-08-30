//
//  ResultController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "ResultController.h"
#import "BankModel.h"

@interface ResultController ()
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,strong) FanTableView *tableView;
@end

@implementation ResultController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = [self.type isEqualToString:@"cash"] ? @"提现结果" : @"充值结果";
    NSMutableArray *arr = @[].mutableCopy;
    [arr addObject:[ResultStutusModel modelWithJson:@{@"type":self.type,@"status":[NSString stringWithFormat:@"%@",DICTION_OBJECT(self.transferData, @"code")],@"descript":[NSString stringWithFormat:@"%@",DICTION_OBJECT(self.transferData, @"msg")]}]];
    NSString *amount = [NSString stringWithFormat:@"￥%@",DICTION_OBJECT(DICTION_OBJECT(self.transferData, @"data"), @"amount")];//提现金额
    NSString *amount_bank = [NSString stringWithFormat:@"￥%@",DICTION_OBJECT(DICTION_OBJECT(self.transferData, @"data"), @"amount_bank")];//最终银行卡支出或收入金额
    NSString *to = [NSString stringWithFormat:@"%@",DICTION_OBJECT(DICTION_OBJECT(self.transferData, @"data"), @"to")];//银行卡
    NSString *from = [NSString stringWithFormat:@"%@",DICTION_OBJECT(DICTION_OBJECT(self.transferData, @"data"), @"from")];//来源
    if ([self.type isEqualToString:@"cash"]) {
        //添加手续费 和到账金额to
        NSString *rate = [NSString stringWithFormat:@"￥%@",DICTION_OBJECT(DICTION_OBJECT(self.transferData, @"data"), @"rate")];
        [arr addObject:[ResultInfoModel modelWithJson:@{@"title": @"提现金额" ,@"descript":amount}]];
        [arr addObject:[ResultInfoModel modelWithJson:@{@"title": @"提现方式",@"descript":to}]];
        [arr addObject:[ResultInfoModel modelWithJson:@{@"title":@"提现服务费",@"descript":rate}]];
        [arr addObject:[ResultInfoModel modelWithJson:@{@"title":@"提现到账金额",@"descript":amount_bank}]];
    }else{
        [arr addObject:[ResultInfoModel modelWithJson:@{@"title": @"充值金额",@"descript":amount_bank}]];
        [arr addObject:[ResultInfoModel modelWithJson:@{@"title": @"充值方式",@"descript":from}]];
    }
    [arr addObject:[BankAddModel modelWithJson:@{@"title":@"完成",@"color":@"_yellow_color"}]];
    [self.tableView.viewModel setList:arr type:0];
}

- (void)leftNavBtnClick{
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
}

- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT) style:UITableViewStylePlain];
        __weak ResultController *weakSelf= self;
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_click) {
                if ([obj isKindOfClass:[BankAddModel class]]) {
                    [weakSelf leftNavBtnClick];
                }
            }
        };
        [self.view addSubview:_tableView];
    }return _tableView;
}

- (NSString *)type{
    if (!_type) {
        _type = [NSString stringWithFormat:@"%@",DICTION_OBJECT(self.urlParams, @"type")];
    }return _type;
}
@end



@implementation ResultStutusModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    ResultStutusModel *model = [ResultStutusModel new];
    model.status = DICTION_OBJECT(json, @"status");
    model.type = DICTION_OBJECT(json, @"type");
    model.descript = DICTION_OBJECT(json, @"descript");
    model.fanClassName = @"ResultStatusCell";
    return model;
}
- (NSString *)title{
    if ([self.type isEqualToString:@"cash"]) {
        if ([self.status isEqualToString:@"1"]) {
            self.descript  = @"预计2小时内到账";
        }
        return [self.status isEqualToString:@"1"] ? @"提现申请成功,等待银行处理" : @"提现失败";
    }else{
        return [self.status isEqualToString:@"1"] ? @"充值成功" :@"充值失败";
    }
}
- (NSString *)image{
    return [self.status isEqualToString:@"0"] ? @"result_failure" :@"result_success";
}
- (CGFloat)cellHeight{
    return [self.descript isNotBlank] ? 170 : 145;
}
@end



@implementation ResultInfoModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    ResultInfoModel *model = [ResultInfoModel new];
    model.title = DICTION_OBJECT(json, @"title");
    model.descript = DICTION_OBJECT(json, @"descript");
    model.fanClassName = @"ResultInfoCell";
    model.cellHeight = 50;
    return model;
}
@end


@interface ResultStatusCell()
@property (nonatomic ,strong) FanImageView *img;
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *descLb;
@end

@implementation ResultStatusCell
- (void)initView{
    self.backgroundColor = [UIColor clearColor];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.img.frame = CGRectMake(self.width/2 - 27.5, 30, 55, 55);
    self.titleLb.frame = CGRectMake(15, _img.bottom + 10, self.width - 30, 20);
    self.descLb.frame = CGRectMake(15 , _titleLb.bottom + 5, self.width - 30, 20);
    
}
- (void)cellModel:(id)cellModel{
    ResultStutusModel *model = cellModel;
    [self.img setImageWithUrl:model.image];
    [self.titleLb setText:model.title];
    [self.descLb setText:[NSString stringWithFormat:@"%@",model.descript]];
}
- (FanImageView *)img{
    if (!_img) {
        _img = [FanImageView new];
        [self addSubview:_img];
    }return _img;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanFont(17);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _titleLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLb];
    }return _titleLb;
}

- (UILabel *)descLb{
    if (!_descLb) {
        _descLb = [UILabel new];
        _descLb.font = FanFont(15);
        _descLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _descLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_descLb];
    }return _descLb;
}

@end

@interface ResultInfoCell()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *descLb;
@end
@implementation ResultInfoCell

- (void)initView{
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle0_0;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLb.frame = CGRectMake(15, 10, 150, 20);
    self.descLb.frame = CGRectMake(_titleLb.right , 10, self.width - 15 - _titleLb.right, 20);
    
}
- (void)cellModel:(id)cellModel{
    ResultInfoModel *model = cellModel;
    [self.titleLb setText:model.title];
    [self.descLb setText:[NSString stringWithFormat:@"%@",model.descript]];
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanFont(15);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}

- (UILabel *)descLb{
    if (!_descLb) {
        _descLb = [UILabel new];
        _descLb.font = FanFont(15);
        _descLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _descLb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_descLb];
    }return _descLb;
}

@end
