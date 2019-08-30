//
//  WalletModel.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "WalletModel.h"

@implementation WalletModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    WalletModel *model = [WalletModel new];
    model.balance = DICTION_OBJECT(json, @"balance");
    model.whiteList = [DICTION_OBJECT(json, @"white") boolValue];
    model.hasBank = [DICTION_OBJECT(json, @"addBank") boolValue];
    model.setPayPwd = [DICTION_OBJECT(json, @"paypwd") boolValue];
    
 
    
    return model;
}

@end



@implementation WalletCellModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    WalletCellModel *model = [WalletCellModel new];
    model.title = DICTION_OBJECT(json, @"title");
    model.desc = DICTION_OBJECT(json, @"desc");
    model.urlScheme = DICTION_OBJECT(json, @"urlScheme");
    return model;
}
- (CGFloat)cellHeight{
    return 55;
}
- (NSString *)fanClassName{
    return @"WalletCell";
}

@end
