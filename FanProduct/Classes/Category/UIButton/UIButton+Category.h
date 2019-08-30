//
//  UIButton+Category.h
//  FanProduct
//
//  Created by 99epay on 2019/6/19.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Category)
/**
 *  倒计时
 *
 *  @param timeLine 倒计时
 *  @param timeColor 倒计时时间文字字体颜色
 *  @param titleColor 按钮文本的字体颜色
 */
- (void)startWithTimeInterval:(double)timeLine title:(NSString *)title timeColor:(NSString *)timeColor titleColor:(NSString *)titleColor;
/**倒计时状态*/
@property(nonatomic,assign)BOOL isTime;
/**结束倒计时*/
@property(nonatomic,assign)BOOL endTime;
@end

NS_ASSUME_NONNULL_END
