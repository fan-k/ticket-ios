//
//  FanColor.h
//  FanProduct
//
//  Created by 99epay on 2019/6/19.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FanColor : UIColor
+ (instancetype)shareInstance;
@property (nonatomic ,strong) NSDictionary *color_plist;
@end

NS_ASSUME_NONNULL_END
