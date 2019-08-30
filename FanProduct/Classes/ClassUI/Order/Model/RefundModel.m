//
//  RefundModel.m
//  FanProduct
//
//  Created by 99epay on 2019/7/17.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "RefundModel.h"
#import "BankController.h"

@implementation RefundModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    RefundModel *model = [RefundModel new];
    RefundOrderInfoModel * infoModel = [RefundOrderInfoModel  modelWithJson:DICTION_OBJECT(json, @"order")];
    if (infoModel) {
        [model.contentList addObject:infoModel];
        [model.contentList addObject:[FanNilModel new]];
        [model.contentList addObject:[RefundReasonModel modelWithJson:DICTION_OBJECT(json, @"refund")]];
        [model.contentList addObject:[FanNilModel new]];
        [model.contentList addObject:[FanHeaderModel modelWithJson:@{@"title":@"退票内容"}]];
        [model.contentList addObject:[RefundInfoModel modelWithJson:DICTION_OBJECT(json, @"refund")]];
        [model.contentList addObject:[BankAddModel modelWithJson:@{@"title":@"申请退票",@"color":@"_yellow_color"}]];
    }else{
        return nil;
    }
    return model;
}
@end


@implementation RefundOrderInfoModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    RefundOrderInfoModel *model = [RefundOrderInfoModel new];
    model.img = DICTION_OBJECT(json, @"picture");
    model.count  = DICTION_OBJECT(json, @"count");
    model.totalprice = DICTION_OBJECT(json, @"totalprice");
    model.title = DICTION_OBJECT(json, @"title");
    model.fanClassName  = @"RefundOrderInfoCell";
    return model;
}

@end


@implementation RefundReasonModel
- (instancetype)init{
    self = [super init];
    self.cellHeight = 50;
    self.fanClassName  = @"RefundReasonCell";
    return self;
}
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    RefundReasonModel *model = [RefundReasonModel new];
    model.refundReason = DICTION_OBJECT(json, @"refundReason");
    return model;
}

@end
@implementation RefundInfoModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    RefundInfoModel *model = [RefundInfoModel new];
    model.refundPrice = DICTION_OBJECT(json, @"refundPrice");
    model.refundType = DICTION_OBJECT(json, @"refundType");
    model.fanClassName  = @"RefundInfoCell";
    return model;
}

@end


@implementation RefundChanceCellModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    RefundChanceCellModel *model = [RefundChanceCellModel new];
    model.title = DICTION_OBJECT(json, @"title");
    model.type = DICTION_OBJECT(json, @"type");
    model.cellHeight = 45;
    model.fanClassName  = @"RefundChanceCell";
    return model;
}

@end

#import "OrderModel.h"
@implementation RefundDetailModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    RefundDetailModel *model = [RefundDetailModel new];
    
    [model.contentList addObject:[FanNilModel new]];
    OrderDetailListCellModel *priceModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"退款金额",@"descript":[NSString stringWithFormat:@"%@元",DICTION_OBJECT(json, @"price")],@"color":@"_red_color"}];
    [model.contentList addObject:priceModel];
    OrderDetailListCellModel *typeModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"退款账号",@"descript":[NSString stringWithFormat:@"%@",DICTION_OBJECT(json, @"type")],@"color":@"_8c8c8c_color"}];
    [model.contentList addObject:typeModel];
    OrderDetailListCellModel *numberModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"退款流水号",@"descript":[NSString stringWithFormat:@"%@",DICTION_OBJECT(json, @"number")],@"color":@"_8c8c8c_color",@"separatorStyle":@"2"}];
    [model.contentList addObject:numberModel];
    [model.contentList addObject:[FanNilModel new]];
    
    RefundDetailFlowModel *flowModel = [RefundDetailFlowModel modelWithJson:json];
    if (flowModel.contentList.count) {
        RefundDetailFlowModel *lastModel = flowModel.contentList.lastObject;
        RefundDetailHeaderModel *headerModel = [RefundDetailHeaderModel modelWithJson:json];
        headerModel.title = lastModel.title;
        [model.contentList insertObject:headerModel atIndex:0];
        [model.contentList addObjectsFromArray:flowModel.contentList];
    }
    return model;
}

@end


@implementation RefundDetailHeaderModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    RefundDetailHeaderModel *model = [RefundDetailHeaderModel new];
    model.expectTime =  DICTION_OBJECT(json, @"expectTime");
    model.fanClassName = @"RefundFlowHeaderCell";
    return model;
}

@end

@implementation RefundDetailFlowModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    RefundDetailFlowModel *model = [RefundDetailFlowModel new];
    NSArray *flow = DICTION_OBJECT(json, @"flow");
    if (isValidArray(flow)) {
        [flow enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            RefundDetailFlowModel *flowModel = [RefundDetailFlowModel modelWithJson:obj];
            if (flowModel) {
                [model.contentList addObject:flowModel];
            }
        }];
    }else{
        model.title = DICTION_OBJECT(json, @"title");
        model.time = DICTION_OBJECT(json, @"time");
        model.descript = DICTION_OBJECT(json, @"descript");
        model.fanClassName = @"RefundFlowCell";
    }
    return model;
}
@end

