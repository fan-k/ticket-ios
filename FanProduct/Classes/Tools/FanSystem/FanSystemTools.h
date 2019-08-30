//
//  FanSystemTools.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/18.
//  Copyright © 2018 Fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UICKeyChainStore.h"

@interface FanSystemTools : NSObject

/**UUID*/
+(NSString *)getUUID;
/**根据server 获取UUID*/
+(NSString *)getUUIDFromServer;
/**根据server保存UUID*/
+(void)setUUIDFromServer:(NSString *)UUIDFromServer;
@end
