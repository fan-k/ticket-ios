//
//  FanRequestItem.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/17.
//  Copyright © 2018 Fan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FanErrorView.h"

@class FanRequestTool;



/**
  网络请求的对象 封装网络请求的参数数据
 */
@interface FanRequestItem : NSObject
/**回调block*/
typedef void(^completeBlock)(FanRequestItem *complteItem);

/*请求结果状态 */
@property (nonatomic ,copy) NSString *code;
/*请求接口*/
@property (nonatomic, copy) NSString *url;
/*请求完整的链接*/
@property (nonatomic, copy) NSString *completeurl;
/*请求的参数*/
@property (nonatomic ,strong) NSMutableDictionary * params;
/**公共参数*/
@property (nonatomic ,strong) NSMutableDictionary *publicParams;
/*加密后的参数*/
@property (nonatomic ,strong) NSDictionary * encryptParams;
/**上传图片，可以是多维数组*/
@property (nonatomic ,strong) NSArray * postListImages;
/*请求所属对象*/
@property (nonatomic ,strong) id object;
/*请求对象所对应的事件tag*/
@property (nonatomic, assign) int tag;
/*请求所属队列 记录发起的NSURLSessionDataTask，dealloc时终止请求*/
@property (nonatomic ,strong) NSMutableArray *requestQueue;
/*item所属队列 用于处理请求间隔、请求重发*/
@property (nonatomic ,strong) NSMutableArray *itemQueue;
/*所发的请求*/
@property (nonatomic ,strong) NSURLSessionDataTask *dataTask;
/*是否在请求中*/
@property (nonatomic ,assign) BOOL isdataTask;
/*请求开始时间*/
@property(nonatomic, assign) long long startDate;
/*请求结束时间*/
@property (nonatomic, assign) long long endDate;
/*请求开始到结束的时间时长*/
@property (nonatomic, assign) long long duration;
/*请求是否有间隔频率*/
@property (nonatomic, assign) BOOL isInterval;
/*唯一id 通过各种拼接成*/
@property (nonatomic ,copy) NSString *requestID;
/**contentType  默认application/json*/
@property (nonatomic ,copy) NSString *contentType;
/*isCache 查找结果*/
@property (nonatomic ,assign) BOOL searched;
/*请求的方式 GET POST  默认POST*/
@property(nonatomic, copy) NSString *method;
/**get请求时是否通过拼接url的形式传递参数*/
@property (nonatomic ,assign) BOOL appendParams;
/*请求返回状态 --成功1 失败0*/
@property (nonatomic ,assign) BOOL success;
/*请求返回 error*/
@property (nonatomic ,strong) NSError*error;
/**显示loadIng*/
@property (nonatomic ,assign) BOOL showLoadIng;
/*请求返回数据*/
@property (nonatomic ,strong) id responseObject;
/*自定义的假数据*/
@property (nonatomic ,strong) id customResponseObject;
/*回调block*/
@property (nonatomic ,copy) completeBlock completeBlock;
/**当前请求显示的error类型*/
@property (nonatomic ,assign) FanErrorType errorType;
/*item-->是否提示msg 默认yes*/
@property (nonatomic ,assign) BOOL alertMsg;
/**判断请求间隔 返回0/1 ，0请求间隔内，1请求间隔外*/
- (NSInteger)requestFrequency;
/**是否请求结束*/
- (BOOL)isDataTaskOver;
/**开始请求*/
- (void)startRequest;
/**取消请求*/
- (void)cancelRequest;


@end




@interface FanPostImageModel : NSObject
/**对应的是上传图片方法中的name*/
@property (nonatomic ,copy) NSString *name;
/**对应的是上传图片方法中的fileName*/
@property (nonatomic ,copy) NSString *fileName;
/**上传图片的mimeType*/
@property (nonatomic ,copy) NSString *mimeType;
/**图片的base64字符串*/
@property (nonatomic ,copy) NSString *imageEncodedStr;
/**图片的data 用于上传*/
@property (nonatomic ,strong) NSData *imageData;
/**图片*/
@property (nonatomic ,strong) UIImage *image;
@end
