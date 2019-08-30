//
//  WalletHeaderView.h
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanView.h"
#import "WalletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WalletHeaderView : FanView
@property (nonatomic ,strong) WalletModel *model;
- (void)setOffset:(CGFloat)offset;
@end

NS_ASSUME_NONNULL_END
