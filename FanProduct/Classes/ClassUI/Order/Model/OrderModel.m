//
//  OrderModel.m
//  FanProduct
//
//  Created by 99epay on 2019/7/9.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    OrderModel *model = [OrderModel new];
    
    model.title = DICTION_OBJECT(DICTION_OBJECT(json, @"ticketinfo"), @"title");
    model.UUbuy_limit = DICTION_OBJECT(DICTION_OBJECT(json, @"ticketinfo"), @"UUbuy_limit");
    model.UUrefund_rule = DICTION_OBJECT(DICTION_OBJECT(json, @"ticketinfo"), @"UUrefund_rule");
    model.UUtourist_info = DICTION_OBJECT(DICTION_OBJECT(json, @"ticketinfo"), @"UUtourist_info");
    model.notes = DICTION_OBJECT(DICTION_OBJECT(json, @"ticketinfo"), @"notes");
    model.interType = DICTION_OBJECT(DICTION_OBJECT(json, @"ticketinfo"), @"interType");
    model.orderPriceModel = [OrderPriceModel modelWithJson:json];
    
    return model;
}

- (NSMutableAttributedString *)lableAtt{
    if (!_lableAtt) {
        //暂时三个标签  入园方式 退票  身份证验证
        //        _lableAtt = [[NSMutableAttributedString alloc] initWithString:self.];
    }return _lableAtt;
}

@end


@implementation OrderPriceModel
- (instancetype)init{
    self = [super init];
    _ticketCount  =@"1";
    return self;
}
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    OrderPriceModel *model = [OrderPriceModel new];
    NSArray *arr = DICTION_OBJECT(json, @"prices");
    if(isValidArray(arr)){
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            OrderPriceModel *priceModel = [OrderPriceModel modelWithJson:obj];
            if (priceModel) {
                [model.contentList addObject:priceModel];
            }
        }];
        for (long i = model.contentList.count - 1; i >= 0 ; i --) {
            OrderPriceModel *priceModel = model.contentList[i];
            if (priceModel.canOrder) {
                model.currentPriceModel = priceModel;//取默认的
                model.currentIndex = i;
            }
        }
    }else{
        model.canOrder = [DICTION_OBJECT(json, @"canOrder") boolValue];
        model.count = DICTION_OBJECT(json, @"count");
        model.date = DICTION_OBJECT(json, @"date");
        model.prize = DICTION_OBJECT(json, @"prize");
    }
    return model;
}
- (void)setCount:(NSString *)count{
    if (count.integerValue <= 0) {
        //不限购 设定最大值
        count = @"100";
    }
    _count = count;
}
- (void)setTicketCount:(NSString *)ticketCount{
    if (ticketCount.integerValue < 1) {
        //
        [FanAlert alertMessage:@"最少要买一张哦~" type:AlertMessageTypeNomal];
    }else if (ticketCount.integerValue > self.count.integerValue) {
        [FanAlert alertMessage:[NSString stringWithFormat:@"最多只能买%@张",self.count] type:AlertMessageTypeNomal];
    }else{
        _ticketCount = ticketCount;
    }
}
@end


@implementation OrderListCellModel


