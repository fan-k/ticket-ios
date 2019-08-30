//
//  FanWeChat.m
//  FanProduct
//
//  Created by 99epay on 2019/7/15.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanWeChat.h"
#import<CommonCrypto/CommonDigest.h>

@implementation FanWeChat

+ (instancetype)shareInstance{
    static FanWeChat *weChat;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weChat = [FanWeChat new];
    });
    return weChat;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [WXApi registerApp:@"wxd930ea5d5a258f4f"];
    }return self;
}


///获取微信支付需要的随机数
- (NSString *)paymentWechatNonceString {
    NSArray *sampleArray = @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9",
                             @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J",
                             @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T",
                             @"U", @"V", @"W", @"X", @"Y", @"Z"];
    
    NSMutableString *randomString = [NSMutableString string];
    for (NSInteger i = 0; i<32; ++i) {
        [randomString appendString:sampleArray[random()%32]];
    }
    return [randomString copy];
}

///获取微信支付需要的签名
- (NSString *)paymentWechatSign:(NSDictionary *)dic {
    
    NSMutableString *stringA = [NSMutableString string];
    //按字典key升序排序
    NSArray *sortKeys = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    //拼接格式 “key0=value0&key1=value1&key2=value2”
    for (NSString *key in sortKeys) {
        [stringA appendString:[NSString stringWithFormat:@"%@=%@&", key, dic[key]]];
    }
    //拼接商户签名,,,,kShopSign 要和微信平台上填写的密钥一样，（密钥就是签名）
    [stringA appendString:[NSString stringWithFormat:@"key=%@", FAN_KEY_WEIXIN_PAY_SIGN]];
    //MD5加密
    NSString *stringB = [self MD5:[stringA copy]];
    //返回大写字母
    return stringB.uppercaseString;
}

///iOS系统API自带MD5加密算法
- (NSString *)MD5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}
- (void)sendReqWithItem:(FanRequestItem *)item{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = FAN_KEY_WEIXIN_ID;
    request.prepayId= @"wx3015074971963409502f79811367577700";
    request.package = @"Sign=WXPay";
    NSString *nonce_str = [self paymentWechatNonceString];
    request.nonceStr= nonce_str;
    request.timeStamp= [[NSDate date] timeIntervalSince1970] * 1000;
    request.sign= [self paymentWechatSign:@{
                                            @"appid":FAN_KEY_WEIXIN_APPID,
                                            @"mch_id":FAN_KEY_WEIXIN_ID,
                                            @"device_info":@"WEB",
                                            @"nonce_str":nonce_str,
                                            @"body":@"票儿网-购买门票",
                                            }];
    if([WXApi isWXAppInstalled]){
        [WXApi sendReq:request];
    }else{
        [WXApi sendAuthReq:request viewController:MainRootSelectTopViewController() delegate:[FanWeChat shareInstance]];
    }
}
+ (BOOL)handleOpenURL:(NSURL *)url{
    return   [WXApi handleOpenURL:url delegate:[FanWeChat shareInstance]];
}

/**微信支付结果回调*/
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass: [PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:{
                //服务器端查询支付通知或查询API返回的结果再提示成功
                if ([FanWeChat shareInstance].customActionBlock) {
                    [FanWeChat shareInstance].customActionBlock(resp, cat_pay_unsure);
                }
            }
                break;
            case WXErrCodeUserCancel:{
                [FanAlert alertMessage:response.errStr type:AlertMessageTypeNomal];
            }break;
            default:
                [FanAlert alertMessage:response.errStr type:AlertMessageTypeNomal];
                break;
        }
    }
    
}
@end

