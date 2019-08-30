//
//  BankDetailController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "BankDetailController.h"
#import "BankModel.h"

@interface BankDetailController ()
@property (nonatomic ,strong) FanTableView *tableView;
@end

@implementation BankDetailController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"银行卡详情";
    NSArray *list = @[
                      [BankCardModel modelWithJson:self.urlParams],
                      [FanNilModel new],
                      [BankQuotaModel modelWithJson:@{@"title":@"每笔支付限额",@"desc":[NSString stringWithFormat:@"￥%@",DICTION_OBJECT(self.urlParams, @"limitOnce")]}],
                      [BankQuotaModel modelWithJson:@{@"title":@"每日支付限额",@"desc":[NSString stringWithFormat:@"￥%@",DICTION_OBJECT(self.urlParams, @"limitDay")]}],
                      [BankAddModel modelWithJson:@{@"title":@"解除绑定"}]
                      ];
    
    [self.tableView.viewModel setList:list type:0];
}
- (void)RelieveBand{
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    self.params[@"id"] = DICTION_OBJECT(self.urlParams, @"id");
    [self requestWithUrl:FanUrlUserBankUnBand loading:YES error:FanErrorTypeTopAlert];
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    //解绑成功
    [FanAlert alertMessage:@"解绑成功" type:AlertMessageTypeNomal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self leftNavBtnClick];
    });
}
- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        __weak BankDetailController *weakSelf = self;
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            if ( idx == cat_action_click) {
                [FanAlert showAlertControllerWithTitle:@"提示" message:@"您是否要解除该银行卡的绑定" _cancletitle_:@"取消" _confirmtitle_:@"解绑" handler1:nil handler2:^(UIAlertAction * _Nonnull action) {
                     [weakSelf RelieveBand];
                }];
            }
        };
    }return _tableView;
}
@end
