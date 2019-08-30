//
//  NSString+Category.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/17.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "NSString+Category.h"
#import <objc/runtime.h>
#import "sys/utsname.h"


@implementation NSString (bank)
/**银行卡背景颜色*/
- (NSString *)bankBgColor{
    if ([self rangeOfString:@"工商银行"].location != NSNotFound) {
        //工商
        return @"_ff625a_color";
    }else if ([self rangeOfString:@"交通"].location != NSNotFound) {
        //交通
        return @"_2c95f0_color";
    }else if ([self rangeOfString:@"农业银行"].location != NSNotFound) {
        //农业
       return @"_59cfbf_color";
    }else if ([self rangeOfString:@"建设银行"].location != NSNotFound) {
        //建设
        return @"_2c95f0_color";
    }else if ([self rangeOfString:@"中国银行"].location != NSNotFound) {
        //中国
        return @"_ff625a_color";
    }else  {
        //其他
        return@"_ff8048_color";
    }
}
/**银行卡背景图片*/
- (NSString *)bankBgImage{
    if ([self rangeOfString:@"工商银行"].location != NSNotFound) {
        //工商
        return @"bank_bg_gs";
    }else if ([self rangeOfString:@"交通"].location != NSNotFound) {
        //交通
        return @"bank_bg_jt";
    }else if ([self rangeOfString:@"农业银行"].location != NSNotFound) {
        //农业
        return @"bank_bg_ny";
    }else if ([self rangeOfString:@"建设银行"].location != NSNotFound) {
        //建设
        return @"bank_bg_js";
    }else if ([self rangeOfString:@"中国银行"].location != NSNotFound) {
        //中国
        return @"bank_bg_zg";
    }else  {
        //其他
        return @"bank_bg_default";
    }
}
/**银行卡图标*/
- (NSString *)bankIcon{
    if ([self rangeOfString:@"工商银行"].location != NSNotFound) {
        //工商
        return @"bank_icon_gs";
    }else if ([self rangeOfString:@"交通"].location != NSNotFound) {
        //交通
       return @"bank_icon_jt";
    }else if ([self rangeOfString:@"农业银行"].location != NSNotFound) {
        //农业
        return @"bank_icon_ny";
    }else if ([self rangeOfString:@"建设银行"].location != NSNotFound) {
        //建设
        return @"bank_icon_js";
    }else if ([self rangeOfString:@"中国银行"].location != NSNotFound) {
        //中国
        return @"bank_icon_zg";
    }else  {
        //其他
        return @"bank_icon_default";
    }
}
@end

@implementation NSString (Category)
- (NSString *)toFilterSpace{
    NSString *string = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}
- (NSString *)phoneNumberReplace{
    return [self stringByReplacingCharactersInRange:NSMakeRange(3, 6) withString:@" **** **"];
}
/**数字转性别*/
- (NSString *)toConversionSex{
    if ([self isEqualToString:@"0"]) {
        return @"保密";
    }else if ([self isEqualToString:@"1"]){
        return @"男";
    }else
        return @"女";
}

/**性别转z数字*/
- (NSString *)toChangedSexToNumber{
    if ([self isEqualToString:@"保密"]) {
        return @"0";
    }else if ([self isEqualToString:@"男"]) {
        return @"1";
    } else
        return @"2";
}


/**改变目标文字的字体大小 颜色*/
-(NSMutableAttributedString *)changetargetTextColor:(UIColor *)color font:(NSInteger)font withText:(NSString *)string{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self];
    for (NSString *s in @[[string uppercaseString]]) {
        NSRange range = [self rangeOfString:[s uppercaseString] options:NSBackwardsSearch];// NSBackwardsSearch Search from end of source string  搜索所有的字符串到结束
        if (range.location != NSNotFound) {
            [att addAttribute:NSForegroundColorAttributeName value:color range:range];
            [att addAttribute:NSFontAttributeName value:FanFont(font) range:range];
        }
    }
    return att;
}
- (NSMutableAttributedString *)xieyi_changeColor:(NSString *)changeColorTxt withAlignment:(NSTextAlignment)alignment{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self];
    [att addAttributes:@{NSForegroundColorAttributeName:COLOR_PATTERN_STRING(@"_008aff_color")} range:NSMakeRange(self.length - changeColorTxt.length, changeColorTxt.length)];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:alignment];
    [att addAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, changeColorTxt.length)];
    
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setColor:COLOR_PATTERN_STRING(@"_008aff_color")];
    [att setTextHighlight:highlight range:NSMakeRange(self.length - changeColorTxt.length, changeColorTxt.length)];
    return att;
}

