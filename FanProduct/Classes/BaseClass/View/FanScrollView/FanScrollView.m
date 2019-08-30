//
//  FanScrollView.m
//  FanProduct
//
//  Created by 99epay on 2019/6/21.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanScrollView.h"

@implementation FanScrollView

/**用于首页HomeController*/
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view       = [super hitTest:point withEvent:event];
    BOOL hitHead       = point.y < (self.headerHeight - self.offset.y);
    if (hitHead || !view) {
        self.scrollEnabled = NO;
        if (!view) {
            for (UIView* subView in self.subviews) {
                if (subView.frame.origin.x == self.contentOffset.x) {
                    view = subView;
                }
            }
        }
        return view;
    } else {
        self.scrollEnabled = YES;
        return view;
    }
}

@end
