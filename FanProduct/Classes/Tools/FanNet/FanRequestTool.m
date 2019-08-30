//
//  FanRequestTool.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/17.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "FanRequestTool.h"

@implementation FanRequestTool

+ (instancetype)shareInstance{
    static FanRequestTool *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[FanRequestTool alloc] init];
    });
    return tools;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        _shareManger = [AFHTTPSessionManager manager];
        _shareManger.requestSerializer = [AFHTTPRequestSerializer serializer];
        _shareManger.responseSerializer = [AFHTTPResponseSerializer serializer];
        /*接受类型，如果不一致请替换一致text/html或别的*/
        _shareManger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    }
    return self;
}

- (NSURLSessionDataTask * )requestWithItem:(FanRequestItem *)item
                             completeBlock:(completeBlock)completeBlock
                                   inQueue:(id)queue{
    //loading
    if (item.showLoadIng) {
        [FanAlert showLoading];
    }
    //假数据数据-- 用于测试
    if (item.customResponseObject) {
        item.responseObject = item.customResponseObject;
        NSLog(@"__%@",[item.responseObject toJson]);
        if (completeBlock) {
            completeBlock(item);
            if (item.showLoadIng) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [FanAlert hideLoading];
                });
            }
        }
        return nil;
    }
    if (item.postListImages.count) {//上传图片
        return [self postDataWithItem:item completeBlock:completeBlock inQueue:queue];
    }
    return [self startRequestWithItem:item completeBlock:completeBlock inQueue:queue];
   
}
- (NSURLSessionDataTask *)startRequestWithItem:(FanRequestItem *)item
                                 completeBlock:(completeBlock)completeBlock
                                       inQueue:(id)queue{
    NSError *reqerror =  nil;
    //添加公共参数
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params addEntriesFromDictionary:item.publicParams];
    [params addEntriesFromDictionary:item.params];
    
    
    NSMutableURLRequest *request = [[FanRequestTool shareInstance].shareManger.requestSerializer
                                    requestWithMethod:item.method
                                    URLString:item.completeurl
                                    parameters:params
                                    error:&reqerror];
    [request setTimeoutInterval:15];
    [request setValue:item.contentType forHTTPHeaderField:@"Content-Type"];
    item.startDate = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    item.isdataTask = YES;
    NSURLSessionDataTask *dataTask = [[FanRequestTool shareInstance].shareManger
                                      dataTaskWithRequest:request
                                      completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        item.endDate = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
        if (error) {
            item.error = error;
            [FanRequestTool networkErrorInfomationCollectWithError:error withUrl:item.completeurl];
        } else {
            item.responseObject = [(NSData *)responseObject toDict];
        }
        if (completeBlock) {
            completeBlock(item);
        }
       //隐藏loading
          if (item.showLoadIng) {
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                  [FanAlert hideLoading];
              });
          }
      
    }];
    //把请求加到队列中 是为了从页面离开时 中止当前的请求
    __block NSMutableArray *queueArr = [queue isKindOfClass:[NSMutableArray class]] ? queue : nil;
    if (queueArr) [queueArr addObject:dataTask];
    [[FanRequestTool shareInstance].shareManger
     setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
        //请求完成  移除请求  ---
        if (!queueArr) return ;
        NSUInteger _idx = [queueArr indexOfObject:task];
        if (_idx != NSNotFound) {
            [queueArr removeObjectAtIndex:_idx];
            item.isdataTask = NO;
        }
    }];
    [dataTask resume];
    return dataTask;
}
- (NSURLSessionDataTask *)postDataWithItem:(FanRequestItem *)item
                             completeBlock:(completeBlock)completeBlock
                                   inQueue:(id)queue{
    //添加公共参数和神策预设参数
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params addEntriesFromDictionary:item.publicParams];
    [params addEntriesFromDictionary:item.params];
    item.startDate = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
    item.isdataTask = YES;
    NSURLSessionDataTask *dataTask = [[FanRequestTool shareInstance].shareManger
                                      POST:item.completeurl
                                      parameters:params
                                      constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [self appendPartWithFileData:formData byImages:item.postListImages];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        item.endDate = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
        if ([responseObject isKindOfClass:[NSData class]]) {
            item.responseObject = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
        if (completeBlock) {
            completeBlock(item);
        }
        
      
         //隐藏loading
        if (item.showLoadIng) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [FanAlert hideLoading];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        item.endDate = (long long)([[NSDate date] timeIntervalSince1970] * 1000);
        item.error = error;
        if (completeBlock) {
            completeBlock(item);
        }
         //隐藏loading
        if (item.showLoadIng) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [FanAlert hideLoading];
            });
        }
        [FanRequestTool networkErrorInfomationCollectWithError:error withUrl:item.completeurl];
    }];
    //把请求加到队列中 是为了从页面离开时 中止当前的请求
    __block NSMutableArray *queueArr = [queue isKindOfClass:[NSMutableArray class]] ? queue : nil;
    if (queueArr) [queueArr addObject:dataTask];
    [[FanRequestTool shareInstance].shareManger
     setTaskDidCompleteBlock:^(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSError * _Nullable error) {
        //请求完成  移除请求  ---
        if (!queueArr) return ;
        NSUInteger _idx = [queueArr indexOfObject:task];
        if (_idx != NSNotFound) {
            [queueArr removeObjectAtIndex:_idx];
            item.isdataTask = NO;
        }
    }];
    [dataTask resume];
    
    return dataTask;
}
- (void)appendPartWithFileData:(id<AFMultipartFormData> _Nonnull)formData byImages:(NSArray *)postListImages{
    [postListImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[FanPostImageModel class]]) {//是图片对象直接拼接
            FanPostImageModel *model = obj;
             [formData appendPartWithFileData:model.imageData name:model.name fileName:model.fileName mimeType:model.mimeType];
        }else if([obj isKindOfClass:[NSArray class]]){
            //是数组 super
            [self appendPartWithFileData:formData byImages:obj];
        }
    }];
}
//神策统计--接口异常信息采集
+ (void)networkErrorInfomationCollectWithError:(NSError *)error withUrl:(NSString *)url{
    NSMutableDictionary *errordict = [NSMutableDictionary dictionary];
    errordict[@"code"] = @(error.code);
    errordict[@"desc"] = error.localizedFailureReason;
    errordict[@"api_url"] =url;
    
}
#pragma mark -- 网络监听
+ (BOOL)net{
    return [FanRequestTool isNetwork];
}

