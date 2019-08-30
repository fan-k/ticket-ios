//
//  ScenicModel.h
//  FanProduct
//
//  Created by 99epay on 2019/6/10.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScenicModel : FanModel
@property (nonatomic ,strong) NSArray *pictures;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *desc;
@property (nonatomic ,copy) NSString *star;
@property (nonatomic ,copy) NSString *startTime;
@property (nonatomic ,copy) NSString *endTime;
@property (nonatomic ,copy) NSString *score;
@property (nonatomic ,copy) NSString *evaluateCount;
@property (nonatomic ,copy) NSString *evaluateStar;
@property (nonatomic ,copy) NSString *adress;
/**推荐值*/
@property (nonatomic ,copy) NSString *recommend;
/**价钱*/
@property (nonatomic ,copy) NSString *price;
/**已售数量*/
@property (nonatomic ,copy) NSString *sellCount;
/**距离*/
@property (nonatomic ,copy) NSString *distance;
@end


@interface ScenicAdressModel : FanModel
@property (nonatomic ,copy) NSString *adress;
@property (nonatomic ,assign) CGFloat adressHeight;
@end

@interface ScenicTicketModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *type;
@property (nonatomic ,copy) NSString *sellCount;
@property (nonatomic ,copy) NSString *price;
@property (nonatomic ,copy) NSString *orderTxt;
@property (nonatomic ,strong) NSArray *labels;
@property (nonatomic ,copy) NSString *discount;
@property (nonatomic ,copy) NSString *recommand;
@property (nonatomic ,assign) BOOL canOrder;

@property (nonatomic ,strong) NSMutableAttributedString *price_att;

@end


@interface ScenicInfoModel : FanModel
@property (nonatomic ,copy) NSString *discount;
@property (nonatomic ,copy) NSString *timeTxt;
@property (nonatomic ,copy) NSString *duration;
@end



@interface ScenicEvaluateLabelModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,assign) CGFloat titleWidth;
@property (nonatomic ,assign) CGFloat contentHeight;
@end
@interface ScenicEvaluateModel : FanModel
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *time;
@property (nonatomic ,copy) NSString *img;
@property (nonatomic ,copy) NSString *evaluateStar;
@property (nonatomic ,copy) NSString *content;
@property (nonatomic ,strong) NSArray *imgs;
@end


@interface ScenicSonEvaluateModel : FanModel
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *time;
@property (nonatomic ,copy) NSString *img;
@property (nonatomic ,copy) NSString *content;
@end


NS_ASSUME_NONNULL_END
