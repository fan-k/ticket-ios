//
//  WalletModel.h
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletModel : FanModel
@property (nonatomic ,copy) NSString *balance;
@property (nonatomic ,assign) BOOL  whiteList;
@property (nonatomic ,assign) BOOL  hasBank;
@property (nonatomic ,assign) BOOL  setPayPwd;
@end


@interface WalletCellModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *desc;
@end

NS_ASSUME_NONNULL_END
