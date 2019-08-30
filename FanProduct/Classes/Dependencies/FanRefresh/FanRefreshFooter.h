//
//  FanRefreshFooter.h
//  FanProduct
//
//  Created by 99epay on 2019/6/18.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FanRefreshFooter : MJRefreshAutoStateFooter
/** 文字距离圈圈、箭头的距离 */
@property (assign, nonatomic) CGFloat labelLeftInset;
/** 显示刷新状态的label */
@property (weak, nonatomic, readonly) UILabel *stateLabel;

/** 设置state状态下的文字 */
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;

/** 隐藏刷新状态的文字 */
@property (assign, nonatomic, getter=isRefreshingTitleHidden) BOOL refreshingTitleHidden;
@end

NS_ASSUME_NONNULL_END
