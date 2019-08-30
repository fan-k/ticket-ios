//
//  ScenicModel.m
//  FanProduct
//
//  Created by 99epay on 2019/6/10.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "ScenicModel.h"
#import "HomeModel.h"

@implementation ScenicModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    ScenicModel *model = [ScenicModel new];
    model.pictures = DICTION_OBJECT(json, @"pictures");
    model.title = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"title");
    model.desc = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"desc");
    model.star = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"star");
    model.startTime = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"startTime");
    model.endTime = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"endTime");
    model.score = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"score");
    model.evaluateCount = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"evaluateCount");
    model.evaluateStar = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"evaluateStar");
    model.adress = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"adress");
    model.o_id = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"id");
    model.price = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"price");
    model.recommend = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"recommend");
    model.distance = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"distance");
    model.sellCount = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"sellCount");
    model.urlScheme = [NSString stringWithFormat:@"ScenicSpotController?id=%@",model.o_id];
    ScenicAdressModel *adressModel = [ScenicAdressModel modelWithJson:DICTION_OBJECT(json, @"scenicInfo")];
    if (adressModel) {
        [model.contentList addObject:adressModel];
        [model.contentList addObject:[FanNilModel new]];
    }
    
    ScenicTicketModel *ticketModel = [ScenicTicketModel modelWithJson:json];
    if (ticketModel.contentList.count) {
        [model.contentList addObject:[FanHeaderModel modelWithJson:@{@"title":@"门票"}]];
        [model.contentList addObjectsFromArray:ticketModel.contentList];
        [model.contentList addObject:[FanNilModel new]];
    }
    
    ScenicInfoModel *infoModel = [ScenicInfoModel modelWithJson:json];
    if (infoModel) {
        [model.contentList addObject:[FanHeaderModel modelWithJson:@{@"title":@"景点信息",@"more":@"查看全部",@"urlScheme":@"ScenicInfoController"}]];
        [model.contentList addObject:infoModel];
        [model.contentList addObject:[FanNilModel new]];
    }
    
    ScenicEvaluateModel *evaluateModel = [ScenicEvaluateModel modelWithJson:json];
    if (evaluateModel.contentList.count) {
        [model.contentList addObject:[FanHeaderModel modelWithJson:@{@"title":@"用户评价",@"more":@"查看全部",@"urlScheme":[NSString stringWithFormat:@"ScenicEvaluateController?scenicId=%@",model.o_id]}]];
        ScenicEvaluateLabelModel *labelModel = [ScenicEvaluateLabelModel modelWithJson:json];
        if (labelModel) {
            labelModel.urlScheme = [NSString stringWithFormat:@"ScenicEvaluateController?scenicId=%@",model.o_id];
            [model.contentList addObject:labelModel];
        }
        [model.contentList addObjectsFromArray:evaluateModel.contentList];
        [model.contentList addObject:[FanNilModel new]];
    }
    NSArray *recommend = DICTION_OBJECT(json, @"recommend"); if(!isValidArray(recommend)) recommend = @[];
    HomeContentModel *recommendModel = [HomeContentModel modelWithJson:@{@"data":recommend}];
    if (recommendModel.contentList.count) {
        [model.contentList addObject:[FanHeaderModel modelWithJson:@{@"title":@"推荐景点"}]];
        [model.contentList addObjectsFromArray:recommendModel.contentList];
    }
    return model;
}
@end

@implementation ScenicAdressModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    ScenicAdressModel *model = [ScenicAdressModel new];
    model.adress = DICTION_OBJECT(json, @"adress");
    model.urlScheme = [NSString stringWithFormat:@"ScenicMapController?%@",model.adress];
    return model;
}
- (CGFloat)adressHeight{
    if (!_adressHeight) {
        _adressHeight = [FanSize getHeightWithString:self.adress fontSize:13 width:FAN_SCREEN_WIDTH - 60];
        if (_adressHeight < 15) {
            _adressHeight = 15;
        }
    }return _adressHeight;
}
- (CGFloat)cellHeight{
    return 20 + self.adressHeight;
}
- (NSString *)fanClassName{
    return @"ScenicAdressCell";
}

@end

@implementation ScenicTicketModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    ScenicTicketModel *model = [ScenicTicketModel new];
    if ([json.allKeys containsObject:@"tickets"]) {
        NSArray *tickets = DICTION_OBJECT(json, @"tickets");
        if ([tickets isKindOfClass:[NSArray class]]) {
            [tickets enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ScenicTicketModel *ticketModel = [ScenicTicketModel modelWithJson:obj];
                if (ticketModel) {
                    [model.contentList addObject:ticketModel];
                }
            }];
        }
    }else{
         model.o_id = DICTION_OBJECT(json, @"id");
         model.title = DICTION_OBJECT(json, @"title");
         model.type = DICTION_OBJECT(json, @"type");
         model.sellCount = DICTION_OBJECT(json, @"sellCount");
         model.price = DICTION_OBJECT(json, @"price");
         model.orderTxt = DICTION_OBJECT(json, @"orderTxt");
         model.canOrder = [DICTION_OBJECT(json, @"canOrder") boolValue];
         model.recommand = DICTION_OBJECT(json, @"recommand");
         model.labels = isValidArray(DICTION_OBJECT(json, @"labels")) ? DICTION_OBJECT(json, @"labels") : @[];
         model.discount =  DICTION_OBJECT(json, @"discount");
    }
    return model;
}
- (CGFloat)cellHeight{
    CGFloat height = 110;
    if (![self.orderTxt isNotBlank]) {
        height -= 22;
    }
    if (self.labels.count <= 0) {
        height -=  21;
    }
    return height;
}
- (NSString *)fanClassName{
    return @"ScenicTicketCell";
}
- (NSMutableAttributedString *)price_att{
    if (!_price_att) {
        _price_att = [[NSMutableAttributedString alloc] initWithString:self.price];
        _price_att.font = FanRegularFont(17);
        _price_att.color = COLOR_PATTERN_STRING(@"_ff8925_color");
        [_price_att changeStringStyleWithText:@"￥" color:COLOR_PATTERN_STRING(@"_ff8925_color") font:FanRegularFont(10)];
        [_price_att changeStringStyleWithText:@"起" color:COLOR_PATTERN_STRING(@"_999999_color") font:FanRegularFont(10)];        
    }return _price_att;
}
@end

@implementation ScenicEvaluateLabelModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    ScenicEvaluateLabelModel *model = [ScenicEvaluateLabelModel new];
    NSArray *arr = DICTION_OBJECT(json, @"evaluateLabel");
    if ([arr isKindOfClass:[NSArray class]] && arr.count > 0) {
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (isValidString(obj)) {
                ScenicEvaluateLabelModel *label = [ScenicEvaluateLabelModel new];
                label.title = obj;
                [model.contentList addObject:label];
            }
        }];
    }else{
        return nil;
    }
    return model;
}

- (CGFloat)cellHeight{
    return self.contentHeight + 30;
}
- (CGFloat)contentHeight{
    if (!_contentHeight) {
        CGFloat left = 15;
        CGFloat top = 0;
        for (int i = 0; i < self.contentList.count; i ++) {
            ScenicEvaluateLabelModel *model = self.contentList[i];
            if (model.titleWidth > FAN_SCREEN_WIDTH - 30 - left) {
                //换行
                top += 35;
                left = 15;
                model.cellTop = top;
                model.cellLeft = left;
                left += model.titleWidth;
                left += 15;//间隔
            }else{
                model.cellTop = top;
                model.cellLeft = left;
                left += model.titleWidth;
                left += 15;//间隔
            }
        }
        _contentHeight = top += 30;
    }return _contentHeight;
}
- (CGFloat)titleWidth{
    if (!_titleWidth) {
        _titleWidth = [FanSize getWidthWithString:self.title fontSize:11] + 30;
    }return _titleWidth;
}
- (NSString *)fanClassName{
    return @"ScenicEvaluateLabelCell";
}
@end

@implementation ScenicEvaluateModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    ScenicEvaluateModel *model = [ScenicEvaluateModel new];
    if ([json.allKeys containsObject:@"evaluates"]) {
        NSArray *evaluates = DICTION_OBJECT(json, @"evaluates");
        if ([evaluates isKindOfClass:[NSArray class]]) {
            [evaluates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                ScenicEvaluateModel *evaluateModel = [ScenicEvaluateModel modelWithJson:obj];
                if (evaluateModel) {
                    [model.contentList addObject:evaluateModel];
                    model.lastId = evaluateModel.o_id;
                }
            }];
            if (evaluates.count >= 30) {
                model.ismore = YES;
            }
        }
    }else{
        model.o_id = DICTION_OBJECT(json, @"id");
        model.name = DICTION_OBJECT(json, @"name");
        model.time = DICTION_OBJECT(json, @"time");
        model.img = DICTION_OBJECT(json, @"img");
        model.evaluateStar = DICTION_OBJECT(json, @"evaluateStar");
        model.content = DICTION_OBJECT(json, @"content");
        model.imgs = DICTION_OBJECT(json, @"imgs");
        model.urlScheme = [NSString stringWithFormat:@"ScenicEvaluateDetailController?id=%@",model.o_id];
        ScenicSonEvaluateModel *sonModel = [ScenicSonEvaluateModel subModelWithJson:json];
        if (sonModel.contentList.count) {
            [model.contentList addObjectsFromArray:sonModel.contentList];
        }
        
    }
    return model;
}
- (NSString *)fanClassName{
    return @"ScenicEvaluateCell";
}
@end


@implementation ScenicSonEvaluateModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    ScenicSonEvaluateModel *model = [ScenicSonEvaluateModel new];
    NSArray *reply = DICTION_OBJECT(json, @"reply");
    if (isValidArray(reply)) {
        [reply enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ScenicSonEvaluateModel *sonModel = [ScenicSonEvaluateModel subModelWithJson:obj];
            if (sonModel) {
                [model.contentList addObject:sonModel];
            }
        }];
    }else{
        model.o_id = DICTION_OBJECT(json, @"id");
        model.name = DICTION_OBJECT(json, @"name");
        model.time = DICTION_OBJECT(json, @"time");
        model.content = DICTION_OBJECT(json, @"content");
        model.img = DICTION_OBJECT(json, @"img");
        model.fanClassName  = @"ScenicSonEvaluateCell";
    }
    return model;
}
@end



@implementation ScenicInfoModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    ScenicInfoModel *model = [ScenicInfoModel new];
    model.discount = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"discount");
    model.timeTxt = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"timeTxt");
    model.duration = DICTION_OBJECT(DICTION_OBJECT(json, @"scenicInfo"), @"duration");
    return model;
}
- (NSString *)fanClassName{
    return @"ScenicInfoCell";
}

@end

