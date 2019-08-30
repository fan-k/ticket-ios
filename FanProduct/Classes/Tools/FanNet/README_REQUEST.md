
##FanRequestItem 的思想是把网络请求封装为一个请求对象（FanRequestItem）。
网络请求的各种参数为item的属性，通过对属性的设定封装，统一处理请求的参数

item中属性设定

    请求参数：params
    公共参数：publicParam
    接口字段：url
    完整链接：completeurl
    上传图片：postListImages（FanPostImageModel）
    请求时间：startDate /endDate
    请求时长：duration请求开始到请求结束的请求时长
    请求频率：默认10秒，通过- (NSInteger)interval:(BOOL)iscache 方法判断
    ItemQueue:item所属队列 用于处理请求监测、请求重发
    RequestQueue：请求所属队列 记录发起的NSURLSessionDataTask ，可判断当前请求的进行状态,dealloc时终止请求
    请求Session:dataTask,用于取消请求
    请求方法：method（get需要拼接链接时 需设定appendParams为YES）
    请求结果：success
    数据code：code
    返回数据：responseObject
    自定义测试数据：customResponseObject
    请求回调：completeBlock
    请求归属对象：object
    请求归属事件tag：tag
    ......
    
item使用方法：

    发起请求： startRequest
    取消请求： cancelRequest
    
##FanRequestTool为网络请求类，封装处理了网络请求和网络监测。
网络请求：使用FanRequestItem创建一个NSURLSessionDataTask请求对象，将返回接口通过completeBlock回调。
    
    - (NSURLSessionDataTask * )requestWithItem:(FanRequestItem *)item
                                                     completeBlock:(completeBlock)completeBlock
                                                                inQueue:(id)queue;
                                                                
网络监测：开启网络监测startNotifier，网络状态netStatus，网络变动通过通知方式进行消息发送：YBLNetWorkChangedNotification

##FanRequestFiles ：接口都声明在这里。


##一个完整的网络请求
     1：使用FanRequestItem直接发起
     
     FanRequestItem *item = [FanRequestItem new];
     item.params[@"id"] = User_ID;
     item.showLoadIng = YES;
     item.url = [NSString stringWithFormat:@"%@User/getDetail.html",Change_URL_STR];
     item.completeBlock = ^(FanRequestItem *item) {
        if(item.success){
            //成功处理
            }else{
            //失败处理
            }
     };
     [item startRequest];

 2：在VC中直接发起网络请求并统一处理请求回调，方法参数声明类：UIViewController+FanRequest
 
    a. 参数设定: self.params[@"key"] = @"value";
    b. 发起请求: [self requestWithUrl:@"url" loading:YES];
    c. 成功回调: handelSuccessRequest 方法，此方法需在VC中实现
    d. 失败回调: handelFailureRequest 方法，此方法需在VC中实现
    e. 当前VC 通过b方式发起的网络请求的回调 都是cd. 通过item.url区分接口。
     
3：取消请求
   
      在VC的dealloc方法中，可通过遍历当前VC的requestQueue，对未完成网络请求的item，取消请求。


    
    






