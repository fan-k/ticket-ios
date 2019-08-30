//
//  OrderPlaceController.m
//  FanProduct
//
//  Created by 99epay on 2019/7/9.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "OrderPlaceController.h"
#import "MLInputDodger.h"
@interface OrderPlaceController ()
@property (nonatomic ,strong) OrderModel *orderModel;
@property (nonatomic ,strong) FanTableView *tableView;
@property (nonatomic ,strong) OrderPlaceTabbar *tabbar;
@end

@implementation OrderPlaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftImage  = @"nav_back";
    self.navTitle  = @"提交订单";
    [self initOrderInfo];
    // Do any additional setup after loading the view.
}
-  (void)initOrderInfo{
    self.params[@"id"] = DICTION_OBJECT(self.urlParams, @"id");//门票ID
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    [self requestWithUrl:FanUrlOrderWill loading:YES];
}
- (void)submitOrder{
    // 判断游客信息是否填写完整
    
    if (![self.orderModel.touristModel.name isNotBlank]) {
        [FanAlert alertMessage:@"请先完善游客信息" type:AlertMessageTypeNomal]; return;
    }
    if (![self.orderModel.touristModel.phone isNotBlank]) {
        [FanAlert alertMessage:@"请先完善游客信息" type:AlertMessageTypeNomal]; return;
    }
    if (self.orderModel.UUtourist_info.integerValue > 1) {
        if (![self.orderModel.touristModel.card isNotBlank]) {
            [FanAlert alertMessage:@"请先完善游客信息" type:AlertMessageTypeNomal]; return;
        }
    }
    //提交订单
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    self.params[@"name"] = self.orderModel.touristModel.name;
    self.params[@"phone"] = self.orderModel.touristModel.phone;
    self.orderModel.UUtourist_info.integerValue > 1 ? self.params[@"card"] = self.orderModel.touristModel.card:@"";
    self.params[@"tickedId"] = self.orderModel.orderPriceModel.currentPriceModel.o_id;
    self.params[@"count"] = self.orderModel.orderPriceModel.currentPriceModel.ticketCount;
    self.params[@"price"] = self.orderModel.orderPriceModel.currentPriceModel.prize;
    [self requestWithUrl:FanUrlOrderSubmit loading:NO];
    
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    if([item.url isEqualToString:FanUrlOrderSubmit]){
        [FanAlert alertErrorWithItem:item];
    }
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlOrderWill]) {
        //预下单 获取默认门票价格信息 门票信息
        self.orderModel = [OrderModel modelWithJson:DICTION_OBJECT(item.responseObject, @"data")];
        NSMutableArray *arr = @[].mutableCopy;
        OrderModel *info = self.orderModel.mutableCopy;
        info.fanClassName = @"OrderScenicTicketInfoCell";
        [arr addObject:info];
        OrderModel *tourist_info = self.orderModel.mutableCopy;
        tourist_info.fanClassName = @"OrderTouristInfoCell";
        [arr addObject:tourist_info];
        
        [self.tableView.viewModel setList:arr type:0];
        self.tabbar.model = self.orderModel.orderPriceModel.currentPriceModel;
    }else if([item.url isEqualToString:FanUrlOrderSubmit]){
        NSString *number = DICTION_OBJECT(DICTION_OBJECT(item.responseObject, @"data"), @"number");
        NSString *endTime = DICTION_OBJECT(DICTION_OBJECT(item.responseObject, @"data"), @"endTime");
        NSString *title = DICTION_OBJECT(DICTION_OBJECT(item.responseObject, @"data"), @"title");
        NSString *price = DICTION_OBJECT(DICTION_OBJECT(item.responseObject, @"data"), @"totalPrice");
        [self pushViewControllerWithUrl:[NSString stringWithFormat:@"OrderPayController?number=%@&endTime=%@&title=%@&price=%@",number,endTime,title,price] transferData:nil hander:nil];
    }
}
- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT - FAN_TABBAR_HEIGHT) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        __weak OrderPlaceController *weakSelf =  self;
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_check_price_date) {
                [weakSelf.tabbar setModel:weakSelf.orderModel.orderPriceModel.currentPriceModel];
            }else if(idx == cat_chance_touristinfo){
                OrderModel *orderModel = obj;
                [weakSelf pushViewControllerWithUrl:[NSString stringWithFormat:@"OrderTouristController?UUtourist_info=%@",weakSelf.orderModel.UUtourist_info] transferData:nil hander:^(id obj, int idx) {
                    if (obj && [obj isKindOfClass:NSClassFromString(@"TouristModel")]) {
                        //刷新游客信息
                        orderModel.touristModel = obj;
                        weakSelf.orderModel.touristModel = obj;
                        [weakSelf.tableView reloadData];
                    }
                }];
            }else if (idx == cat_submit_touristinfo){
                weakSelf.orderModel.touristModel = obj;
            }
        };
        CGFloat height = _tableView.height - 100;
        //设置底部距离键盘高度
        _tableView.shiftHeightAsDodgeViewForMLInputDodger = height;
        //编辑状态自动往上升
        [_tableView registerAsDodgeViewForMLInputDodger];
    }return _tableView;
}
- (OrderPlaceTabbar *)tabbar{
    if (!_tabbar) {
        _tabbar   = [[OrderPlaceTabbar alloc] initWithFrame:CGRectMake(0, FAN_SCREEN_HEIGHT - FAN_TABBAR_HEIGHT, FAN_SCREEN_WIDTH, FAN_TABBAR_HEIGHT)];
        [self.view addSubview:_tabbar];
        __weak OrderPlaceController *weakSelf =  self;
        _tabbar.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_submit_order) {
                [weakSelf submitOrder];
            }
        };
    }return _tabbar;
}
@end


