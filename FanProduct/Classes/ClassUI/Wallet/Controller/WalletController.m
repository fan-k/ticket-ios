//
//  WalletController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "WalletController.h"
#import "WalletModel.h"
#import "WalletHeaderView.h"

@interface WalletController ()
@property (nonatomic ,strong) WalletHeaderView *headerView;
@property (nonatomic ,strong) FanTableView *tableView;
@end

@implementation WalletController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"我的钱包";
    self.navigationView.backgroundColor = self.navigationLine.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWalletInfo) name:NotificationWalletInfoChanged object:nil];
    __weak WalletController*weakself = self;
    [FanWallet updateWalletWithCompleteBlock:^{
        [weakself initWalletInfo];
    }];
}
- (void)updateWalletInfo{
    [self initWalletInfo];
}
- (void)initWalletInfo{
    if ([FanWallet shareInstance].walletModel) {
        NSMutableArray *contentList = [NSMutableArray array];
        if ([FanWallet shareInstance].walletModel.balance) {
            [contentList addObject:[WalletCellModel modelWithJson:@{@"title":@"充值",@"urlScheme":@"RechargeController?type=recharge"}]];
        }
        [contentList addObject:[WalletCellModel modelWithJson:@{@"title":@"提现",@"urlScheme":@"RechargeController?type=cash"}]];
        [contentList addObject:[FanNilModel new]];
        [contentList addObject:[WalletCellModel modelWithJson:@{@"title":@"账单明细",@"urlScheme":@"BillController"}]];
        [contentList addObject:[FanNilModel new]];
        if ([FanWallet shareInstance].walletModel.hasBank) {
            [contentList addObject:[WalletCellModel modelWithJson:@{@"title":@"我的银行卡",@"urlScheme":@"BankController"}]];
        }else{
            [contentList addObject:[WalletCellModel modelWithJson:@{@"title":@"我的银行卡",@"desc":@"未添加",@"urlScheme":@"BankController"}]];
        }
        [contentList addObject:[WalletCellModel modelWithJson:@{@"title":@"支付设置",@"urlScheme":@"PaySetController"}]];
        [self.tableView.viewModel setList:contentList type:0];
    }else{
        self.navigationView.backgroundColor = COLOR_PATTERN_STRING(@"_ffffff_color");
        self.navigationLine.backgroundColor = COLOR_PATTERN_STRING(@"_line_color");
        [FanAlert alertErrorWithMessage:@"钱包信息加载失败~"];
    }
}

- (void)alertBandCard{
    __weak WalletController *weakself = self;
    [FanAlert showAlertControllerWithTitle:@"提示" message:@"您尚未绑定银行卡，请先绑定银行卡" _cancletitle_:@"放弃" _confirmtitle_:@"绑定" handler1:nil handler2:^(UIAlertAction * _Nonnull action) {
        [weakself pushViewControllerWithUrl:@"BankController" transferData:nil hander:nil];
    }];
}
- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.tableHeaderView = self.headerView;
        __weak WalletController *weakself = self;
        _tableView.headRefreshblock = ^{
            [weakself initWalletInfo];
        };
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_scrollView_didScroll) {
                UIScrollView *scrollView = obj;
                CGFloat yOffset = scrollView.contentOffset.y ;
                [weakself.headerView setOffset:yOffset];
            }else if (idx == cat_action_cell_click){
                FanModel *model = obj;
                //充值 提现 需先验证绑定银行卡
                if ([model.urlScheme isEqualToString:@"CashController"] || [model.urlScheme isEqualToString:@"RechargeController"]) {
                    if ([FanWallet shareInstance].walletModel.hasBank) {
                        [weakself pushViewControllerWithUrl:model.urlScheme transferData:nil hander:nil];
                    }else{
                        //未绑定 先绑定
                        [weakself alertBandCard];
                    }
                }else{
                    [weakself pushViewControllerWithUrl:model.urlScheme transferData:nil hander:nil];
                }
            }
        };
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
    }return _tableView;
}
- (WalletHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[WalletHeaderView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, 200)];
        _headerView.model = [FanWallet shareInstance].walletModel;
    }return _headerView;
}
@end