+ (instancetype)subModelWithJson:(NSDictionary *)json{
    OrderListCellModel *model = [OrderListCellModel new];
    if ([json.allKeys containsObject:@"data"] && isValidArray(DICTION_OBJECT(json, @"data"))) {
        NSArray *arr = DICTION_OBJECT(json, @"data");
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            OrderListCellModel *cellModel = [OrderListCellModel modelWithJson:obj];
            if (cellModel) {
                [model.contentList addObject:cellModel];
                model.lastId = cellModel.o_id;
            }
        }];
        model.ismore = arr.count >= 30;
    }else{
        NSDictionary *scenicInfo = DICTION_OBJECT(json, @"scenicInfo");
        model.scenicTitle = DICTION_OBJECT(scenicInfo, @"title");
        model.scenicurl = DICTION_OBJECT(scenicInfo, @"url");
        
        model.endTime = DICTION_OBJECT(json, @"endTime");
        model.title = DICTION_OBJECT(json, @"title");
        model.picture = DICTION_OBJECT(json, @"picture");
        model.count = DICTION_OBJECT(json, @"count");
        model.totalprice = DICTION_OBJECT(json, @"totalprice");
        model.unitprice = DICTION_OBJECT(json, @"unitprice");
        model.status = DICTION_OBJECT(json, @"status");
        model.ordertime = DICTION_OBJECT(json, @"ordertime");
        model.playtime = DICTION_OBJECT(json, @"playtime");
        model.o_id  =DICTION_OBJECT(json, @"number");
        model.urlScheme  = [NSString stringWithFormat:@"OrderDetailController?number=%@",model.o_id];
        model.fanClassName  = @"OrderListCell";
    }
    return model;
}
- (NSString *)statusTxt{
    if (!_statusTxt) {
        /* 0：未付款，1：已付款，2：未取票，3：已取票，4：退票中，5：已退票，6：已完成，7：未评价，8：已评价，9:已取消*/
        if ([self.status isEqualToString:@"0"]) {
            _statusTxt = @"未付款";
        }else if ([self.status isEqualToString:@"1"]) {
            _statusTxt = @"已付款";
        }else if ([self.status isEqualToString:@"2"]) {
            _statusTxt = @"未取票";
        }else if ([self.status isEqualToString:@"3"]) {
            _statusTxt = @"已取票";
        }else if ([self.status isEqualToString:@"4"]) {
            _statusTxt = @"退票中";
        }else if ([self.status isEqualToString:@"5"]) {
            _statusTxt = @"已退票";
        }else if ([self.status isEqualToString:@"6"]) {
            _statusTxt = @"已完成";
        }else if ([self.status isEqualToString:@"7"]) {
            _statusTxt = @"已使用";
        }else if ([self.status isEqualToString:@"8"]) {
            _statusTxt = @"已完成";
        }else if ([self.status isEqualToString:@"9"]) {
            _statusTxt = @"已取消";
        }
    }return _statusTxt;
}
- (NSString *)rightTxt{
    if (!_rightTxt) {
        /* 0：未付款，1：已付款，2：未取票，3：已取票，4：退票中，5：已退票，6：已完成，7：未评价，8：已评价，9:已取消*/
        if ([self.status isEqualToString:@"0"]) {
            _rightTxt = @"去付款";
        }else if ([self.status isEqualToString:@"1"]) {
            _rightTxt = @"取票";
        }else if ([self.status isEqualToString:@"2"]) {
            _rightTxt = @"取票";
        }else if ([self.status isEqualToString:@"3"]) {
            _rightTxt = @"评价";
        }else if ([self.status isEqualToString:@"4"]) {
            _rightTxt = @"取消退票";
        }else if ([self.status isEqualToString:@"5"]) {
            _rightTxt = @"再次购买";
        }else if ([self.status isEqualToString:@"6"]) {
            _rightTxt = @"评价";
        }else if ([self.status isEqualToString:@"7"]) {
            _rightTxt = @"评价";
        }else if ([self.status isEqualToString:@"8"]) {
            _rightTxt = @"再次购买";
        }else if ([self.status isEqualToString:@"9"]) {
            _rightTxt = @"再次购买";
        }
    }return _rightTxt;
}
@end



