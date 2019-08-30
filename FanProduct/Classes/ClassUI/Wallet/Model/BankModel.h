//
//  BankModel.h
//  FanProduct
//
//  Created by 99epay on 2019/6/25.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BankModel : FanModel

@end

@interface BankCardModel : FanModel
@property (nonatomic ,copy) NSString *bgColor;
@property (nonatomic ,copy) NSString *bgImg;
@property (nonatomic ,copy) NSString *iconImg;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *card;
@property (nonatomic ,copy) NSString *rate;
@property (nonatomic ,copy) NSString *rateMoney;
@property (nonatomic ,copy) NSString *rateType;
@property (nonatomic ,copy) NSString *limitOnce;
@property (nonatomic ,copy) NSString *limitDay;
@property (nonatomic ,copy) NSString *cardHeader;


@property (nonatomic ,copy) NSString *card_att;
@property (nonatomic ,assign) BOOL isSelected;

//服务费计算
//提现或充值金额
@property (nonatomic ,assign) CGFloat amountCount;
//对应的手续费
@property (nonatomic ,assign) CGFloat chargeCount;

@end
@interface BankAddModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *color;
@end

@interface BankQuotaModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *desc;
@end
NS_ASSUME_NONNULL_END
