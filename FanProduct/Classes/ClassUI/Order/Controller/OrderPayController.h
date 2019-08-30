//
//  OrderPayController.h
//  FanProduct
//
//  Created by 99epay on 2019/7/9.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderPayController : FanController

@end



@interface OrderPayCellModel : FanModel
@property (nonatomic ,assign) BOOL selected;
@property (nonatomic ,copy) NSString * title;
@property (nonatomic ,copy) NSString * descript;
@property (nonatomic ,copy) NSString * icon;
@end

@interface OrderPayCell : FanTableViewCell

@end

@interface OrderPayHeaderView : FanView
@property (nonatomic ,strong) NSDictionary *model;
@end

NS_ASSUME_NONNULL_END
