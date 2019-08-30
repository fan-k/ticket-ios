//
//  ScenicFooterView.m
//  FanProduct
//
//  Created by 99epay on 2019/6/10.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "ScenicFooterView.h"

@implementation ScenicFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *lb2 = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2 - 75, 0, 150, 50)];
        lb2.textAlignment = NSTextAlignmentCenter;
        lb2.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        lb2.font =  FanRegularFont(12);
        lb2.text = @"专业服务 全程保障";
        [self addSubview:lb2];
        UILabel *lb1 = [[UILabel alloc] initWithFrame:CGRectMake(lb2.left - 50, 25, 30, FAN_LINE_HEIGHT)];
        lb1.backgroundColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        [self addSubview:lb1];
        UILabel *lb3 = [[UILabel alloc] initWithFrame:CGRectMake(lb2.right + 20, 25, 30, FAN_LINE_HEIGHT)];
        lb3.backgroundColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        [self addSubview:lb3];
        self.backgroundColor = COLOR_PATTERN_STRING(@"_whiter_color");
    }return self;
}


@end
