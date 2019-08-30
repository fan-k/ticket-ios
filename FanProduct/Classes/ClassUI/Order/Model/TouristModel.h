//
//  TouristModel.h
//  FanProduct
//
//  Created by 99epay on 2019/7/12.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TouristModel : FanModel
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *phone;
@property (nonatomic ,copy) NSString *card;
@property (nonatomic ,copy) NSString *UUtourist_info;
@property (nonatomic ,assign) BOOL  selected;
@end


@interface TouristAddModel : FanModel

@end

NS_ASSUME_NONNULL_END
