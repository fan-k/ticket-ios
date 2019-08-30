//
//  FanWallet.m
//  FanProduct
//
//  Created by 99epay on 2019/6/19.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanWallet.h"

@implementation FanWallet
+ (instancetype)shareInstance{
    static FanWallet *wallet;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wallet = [FanWallet new];
    });
    return wallet;
}

+ (void)updateWalletWithCompleteBlock:(void (^)())completeBlock{
    if ([UserInfo shareInstance].isLogin) {
        FanRequestItem *item = [FanRequestItem new];
        item.url = FanUrlUserWallet;
        item.params[@"token"] = [UserInfo shareInstance].userModel.token;
        item.completeBlock = ^(FanRequestItem *complteItem) {
            //code 10001 用户信息失效
            if ([DICTION_OBJECT(complteItem.responseObject, @"code") isEqualToString:@"1001"]) {
                [UserInfo logout];
            }else if ([DICTION_OBJECT(complteItem.responseObject, @"code") isEqualToString:@"1"]){
                WalletModel *model = [WalletModel modelWithJson:DICTION_OBJECT(complteItem.responseObject, @"data")];
                if (model) {
                    [FanWallet shareInstance].walletModel = model;
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationWalletInfoChanged object:nil];
                }
            }
            if (completeBlock) {
                completeBlock();
            }
        };
        [item startRequest];
    }else{
        if (completeBlock) {
            completeBlock();
        }
    }
}
@end