+ (NSUInteger )isNetwork{
    NSUInteger isNetwork;
    //获取Reachability对象的网络状态
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (manager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN)
        isNetwork = 1;
    else if (manager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi){
        isNetwork = 2;
    }else
        isNetwork = 0;

    return isNetwork;
}

+ (void)startNotifier{
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [FanRequestTool shareInstance].netStatus = [FanRequestTool isNetwork];

    
//    [FanRequestTool shareInstance].netStatus = [YYReachability reachability].status;
//    [YYReachability reachability].notifyBlock = ^(YYReachability * _Nonnull reachability) {
//        if (reachability.status == YYReachabilityStatusNone ) {
//            //无网提示
//            [FanAlert alertErrorWithMessage:@"网络失去了连接~"];
//        }else{
//            if ([FanRequestTool shareInstance].netStatus == 0) {
//                //无网到有网的 发送网络改变的通知
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [[NSNotificationCenter defaultCenter] postNotificationName:FanNetWorkChangedNotification object:nil];
//                });
//                return ;
//            }
//        }
//        [FanRequestTool shareInstance].netStatus = reachability.status;
//        //网络变动的通知
//        [[NSNotificationCenter defaultCenter] postNotificationName:FanNetWorkChangedNotification object:nil];
//    };
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable ) {
            //无网提示
            [FanAlert alertErrorWithMessage:@"网络失去了连接~"];
        }else{
            if ([FanRequestTool shareInstance].netStatus == 0) {
                //无网到有网的 发送网络改变的通知
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:FanNetWorkChangedNotification object:nil];
                });
                return ;
            }
        }
        [FanRequestTool shareInstance].netStatus = status;
        //网络变动的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:FanNetWorkChangedNotification object:nil];
    }] ;
}



@end
