//
//  FanSystemTools.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/18.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "FanSystemTools.h"

@implementation FanSystemTools


#pragma mark - 获取UUID
+(NSString *)getUUID{
    UICKeyChainStore *keychainItem = [[UICKeyChainStore alloc] initWithService:@"com.fan.demo"];
    NSString *strUUID = [keychainItem objectForKeyedSubscript:@"UUID"];
    //首次执行该方法时，uuid为空
    if (!strUUID || [strUUID isEqualToString:@""]){
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
        [keychainItem setString:strUUID forKey:@"UUID"];
        CFRelease(uuidRef);
    }
    return strUUID;
}

#pragma mark - 获取UUIDFromServer
+(NSString *)getUUIDFromServer{
    UICKeyChainStore *keychainItem = [[UICKeyChainStore alloc] initWithService:@"com.fan.demo"];
    NSString *strUUID = [keychainItem objectForKeyedSubscript:@"UUIDFromServer"];
    //首次执行该方法时，uuid为空
    if (!strUUID){
        strUUID = @"";
    }
    return strUUID;
}

#pragma mark - 设置UUIDFromServer
+(void)setUUIDFromServer:(NSString *)UUIDFromServer{
    if (UUIDFromServer && ![UUIDFromServer isEqual:@""]) {
        UICKeyChainStore *keychainItem = [[UICKeyChainStore alloc] initWithService:@"com.fan.demo"];
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        [keychainItem setString:UUIDFromServer forKey:@"UUIDFromServer"];
        CFRelease(uuidRef);
    }
}


@end
