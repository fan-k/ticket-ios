//
//  FoundClassView.h
//  FanProduct
//
//  Created by 99epay on 2019/6/10.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanView.h"
#import "HomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FoundClassView : FanView<UIScrollViewDelegate>

@property (nonatomic ,assign) NSUInteger index;
@property (nonatomic ,strong) NSArray *menus;

// 处理加载的列表数据
- (void)managerListWithItem:(FanRequestItem *)item;
@end


NS_ASSUME_NONNULL_END
