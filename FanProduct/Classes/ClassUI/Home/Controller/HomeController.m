//
//  HomeController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/5.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "HomeController.h"
#import "HomeNavigationView.h"
#import "HomeModel.h"
#import "HomeSectionHeaderView.h"
#import "SearchModel.h"
@interface HomeController ()
@property (nonatomic ,strong) HomeSectionHeaderView *sectionHeaderView;
@property (nonatomic ,strong) HomeNavigationView *navigationSearchView;
@property (nonatomic ,strong) FanTableView *tableView;
@property (nonatomic ,strong) NSArray *menus;
@property (nonatomic ,strong) HomeModel *homeModel;
// error
@property (nonatomic ,strong) FanErrorView *errorView;
@property (nonatomic ,assign) CGFloat headerOffsetY;
@property (nonatomic ,copy) NSString *city;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = COLOR_PATTERN_STRING(@"_base_background_color");
    
    [self.view addSubview:self.navigationSearchView];
    [self.view bringSubviewToFront:self.navigationSearchView];
   
    [self initIndex];
    //更新用户信息 钱包信息
    [UserInfo updateUserInfoWithCompleteBlock:nil];
    // Do any additional setup after loading the view.
}
- (void)initIndex{
    //开启定位 根据位置信息 获取数据
    __weak typeof(self) weakSelf = self;
    [FanLocationManager startUpdatingLocationWithHander:^(CLLocation *location, cat_action_type idx) {
        [weakSelf setCity:[FanLocationManager shareInstance].cityName];
    }];
}
- (void)setCity:(NSString *)city{
    if (isValidString(city)) {
        _city = city;
        [self.navigationSearchView setCity:city];
        self.params[@"city"] =  city;
        [self requestWithUrl:FanUrlIndex loading:YES];
    }
}
- (void)initHomeWithCity:(NSString *)city{
  
}
- (void)loadListData:(HomeSectionHeaderModel *)model{
    self.params[@"theme"] = model.type;
    self.params[@"lastId"] = model.lastId;
    [self requestWithUrl:FanUrlViewList object:model loading:NO error:NO];
}
- (void)changeCurrentModel:(HomeSectionHeaderModel *)model{
    model.refresh = NO;
    if (_homeModel.contentList.count > 1) {
        [_homeModel.contentList replaceObjectAtIndex:1 withObject:model.contentList];
    }else{
        [_homeModel.contentList addObject:model.contentList];
    }
    
    [_tableView.viewModel setList:_homeModel.contentList type:0];
    _tableView.more = model.ismore;
    //把列表滚动到记录的偏移位置
    if (model.scroll) {
        if (_tableView.contentOffset.y >= self.headerOffsetY ||  model.contentOffsetY != self.headerOffsetY) {
            _tableView.contentOffset = CGPointMake(0, model.contentOffsetY);
        }
    }
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlIndex]) {
        //添加error
        if (!_errorView) {
            [self.tableView addSubview:self.errorView];
            [self.tableView bringSubviewToFront:self.errorView];
            self.errorView.type = [FanRequestTool net] ? FanErrorTypeError : FanErrorTypeNet;
            //处理导航
            self.navigationSearchView.alpha = 1;
        }
    }else if ([item.url isEqualToString:FanUrlViewList]){
         HomeSectionHeaderModel *model = item.object;
         model.isLoadData = YES;
        //加载错误 添加一个error
        [self changeCurrentModel:model];
    }
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlIndex]) {
        _homeModel = [HomeModel modelWithJson:item.responseObject];
        if (_homeModel) {
            
            [self.tableView.viewModel setList:_homeModel.contentList type:0];
            //找表头的位置 记录表头的位置
            self.headerOffsetY = self.tableView.contentSize.height - 60;
            [self.sectionHeaderView.model.contentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                HomeSectionHeaderModel *model =  obj;
                model.contentOffsetY = self.headerOffsetY;
            }];
            //移除error //处理导航
            if (_errorView) {
                _errorView.customActionBlock = nil;
                [_errorView removeFromSuperview];
                _errorView = nil;
                self.navigationSearchView.alpha = 0;
            }
            //加载第一列数据
            [self headRefresh];
        }else{
            //加载error
            [self handelFailureRequest:item];
        }
    }else if ([item.url isEqualToString:FanUrlViewList]){
       //
        HomeSectionHeaderModel *model = item.object;
        [model managerHomeList:item];
        [self changeCurrentModel:model];
    }
}

