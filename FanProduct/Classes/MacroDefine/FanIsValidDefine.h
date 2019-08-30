//
//  FanIsValidDefine.h
//  FanProduct
//
//  Created by 99epay on 2019/6/19.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#ifndef FanIsValidDefine_h
#define FanIsValidDefine_h



/**
 *obj是否是Class类型
 */
#define FAN_ISCLASS(Class,obj)[obj isKindOfClass:[Class class]]


#ifdef DEBUG
// DEBUG模式下进行调试打印

// 输出结果标记出所在类方法与行数
#define DEF_DEBUG(fmt, ...)   NSLog((@"%s[第: %d行]™ " fmt), strrchr(__FUNCTION__,'['), __LINE__, ##__VA_ARGS__)

#else

#define DEF_DEBUG(...)   {}

#endif



#endif /* FanIsValidDefine_h */
/**判断字符串是否合法*/
static inline BOOL isValidString(NSString *string){
    return (string && FAN_ISCLASS(NSString, string) && [string length] > 0) ? YES : NO;
}
/**判断Number是否合法*/
static inline BOOL isValidNumber(id number){
    return (number && FAN_ISCLASS(NSNumber, number)) ? YES : NO;
}
/**判断字典是否合法*/
static inline BOOL isValidDictionary(NSDictionary *dic){
    return (dic && FAN_ISCLASS(NSDictionary, dic)) ? YES : NO;
}
/**判断数组是否合法*/
static inline BOOL isValidArray(NSArray *array){
    return (array && FAN_ISCLASS(NSArray, array) ) ? YES : NO;
}
/**密码长度判断*/
static inline BOOL judgePassWordLength(NSString *pass){
    BOOL result = true;
    if (pass.length < 6  || pass.length > 16) {
        result = false;
    }
    return result;
}
/**手机验证*/
static inline BOOL isValidPhoneNumber(NSString *cellNum){
    if (cellNum) {
        cellNum = [cellNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,175,176,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|7[56]|8[56])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,177,180,189
     22         */
    NSString * CT = @"^1((33|53|77|8[09])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:cellNum] == YES)
       || ([regextestcm evaluateWithObject:cellNum] == YES)
       || ([regextestct evaluateWithObject:cellNum] == YES)
       || ([regextestcu evaluateWithObject:cellNum] == YES)){
        return YES;
    }else{
        return NO;
    }

}
/**密码格式判断*/
static inline BOOL judgePassWordLegal(NSString *pass){
    BOOL result = false;
    NSString * regex = @"^([0-9A-Za-z]|[`~!@#$%^&*()+=|{}_':;',\\\\[\\\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？])*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [pred evaluateWithObject:pass];
    return result;
}
/**密码组合判断*/
static inline BOOL isValidPW(NSString *pw){
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)(?![`~!@#$%^&*()+=|{}_':;',\\\\[\\\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？])([0-9A-Za-z]|[`~!@#$%^&*()+=|{}_':;',\\\\[\\\\].<>/?~！@#￥%……&*（）——+|{}【】‘；：”“’。，、？]){6,16}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return ([pred evaluateWithObject:pw])? YES : NO;
}
/**判断是不是数字和.*/
static inline BOOL isValidMoney(NSString *money){
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9]+$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger numberOfMatches = [regex numberOfMatchesInString:money options:0 range:NSMakeRange(0, [money length])];
    BOOL result = numberOfMatches > 0 ? YES : NO;
    if (!result) {
        if ([money isEqualToString:@"."]) {
            result = YES;
        }
    }
    return result;
}
