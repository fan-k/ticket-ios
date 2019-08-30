//
//  UIColor+HexString.h
//  FanProduct
//
//  Created by 樊康鹏 on 2019/2/17.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface UIColor (HexString)
+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithClassName:(NSString *)nameString;
@end

NS_ASSUME_NONNULL_END
