//
//  SearchController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/11.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "SearchController.h"
#import "FanSearchView.h"
#import "SearchModel.h"
@interface SearchController ()
@property (nonatomic ,strong) SearchModel *searchModel;
@property (nonatomic ,strong) FanSearchView *searchBar;
@property (nonatomic ,strong) FanTableView *tableView;
@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    [self.navigationView addSubview:self.searchBar];
    self.searchModel = [SearchModel new];
    [self initHotCity];
    
    
    // Do any additional setup after loading the view.
}
- (void)initHotCity{
    [DICTION_OBJECT(self.urlParams, @"type") integerValue] == 1 ?[self requestWithUrl:FanUrlHotCity loading:NO] : [self requestWithUrl:FanUrlHotScenic loading:NO];
}

- (void)search:(NSString *)txt{
    //区分搜城市还是搜景区
    self.params[@"txt"] = txt;
    [DICTION_OBJECT(self.urlParams, @"type") integerValue] == 1 ? [self requestWithUrl:FanUrlSearchCity loading:YES error:FanErrorTypeError] : [self requestWithUrl:FanUrlSearchScenic loading:YES  error:FanErrorTypeError];
}

- (void)handelFailureRequest:(FanRequestItem *)item{
    
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlHotCity]) {
        [[NSUserDefaults standardUserDefaults] setObject:DICTION_OBJECT(item.responseObject, @"data") forKey:@"hots_city"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.searchModel.searchType = [DICTION_OBJECT(self.urlParams, @"type") integerValue];
        [self.tableView.viewModel setList:self.searchModel.contentList type:0];
    }else if ([item.url isEqualToString:FanUrlHotScenic]) {
        [[NSUserDefaults standardUserDefaults] setObject:DICTION_OBJECT(item.responseObject, @"data") forKey:@"hots_scenic"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.searchModel.searchType = [DICTION_OBJECT(self.urlParams, @"type") integerValue];
        [self.tableView.viewModel setList:self.searchModel.contentList type:0];
    }else if ([item.url isEqualToString:FanUrlSearchCity]){
        SearchCellModel *model = [SearchCellModel modelWithJson:item.responseObject];
        self.tableView.viewModel.errorType = FanErrorTypeNoData;
        [self.tableView.viewModel setList:model.contentList type:0];
    }else if ([item.url isEqualToString:FanUrlSearchScenic]){
        HomeContentModel *model = [HomeContentModel modelWithJson:item.responseObject];
        self.tableView.viewModel.errorType = FanErrorTypeNoData;
        [self.tableView.viewModel setList:model.contentList type:0];
    }
}


- (FanSearchView *)searchBar{
    if (!_searchBar) {
        _searchBar = [[FanSearchView alloc] initWithFrame:CGRectMake(50, self.leftButton.top, FAN_SCREEN_WIDTH - 50, 40)];
        _searchBar.placeholder = [DICTION_OBJECT(self.urlParams, @"type") integerValue] ==SearchTypeScenicNomal  ?  @"搜索景区/目的地/门票"  : @"搜索城市";
        __weak SearchController *weakSelf = self;
        _searchBar.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_search) {
                [weakSelf search:obj];
            }else if (idx == cat_nav_left_click){
                weakSelf.searchModel.searchType = [DICTION_OBJECT(weakSelf.urlParams, @"type") integerValue];
                [weakSelf.tableView.viewModel setList:weakSelf.searchModel.contentList type:0];
            }
        };
    }return _searchBar;
}

- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT) style:UITableViewStylePlain];
        __weak SearchController *weakSelf = self;
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_cell_click) {//城市
                if ([obj isKindOfClass:[SearchCellModel class]]) {
                    SearchCellModel *model = obj;
                    //记录下来 并跳转走
                    weakSelf.searchModel.searchModel = model;
                    [weakSelf leftNavBtnClick];
                    if (weakSelf.customActionBlock) {
                        weakSelf.customActionBlock(model.title, cat_action_cell_click);
                    }
                }else if ([obj isKindOfClass:[HomeContentModel class]]){//景区
                    HomeContentModel *model = obj;
                    //记录下来 并跳转走
                    weakSelf.searchModel.searchModel = [SearchCellModel modelWithJson:@{@"title":[NSString stringWithFormat:@"%@",model.title],@"id":[NSString stringWithFormat:@"%@",model.o_id]}];
                    [weakSelf pushViewControllerWithUrl:model.urlScheme transferData:nil hander:nil];
                }
                else if([obj isKindOfClass:[SearchHotModel class]]){//区分城市 和景区
                    SearchHotModel *model = obj;
                    if ([DICTION_OBJECT(weakSelf.urlParams, @"type") integerValue] == 1 ) {
                        //城市
                        [weakSelf leftNavBtnClick];
                        if (weakSelf.customActionBlock) {
                            weakSelf.customActionBlock(model.title, cat_action_cell_click);
                        }
                    }else{
                        //景区
                        //记录下来 并跳转走
                        weakSelf.searchModel.searchModel = [SearchCellModel modelWithJson:@{@"title":[NSString stringWithFormat:@"%@",model.title],@"id":[NSString stringWithFormat:@"%@",model.o_id]}];
                        [weakSelf pushViewControllerWithUrl:[NSString stringWithFormat:@"ScenicSpotController?id=%@",model.o_id] transferData:nil hander:nil];
                    }
                   
                }
            }
        };
        [self.view addSubview:_tableView];
    }return _tableView;
}

@end
