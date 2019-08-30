//
//  RefundCell.h
//  FanProduct
//
//  Created by 99epay on 2019/7/17.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanTableViewCell.h"
#import "RefundModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RefundCell : FanTableViewCell

@end


@interface RefundOrderInfoCell : FanTableViewCell

@end


@interface RefundReasonCell : FanTableViewCell

@end


@interface RefundInfoCell : FanTableViewCell

@end


@interface RefundChanceView : FanView
@property (nonatomic ,strong) NSArray *list;
@property (nonatomic ,copy) NSString *title;
@end
@interface RefundChanceCell : FanTableViewCell
@end

@interface RefundChanceHeader : FanView
@property (nonatomic ,copy) NSString *title;
@end


@interface RefundFlowHeaderCell : FanTableViewCell
@property (nonatomic ,copy) NSString *title;
@end

@interface RefundFlowCell : FanTableViewCell
@property (nonatomic ,copy) NSString *title;
@end

NS_ASSUME_NONNULL_END
