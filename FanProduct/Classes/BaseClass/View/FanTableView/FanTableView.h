//
//  FanTableView.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/28.
//  Copyright © 2018 Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FanRefresh.h"
@class FanViewModel;



@interface FanTableView : UITableView
@property (nonatomic ,strong)FanViewModel *viewModel;
/**列表区头高度*/
@property (nonatomic ,copy) CGFloat (^fanTableViewHeightBlock)(id obj, int idx);
/**列表区头视图*/
@property (nonatomic ,copy) id (^fanTableViewBlock)(id obj, int idx);
/**区头*/
@property (nonatomic ,strong) NSMutableArray *sectionViews;
/**下拉刷新*/
@property (nonatomic ,copy) void (^headRefreshblock)();
/**上提加载*/
@property (nonatomic ,copy) void (^footRefreshblock)();

/**无更多*/
@property (nonatomic ,assign) BOOL more;

/**结束刷新*/
- (void)endRefreshing;
@end