@interface OrderPlaceTabbar ()
@property (nonatomic ,strong) UILabel *priceLb;
@property (nonatomic ,strong) UIButton *billButton;
@property (nonatomic ,strong) UIButton *submitButton;
@end
@implementation OrderPlaceTabbar

- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.priceLb];
    [self addSubview:self.billButton];
    [self addSubview:self.submitButton];
}

- (void)setModel:(OrderPriceModel *)model{
    _model = model;
    CGFloat prize  = [model.prize floatValue];
    CGFloat count = model.ticketCount.floatValue;
    CGFloat total  = prize * count;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"总价：￥%2.f",total]];
    att.font = FanRegularFont(23);
    att.color = COLOR_PATTERN_STRING(@"_red_color");
    [att changeStringStyleWithText:@"总价：￥" color:COLOR_PATTERN_STRING(@"_red_color") font:FanRegularFont(13)];
    self.priceLb.attributedText = att;
}
- (void)submit{
    if (self.customActionBlock) {
        self.customActionBlock(self, cat_submit_order);
    }
}
- (void)showBIll{
    OrderBillView *billView = [[UIApplication sharedApplication].keyWindow viewWithTag:10021];
    if (!billView) {
        billView = [[OrderBillView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_TABBAR_HEIGHT)];
        billView.model = self.model;
        billView.tag = 10021 ;
        [[UIApplication sharedApplication].keyWindow addSubview:billView];
    }else{
        [billView removeFromSuperview];
    }

}
- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(self.width - 140, 0, 140, 54);
        [_submitButton setTitle:@"提交订单" forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:FanRegularFont(17)];
        [_submitButton setTitleColor:COLOR_PATTERN_STRING(@"_212121_color") forState:UIControlStateNormal];
        [_submitButton setBackgroundColor:COLOR_PATTERN_STRING(@"_fdc716_color")];
        [_submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
        
    }return _submitButton;
}
- (UILabel *)priceLb{
    if (!_priceLb) {
        _priceLb = [UILabel new];
        _priceLb.frame = CGRectMake(15, 17, self.billButton.left - 30, 20);
    }return _priceLb;
}
- (UIButton *)billButton{
    if (!_billButton) {
        _billButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _billButton.frame = CGRectMake(self.submitButton.left - 80, 0, 70, 54);
        [_billButton setTitle:@"明细" forState:UIControlStateNormal];
        [_billButton setImage:IMAGE_WITH_NAME(@"order_bill") forState:UIControlStateNormal];
        _billButton.titleEdgeInsets = UIEdgeInsetsMake(_billButton.titleEdgeInsets.top, 10, _billButton.titleEdgeInsets.bottom, 20);
        _billButton.imageEdgeInsets = UIEdgeInsetsMake(_billButton.imageEdgeInsets.top, _billButton.width - 20, _billButton.imageEdgeInsets.bottom, 0);
        [_billButton.titleLabel setFont:FanRegularFont(11)];
        [_billButton setTitleColor:COLOR_PATTERN_STRING(@"_212121_color") forState:UIControlStateNormal];
        [_billButton addTarget:self action:@selector(showBIll) forControlEvents:UIControlEventTouchUpInside];
    }return _billButton;
}
@end
#import "BillController.h"
@interface OrderBillView ()
@property (nonatomic ,strong) FanTableView *tableView;

@end
@implementation OrderBillView

- (void)initView{
    self.backgroundColor = COLOR_PATTERN_STRING(@"_cover_color");
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(self.tableView.frame, point)) {
        [self removeFromSuperview];
    }
}

- (void)setModel:(OrderPriceModel *)model{
    
    self.tableView.height = 80;
    self.tableView.top  = self.height - self.tableView.height;
    NSArray *arr = @[
                     [FanHeaderModel modelWithJson:@{@"title":@"价格明细"}],
                     [BillDetailCellModel modelWithJson:@{@"title":@"门票",@"desc":[NSString stringWithFormat:@"￥%@  X%@张",model.prize,model.ticketCount]}],
                     ];
    [self.tableView.viewModel setList:arr type:0];
}

- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_TABBAR_HEIGHT) style:UITableViewStylePlain];
        [self addSubview:_tableView];
    }return _tableView;
}
@end
