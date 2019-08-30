//
//  MineModel.h
//  FanProduct
//
//  Created by 99epay on 2019/6/12.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineModel : FanModel
@property (nonatomic ,copy) NSString *title;

@end


@interface MineListCellModel : FanModel
@property (nonatomic ,copy) NSString *picture;
@end


@interface MineUserInfoCityModel : FanModel

@property (nonatomic,strong) NSMutableArray *mutbleCitys;

@property (nonatomic,copy) NSArray *lists;

@property (nonatomic,copy) NSArray *citys;//城市数组

@property (nonatomic,copy) NSString *name;//省名字


@end
NS_ASSUME_NONNULL_END
