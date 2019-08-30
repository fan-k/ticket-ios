//
//  FanRequestTool.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/17.
//  Copyright © 2018 Fan. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <YYKit.h>

typedef void(^completeBlock)(FanRequestItem *complteItem);

/**
 网络请求单例类 负责发送网络请求+监听网络状态
 */
@interface FanRequestTool : NSObject

@property(nonatomic, strong)AFHTTPSessionManager *shareManger;

/**单例*/
+ (instancetype)shareInstance;
#pragma mark -- 网络请求
/**
 网络请求调用方法
 
 @param item item
 @param queue queue
 @return NSURLSessionDataTask
 */
- (NSURLSessionDataTask * )requestWithItem:(FanRequestItem *)item
                             completeBlock:(completeBlock)completeBlock
                                   inQueue:(id)queue;

#pragma mark -- 网络监听
/**是否有网*/
+ (BOOL)net;
/**开启监听*/
+ (void)startNotifier;
/**网络状态*/
@property(nonatomic ,assign) NSUInteger  netStatus;
/**是否为移动网络*/
@property(nonatomic ,assign) BOOL mobilenetwork;
@end
