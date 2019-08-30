//
//  FoundController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/5.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FoundController.h"
#import "HomeModel.h"
#import "FoundClassView.h"
#import "FoundSearchView.h"
#import "SearchModel.h"
@interface FoundController ()
@property (nonatomic ,strong) FoundSearchView *navigationSearchView;
@property (nonatomic ,strong) HomeModel *homeModel;
@property (nonatomic ,strong) FoundClassView *foundClassView;
@property (nonatomic ,copy) NSString *city;
@property (nonatomic ,strong) FanErrorView *errorView;
@end

@implementation FoundController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.navigationSearchView];
    //开启定位 根据位置信息 获取数据
    __weak typeof(self) weakSelf = self;
    [FanLocationManager startUpdatingLocationWithHander:^(CLLocation *location, cat_action_type idx) {
        weakSelf.city = [FanLocationManager shareInstance].cityName;
    }];
    // Do any additional setup after loading the view.
}
- (void)setCity:(NSString *)city{
    if(isValidString(city)){
        _city = city;
        [self.navigationSearchView setCity:city];
        //获取分类
        self.params[@"city"] = city;
        [self requestWithUrl:FanUrlViewClass loading:YES];
    }
}
- (void)initList:(id)obj{
    FanCollectionDelegate *vm = obj;
    HomeSectionHeaderModel *model = vm.obj;
    self.params[@"theme"] = model.type;
    [self requestWithUrl:FanUrlViewList object:obj loading:YES error:FanErrorTypeError];
}

- (void)handelFailureRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlViewClass]) {
        //添加error
        [self.view addSubview:self.errorView];
        [self.view bringSubviewToFront:self.errorView];
        self.errorView.type = [FanRequestTool net] ? FanErrorTypeError : FanErrorTypeNet;
    }
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlViewClass]) {
        self.foundClassView.menus = DICTION_OBJECT(item.responseObject, @"data");
        [self.foundClassView setIndex:0];
        if (_errorView) {
            _errorView.customActionBlock = nil;
            [_errorView removeFromSuperview];
            _errorView = nil;
        }
    }else if ([item.url isEqualToString:FanUrlViewList]) {
        [self.foundClassView managerListWithItem:item];
    }
}


- (FoundClassView *)foundClassView{
    if (!_foundClassView) {
        _foundClassView = [[FoundClassView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_CONTENT_HEIGHT)];
        __weak FoundController *weakSelf = self;
        _foundClassView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_table_refresh) {
                [weakSelf initList:obj];
            }else if (idx == cat_table_load){
                [weakSelf initList:obj];
            }
            else if (idx == cat_found_class_add){
                [weakSelf presentViewControllerWithUrl:@"FoundClassController" transferData:obj hander:^(id obj, int idx) {
                    weakSelf.foundClassView.index  = [obj integerValue];
                }];
            }else if (idx == cat_action_cell_click){
                FanModel *model = obj;
                [weakSelf pushViewControllerWithUrl:model.urlScheme transferData:nil hander:nil];
            }
            
        };
        [self.view addSubview:_foundClassView];

    }return _foundClassView;
}
- (FoundSearchView *)navigationSearchView{
    if (!_navigationSearchView) {
        _navigationSearchView = [[FoundSearchView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_NAV_HEIGHT)];
        __weak FoundController *weakSelf = self;
        _navigationSearchView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_search_city){
                [weakSelf pushViewControllerWithUrl:@"SearchController?type=1" transferData:nil hander:^(id obj, int idx) {
                     weakSelf.city = obj;
                }];
            }else if (idx == cat_search_ScenicSpot){
                [weakSelf pushViewControllerWithUrl:@"SearchController?type=3" transferData:nil hander:nil];
            }
        };
    }return _navigationSearchView;
}
- (FanErrorView *)errorView{
    if (!_errorView) {
        _errorView = [[FanErrorView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_CONTENT_HEIGHT)];
    }return _errorView;
}
@end
