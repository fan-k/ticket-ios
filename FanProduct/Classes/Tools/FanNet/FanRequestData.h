//
//  FanRequestData.h
//  FanProduct
//
//  Created by 99epay on 2019/6/5.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface FanRequestData : FanObject
/**单例*/
+ (instancetype)shareInstance;
- (NSDictionary *)requestDataItem:(FanRequestItem *)item;

@end

NS_ASSUME_NONNULL_END
