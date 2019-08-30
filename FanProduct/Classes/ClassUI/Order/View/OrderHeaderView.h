//
//  OrderHeaderView.h
//  FanProduct
//
//  Created by 99epay on 2019/7/9.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanView.h"
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderHeaderView : FanView
@property (nonatomic ,strong) NSArray *menus;
@property (nonatomic ,assign) NSInteger selectIndex;
@property (nonatomic ,strong) HomeSectionHeaderModel *model;
@end

NS_ASSUME_NONNULL_END
