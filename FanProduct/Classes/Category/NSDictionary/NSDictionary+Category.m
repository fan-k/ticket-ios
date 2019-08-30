//
//  NSDictionary+Category.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/17.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "NSDictionary+Category.h"
#import <objc/runtime.h>

@implementation NSDictionary (Category)



- (NSString *)toJson{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (id)safeObjectForKey:(id)aKey{
    //还没写 😝
    return  [self objectForKey:aKey];
}





@end

@implementation NSMutableDictionary (Category)
- (void)sensor_setValue:(id)value forKey:(id)akey{
    if(!value){
        value = @"0";
    }
    self[akey] = value;
}
@end
