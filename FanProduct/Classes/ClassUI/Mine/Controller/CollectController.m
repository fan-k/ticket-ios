//
//  CollectController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "CollectController.h"
#import "HomeModel.h"

@interface CollectController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) FanTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *collectList;
@property (nonatomic ,strong) FanErrorView *errorView;
@property (nonatomic ,copy) NSString *type;
@end

@implementation CollectController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = [self.type isEqualToString:@"collect"] ? @"我的收藏" :@"浏览记录";
    self.rightTxt = @"清空";
     [self initlist];
}
- (void)rightNavBtnCilck{
    [FanAlert showAlertControllerWithTitle:@"提示" message:[self.type isEqualToString:@"collect"] ? @"是否清空收藏" :@"是否清空浏览记录" _cancletitle_:@"取消" _confirmtitle_:@"确定" handler1:nil handler2:^(UIAlertAction * _Nonnull action) {
        [self.type isEqualToString:@"collect"]  ? [[FanDataBase shareInstance] deleteAllCollect] : [[FanDataBase shareInstance] deleteAllHistory];
        self.collectList = nil;
        [self initlist];
    }];
}
- (void)initlist{
    if (self.collectList.count) {
        [self.tableView reloadData];
        self.tableView.more = NO;
        if (_errorView) {
            [_errorView removeFromSuperview];
            _errorView.customActionBlock = nil;
            _errorView = nil;
        }
    }else{
        if (!_errorView) {
            [self.view addSubview:self.errorView];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FanModel *model = self.collectList[indexPath.row];
    return model.cellHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.collectList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FanModel *model =  self.collectList[indexPath.row];
    model.row  = indexPath.row;
    model.section = indexPath.section;
    FanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.fanClassName];
    if(!cell){
        cell = [[NSClassFromString(model.fanClassName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model.fanClassName];
    }
    cell.cellModel = model;
    cell.customActionBlock = self.customActionBlock;
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FanModel *model =  self.collectList[indexPath.row];
    [self pushViewControllerWithUrl:model.urlScheme transferData:nil hander:nil];
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath{
    return YES;
}
- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath{
    FanModel *model =  self.collectList[indexPath.row];
    [self.collectList removeObject:model];
    [[FanDataBase shareInstance] deleteCollectWidthId:model.o_id];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    if (!self.collectList.count) {
        if (!_errorView) {
            [self.view addSubview:self.errorView];
        }
    }else{
        if (_errorView) {
            [_errorView removeFromSuperview];
            _errorView.customActionBlock = nil;
            _errorView = nil;
        }
    }
}



- (NSMutableArray *)collectList{
    if (!_collectList) {
        NSArray *arr = [self.type isEqualToString:@"collect"] ? [[FanDataBase shareInstance] selectAllCollect] :[[FanDataBase shareInstance] selectAllHistory];
        HomeContentModel *model = [HomeContentModel modelWithJson:@{@"data":arr}];
        _collectList = [NSMutableArray arrayWithArray:model.contentList];
    }return _collectList;
}
- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView  = [[FanTableView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        __weak CollectController *weakSelf = self;
        _tableView.headRefreshblock = ^{
            weakSelf.collectList = nil;
            [weakSelf.tableView reloadData];
            weakSelf.tableView.more = NO;
        };
    }return _tableView;
}
- (FanErrorView *)errorView{
    if (!_errorView) {
        _errorView = [[FanErrorView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT)];
        __weak CollectController *weakSelf = self;
        _errorView.type = FanErrorTypeNoData;
        _errorView.errorTxt = [self.type isEqualToString:@"collect"] ?  @"暂无收藏":@"暂无浏览记录";
        _errorView.customActionBlock = ^(id obj, cat_action_type idx) {
            weakSelf.collectList = nil;
            [weakSelf initlist];
        };
    }return _errorView;
}
- (NSString *)type{
    if (!_type) {
        _type   = DICTION_OBJECT(self.urlParams, @"type");
    }return _type;
}
@end
