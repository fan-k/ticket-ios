//
//  UILabel+Category.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/27.
//  Copyright © 2018 Fan. All rights reserved.
//


#import "UILabel+Category.h"


static const char *UIControl_enventIsIgnoreEvent_endtime = "UIControl_enventIsIgnoreEvent_endtime";
static const char *UIControl_enventIsIgnoreEvent_Time_change_font = "UIControl_enventIsIgnoreEvent_Time_change_font";
static const char *UIControl_enventIsIgnoreEvent_Time_change_color = "UIControl_enventIsIgnoreEvent_Time_change_color";
static const char *UIControl_enventIsIgnoreEvent_Time_change_text = "UIControl_enventIsIgnoreEvent_Time_change_text";
static const char *UIControl_enventIsIgnoreEvent_isTime = "UIControl_enventIsIgnoreEvent_isTime";
static const char *UIControl_enventIsIgnoreEvent_self_text = "UIControl_enventIsIgnoreEvent_self_text";



@implementation UILabel (Category)
+ (instancetype)createLabelWithFrame:(CGRect)frame text:(NSString *)text titleColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font{
    UILabel *l = [[UILabel alloc]initWithFrame:frame];
    l.text = text;
    l.textColor = textColor;
    l.textAlignment = textAlignment;
    l.font = font;
    return l;
}

- (void)startWithTimeInterval:(double)timeLine{
    // 倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        
        // 倒计时结束，关闭
        if (timeOut <= 0 || self.endTime) {
            self.isTime = NO;
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.time_change_text.length > 0 && self.self_text.length > 0) {
                    NSString *string = [NSString stringWithFormat:@"%@",self.self_text];
                    NSMutableAttributedString *att = [string changetargetTextColor:COLOR_PATTERN_STRING(self.time_change_color) font:self.time_change_font withText:self.time_change_text];
                    [self setAttributedText:att];
                }else
                    if (self.self_text.length > 0) {
                        [self setText:[NSString stringWithFormat:@"%@",self.self_text]];
                    }else
                        [self setText:@""];
                if (self.customActionBlock){
                    self.customActionBlock(self, cat_time_out);
                }
            });
        }else{
            self.isTime = YES;
            int seconds = timeOut % 60;
            NSString * timeStr = [NSString stringWithFormat:@"%d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.time_change_text.length > 0 && self.self_text.length > 0) {
                    NSString *string = [NSString stringWithFormat:@"%@%@",timeStr,self.self_text];
                    NSMutableAttributedString *att = [string changetargetTextColor:COLOR_PATTERN_STRING(self.time_change_color) font:self.time_change_font withText:self.time_change_text];
                    [self setAttributedText:att];
                }else
                    if (self.self_text.length > 0) {
                        [self setText:[NSString stringWithFormat:@"%@%@",timeStr,self.self_text]];
                    }else  [self setText:[NSString stringWithFormat:@"%@秒",timeStr]];
            });
            timeOut--;
        }
    });
    
    dispatch_resume(_timer);
}


- (void)setTime_change_font:(NSUInteger)time_change_font{
    objc_setAssociatedObject(self, UIControl_enventIsIgnoreEvent_Time_change_font, @(time_change_font), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSUInteger)time_change_font{
    return [objc_getAssociatedObject(self, UIControl_enventIsIgnoreEvent_Time_change_font) integerValue];
}

- (void)setTime_change_text:(NSString *)time_change_text{
    objc_setAssociatedObject(self, UIControl_enventIsIgnoreEvent_Time_change_text, time_change_text, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)time_change_text{
    return objc_getAssociatedObject(self, UIControl_enventIsIgnoreEvent_Time_change_text);
}
- (void)setTime_change_color:(NSString *)time_change_color{
    objc_setAssociatedObject(self, UIControl_enventIsIgnoreEvent_Time_change_color, time_change_color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)time_change_color{
    return objc_getAssociatedObject(self, UIControl_enventIsIgnoreEvent_Time_change_color);
}
- (void)setEndTime:(BOOL)endTime{
    objc_setAssociatedObject(self, UIControl_enventIsIgnoreEvent_endtime, @(endTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)endTime{
    return [objc_getAssociatedObject(self, UIControl_enventIsIgnoreEvent_endtime) boolValue];
}
- (void)setIsTime:(BOOL)isTime{
    objc_setAssociatedObject(self, UIControl_enventIsIgnoreEvent_isTime, @(isTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isTime{
    return [objc_getAssociatedObject(self, UIControl_enventIsIgnoreEvent_isTime) boolValue];
}
- (void)setSelf_text:(NSString *)self_text{
    objc_setAssociatedObject(self, UIControl_enventIsIgnoreEvent_self_text, self_text, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)self_text{
    return objc_getAssociatedObject(self, UIControl_enventIsIgnoreEvent_self_text);
}
@end
