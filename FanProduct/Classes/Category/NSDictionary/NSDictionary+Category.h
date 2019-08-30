//
//  NSDictionary+Category.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/17.
//  Copyright © 2018 Fan. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface NSDictionary (Category)

/**
 字段的安全取值

 @param aKey akey
 @return id
 */
- (id)safeObjectForKey:(id)aKey;
/**
 字典转json

 @return json
 */
- (NSString *)toJson;





@end

@interface NSMutableDictionary (Category)

/**
 神策属性赋值
 
 @param value value
 @param akey akey
 */
- (void)sensor_setValue:(id)value forKey:(id)akey;


@end

/**
 字典取值便捷方法

 @param dict dict
 @param key key
 @return id
 */
static inline id DICTION_OBJECT(id dict ,id key){
    if ([dict isKindOfClass:[NSDictionary class]]) {
        return [dict safeObjectForKey:key];
    }else{
        return nil;
    }
}
