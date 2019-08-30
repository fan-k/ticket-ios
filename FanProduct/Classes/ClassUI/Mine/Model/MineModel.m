//
//  MineModel.m
//  FanProduct
//
//  Created by 99epay on 2019/6/12.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "MineModel.h"

@implementation MineModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    MineModel *model = [MineModel new];
    model.title = DICTION_OBJECT(json, @"title");
    model.contentList = DICTION_OBJECT(json, @"data");
    return model;
}
- (CGFloat)cellHeight{
    return 117;
}
- (NSString *)fanClassName{
    return @"MineCell";
}

@end
@implementation MineListCellModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    MineListCellModel *model = [MineListCellModel new];
    model.picture = DICTION_OBJECT(json, @"picture");
    return model;
}

- (CGFloat)cellHeight{
    return 75;
}
- (NSString *)fanClassName{
    return @"MineListCell";
}
@end


@implementation MineUserInfoCityModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    MineUserInfoCityModel *model = [MineUserInfoCityModel new];
    model.lists = isValidArray(DICTION_OBJECT(json, @"citys")) ? DICTION_OBJECT(json, @"citys") : nil;
    model.name = DICTION_OBJECT(json, @"name");
    model.citys = DICTION_OBJECT(json, @"cities");
    return model;
}

- (NSMutableArray *)mutbleCitys{
    if (!_mutbleCitys) {
        _mutbleCitys = [NSMutableArray array];
        for (NSDictionary *dict in self.lists) {
            MineUserInfoCityModel *model = [MineUserInfoCityModel modelWithJson:dict];
            [_mutbleCitys addObject:model];
        }
    }
    return _mutbleCitys;
}

@end
