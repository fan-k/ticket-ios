//
//  FanColor.m
//  FanProduct
//
//  Created by 99epay on 2019/6/19.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanColor.h"

@implementation FanColor
+ (instancetype)shareInstance{
    static FanColor *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[FanColor alloc] init];
    });
    return tool;
}
- (NSDictionary *)color_plist{
    if (!_color_plist) {
        _color_plist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"color" ofType:@"plist"]];
    }return _color_plist;
}
@end
