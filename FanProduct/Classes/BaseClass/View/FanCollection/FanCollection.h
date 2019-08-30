//
//  FanCollection.h
//  FanProduct
//
//  Created by 99epay on 2019/6/18.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FanCollectionDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface FanCollection : UICollectionView
@property (nonatomic ,strong)FanCollectionDelegate *viewModel;

/**下拉刷新*/
@property (nonatomic ,copy) void (^headRefreshblock)();
/**上提加载*/
@property (nonatomic ,copy) void (^footRefreshblock)();

/**无更多*/
@property (nonatomic ,assign) BOOL more;

/**结束刷新*/
- (void)endRefreshing;
@end

NS_ASSUME_NONNULL_END