- (void)headRefresh{
    HomeSectionHeaderModel *model = self.sectionHeaderView.model.contentList[self.sectionHeaderView.model.currentIndex];
    model.refresh = YES;
    model.scroll = NO;
    [self loadListData:model];
}

- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_TABBAR_HEIGHT) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        [self.view sendSubviewToBack:_tableView];
        __weak FanTableView *weakTableView = _tableView;
        __weak typeof(self) weakSelf = self;
        _tableView.headRefreshblock = ^{
            [weakSelf headRefresh];
        };
        _tableView.footRefreshblock = ^{
            [weakSelf loadListData:weakSelf.sectionHeaderView.model.contentList[weakSelf.sectionHeaderView.model.currentIndex]];
        };
        _tableView.fanTableViewBlock = ^id(id obj, int idx) {
            if ([obj integerValue] == 1) {
                return weakSelf.sectionHeaderView;
            }else{
                return nil;
            }
            
        };
        _tableView.fanTableViewHeightBlock = ^CGFloat(id obj, int idx) {
            if ([obj integerValue] == 1) {
                return 50;
            }else{
                return 0;
            }
        };
        //设置区头偏移
        _tableView.viewModel.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_scrollView_didScroll) {
                UIScrollView *scrollView = obj;
                CGFloat offsetY = scrollView.contentOffset.y;
                CGFloat tableHeaderViewHeight = 200;
                // 修改导航栏透明度
                 weakSelf.navigationSearchView.alpha = offsetY / tableHeaderViewHeight;
                // 修改组头悬停位置
                if (offsetY >= tableHeaderViewHeight) {
                    // 留出导航栏的位置
                    weakTableView.contentInset = UIEdgeInsetsMake(FAN_NAV_HEIGHT, 0, 0, 0);
                } else {
                    weakTableView.contentInset = UIEdgeInsetsZero;
                }
                HomeSectionHeaderModel *model = weakSelf.sectionHeaderView.model.contentList[weakSelf.sectionHeaderView.model.currentIndex];
                model.contentOffsetY = offsetY;
            }else if(idx == cat_action_cell_click){
                FanModel *model = obj;
                [weakSelf pushViewControllerWithUrl:model.urlScheme transferData:nil hander:nil];
            }
        };
    }return _tableView;
}
- (NSArray *)menus{
    if (!_menus) {
        NSArray *menus = @[@{@"title":@"推荐",@"type":@"recommend"},@{@"title":@"周边游",@"type":@"near"},@{@"title":@"一日游",@"type":@"oneday"}];
        _menus = menus;
    }return _menus;
}
- (HomeNavigationView *)navigationSearchView{
    if (!_navigationSearchView) {
        _navigationSearchView = [[HomeNavigationView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_NAV_HEIGHT)];
        __weak HomeController *weakSelf = self;
        _navigationSearchView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_message) {
                [weakSelf pushViewControllerWithUrl:@"MessageListController" transferData:nil hander:nil];
            }else if (idx == cat_search_city){
                [weakSelf pushViewControllerWithUrl:@"SearchController?type=1" transferData:nil hander:^(id obj, int idx) {
                    //1 获取数据
                    [weakSelf setCity:obj];
                }];
            }else if (idx == cat_search_ScenicSpot){
                [weakSelf pushViewControllerWithUrl:@"SearchController?type=3" transferData:nil hander:nil];
            }
        };
    }return _navigationSearchView;
}
- (HomeSectionHeaderView *)sectionHeaderView{
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[HomeSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, 50)];
        _sectionHeaderView.buttonWidth = (FAN_SCREEN_WIDTH - 20 )/self.menus.count;
        _sectionHeaderView.menus = self.menus;
        __weak HomeController *weakSelf = self;
        _sectionHeaderView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_click) {
                HomeSectionHeaderModel *model = weakSelf.sectionHeaderView.model.contentList[[obj integerValue]];
                model.scroll = YES;
                if (model.isLoadData) {
                     [weakSelf changeCurrentModel:model];
                }else
                    [weakSelf loadListData:model];
            }
        };
    }return _sectionHeaderView;
}
- (FanErrorView *)errorView{
    if (!_errorView) {
        _errorView = [[FanErrorView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_CONTENT_HEIGHT)];
        __weak HomeController *weakSelf = self;
        _errorView.customActionBlock = ^(id obj, cat_action_type idx) {
            [weakSelf setCity:weakSelf.city];
        };
    }return _errorView;
}
@end
