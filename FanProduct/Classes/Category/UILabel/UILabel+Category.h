//
//  UILabel+Category.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/27.
//  Copyright © 2018 Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Category)

/**
 创建label

 @param frame frame
 @param text text
 @param textColor textColor
 @param textAlignment textAlignment
 @param font font
 @return label
 */
+ (instancetype)createLabelWithFrame:(CGRect)frame
                                text:(NSString *)text
                          titleColor:(UIColor *)textColor
                       textAlignment:(NSTextAlignment)textAlignment
                                font:(UIFont *)font;

/**
 * 开始倒计时
 */
- (void)startWithTimeInterval:(double)timeLine;
/**结束倒计时*/
@property(nonatomic,assign)BOOL endTime;
/**倒计时除时间外的文本*/
@property(nonatomic ,copy) NSString *self_text;
/**倒计时时要改变颜色的文本*/
@property(nonatomic ,copy) NSString *time_change_text;
/**倒计时时要改变颜色的文本的字号*/
@property(nonatomic ,assign) NSUInteger time_change_font;
/**倒计时时要改变颜色的文本的颜色*/
@property(nonatomic ,copy) NSString *time_change_color;
/**倒计时状态*/
@property(nonatomic,assign)BOOL isTime;


@end
