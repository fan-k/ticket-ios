//
//  FanCache.h
//  FanProduct
//
//  Created by 99epay on 2019/7/2.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface FanCache : NSObject
#pragma mark -- 缓存本地数据

+ (BOOL)initCoderModel:(id)obj key:(NSString *)key;

+ (id)encodeCoderModel:(NSString *)key;

+ (BOOL)cleanCoderModel:(NSString *)key;





#pragma mark 获取缓存文件的大小
/**
 计算单个文件大小
 
 @param path 文件路径
 
 @return 文件大小
 */
+ (float)getFileSizeWithPath:(NSString *)path;

/**
 计算文件目录大小
 
 @param path 文件路径
 
 @return 文件目录大小
 */
+ (float)getFolderSizeWithPath:(NSString *)path;

#pragma mark - 清理缓存文件
/**
 清除缓存
 
 @param path 路径
 */
+ (void)clearCache:(NSString *)path;
@end

NS_ASSUME_NONNULL_END
