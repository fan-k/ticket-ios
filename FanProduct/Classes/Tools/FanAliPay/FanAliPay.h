//
//  FanAliPay.h
//  FanProduct
//
//  Created by 99epay on 2019/7/15.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface FanAliPay : NSObject
+ (instancetype)shareInstance;

- (void)sendReqWithItem:(FanRequestItem *)item;
/**支付宝回调*/
+ (BOOL)handleOpenURL:(NSURL *)url;


@end

NS_ASSUME_NONNULL_END
