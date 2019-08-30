//
//  UIColor+HexString.m
//  FanProduct
//
//  Created by 樊康鹏 on 2019/2/17.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "UIColor+HexString.h"

@implementation UIColor (HexString)
+ (UIColor *)colorWithClassName:(NSString *)nameString{
    //拿到类名  名字为唯一的标识
    //取颜色
    NSDictionary *dict = [FanColor shareInstance].color_plist;
    NSString *rgb = DICTION_OBJECT(dict, nameString);
    //区分下16进制和rgb
    //rgb 存储方式中是以,分割
    if ([rgb containsString:@","]) {
        NSArray *rgbs = [rgb componentsSeparatedByString:@","];
        if (rgbs.count >= 3){
            float r = [rgbs[0] floatValue];
            float g = [rgbs[1] floatValue];
            float b = [rgbs[2] floatValue];
            if (rgbs.count == 4) {
                float alpha = [rgbs[3] floatValue];
                UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:alpha];
                return color;
            }else{
                UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
                return color;
            }
        }
    }else if ([rgb containsString:@"#"]){//16进制
        return [UIColor colorWithHexString:rgb];
    }
    
    return [UIColor whiteColor];
}
+ (UIColor *)colorWithHexString:(NSString *)color {
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
    cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
    cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
    return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

@end
