//
//  FanViewModel.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/20.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "FanViewModel.h"

@interface FanViewModel ()
@property (nonatomic ,strong) FanErrorCellModel *errorCellModel;
@end

@implementation FanViewModel
- (FanErrorCellModel *)errorCellModel{
    if (!_errorCellModel) {
        _errorCellModel = [FanErrorCellModel modelWithJson:@{@"title":[self.errorTitle isNotBlank]? self.errorTitle: @"暂无相关数据",@"errorType":[NSString stringWithFormat:@"%ld",self.errorType]}];
    }return _errorCellModel;
}
- (void)dealloc{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    self.customActionBlock  = nil;
    self.resultActionBlock  = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark taleview
- (void)setIsmore:(BOOL)ismore{
    _ismore  = ismore;
    self.tableView.more = ismore;
}
+ (instancetype)initWithTableView:(FanTableView *)tableView{
    FanViewModel *model = [self new];
    model.contentList = [NSMutableArray array];
    model.tableView = tableView;
    tableView.delegate = model;
    tableView.dataSource = model;
    return model;
}
- (void)setTableView:(FanTableView *)tableView{
    _tableView = tableView;
    if (!tableView.tableHeaderView) {
        tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    }
    if (!tableView.tableFooterView) {
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    }
    //注册常用的 公共cell
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:FanTableViewCellId];
    [tableView registerClass:[FanNilCell class] forCellReuseIdentifier:FanNilCellId];
}
- (void)insertList:(id)obj index:(int)index{
    
}
- (void)setList:(NSArray *)list type:(int)type{//type 0 刷新 1追加.
    if (!self.contentList) {
        self.contentList = [NSMutableArray array];
    }
    list = list ?: [NSArray array];
    if (type == tct_refresh) {
        //无更多
        [self.contentList setArray:list];
        
        if (_errorType && list.count <= 0) {
            [self.contentList addObject:self.errorCellModel];
        }else{
            if ([self.contentList containsObject:_errorCellModel]) {
                [self.contentList removeObject:_errorCellModel];
            }
        }
        
    }else if (type == tct_append){
        //设置无更多数据
        [self.contentList addObjectsFromArray:list];
    }else if (type == tct_append_front){
        [self.contentList insertObjects:list atIndexes:[NSIndexSet indexSetWithIndex:0]];
    }
    
   
    if (_tableView) {
        [_tableView reloadData];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FanModel *model = [self.contentList.firstObject isKindOfClass:[NSArray class]] ? self.contentList[indexPath.section][indexPath.row] : self.contentList[indexPath.row];
    if (model.cellHeight) {
        return model.cellHeight;
    }else{
        //尝试使用cell layout 计算高度 在cell 的layoutsubviews 方法中 设置model.cellHeight
        FanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.fanClassName];
        if(!cell){
            if ([[NSClassFromString(model.fanClassName) new] respondsToSelector:@selector(initWithStyle: reuseIdentifier:)]) {
                cell = [[NSClassFromString(model.fanClassName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model.fanClassName];
            }else{
                DEF_DEBUG(@"加载了一个错误的Cell\n 类名%@",model.fanClassName);
            }
        }
        cell.cellModel = model;
        [cell layoutSubviews];
        return model.cellHeight;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self.contentList.firstObject isKindOfClass:[NSArray class]]){
        return [(NSArray *)self.contentList[section] count];
    }
    return self.contentList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.contentList.count){
        if([self.contentList.firstObject isKindOfClass:[NSArray class]]){
            return self.contentList.count;
        }
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FanModel *model = [self.contentList.firstObject isKindOfClass:[NSArray class]] ? self.contentList[indexPath.section][indexPath.row] : self.contentList[indexPath.row];
    model.row  = indexPath.row;
    model.section = indexPath.section;
    FanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.fanClassName];
    if(!cell){
        if ([[NSClassFromString(model.fanClassName) new] respondsToSelector:@selector(initWithStyle: reuseIdentifier:)]) {
            cell = [[NSClassFromString(model.fanClassName) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:model.fanClassName];
        }else{
            DEF_DEBUG(@"加载了一个错误的Cell\n 类名%@",model.fanClassName);
        }
    }
    cell.cellModel = model;
    cell.customActionBlock = self.customActionBlock;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    FanModel *model = [self.contentList.firstObject isKindOfClass:[NSArray class]] ? self.contentList[indexPath.section][indexPath.row] : self.contentList[indexPath.row];
//    FanTableViewCell * fancell = (FanTableViewCell *)cell;
//    fancell.cellModel = model;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(self.tableView.fanTableViewBlock){
        return self.tableView.fanTableViewBlock([NSString stringWithFormat:@"%ld",section],cat_table_viewForSectionHeader);
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.tableView.fanTableViewHeightBlock){
        return self.tableView.fanTableViewHeightBlock([NSString stringWithFormat:@"%ld",section],cat_table_heightForSectionHeader);
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FanModel *model = [self.contentList.firstObject isKindOfClass:[NSArray class]] ? self.contentList[indexPath.section][indexPath.row] : self.contentList[indexPath.row];
    if (self.customActionBlock && ![model.fanClassName isEqualToString:@"FanNilCell"]) {
        self.customActionBlock(model, cat_action_cell_click);
    }
}

#pragma makr -- scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.customActionBlock) {
        self.customActionBlock(scrollView, cat_action_scrollView_didScroll);
    }
}
- (NSMutableArray *)editArr{
    if (!_editArr) {
        _editArr = [NSMutableArray array];
    }
    return _editArr;
}

@end


@implementation FanCollectionDelegate


#pragma mark -- UICollection
- (void)dealloc{
    
    _collection.delegate = nil;
    _collection.dataSource = nil;
    _collection = nil;
    self.customActionBlock  = nil;
    self.resultActionBlock  = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)setMore:(BOOL)more{
    if (more) {
        self.collection.mj_footer.state = MJRefreshStateIdle;
    }else{
        self.collection.mj_footer.state = MJRefreshStateNoMoreData;
    }
}
+ (instancetype)initWithCollection:(FanCollection *)collection{
    FanCollectionDelegate *model = [self new];
    model.collection = collection;
    collection.delegate = model;
    collection.dataSource = model;
    return model;
}
- (void)setCollection:(FanCollection *)collection{
    _collection = collection;
}
- (void)setCollectionList:(NSArray *)list type:(int)type{
    if (!self.collectionContentList) {
        self.collectionContentList  = [NSMutableArray array];
    }
    list = list ?: [NSArray array];
    if (type == tct_refresh) {
        //无更多
        [self.collectionContentList setArray:list];
    }else if (type == tct_append){
        //设置无更多数据
        [self.collectionContentList addObjectsFromArray:list];
    }else if (type == tct_append_front){
        [self.collectionContentList insertObjects:list atIndexes:[NSIndexSet indexSetWithIndex:0]];
    }
    if (_collection) {
        [_collection reloadData];
        [_collection endRefreshing];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionContentList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FanModel *model = self.collectionContentList[indexPath.row];
    FanCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:model.fanClassName forIndexPath:indexPath];
    cell.cellModel = model;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FanModel *model = self.collectionContentList[indexPath.row];
    if (self.customActionBlock) {
        self.customActionBlock(model, cat_action_cell_click);
    }
}
@end

