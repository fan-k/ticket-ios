//
//  PaySetController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/14.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "PaySetController.h"
#import "WalletModel.h"

@interface PaySetController ()
@property (nonatomic ,strong) FanTableView *tableView;
@property (nonatomic ,strong) WalletModel *model;
@end
@implementation PaySetController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"支付设置";
    NSArray *list = @[
                      [WalletCellModel modelWithJson:@{@"title":@"修改支付密码",@"urlScheme":@"BankPwdController?type=reset"}],
                      [WalletCellModel modelWithJson:@{@"title":@"找回支付密码",@"urlScheme":@"VerificateInfoController?type=card"}]
                      ];
    [self.tableView.viewModel setList:list type:0];
}

- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT) style:UITableViewStylePlain];
        __weak PaySetController *weakself = self;
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_cell_click){
                FanModel *model = obj;
               [weakself pushViewControllerWithUrl:model.urlScheme transferData:nil hander:nil];
            }
        };
        [self.view addSubview:_tableView];
    }return _tableView;
}
@end
