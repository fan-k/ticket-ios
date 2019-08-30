//
//  UIButton+Category.m
//  FanProduct
//
//  Created by 99epay on 2019/6/19.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "UIButton+Category.h"

static const char *UIControl_enventIsIgnoreEvent_endtime_button = "UIControl_enventIsIgnoreEvent_endtime_button";
static const char *UIControl_enventIsIgnoreEvent_isTime_button = "UIControl_enventIsIgnoreEvent_isTime_button";



@implementation UIButton (Category)
- (void)startWithTimeInterval:(double)timeLine title:(NSString *)title timeColor:(NSString *)timeColor titleColor:(NSString *)titleColor{
    // 倒计时时间
    __block NSInteger timeOut = timeLine - 1;
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
                [self setTitle:title forState:UIControlStateNormal];
                [self setTitleColor:COLOR_PATTERN_STRING(timeColor) forState:0];
                self.userInteractionEnabled = YES;
            });
        }else{
            self.isTime = YES;
            int seconds = timeOut % (int)timeLine;
            NSString * timeStr = [NSString stringWithFormat:@"%d",seconds];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setTitle:[NSString stringWithFormat:@"%@秒",timeStr] forState:UIControlStateNormal];
                [self setTitleColor:COLOR_PATTERN_STRING(titleColor) forState:0];
                self.userInteractionEnabled = NO;
            });
            
            timeOut--;
        }
    });
    
    dispatch_resume(_timer);
}
- (void)setEndTime:(BOOL)endTime{
    objc_setAssociatedObject(self, UIControl_enventIsIgnoreEvent_endtime_button, @(endTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)endTime{
    return [objc_getAssociatedObject(self, UIControl_enventIsIgnoreEvent_endtime_button) boolValue];
}
- (void)setIsTime:(BOOL)isTime{
    objc_setAssociatedObject(self, UIControl_enventIsIgnoreEvent_isTime_button, @(isTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)isTime{
    return [objc_getAssociatedObject(self, UIControl_enventIsIgnoreEvent_isTime_button) boolValue];
}

@end
