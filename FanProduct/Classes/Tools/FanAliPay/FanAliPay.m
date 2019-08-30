//
//  FanAliPay.m
//  FanProduct
//
//  Created by 99epay on 2019/7/15.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanAliPay.h"

@implementation FanAliPay
+ (instancetype)shareInstance{
    static FanAliPay *alipay;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alipay = [FanAliPay new];
    });
    return alipay;
}
+ (BOOL)handleOpenURL:(NSURL *)url{
    [[AlipaySDK defaultService]
     processOrderWithPaymentResult:url
     standbyCallback:^(NSDictionary *resultDic) {
         NSString *code  = DICTION_OBJECT(resultDic, @"code");
         if ([code isEqualToString:@"9000"]) {
             //支付成功
             if ([FanAliPay shareInstance].customActionBlock) {
                 [FanAliPay shareInstance].customActionBlock(nil, cat_pay_success);
             }
         }else if ([code isEqualToString:@"8000"] || [code isEqualToString:@"6004"]){
             //查询状态
             if ([FanAliPay shareInstance].customActionBlock) {
                 [FanAliPay shareInstance].customActionBlock(nil, cat_pay_unsure);
             }
         }else{
             //支付失败
             [FanAlert alertMessage:DICTION_OBJECT(resultDic, @"memo") type:AlertMessageTypeNomal];
         }
        
     }];
    return YES;
}
- (void)sendReqWithItem:(FanRequestItem *)item{
   
    /*
    //将商品信息赋予AlixPayOrder的成员变量
    Order* order = [Order new];
    
    // NOTE: app_id设置
    order.app_id = appID;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type设置
    order.sign_type = @"RSA";
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = @"我是测试数据";
    order.biz_content.subject = @"1";
    order.biz_content.out_trade_no = [self generateTradeNO]; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
     */
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderInfo];
    
    // NOTE: 如果加签成功，则继续执行支付
    NSString * orderString = DICTION_OBJECT(DICTION_OBJECT(item.responseObject, @"data"), @"orderString");
    if (orderString != nil) {
        //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
//        NSString *appScheme = FAN_KEY_ALIPAY_APPID;
        NSString *appScheme = @"2018120762438835";
        // NOTE: 调用支付结果开始支付
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            if ([FanAliPay shareInstance].customActionBlock) {
                [FanAliPay shareInstance].customActionBlock(resultDic, 0);
            }
        }];
    }
}
@end
