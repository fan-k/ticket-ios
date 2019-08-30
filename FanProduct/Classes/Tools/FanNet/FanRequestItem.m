//
//  FanRequestItem.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/17.
//  Copyright © 2018 Fan. All rights reserved.
//


#define OpenLog 1


#import "FanRequestItem.h"
#import "FanRequestData.h"

@implementation FanRequestItem
- (instancetype)init{
    self = [super init];
    if (self) {
        self.method = @"POST";
        self.alertMsg = YES;
         _params = [NSMutableDictionary dictionary];
        _contentType = @"application/json";
    }return self;
}
- (NSInteger)requestFrequency{
    __block NSInteger isRequest = 1;
    [self.itemQueue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FanRequestItem *item = obj;
        if ([item.requestID isEqualToString:self.requestID]) {
            self.searched = YES;
            *stop = YES;
            //相同id  判断时间jiange
            long long duration =  (long long)([[NSDate date] timeIntervalSince1970] * 1000) - item.startDate;
            if ( duration < 10000) {
                isRequest =  0;
            }else
                isRequest += idx;
        }
    }];
    return isRequest;
}
- (BOOL)isDataTaskOver{
    __block BOOL over = YES;
    [self.itemQueue enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FanRequestItem *item = obj;
        if ([item.requestID isEqualToString:self.requestID]) {
            *stop = YES;
            if (item.isdataTask) {
                over = NO;
            }
        }
    }];
    return over;
}
- (void)startRequest{
    __weak typeof(self) weakSelf = self;
   self.dataTask =  [[FanRequestTool shareInstance] requestWithItem:self completeBlock:^(FanRequestItem *complteItem) {
        if (weakSelf.completeBlock) {
            weakSelf.completeBlock(complteItem);
        }
    } inQueue:self.requestQueue];
}
- (void)cancelRequest{
    if (_dataTask) {
         [_dataTask cancel];
    }
}


- (void)setStartDate:(long long)startDate{
    _startDate = startDate;
    if (OpenLog) {
        NSLog(@"请求开始%lld\n 请求地址%@\n请求参数%@",startDate,self.completeurl,self.params);
    }
}
- (void)setEndDate:(long long)endDate{
    _endDate = endDate;
    if (OpenLog) {
        NSLog(@"请求结束%lld\n 请求地址%@\n请求参数%@",endDate,self.completeurl,self.params);
    }
}
- (void)setError:(NSError *)error{
    _error = error;
    if (OpenLog) {
        NSLog(@"请求失败： 请求地址%@\n请求参数%@",self.completeurl,self.params);
    }
}
- (void)setResponseObject:(id)responseObject{
    _responseObject = responseObject;
    _code = nil;//重置code 
    if (OpenLog) {
        NSLog(@"请求成功： 请求地址%@\n请求参数%@",self.completeurl,self.params);
    }
}
- (void)setUrl:(NSString *)url{
    _url =  url;
    if (![url isNotBlank]) {
        return;
    }
    if ([url hasPrefix:@"http"]) {
        _completeurl = url;
    }else
        _completeurl = [FanBaseUrl stringByAppendingString:url];
    //处理get 参数拼接
    if ([self.method caseInsensitiveCompare:@"get"] == NSOrderedSame && self.appendParams) {
        [self.params.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) {
                [self.completeurl stringByAppendingString:idx == 0 ? [NSString stringWithFormat:@"?%@=%@",obj,obj]:[NSString stringWithFormat:@"&%@=%@",obj,obj]];
            }
        }];
    }
}
- (void)setMethod:(NSString *)method{
    _method = method;
    //重设下url  为了处理method为get时 拼接参数
    if ([_url isNotBlank]) {
        self.url = _url;
    }
}
- (void)setAppendParams:(BOOL)appendParams{
    _appendParams = appendParams;
    if (appendParams) {
        //重设下url  为了处理method为get时 拼接参数
        if ([_url isNotBlank]) {
            self.url = _url;
        }
    }
}

- (BOOL)success{
    if ([self.code isEqualToString:@"1"] || [self.code isEqualToString:@"000"] || [self.code isEqualToString:@"SUCCESS"] || [self.code isEqualToString:@"success"]) {
        return YES;
    }
    return NO;
}
- (NSString *)code{
    if (!_code) {
        _code = DICTION_OBJECT(self.responseObject, @"code");
    }return _code;
}

- (NSString *)requestID{
    if (!_requestID) {
        _requestID = [self.url stringByAppendingString:[self.params toJson]];
    }
    return _requestID;
}

- (NSMutableDictionary *)publicParams{
    if (!_publicParams) {
        _publicParams = [NSMutableDictionary new];
        //公共参数
        _publicParams[@"v"] = FanBundleVersion;//版本号
        _publicParams[@"from"] = @"ios";// 系统，
        _publicParams[@"device_id"] = [FanSystemTools getUUID];
        _publicParams[@"udid"] = [FanSystemTools getUUIDFromServer];
    }return _publicParams;
}

- (id)customResponseObject{
    return [[FanRequestData shareInstance] requestDataItem:self];
}
@end



@implementation FanPostImageModel

- (NSData *)imageData{
    if (!_imageData) {
        if ([self.imageEncodedStr isNotBlank]) {
            _imageData =  [[NSData alloc] initWithBase64EncodedString:self.imageEncodedStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        }else if (self.image){
            _imageData = UIImageJPEGRepresentation(self.image, 0.01);
        }
    }return _imageData;
}
@end

