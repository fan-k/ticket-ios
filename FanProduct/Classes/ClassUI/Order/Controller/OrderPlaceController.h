//
//  OrderPlaceController.h
//  FanProduct
//
//  Created by 99epay on 2019/7/9.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanController.h"
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderPlaceController : FanController

@end


@interface OrderPlaceTabbar : FanView
@property (nonatomic ,strong) OrderPriceModel *model;
@end


@interface OrderBillView : FanView
@property (nonatomic ,strong) OrderPriceModel *model;
@end
NS_ASSUME_NONNULL_END
