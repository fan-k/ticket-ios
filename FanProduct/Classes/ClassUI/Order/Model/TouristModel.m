//
//  TouristModel.m
//  FanProduct
//
//  Created by 99epay on 2019/7/12.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "TouristModel.h"

@implementation TouristModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    TouristModel *model = [TouristModel new];
    model.name = DICTION_OBJECT(json, @"name");
    model.phone = DICTION_OBJECT(json, @"phone");
    model.card = DICTION_OBJECT(json, @"card");
    model.UUtourist_info = DICTION_OBJECT(json, @"UUtourist_info");
    model.o_id = DICTION_OBJECT(json, @"id");
    model.fanClassName = @"TouristCell";
    return model;
}
- (CGFloat)cellHeight{
    CGFloat height = 105;
    
    if (self.UUtourist_info.integerValue > 0) {
        //需要身份验证
        //f未选中 并且身份信息为空
        if (!self.selected  && ![self.card isNotBlank]) {
            height = 85;
        }
    }else{
        //不需要身份验证
        height = 85;
    }
    return height;
}
@end


@implementation TouristAddModel

- (instancetype)init{
    self = [super init];
    self.fanClassName = @"TouristAddCell";
    return self;
}

@end
