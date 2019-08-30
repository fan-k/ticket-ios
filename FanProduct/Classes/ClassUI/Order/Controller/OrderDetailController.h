//
//  OrderDetailController.h
//  FanProduct
//
//  Created by 99epay on 2019/7/9.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanController.h"
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailController : FanController

@end

@interface OrderDetailHeader : FanView
@property (nonatomic ,strong) OrderDetailModel *model;
@end

@interface OrderDetailFooter : UILabel

@end
@interface OrderDetailTabbar : FanView
@property (nonatomic ,strong) OrderDetailModel *model;
@end

NS_ASSUME_NONNULL_END