-(NSString *)formatterBankCardNum{
    NSString *tempStr = self;
    NSInteger size =(tempStr.length / 4);
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0;n < size; n++){
        [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(size*4, (tempStr.length % 4))]];
    tempStr = [tmpStrArr componentsJoinedByString:@" "];
    return tempStr;
}
- (NSString *)toClassController{
    NSString *className = [self.classTable objectForKey:self];
    if (![className isNotBlank]) {//如果映射表中 不存在 返回原有的值
        className = self;
    }
    return className;
}
- (NSDictionary *)classTable{
    return @{
             @"ScenicSpot":@"ScenicSpotController",
             @"scenic":@"ScenicSpotController",
             @"Scenicspot":@"ScenicSpotController",
             @"scenicspot":@"ScenicSpotController",
             @"SCENICSPOT":@"ScenicSpotController",
             
             };
}
+ (void)load{
    [super load];
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(substringToIndex:)), class_getInstanceMethod([self class], @selector(blt_substringToIndex:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(substringFromIndex:)), class_getInstanceMethod([self class], @selector(blt_substringFromIndex:)));
    
    Method originalMethod = class_getInstanceMethod(object_getClass((id)self), @selector(stringWithFormat:));
    Method swizzledMethod = class_getInstanceMethod(object_getClass((id)self), @selector(blt_stringWithFormat:));
    if (class_addMethod(object_getClass((id)self),  @selector(stringWithFormat:), method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(object_getClass((id)self), @selector(blt_stringWithFormat:), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }

}
- (NSString *)blt_substringFromIndex:(NSUInteger)from{
    if (self.length  < from) {
        from = self.length ;
    }
    return [self blt_substringFromIndex:from];
}
- (NSString *)blt_substringToIndex:(NSUInteger)to{
    if (self.length  < to) {
        to = self.length ;
    }
    return [self blt_substringToIndex:to];
}
/**排除因为%@出现的(null)*/
+ (instancetype)blt_stringWithFormat:(NSString *)format, ...{
    va_list ap;
    va_start(ap, format);
    NSString * string =  [[self alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    if (string.length) {
        string = [string stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    }
    return string;
}
- (NSDictionary *)toDict{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return dict;;
}
- (BOOL)isNotBlank {
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}
- (NSMutableDictionary *)urlToParamDict{
    //先转编码
    NSString *url  = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url];
    __block NSMutableDictionary *parm = [NSMutableDictionary new];
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //把pbj.value 转编码回来
        if (obj.value && obj.name) {
            [parm setObject:[obj.value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:obj.name];
        }
    }];
        
    return parm;
}
- (BOOL)equal:(NSString *)string{
    if ([self isEqualToString:string]) {
        return YES;
    }return NO;
}

+ (NSString *)iphoneType{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString*platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    if([platform isEqualToString:@"iPhone1,1"])
        return @"iPhone 2G";
    else if([platform isEqualToString:@"iPhone1,2"])
        return @"iPhone 3G";
    else if([platform isEqualToString:@"iPhone2,1"])
        return @"iPhone 3GS";
    else if([platform isEqualToString:@"iPhone3,1"])
        return @"iPhone 4";
    else if([platform isEqualToString:@"iPhone3,2"])
        return @"iPhone 4";
    else if([platform isEqualToString:@"iPhone3,3"])
        return @"iPhone 4";
    else if([platform isEqualToString:@"iPhone4,1"])
        return @"iPhone 4S";
    else if([platform isEqualToString:@"iPhone5,1"])
        return @"iPhone 5";
    else if([platform isEqualToString:@"iPhone5,2"])
        return @"iPhone 5";
    else if([platform isEqualToString:@"iPhone5,3"])
        return @"iPhone 5c";
    else if([platform isEqualToString:@"iPhone5,4"])
        return @"iPhone 5c";
    else if([platform isEqualToString:@"iPhone6,1"])
        return @"iPhone 5s";
    else if([platform isEqualToString:@"iPhone6,2"])
        return @"iPhone 5s";
    else if([platform isEqualToString:@"iPhone7,1"])
        return @"iPhone 6 Plus";
    else if([platform isEqualToString:@"iPhone7,2"])
        return @"iPhone 6";
    else if([platform isEqualToString:@"iPhone8,1"])
        return @"iPhone 6s";
    else if([platform isEqualToString:@"iPhone8,2"])
        return @"iPhone 6s Plus";
    else if([platform isEqualToString:@"iPhone8,4"])
        return @"iPhone SE";
    else if([platform isEqualToString:@"iPhone9,1"])
        return @"iPhone 7";
    else if([platform isEqualToString:@"iPhone9,2"])
        return @"iPhone 7 Plus";
    else if([platform isEqualToString:@"iPhone10,1"])
        return @"iPhone 8";
    else if([platform isEqualToString:@"iPhone10,4"])
        return @"iPhone 8";
    else if([platform isEqualToString:@"iPhone10,2"])
        return @"iPhone 8 Plus";
    else if([platform isEqualToString:@"iPhone10,5"])
        return @"iPhone 8 Plus";
    else if([platform isEqualToString:@"iPhone10,3"])
        return @"iPhone X";
    else if([platform isEqualToString:@"iPhone10,6"])
        return @"iPhone X";
    else if([platform isEqualToString:@"iPhone11,2"])
        return @"iPhone XS";
    else if([platform isEqualToString:@"iPhone11,4"])
        return @"iPhone XS Max";
    else if([platform isEqualToString:@"iPhone11,6"])
        return @"iPhone XS Max";
    else if([platform isEqualToString:@"iPhone11,8"])
        return @"iPhone XR";
    else if([platform isEqualToString:@"iPod1,1"])
        return @"iPod Touch 1G";
    else if([platform isEqualToString:@"iPod2,1"])
        return @"iPod Touch 2G";
    else if([platform isEqualToString:@"iPod3,1"])
        return @"iPod Touch 3G";
    else if([platform isEqualToString:@"iPod4,1"])
        return @"iPod Touch 4G";
    else if([platform isEqualToString:@"iPod5,1"])
        return @"iPod Touch 5G";
    else if([platform isEqualToString:@"iPad1,1"])
        return @"iPad 1G";
    else if([platform isEqualToString:@"iPad2,1"])
        return @"iPad 2";
    else if([platform isEqualToString:@"iPad2,2"])
        return @"iPad 2";
    else if([platform isEqualToString:@"iPad2,3"])
        return @"iPad 2";
    else if([platform isEqualToString:@"iPad2,4"])
        return @"iPad 2";
    else if([platform isEqualToString:@"iPad2,5"])
        return @"iPad Mini 1G";
    else if([platform isEqualToString:@"iPad2,6"])
        return @"iPad Mini 1G";
    else if([platform isEqualToString:@"iPad2,7"])
        return @"iPad Mini 1G";
    else if([platform isEqualToString:@"iPad3,1"])
        return @"iPad 3";
    else if([platform isEqualToString:@"iPad3,2"])
        return @"iPad 3";
    else if([platform isEqualToString:@"iPad3,3"])
        return @"iPad 3";
    else if([platform isEqualToString:@"iPad3,4"])
        return @"iPad 4";
    else if([platform isEqualToString:@"iPad3,5"])
        return @"iPad 4";
    else if([platform isEqualToString:@"iPad3,6"])
        return @"iPad 4";
    else if([platform isEqualToString:@"iPad4,1"])
        return @"iPad Air";
    else if([platform isEqualToString:@"iPad4,2"])
        return @"iPad Air";
    else if([platform isEqualToString:@"iPad4,3"])
        return @"iPad Air";
    else if([platform isEqualToString:@"iPad4,4"])
        return @"iPad Mini 2G";
    else if([platform isEqualToString:@"iPad4,5"])
        return @"iPad Mini 2G";
    else if([platform isEqualToString:@"iPad4,6"])
        return @"iPad Mini 2G";
    else if([platform isEqualToString:@"iPad4,7"])
        return @"iPad Mini 3";
    else if([platform isEqualToString:@"iPad4,8"])
        return @"iPad Mini 3";
    else if([platform isEqualToString:@"iPad4,9"])
        return @"iPad Mini 3";
    else if([platform isEqualToString:@"iPad5,1"])
        return @"iPad Mini 4";
    else if([platform isEqualToString:@"iPad5,2"])
        return @"iPad Mini 4";
    else if([platform isEqualToString:@"iPad5,3"])
        return @"iPad Air 2";
    else if([platform isEqualToString:@"iPad5,4"])
        return @"iPad Air 2";
    else if([platform isEqualToString:@"iPad6,3"])
        return @"iPad Pro 9.7";
    else if([platform isEqualToString:@"iPad6,4"])
        return @"iPad Pro 9.7";
    else if([platform isEqualToString:@"iPad6,7"])
        return @"iPad Pro 12.9";
    else if([platform isEqualToString:@"iPad6,8"])
        return @"iPad Pro 12.9";
    else if([platform isEqualToString:@"i386"])
        return @"iPhone Simulator";
    else if([platform isEqualToString:@"x86_64"])
        return @"iPhone Simulator";
    return platform;
    
}
@end


@implementation NSMutableAttributedString (Category)
- (void)changeStringStyleWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font{
    NSRegularExpression *regular = [[NSRegularExpression alloc]initWithPattern:text options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * arr1 = [regular matchesInString:[self string] options:NSMatchingReportProgress range:NSMakeRange(0, self.string.length)];
    NSMutableArray *rangeArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *titleArr = [NSMutableArray arrayWithCapacity:0];
    for (NSTextCheckingResult *result in arr1) {
        if (result.range.location != NSNotFound) {
            [rangeArr insertObject:result atIndex:0];
            NSMutableAttributedString *titleAtt = [[NSMutableAttributedString alloc] initWithString:text];
            [titleAtt addAttributes:@{NSForegroundColorAttributeName:color,NSFontAttributeName:font} range:NSMakeRange(0,titleAtt.length)];
            [titleArr insertObject:titleAtt atIndex:0];
        }
    }
    int i = 0;
    for (NSTextCheckingResult *result in rangeArr) {
        NSMutableAttributedString *attchment = titleArr[i];
        [self replaceCharactersInRange:result.range withAttributedString:attchment];
        i++;
    }

}
- (NSMutableAttributedString *)xieyi_changeColor:(NSString *)changeColorTxt color:(NSString *)color{
    YYTextHighlight *highlight = [YYTextHighlight new];
    [highlight setColor:COLOR_PATTERN_STRING(color)];
    [self setTextHighlight:highlight range:NSMakeRange(self.length - changeColorTxt.length, changeColorTxt.length)];
    return self;
}
@end
