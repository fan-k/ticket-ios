//
//  FanViewModel.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/20.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "FanObject.h"

typedef enum _tableview_content_type {
    tct_refresh=0,//刷新
    tct_append,//追加
    tct_append_front,//前面追加
    tct_append_other,//其他模式
}TableviewContentType;


static NSString *const FanNilCellId = @"FanNilModel";
static NSString *const FanTableViewCellId = @"FanTableViewCellId";



/**ViewModel 基类，主要封装TableView的代理*/
@interface FanViewModel : FanObject<UITableViewDelegate,UITableViewDataSource>
#pragma mark -- FanTableView

@property(nonatomic, strong)NSMutableArray *contentList;
@property (nonatomic ,strong) NSMutableArray *editArr;
@property(nonatomic, weak)FanTableView *tableView;
/**是否请求过接口数据*/
@property (nonatomic ,assign) BOOL isRequested;
/**当前列表的最后一条数据ID 用于加载更多*/
@property (nonatomic ,copy) NSString *lastId;
/**当前列表数据的状态 是否有更多数据*/
@property (nonatomic ,assign) BOOL ismore;
/**viewModel的自定义数据源*/
@property (nonatomic ,strong) id obj;
/**errorType*/
@property (nonatomic ,assign) NSUInteger errorType;
/**errorTitle*/
@property (nonatomic ,copy) NSString *errorTitle;
/**
 列表赋值刷新
 
 @param list 数据源
 @param type TableviewContentType
 */
- (void)setList:(NSArray *)list type:(int)type;
//插入数据或列表元素
- (void)insertList:(id)obj index:(int)index;
/**
 初始化

 @param tableView tableView
 @return viewModel
 */
+ (instancetype)initWithTableView:(UITableView *)tableView;


@end



@interface FanCollectionDelegate : NSObject<UICollectionViewDelegate,UICollectionViewDataSource>
#pragma mark  -- collection
@property(nonatomic, strong)NSMutableArray *collectionContentList;

@property(nonatomic, weak) FanCollection *collection;

/**是否请求过接口数据*/
@property (nonatomic ,assign) BOOL isRequested;
/**当前列表的最后一条数据ID 用于加载更多*/
@property (nonatomic ,copy) NSString *lastId;

/**无更多*/
@property (nonatomic ,assign) BOOL more;
/**数据源*/
@property (nonatomic ,strong) id obj;
/**
 列表赋值刷新
 
 @param list 数据源
 @param type TableviewContentType
 */
- (void)setCollectionList:(NSArray *)list type:(int)type;
/**
 初始化
 
 @param collection collection
 @return viewModel
 */
+ (instancetype)initWithCollection:(FanCollection *)collection;


@end

