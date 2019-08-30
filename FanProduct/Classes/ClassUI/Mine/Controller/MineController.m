//
//  MineController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/5.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "MineController.h"
#import "MineModel.h"
#import "MineHeaderView.h"
#import "MineFooterView.h"
@interface MineController ()
@property (nonatomic ,strong) NSMutableArray *mineList;
@property (nonatomic ,strong) FanTableView *tableView;
@property (nonatomic ,strong) MineHeaderView *headerView;
@property (nonatomic ,strong) MineFooterView *footerView;
@end

@implementation MineController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView.viewModel setList:self.mineList type:0];
    // Do any additional setup after loading the view.
}
- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_TABBAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        [self.view addSubview:_tableView];
         __weak MineController *weakself = self;
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_scrollView_didScroll) {
                if (idx == cat_action_scrollView_didScroll) {
                    UIScrollView *scrollView = obj;
                    CGFloat yOffset = scrollView.contentOffset.y ;
                    [weakself.headerView setOffset:yOffset];
                }
            }else if (idx == cat_action_cell_click){
                FanModel *model = obj;
                if ( [model.urlScheme isEqualToString:@"WalletController"] ||[model.urlScheme isEqualToString:@"BankController"]) {
                    [UserInfo VerificationLogin:^{
                        [weakself pushViewControllerWithUrl:model.urlScheme transferData:nil hander:nil];
                    } closeblock:nil animate:YES];
                }else
                    [weakself pushViewControllerWithUrl:model.urlScheme transferData:nil hander:nil];
            }
        };
    }return _tableView;
}
- (MineHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[MineHeaderView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_WIDTH/2 + 100)];
        __weak MineController *weakself = self;
        _headerView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_mine_set) {
                [weakself pushViewControllerWithUrl:@"SetController" transferData:nil hander:nil];
            }else if(idx == cat_mine_userinfo){
                [weakself pushViewControllerWithUrl:@"UserInfoController" transferData:nil hander:nil];
            }else if (idx == cat_login){
                [UserInfo VerificationLogin:nil closeblock:nil animate:YES];
            }else if(idx == cat_action_cell_click){
                FanModel *model = obj;
                [weakself pushViewControllerWithUrl:model.urlScheme transferData:nil hander:nil];
            }
        };
    }return _headerView;
}
- (MineFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[MineFooterView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, 100)];
    }return _footerView;
}
- (NSMutableArray *)mineList{
    if (!_mineList) {
        _mineList = [NSMutableArray array];
        [_mineList addObject:[MineListCellModel modelWithJson:@{@"picture":@"mine_picture"}]];
        [_mineList addObject:[FanNilModel new]];
        [_mineList addObject:[MineModel modelWithJson:@{@"title":@"我的服务",@"data":@[
                                                                @{@"title":@"我的钱包",@"image":@"mine_qianbao",@"urlScheme":@"WalletController"},
                                                                @{@"title":@"银行卡",@"image":@"mine_bank",@"urlScheme":@"BankController"},
                                                                @{@"title":@"我的客服",@"image":@"mine_kefu",@"urlScheme":@"FanWebController?title=我的客服"},
                                                                @{@"title":@"关于我们",@"image":@"mine_wm",@"urlScheme":@"AboutController"}
                                                                ]}]];

    }return _mineList;
}

@end
