//
//  ScenicEvaluateController.m
//  FanProduct
//
//  Created by 99epay on 2019/7/3.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "ScenicEvaluateController.h"
#import "FanClassView.h"
#import "HomeSectionHeaderView.h"
#import "ScenicModel.h"


@interface ScenicEvaluateController ()
@property (nonatomic ,strong) HomeSectionHeaderView *headerView;
@property (nonatomic ,strong) FanClassView *hoverView;
@end

@implementation ScenicEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"用户评价";
    //获取分类信息
    [self initClassInfo];
    // Do any additional setup after loading the view.
}
- (void)initClassInfo{
    self.params[@"scenicId"] = DICTION_OBJECT(self.urlParams, @"scenicId");
    [self requestWithUrl:FanUrlEvaluateClass loading:YES error:FanErrorTypeError];
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlEvaluateClass]) {
        NSArray *arr = DICTION_OBJECT(item.responseObject, @"data");
        __block NSMutableArray *menus = [NSMutableArray array];
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
            if ([DICTION_OBJECT(dict, @"count") integerValue ] > 0) {
                [menus addObject:@{@"title":[NSString stringWithFormat:@"%@(%@)",DICTION_OBJECT(dict, @"title"),DICTION_OBJECT(dict, @"count")],@"type":[NSString stringWithFormat:@"%@",DICTION_OBJECT(dict, @"type")]}];
            }else{
                [menus addObject:@{@"title":[NSString stringWithFormat:@"%@",DICTION_OBJECT(dict, @"title")],@"type":[NSString stringWithFormat:@"%@",DICTION_OBJECT(dict, @"type")]}];
            }
        }];
        self.headerView.menus = menus;
        [self.view addSubview:self.hoverView];
        
    }
}
- (FanClassView *)hoverView{
    if (!_hoverView) {
        __block NSMutableArray *views = [NSMutableArray array];
        [self.headerView.model.contentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ScenicEvaluateListController *list = [ScenicEvaluateListController new];
            HomeSectionHeaderModel * model = obj;
            model.o_id = DICTION_OBJECT(self.urlParams, @"scenicId");
            list.transferData = model;
            [views addObject:list];
        }];
        _hoverView=  [[FanClassView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT) tables:views titleView:self.headerView];
    }return _hoverView;
}

- (HomeSectionHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[HomeSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, 60)];
        _headerView.buttonWidth = (FAN_SCREEN_WIDTH - 20)/4;
    }return _headerView;
}

@end


@interface ScenicEvaluateListController()
@property (nonatomic ,strong) FanTableView *tableView;

@end
@implementation ScenicEvaluateListController
- (void)viewDidLoad{
    [super viewDidLoad];
    __weak ScenicEvaluateListController *weakSelf = self;
    self.resultActionBlock = ^(id obj, cat_action_type idx) {
        [weakSelf initListData];
    };
}
- (void)initListData{
    if (!self.tableView.viewModel.isRequested) {
        [self loadMore];
    }
}
- (void)loadMore{
    HomeSectionHeaderModel *model = self.transferData;
    self.params[@"scenicId"] = model.o_id;
    self.params[@"type"] = model.type;
    self.params[@"lastid"] = model.lastId;
    [self requestWithUrl:FanUrlEvaluateList object:self.tableView loading:NO error:model.lastId ? FanErrorTypeTopAlert:FanErrorTypeError];
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    //如果是全部 并且是第一页 添加上标签
    HomeSectionHeaderModel *model = self.transferData;
    NSArray *arr = DICTION_OBJECT(item.responseObject, @"data");
    ScenicEvaluateModel *cellModel = [ScenicEvaluateModel modelWithJson:@{@"evaluates":isValidArray(arr)?arr:@[]}];
    if (cellModel && cellModel.contentList.count) {
        [model.contentList addObjectsFromArray:cellModel.contentList];
        model.ismore = cellModel.ismore;
        model.lastId = cellModel.lastId;
    }
    [self.tableView.viewModel setList:model.contentList type:0];
    self.tableView.more = model.ismore;
}
- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectZero];
        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT - 60);
        __weak ScenicEvaluateListController *weakSelf = self;
        _tableView.footRefreshblock = ^{
            [weakSelf loadMore];
        };
//        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
//            if (idx == cat_action_cell_click){
//                FanModel *model = obj;
//                [weakSelf pushViewControllerWithUrl:model.urlScheme transferData:nil hander:nil];
//            }
//        };
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}
@end


@interface ScenicEvaluateDetailController ()
@property (nonatomic ,strong) FanTableView *tableView;

@end

@implementation ScenicEvaluateDetailController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"评价详情";
    [self initListData];
}

- (void)initListData{
    self.params[@"id"] = DICTION_OBJECT(self.urlParams, @"id");
    [self requestWithUrl:FanUrlEvaluateDetail object:self.tableView loading:NO error:FanErrorTypeError];

}
- (void)handelFailureRequest:(FanRequestItem *)item{
    
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    NSMutableArray *contentList = [NSMutableArray array];
    ScenicEvaluateModel *cellModel = [ScenicEvaluateModel modelWithJson:DICTION_OBJECT(item.responseObject, @"data")];
    if (cellModel) {
        [contentList addObject:cellModel];
        if (cellModel.contentList.count) {
            [contentList addObjectsFromArray:cellModel.contentList];
        }
    }
    [self.tableView.viewModel setList:contentList type:0];
}

- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectZero];
        _tableView.frame = CGRectMake(0, FAN_NAV_HEIGHT, self.view.frame.size.width, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT);
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}
@end



@implementation ScenicEvaluateWriteController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"写评价";
}

@end
