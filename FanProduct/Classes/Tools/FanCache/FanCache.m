//
//  FanCache.m
//  FanProduct
//
//  Created by 99epay on 2019/7/2.
//  Copyright © 2019 樊康鹏. All rights reserved.
//
/**
 *
 *      缓存清理思路
 *
 *      第一步: 拿到需要清理的缓存文件Caches路径
 *      NSString* filePath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
 *
 *      第二步 创建文件管理者
 *      NSFileManager *fileManager=[NSFileManager defaultManager];
 *
 *      第三步 判断缓存文件路径中的文件内容是否存在
 *      if ([fileManager fileExistsAtPath:path])
 *
 *      第四步 遍历缓存路径，拿到路径中所有文件数组
 *      NSArray *childerFiles = [fileManager subpathsAtPath:path];
 *
 *      第五步  遍历数组，拼接数组
 *      NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
 *
 *      第六步  计算文件大小
 *      long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
 */
 

#import "FanCache.h"
#import <SDImageCache.h>


@implementation FanCache
#pragma mark -- 缓存本地数据

+ (BOOL)initCoderModel:(id)obj key:(NSString *)key{
    if (key && obj) {
        [FanCache cleanCoderModel:key];
        //创建归档所需可变data对象
        NSMutableData *mutableData = [NSMutableData data];
        //创建归档类
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:mutableData];
        //进行归档
        [archiver encodeObject:obj forKey:key];
        //归档完  需要主动结束
        [archiver finishEncoding];
        //写入本地
        NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:key];
        //成功
        return [mutableData writeToFile:file atomically:YES];
    }
    return NO;
}

+ (id)encodeCoderModel:(NSString *)key{
    if (key) {
        //读取本地
        NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:key];
        //转🌹data
        NSData *data = [NSData dataWithContentsOfFile:file];
        //创建反归档类
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
        //反归档处理
        id obj = [unArchiver decodeObjectForKey:key];
        //反归档完 需手动结束
        [unArchiver finishDecoding];
        
        
        if (obj) {
            //存在
            return obj;
        }else//
            return nil;
    }
    return nil;
}

+ (BOOL)cleanCoderModel:(NSString *)key{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:key];
    [manager removeItemAtPath:file error:nil];
    return YES;
}
/**
 计算单个文件大小
 
 @param path 文件路径
 
 @return 文件大小（M）
 */
+ (float)getFileSizeWithPath:(NSString *)path{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        long long size = [manager attributesOfItemAtPath:path error:nil].fileSize;
        return size / (1024.0 * 1024.0);
    }else
        return 0;
}

/**
 计算文件目录大小
 
 @param path 文件路径
 
 @return 文件目录大小
 */
+ (float)getFolderSizeWithPath:(NSString *)path{
    float folderSize = 0.0f;
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSArray *chiderFiles = [manager subpathsAtPath:path];
        for (NSString *fileName in chiderFiles) {
            //获取绝对路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            folderSize += [FanCache getFileSizeWithPath:absolutePath];
            
        }
        return folderSize;
    }else
        return 0;
}

/**
 清除缓存
 
 @param path 路径
 */
+ (void)clearCache:(NSString *)path{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSArray *chiderFiles = [manager subpathsAtPath:path];
        for (NSString *fileName in chiderFiles) {
            //            DEF_DEBUG(@"filesName == %@",fileName);
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            //            DEF_DEBUG(@"absolutePath == %@",absolutePath);
            [manager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];//SDWebImage自带清除
}

@end
