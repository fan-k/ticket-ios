//
//  FanWallet.h
//  FanProduct
//
//  Created by 99epay on 2019/6/19.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FanWallet : NSObject
+ (instancetype)shareInstance;
/**钱包model*/
@property (nonatomic ,strong) WalletModel *walletModel;


+ (void)updateWalletWithCompleteBlock:(void(^)())completeBlock;
@end

NS_ASSUME_NONNULL_END
