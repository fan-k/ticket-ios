//
//  FanConfig.m
//  FanProduct
//
//  Created by 99epay on 2019/7/2.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanConfig.h"

@implementation FanConfig
+ (instancetype)shareInstance{
    static FanConfig *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[FanConfig alloc] init];
    });
    return tool;
}
@end
