//
//  MineHeaderView.h
//  FanProduct
//
//  Created by 99epay on 2019/6/12.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineHeaderView : FanView
- (void)setOffset:(CGFloat)offset;
@end


@interface MineToolView : FanView
@property (nonatomic ,strong) NSDictionary *dict;
@end

NS_ASSUME_NONNULL_END
