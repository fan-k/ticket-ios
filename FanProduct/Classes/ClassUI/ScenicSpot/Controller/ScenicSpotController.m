//
//  ScenicSpotController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/10.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "ScenicSpotController.h"
#import "ScenicModel.h"
#import "ScenicNavigationView.h"
#import "ScenicHeaderView.h"
#import "ScenicFooterView.h"

@interface ScenicSpotController ()
@property (nonatomic ,strong) ScenicNavigationView *scenicNavigationView;
@property (nonatomic ,strong) FanTableView *tableView;
@property (nonatomic ,strong) ScenicModel *scenicModel;
@property (nonatomic ,strong) ScenicHeaderView *headerView;
@property (nonatomic ,strong) ScenicFooterView *footerView;
@end

@implementation ScenicSpotController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.scenicNavigationView];
    [self initScenicData];
    // Do any additional setup after loading the view.
}
- (void)initScenicData{
    [self.params addEntriesFromDictionary:self.urlParams];
    [self requestWithUrl:FanUrlScenic loading:YES];
}
/**预定门票*/
- (void)orderTicket:(NSString *)ticketId{
    [UserInfo VerificationLogin:^{
        [self pushViewControllerWithUrl:[NSString stringWithFormat:@"OrderPlaceController?id=%@",ticketId] transferData:nil hander:nil];
    } closeblock:nil animate:YES];
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlScenic]) {
        _scenicModel = [ScenicModel modelWithJson:DICTION_OBJECT(item.responseObject, @"data")];
        _headerView.model = _scenicModel;
        _scenicNavigationView.scenicModel = _scenicModel;
        [_tableView.viewModel setList:_scenicModel.contentList type:0];
    }
}

- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        __weak ScenicSpotController *weakSelf = self;
        __weak FanTableView *weakTable = _tableView;
        _tableView.headRefreshblock = ^{
            [weakSelf initScenicData];
        };
        _tableView.viewModel.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_scrollView_didScroll) {
                UIScrollView *scrollView = obj;
                CGFloat offsetY = scrollView.contentOffset.y;
                CGFloat tableHeaderViewHeight = 200;
                // 修改导航栏透明度
                weakSelf.scenicNavigationView.alpha = offsetY / tableHeaderViewHeight;
            }else if(idx == cat_scenic_order){
                //去预定
                [weakSelf orderTicket:obj];
            }else if (idx == cat_action_cell_click){
                FanModel *model = obj;
                [weakSelf pushViewControllerWithUrl:model.urlScheme transferData:weakSelf.scenicModel hander:nil];
            }else if (idx == cat_scenic_info) {
                //去详情
                [weakSelf pushViewControllerWithUrl:@"ScenicInfoController" transferData:weakSelf.scenicModel hander:nil];
            }else if(idx == cat_scenic_evaluate){
               //去评价
                [weakSelf pushViewControllerWithUrl:@"ScenicEvaluateController" transferData:weakSelf.scenicModel hander:nil];
            }
        };
    }return _tableView;
}
- (ScenicNavigationView *)scenicNavigationView{
    if (!_scenicNavigationView) {
        _scenicNavigationView = [[ScenicNavigationView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_NAV_HEIGHT)];
        __weak ScenicSpotController *weakSelf = self;
        _scenicNavigationView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_nav_left_click) {
                [weakSelf leftNavBtnClick];
            }
        };
    }return _scenicNavigationView;
}

- (ScenicHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ScenicHeaderView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_WIDTH/2 + 85)];
        __weak ScenicSpotController *weakSelf = self;
        _headerView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_scenic_info) {
               //去评价
                [weakSelf pushViewControllerWithUrl:@"ScenicInfoController" transferData:weakSelf.scenicModel hander:nil];
            }else if(idx == cat_scenic_evaluate){
                //去详情
                [weakSelf pushViewControllerWithUrl:@"ScenicEvaluateController" transferData:weakSelf.scenicModel hander:nil];
            }
        };
    }return _headerView;
}
- (ScenicFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[ScenicFooterView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, 50)];
    }return _footerView;
}
@end
