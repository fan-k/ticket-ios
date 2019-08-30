//
//  FanClassView.h
//  FanProduct
//
//  Created by 99epay on 2019/6/20.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FanClassView : FanView<UIScrollViewDelegate>

@property (nonatomic ,copy) NSArray<UIViewController *> *tables;
@property (nonatomic ,copy) NSArray<NSString *> *titles;
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIView *titleView;
/**可选 是否可以滑动 默认 YES*/
@property (nonatomic ,assign) BOOL  canSlide;
/**
 可选 手动选中某个iem
 
 @param index item下标
 */
- (void)selectIndex:(NSInteger)index;

- (instancetype)initWithFrame:(CGRect)frame tables:(NSArray<UIViewController *> *)tables titleView:(UIView *)titleView;

@end



NS_ASSUME_NONNULL_END
