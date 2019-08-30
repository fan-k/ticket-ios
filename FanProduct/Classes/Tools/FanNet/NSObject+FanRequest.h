//
//  NSObject+FanRequest.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/20.
//  Copyright © 2018 Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FanRequest)
#pragma mark -- 网络请求
/**网络请求参数*/
@property (nonatomic ,strong) NSMutableDictionary *params;
/**请求request列表 */
@property(nonatomic, strong)NSMutableArray *requestQueue;
/**item 列表*/
@property(nonatomic, strong)NSMutableArray *itemQueue;
/**网络请求方式*/
@property (nonatomic ,copy) NSString *itemMethod;
/**网络请求的contentType*/
@property (nonatomic ,copy) NSString *itemContentType;


/*
 *base 网络请求方法
 * url
 * loading
 */
- (void)requestWithUrl:(NSString *)url
               loading:(BOOL)loading;
/*
 *base 网络请求方法
 * url
 * loading
 */
- (void)requestWithUrl:(NSString *)url
               loading:(BOOL)loading
                 error:(FanErrorType)error;
/*
 *base 网络请求方法
 * url
 * loading
 */
- (void)requestWithUrl:(NSString *)url
                object:(id)object
               loading:(BOOL)loading
                 error:(FanErrorType)error;
/*处理失败数据*/
- (void)handelFailureRequest:(FanRequestItem *)item;
/*处理成功数据*/
- (void)handelSuccessRequest:(FanRequestItem *)item;
/**error 方法*/
- (void)handelErrorLoadWithItem:(FanRequestItem *)item;

@end
