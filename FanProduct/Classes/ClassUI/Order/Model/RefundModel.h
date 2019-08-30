//
//  RefundModel.h
//  FanProduct
//
//  Created by 99epay on 2019/7/17.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RefundModel : FanModel

@end


@interface RefundOrderInfoModel : FanModel
@property (nonatomic ,copy) NSString *img;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *count;
@property (nonatomic ,copy) NSString *totalprice;
@end

@interface RefundChanceCellModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,assign) BOOL selected;
@end



@interface RefundReasonModel : FanModel
@property (nonatomic ,strong) NSArray *refundReason;
@property (nonatomic ,strong) RefundChanceCellModel *currentModel;
@end






@interface RefundInfoModel : FanModel
@property (nonatomic ,copy) NSString *refundPrice;
@property (nonatomic ,copy) NSString *refundExplain;
@property (nonatomic ,strong) NSArray *refundType;
@property (nonatomic ,strong) RefundChanceCellModel *currentModel;
@end


@interface RefundDetailModel : FanModel

@end

@interface RefundDetailHeaderModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *expectTime;
@end

@interface RefundDetailFlowModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *time;
@property (nonatomic ,copy) NSString *descript;
@end


NS_ASSUME_NONNULL_END

