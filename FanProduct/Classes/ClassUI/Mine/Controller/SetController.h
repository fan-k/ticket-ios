//
//  SetController.h
//  FanProduct
//
//  Created by 99epay on 2019/6/12.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetController : FanController

@end



@interface FanSetCell : FanTableViewCell
@property (nonatomic ,strong) NSString * data;
@end

@interface FanSetSwitchCell : FanTableViewCell
@property (nonatomic ,strong) NSString *data;

@property (nonatomic ,assign) BOOL pushSwitch;
@end

NS_ASSUME_NONNULL_END