@implementation OrderDetailModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    OrderDetailModel *model = [OrderDetailModel new];
    NSDictionary *orderInfo = DICTION_OBJECT(json, @"orderInfo");
    model.o_id = DICTION_OBJECT(orderInfo, @"number");
    model.title = DICTION_OBJECT(orderInfo, @"title");
    model.count = DICTION_OBJECT(orderInfo, @"count");
    model.status = DICTION_OBJECT(orderInfo, @"status");
    model.totalprice = DICTION_OBJECT(orderInfo, @"totalprice");
    model.playtime = DICTION_OBJECT(orderInfo, @"playtime");
    model.paytime = DICTION_OBJECT(orderInfo, @"paytime");
    model.payType = DICTION_OBJECT(orderInfo, @"payType");
    model.codeImgUrl = DICTION_OBJECT(orderInfo, @"codeImgUrl");
    model.touristInfo = DICTION_OBJECT(orderInfo, @"touristInfo");
    model.refundTxt = DICTION_OBJECT(orderInfo, @"refundTxt");
    model.endTime = DICTION_OBJECT(orderInfo, @"endTime");
    NSDictionary *scenicInfo = DICTION_OBJECT(json, @"scenicInfo");
    model.scenicTitle  = DICTION_OBJECT(scenicInfo, @"title");
    model.scenicurl  = DICTION_OBJECT(scenicInfo, @"url");
    model.scenicInterTime  = DICTION_OBJECT(scenicInfo, @"interTime");
    model.adress  = DICTION_OBJECT(scenicInfo, @"adress");
    model.scenicInterType  = DICTION_OBJECT(scenicInfo, @"interType");
    
    
    NSDictionary *ticketInfo = DICTION_OBJECT(json, @"ticketInfo");
    model.ticketInfoTitle  = DICTION_OBJECT(ticketInfo, @"title");
    model.ticketRefund  = DICTION_OBJECT(ticketInfo, @"refund");
    model.price  = DICTION_OBJECT(ticketInfo, @"price");
    
    
    /**构建cellList*/
    /**订单信息*/
    //如果是退票中 添加退票
    if ([model.status isEqualToString:@"4"]) {
        //退票中
        FanHeaderModel *refundModel = [FanHeaderModel modelWithJson:@{@"title":[NSString stringWithFormat:@"退票进度:%@",model.refundTxt],@"more":@"查看退票进度",@"urlScheme":[NSString stringWithFormat:@"RefundDetailController?number=%@",model.o_id]}];
        [model.contentList addObject:refundModel];
    }
    if ([model.status isEqualToString:@"5"]) {
        //已退票
        FanHeaderModel *refundModel = [FanHeaderModel modelWithJson:@{@"title":[NSString stringWithFormat:@"退票进度:%@",model.refundTxt],@"more":@"查看退票详情",@"urlScheme":[NSString stringWithFormat:@"RefundDetailController?number=%@",model.o_id]}];
        [model.contentList addObject:refundModel];
    }
    /**订单标题*/
    FanHeaderModel *headerModel = [FanHeaderModel subModelWithJson:@{@"title":model.title,@"accessView":@"1",@"urlScheme":model.scenicurl}];
    [model.contentList addObject:headerModel];
    
    /**订单使用信息*/
    //时间格式年月日+星期几
    NSString *playTime  = [NSString stringWithFormat:@"%@ %@",[FanTime TimeIntervalIntoString:model.playtime.integerValue formatter:@"yyyy-mm-dd"],[FanTime weekWithTimeInterval:model.playtime]];
    OrderDetailListCellModel *dateModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"使用日期",@"descript":playTime,@"color":@"_fdc716_color"}];
    [model.contentList addObject:dateModel];
    
    OrderDetailListCellModel *interTypeModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"使用方法",@"descript":model.scenicInterType}];
    [model.contentList addObject:interTypeModel];
    
    OrderDetailListCellModel *interTimeModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"入园时间",@"descript":model.scenicInterTime}];
    [model.contentList addObject:interTimeModel];
    
    OrderDetailListCellModel *interAdressModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"入园地址",@"descript":model.adress,@"separatorStyle":@"2"}];
    [model.contentList addObject:interAdressModel];
    
    /**已付款未取票*/
    if ([model.status isEqualToString:@"3"]) {
        OrderDetailListCellModel *codeModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"入园方式",@"descript":@"请入园前先取票",@"color":@"_363636_color",@"separatorStyle":@"2"}];
        [model.contentList addObject:codeModel];
    }else{
        //认定已取票 判断是否存在二维码
        /**如果存在二维码显示二维码*/
        if ([model.codeImgUrl isNotBlank]) {
            OrderDetailListCellModel *codeModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"入园方式",@"descript":model.scenicInterType,@"color":@"_363636_color",@"img":model.codeImgUrl,@"separatorStyle":@"2"}];
            [model.contentList addObject:codeModel];
        }else{
            OrderDetailListCellModel *codeModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"入园方式",@"descript":model.scenicInterType,@"color":@"_363636_color",@"separatorStyle":@"2"}];
            [model.contentList addObject:codeModel];
        }
    }
    
    
    OrderDetailListCellModel *refundModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"退改规则",@"descript":model.ticketRefund,@"color":@"_fdc716_color",@"separatorStyle":@"2"}];
    [model.contentList addObject:refundModel];
    
    /**景区导航*/
    [model.contentList addObject:[FanNilModel new]];
    [model.contentList addObject:[FanHeaderModel subModelWithJson:@{@"title":model.scenicTitle,@"accessView":@"1",@"urlScheme":model.scenicurl}]];
    [model.contentList addObject:[FanNilModel new]];
    
    /**订单信息*/
    [model.contentList addObject:[FanHeaderModel subModelWithJson:@{@"title":@"订单信息"}]];
    
    
    //游客信息
    NSString *touristInfo = @"";
    for (int i = 0 ; i < model.touristInfo.count ; i ++) {
        NSDictionary *userInfo = model.touristInfo[i];
        NSString *name = DICTION_OBJECT(userInfo, @"name");
        NSString *phone = DICTION_OBJECT(userInfo, @"phone");
        NSString *card = DICTION_OBJECT(userInfo, @"card");
        if ([name isNotBlank]) {
            if ([touristInfo isNotBlank]) {
                touristInfo = [touristInfo stringByAppendingString:[NSString stringWithFormat:@"\n姓名：      %@",name]];
            }else{
                touristInfo = [touristInfo stringByAppendingString:[NSString stringWithFormat:@"姓名：      %@",name]];
            }
        }
        if ([phone isNotBlank]) {
            touristInfo = [touristInfo stringByAppendingString:[NSString stringWithFormat:@"\n手机号：   %@",phone]];
        }
        if ([card isNotBlank]) {
            touristInfo = [touristInfo stringByAppendingString:[NSString stringWithFormat:@"\n身份证号：%@",card]];
        }
    }
    OrderDetailListCellModel *touristModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"游客信息",@"descript":touristInfo,@"separatorStyle":@"2"}];
    [model.contentList addObject:touristModel];
    
    OrderDetailListCellModel *numberModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"订单编号",@"descript":model.o_id}];
    [model.contentList addObject:numberModel];
    
    OrderDetailListCellModel *countModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"购买数量",@"descript":[NSString stringWithFormat:@"%@张",model.count]}];
    [model.contentList addObject:countModel];
    
    OrderDetailListCellModel *priceModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"门票单价",@"descript":[NSString stringWithFormat:@"%@元",model.price]}];
    [model.contentList addObject:priceModel];
    
    OrderDetailListCellModel *timeModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"支付时间",@"descript":model.paytime}];
    [model.contentList addObject:timeModel];
    
    OrderDetailListCellModel *typeModel = [OrderDetailListCellModel modelWithJson:@{@"title":@"支付方式",@"descript":model.payType,@"separatorStyle":@"2"}];
    [model.contentList addObject:typeModel];
    
    
    return model;
}

