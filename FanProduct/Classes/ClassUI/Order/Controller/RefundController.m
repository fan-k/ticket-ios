//
//  RefundController.m
//  FanProduct
//
//  Created by 99epay on 2019/7/9.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "RefundController.h"
#import "RefundModel.h"

@interface RefundController ()
@property (nonatomic ,strong) FanTableView *tableView;
@property (nonatomic ,strong) RefundModel *model;
@property (nonatomic ,strong)  NSMutableDictionary *submitDict;
@end

@implementation RefundController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftImage  = @"nav_back";
    self.navTitle = @"申请退票";
    self.submitDict = @{}.mutableCopy;
    [self initRefundInfo];
    // Do any additional setup after loading the view.
}

- (void)initRefundInfo{
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    self.params[@"number"] = DICTION_OBJECT(self.urlParams, @"number");
    [self requestWithUrl:FanUrlOrderRefund loading:YES];
}
- (void)submitRefund{
    if (![DICTION_OBJECT(self.submitDict, @"refundReason") isNotBlank]) {
        [FanAlert alertMessage:@"请选择退票原因" type:AlertMessageTypeNomal];
        return;
    }
    if (![DICTION_OBJECT(self.submitDict, @"refundType") isNotBlank]) {
        [FanAlert alertMessage:@"请选择退票方式" type:AlertMessageTypeNomal];
        return;
    }
    self.params[@"number"] = DICTION_OBJECT(self.urlParams, @"number");
    [self.params addEntriesFromDictionary:self.submitDict];
    [self requestWithUrl:FanUrlRefund loading:NO];
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    [FanAlert alertErrorWithItem:item];
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlOrderRefund]) {
        self.model = [RefundModel modelWithJson:DICTION_OBJECT(item.responseObject, @"data")];
        [self.tableView.viewModel setList:self.model.contentList type:0];
    }else{
        [FanAlert alertMessage:@"申请退票成功" type:AlertMessageTypeNomal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self leftNavBtnClick];
        });
    }
}

- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        __weak RefundController *weakSelf = self;
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_refund_update_info) {
                [weakSelf.submitDict addEntriesFromDictionary:obj];
            }else if (idx == cat_action_click){
               [weakSelf submitRefund];
            }
        };
    }return _tableView;
}
@end


@interface RefundDetailController ()
@property (nonatomic ,strong) FanTableView *tableView;
@property (nonatomic ,strong) RefundDetailModel *model;
@end

@implementation RefundDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftImage  = @"nav_back";
    self.navTitle = @"退票流程";
    [self initRefundFlow];
    // Do any additional setup after loading the view.
}
- (void)initRefundFlow{
    self.params[@"number"] = DICTION_OBJECT(self.urlParams, @"number");
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    [self requestWithUrl:FanUrlRefundDetail loading:YES error:FanErrorTypeError];
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    self.model = [RefundDetailModel modelWithJson:DICTION_OBJECT(item.responseObject, @"data")];
    [self.tableView.viewModel setList:self.model.contentList type:0];
}

- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        __weak RefundDetailController *weakSelf = self;
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            
        };
    }return _tableView;
}
@end
