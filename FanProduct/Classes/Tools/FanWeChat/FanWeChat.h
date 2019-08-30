//
//  FanWeChat.h
//  FanProduct
//
//  Created by 99epay on 2019/7/15.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>

NS_ASSUME_NONNULL_BEGIN

/**集成微信支付 调起和回调功能*/
@interface FanWeChat : NSObject<WXApiDelegate>
+ (instancetype)shareInstance;

- (void)sendReqWithItem:(FanRequestItem *)item;
/**微信回调*/
+ (BOOL)handleOpenURL:(NSURL *)url;
@end

NS_ASSUME_NONNULL_END
