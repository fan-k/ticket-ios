//
//  FanConfig.h
//  FanProduct
//
//  Created by 99epay on 2019/7/2.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FanConfig : NSObject
+ (instancetype)shareInstance;

//版本更新
@property (nonatomic ,copy) NSString *version;
@property (nonatomic ,copy) NSString *versionContent;

@end

NS_ASSUME_NONNULL_END
