//
//  OrderCell.h
//  FanProduct
//
//  Created by 99epay on 2019/7/9.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanTableViewCell.h"

#import "OrderModel.h"
NS_ASSUME_NONNULL_BEGIN

/***/
@interface OrderCell : FanTableViewCell

@end

/**预下单景点门票信息cell*/
@interface OrderScenicTicketInfoCell : FanTableViewCell

@end
/**价格日期*/
@interface OrderDatePriceView : FanView
@property (nonatomic ,assign) BOOL selected;
@property (nonatomic ,strong) OrderPriceModel *model;
@end
/**更多日期*/
@interface OrderMoreDateView : FanView

@end


/**预下单游客信息cell*/
@interface OrderTouristInfoCell : FanTableViewCell

@end

/**预下单游客信息*/
@interface OrderTouristInfoView : FanView
@property (nonatomic ,strong) OrderModel *model;
@end

/**订单列表cell*/
@interface OrderListCell : FanTableViewCell

@end

/**订单列表cell*/
@interface OrderDetailCell : FanTableViewCell

@end




NS_ASSUME_NONNULL_END
