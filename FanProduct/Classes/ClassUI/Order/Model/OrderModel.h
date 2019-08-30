//
//  OrderModel.h
//  FanProduct
//
//  Created by 99epay on 2019/7/9.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanModel.h"
#import "TouristModel.h"
NS_ASSUME_NONNULL_BEGIN

@class OrderPriceModel;
@interface OrderModel : FanModel
/**门票标题*/
@property (nonatomic ,copy) NSString *title;
/**门票购买限制 文本*/
@property (nonatomic ,copy) NSString *UUbuy_limit;
/**门票退票规则*/
@property (nonatomic ,copy) NSString *UUrefund_rule;
/**身份信息验证 0-不需要填写，1-需要填写，2-需要 填写所有游客身份证*/
@property (nonatomic ,copy) NSString *UUtourist_info;
/**入园方式*/
@property (nonatomic ,copy) NSString *interType;
/**购票须知*/
@property (nonatomic ,copy) NSString *notes;

/**订单门票的标签 */
@property (nonatomic ,strong) NSMutableAttributedString *lableAtt;


@property (nonatomic ,strong) OrderPriceModel *orderPriceModel;

/**游客信息*/
@property (nonatomic ,strong) TouristModel *touristModel;

@end

@interface OrderPriceModel : FanModel
/**是否可定*/
@property (nonatomic ,assign) BOOL canOrder;
/**限额票数*/
@property (nonatomic ,copy) NSString *count;
/**日期 2010-02-33*/
@property (nonatomic ,copy) NSString *date;
/**票价*/
@property (nonatomic ,copy) NSString *prize;
/**默认的一个*/
@property (nonatomic ,strong) OrderPriceModel *currentPriceModel;
@property (nonatomic ,assign) NSInteger currentIndex;
/**用户选了几张*/
@property (nonatomic ,copy) NSString *ticketCount;

@end


@interface OrderListCellModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *picture;
@property (nonatomic ,copy) NSString *count;
@property (nonatomic ,copy) NSString *totalprice;
@property (nonatomic ,copy) NSString *unitprice;
/**订单状态 0：未付款，1：已付款，2：未取票，3：已取票，4：退票中，5：已退票，6：已完成，7：未评价，8：已评价，9:已取消*/
@property (nonatomic ,copy) NSString *status;
@property (nonatomic ,copy) NSString *ordertime;
@property (nonatomic ,copy) NSString *playtime;
/**支付截止时间*/
@property (nonatomic ,copy) NSString *endTime;

#pragma mark -- 景点信息
/**景区标题*/
@property (nonatomic ,copy) NSString *scenicTitle;
/**景区链接*/
@property (nonatomic ,copy) NSString *scenicurl;



/**状态文本*/
@property (nonatomic ,copy) NSString *statusTxt;

/**右侧按钮文本 为空时隐藏右侧按钮*/
@property (nonatomic ,copy) NSString *rightTxt;
@end




#pragma mark -- 订单详情

@interface OrderDetailModel : FanModel
#pragma mark -- 订单信息
/**订单标题*/
@property (nonatomic ,copy) NSString *title;
/**订单状态 0：未付款，1：已付款，2：未取票，3：已取票，4：退票中，5：已退票，6：已完成，7：未评价，8：已评价，9:已取消*/
@property (nonatomic ,copy) NSString *status;
/**如果订单处于退票中 应有退票进程状态*/
@property (nonatomic ,copy) NSString *refundTxt;
/**订单数量*/
@property (nonatomic ,copy) NSString *count;
/**总价*/
@property (nonatomic ,copy) NSString *totalprice;
/**支付截止时间*/
@property (nonatomic ,copy) NSString *endTime;
/**使用时间*/
@property (nonatomic ,copy) NSString *playtime;
/**订单二维码或条形码*/
@property (nonatomic ,copy) NSString *codeImgUrl;
/**支付时间*/
@property (nonatomic ,copy) NSString *paytime;
/**支付方式*/
@property (nonatomic ,copy) NSString *payType;
/**游客信息*/
@property (nonatomic ,strong) NSArray *touristInfo;


#pragma mark -- 景点信息
/**景区标题*/
@property (nonatomic ,copy) NSString *scenicTitle;
/**景区链接*/
@property (nonatomic ,copy) NSString *scenicurl;
/**景点游玩时间*/
@property (nonatomic ,copy) NSString *scenicInterTime;
/**景点入园方式*/
@property (nonatomic ,copy) NSString *scenicInterType;
/**景点地址*/
@property (nonatomic ,copy) NSString *adress;

#pragma mark -- 门票信息

/**门票标题*/
@property (nonatomic ,copy) NSString *ticketInfoTitle;
/**门票退票规则*/
@property (nonatomic ,copy) NSString *ticketRefund;
/**门票单价*/
@property (nonatomic ,copy) NSString *price;




/**状态文本*/
@property (nonatomic ,copy) NSString *statusTxt;



@end

@interface OrderDetailListCellModel : FanModel
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *descript;
@property (nonatomic ,copy) NSString *color;
@property (nonatomic ,copy) NSString *img;
@property (nonatomic ,assign) NSInteger separatorStyle;

@end


NS_ASSUME_NONNULL_END

