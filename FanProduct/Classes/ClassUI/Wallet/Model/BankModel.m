//
//  BankModel.m
//  FanProduct
//
//  Created by 99epay on 2019/6/25.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "BankModel.h"

@implementation BankModel

@end
@implementation BankCardModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    BankCardModel *model = [BankCardModel new];
    if ([json.allKeys containsObject:@"data"]) {
        NSArray *datas = DICTION_OBJECT(json, @"data");
        if ([datas isKindOfClass:[NSArray class]]) {
            [datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BankCardModel *cardModel = [BankCardModel modelWithJson:obj];
                if (cardModel) {
                    [model.contentList addObject:cardModel];
                }
            }];
        }
    }else{
        model.title = DICTION_OBJECT(json, @"title");
        model.card  = DICTION_OBJECT(json, @"card");
        model.rate  = DICTION_OBJECT(json, @"rate");
        model.rateMoney =  DICTION_OBJECT(json, @"rateMoney");
        model.rateType = DICTION_OBJECT(json, @"rateType");
        model.limitOnce = DICTION_OBJECT(json, @"limitOnce");
        model.limitDay = DICTION_OBJECT(json, @"limitDay");
        model.cardHeader = DICTION_OBJECT(json, @"cardHeader");
        model.o_id = DICTION_OBJECT(json, @"id");
        model.urlScheme = [NSString stringWithFormat:@"BankDetailController?title=%@&card=%@&limitOnce=%@&limitDay=%@&id=%@",model.title,model.card,model.limitOnce,model.limitDay,model.o_id];
        model.cellHeight = (FAN_SCREEN_WIDTH - 30) * 0.4 + 15;
        model.fanClassName = @"BankCardCell";
    }
    return model;
}
- (CGFloat)chargeCount{
    // 0 固定手续费 1 百分比
    CGFloat chargeCount = 0.00;
    if ([self.rateType isEqualToString:@"0"]) {
        chargeCount =  self.rateMoney.floatValue;
    }else{
       chargeCount =  self.rate.floatValue * self.amountCount;
    }
    if (chargeCount < 0.01) {
        chargeCount = 0.00;
    }
    return chargeCount;
}
- (void)setCard:(NSString *)card{
    _card = card;
    NSString *header = [card substringToIndex:4];
    NSString *footer = [card substringFromIndex:card.length - 4];
    _card_att = [NSString stringWithFormat:@"%@**** ****%@",header,footer];
}
- (void)setTitle:(NSString *)title{
    _title = title;
    self.bgColor = [title bankBgColor];
    self.bgImg = [title bankBgImage];
    self.iconImg = [title bankIcon];
}
@end

@implementation BankAddModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    BankAddModel *model = [BankAddModel new];
    model.title = DICTION_OBJECT(json, @"title");
    model.color = DICTION_OBJECT(json, @"color");
    model.urlScheme =  @"BankAddController";
    return model;
}
- (CGFloat)cellHeight{
    return 100;
}
- (NSString *)fanClassName{
    return @"BankAddCell";
}
@end


@implementation BankQuotaModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    BankQuotaModel *model = [BankQuotaModel new];
    model.title = DICTION_OBJECT(json, @"title");
    model.desc = DICTION_OBJECT(json, @"desc");
    return model;
}
- (CGFloat)cellHeight{
    return 54;
}
- (NSString *)fanClassName{
    return @"BankQuotaCell";
}
@end
