//
//  HomeSectionHeaderView.h
//  FanProduct
//
//  Created by 99epay on 2019/6/6.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanView.h"
#import "HomeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeSectionHeaderView : FanView
@property (nonatomic ,strong) NSArray *menus;
/**默认自适配、设置后取设置的值*/
@property (nonatomic ,assign) CGFloat buttonWidth;
@property (nonatomic ,strong) HomeSectionHeaderModel *model;
@property (nonatomic ,assign) NSInteger selectIndex;
@end




NS_ASSUME_NONNULL_END