- (NSString *)statusTxt{
    if (!_statusTxt) {
        /* 0：未付款，1：已付款，2：未取票，3：已取票，4：退票中，5：已退票，6：已完成，7：未评价，8：已评价，9:已取消*/
        if ([self.status isEqualToString:@"0"]) {
            _statusTxt = @"未付款";
        }else if ([self.status isEqualToString:@"1"]) {
            _statusTxt = @"已付款";
        }else if ([self.status isEqualToString:@"2"]) {
            _statusTxt = @"未取票";
        }else if ([self.status isEqualToString:@"3"]) {
            _statusTxt = @"已取票";
        }else if ([self.status isEqualToString:@"4"]) {
            _statusTxt = @"退票中";
        }else if ([self.status isEqualToString:@"5"]) {
            _statusTxt = @"已退票";
        }else if ([self.status isEqualToString:@"6"]) {
            _statusTxt = @"已完成";
        }else if ([self.status isEqualToString:@"7"]) {
            _statusTxt = @"已使用";
        }else if ([self.status isEqualToString:@"8"]) {
            _statusTxt = @"已完成";
        }else if ([self.status isEqualToString:@"9"]) {
            _statusTxt = @"已取消";
        }
    }return _statusTxt;
}

@end


@implementation OrderDetailListCellModel
+ (instancetype)subModelWithJson:(NSDictionary *)json{
    OrderDetailListCellModel *model = [OrderDetailListCellModel new];
    model.cellHeight = 40;
    model.fanClassName = @"OrderDetailCell";
    model.title = DICTION_OBJECT(json, @"title");
    model.descript = DICTION_OBJECT(json, @"descript");
    model.img = DICTION_OBJECT(json, @"img");
    model.color = DICTION_OBJECT(json, @"color");
    model.separatorStyle = [DICTION_OBJECT(json, @"separatorStyle") integerValue];
    return model;
}

@end

