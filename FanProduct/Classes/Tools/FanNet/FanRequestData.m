//
//  FanRequestData.m
//  FanProduct
//
//  Created by 99epay on 2019/6/5.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanRequestData.h"

@implementation FanRequestData
+ (instancetype)shareInstance{
    static FanRequestData *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[FanRequestData alloc] init];
    });
    return tools;
}

- (NSDictionary *)readLocalFileWithName:(NSString *)name
{
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"FanRequestData.geojson" ofType:nil];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                           options:kNilOptions
                                             error:nil];
    return DICTION_OBJECT(dict, name);
}
- (NSDictionary *)requestDataItem:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlIndex]) {
        return [self index:item];
    }else if ([item.url isEqualToString:FanUrlViewList]) {
        return [self FanUrlViewList:item];
    }else if ([item.url isEqualToString:FanUrlScenic]) {
        return [self FanUrlScenic:item];
    }else if ([item.url isEqualToString:FanUrlHotCity]) {
        return [self FanUrlHotCity:item];
    }else if ([item.url isEqualToString:FanUrlSearchCity]) {
        return [self FanUrlSearchCity:item];
    }else if ([item.url isEqualToString:FanUrlSearchScenic]) {
        return [self FanUrlSearchScenic:item];
    }else if ([item.url isEqualToString:FanUrlHotScenic]){
        return [self FanUrlHotScenic:item];
    }else if([item.url isEqualToString:FanUrlUserDetail]){
        return [self FanUrlUserDetail:item];
    }else if([item.url isEqualToString:FanUrlUserLogin]){
        return [self FanUrlUserLogin:item];
    }else if([item.url isEqualToString:FanUrlUserRegister]){
        return [self FanUrlUserRegister:item];
    }else if([item.url isEqualToString:FanUrlUserGetCode]){
        return [self FanUrlUserGetCode:item];
    }else if([item.url isEqualToString:FanUrlUserVerificateCode]){
        return [self FanUrlUserVerificateCode:item];
    }else if([item.url isEqualToString:FanUrlUserSetPwd]){
        return [self FanUrlUserSetPwd:item];
    }else if([item.url isEqualToString:FanUrlUserResetPwd]){
        return [self FanUrlUserResetPwd:item];
    }else if ([item.url isEqualToString:FanUrlUserWallet]){
        return [self FanUrlUserWallet:item];
    }else if ([item.url isEqualToString:FanUrlUserBill]){
        return [self FanUrlUserBill:item];
    }else if ([item.url isEqualToString:FanUrlUserBillDetail]){
        return [self FanUrlUserBillDetail:item];
    }else if([item.url isEqualToString:FanUrlUserRechargeConfig]){
        return [self FanUrlUserRechargeConfig:item];
    }else if ([item.url isEqualToString:FanUrlUserRecharge]){
        return [self FanUrlUserRecharge:item];
    }else if ([item.url isEqualToString:FanUrlUserCashConfig]){
        return [self FanUrlUserCashConfig:item];
    }else if ([item.url isEqualToString:FanUrlUserCash]){
        return [self FanUrlUserCash:item];
    }else if([item.url isEqualToString:FanUrlUserBankList]){
        return [self FanUrlUserBankList:item];
    }else if([item.url isEqualToString:FanUrlUserBankVerificate]){
        return [self FanUrlUserBankVerificate:item];
    }else if ([item.url isEqualToString:FanUrlUserBankInfoVerificate]){
        return [self FanUrlUserBankInfoVerificate:item];
    }else if ([item.url isEqualToString:FanUrlUserBankGetCode]){
        return [self FanUrlUserBankGetCode:item];
    }else if ([item.url isEqualToString:FanUrlUserBankVerificateCode]){
        return [self FanUrlUserBankVerificateCode:item];
    }else if ([item.url isEqualToString:FanUrlUserBankSetPwd]){
        return [self FanUrlUserBankSetPwd:item];
    }else if([item.url isEqualToString:FanUrlUserBankVerificateCard]){
        return [self FanUrlUserBankVerificateCard:item];
    }else if([item.url isEqualToString:FanUrlUserBankUnBand]){
        return [self FanUrlUserBankUnBand:item];
    }else if ([item.url isEqualToString:FanUrlUserBankResetPwdVerificate]){
        return [self FanUrlUserBankResetPwdVerificate:item];
    }else if ([item.url isEqualToString:FanUrlUserInfoUpdate]){
        return [self FanUrlUserInfoUpdate:item];
    }else if ([item.url isEqualToString:FanUrlViewClass]){
        return [self FanUrlViewClass:item];
    }else if ([item.url isEqualToString:FanUrlEvaluateClass]){
        return [self FanUrlEvaluateClass:item];
    }else if ([item.url isEqualToString:FanUrlEvaluateList]){
        return [self FanUrlEvaluateList:item];
    }else if ([item.url isEqualToString:FanUrlEvaluateDetail]){
        return [self FanUrlEvaluateDetail:item];
    }else if ([item.url isEqualToString:FanUrlOrderList]){
        return [self FanUrlOrderList:item];
    }else if([item.url isEqualToString:FanUrlOrderWill]){
        return  [self FanUrlOrderWill:item];
    }else if([item.url isEqualToString:FanUrlTicketPrice]){
        return  [self FanUrlTicketPrice:item];
    }else if([item.url isEqualToString:FanUrlTouristInfoGet]){
        return  [self FanUrlTouristInfoGet:item];
    }else if([item.url isEqualToString:FanUrlTouristInfoPost]){
        return  [self FanUrlTouristInfoPost:item];
    }else if([item.url isEqualToString:FanUrlTouristInfoOption]){
        return  [self FanUrlTouristInfoOption:item];
    }else if([item.url isEqualToString:FanUrlTouristInfoDelete]){
        return  [self FanUrlTouristInfoDelete:item];
    }else if ([item.url isEqualToString:FanUrlOrderSubmit]){
        return  [self FanUrlOrderSubmit :item];
    }else if([item.url isEqualToString:FanUrlOrderPay]){
        return [self FanUrlOrderPay:item];
    }else if ([item.url isEqualToString:FanUrlPay]){
        return [self readLocalFileWithName:@"FanUrlPay"];;
    }else if ([item.url isEqualToString:FanUrlPayResult]){
        return [self FanUrlPayResult:item];
    }else if ([item.url isEqualToString:FanUrlOrderDetail]){
        return [self FanUrlOrderDetail:item];
    }else if ([item.url isEqualToString:FanUrlOrderTicket]){
        return [self FanUrlOrderTicket:item];
    }else if ([item.url isEqualToString:FanUrlRefundCancel]){
        return [self FanUrlRefundCancel:item];
    }else if ([item.url isEqualToString:FanUrlOrderDelete]){
        return [self FanUrlOrderDelete:item];
    }else if ([item.url isEqualToString:FanUrlOrderCancel]){
        return [self FanUrlOrderCancel:item];
    }else if ([item.url isEqualToString:FanUrlOrderRefund]){
        return [self readLocalFileWithName:@"FanUrlOrderRefund"];
    }else if ([item.url isEqualToString:FanUrlRefund]){
        return [self FanUrlRefund:item];
    }else if([item.url isEqualToString:FanUrlRefundDetail]){
        return [self readLocalFileWithName:@"FanUrlRefundDetail"];
    }
    
    return nil;
}
- (NSDictionary *)FanUrlRefund:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"成功"
             };
}

- (NSDictionary *)FanUrlOrderCancel:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"取消订单成功",
             };
}
- (NSDictionary *)FanUrlOrderDelete:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"删除订单成功",
             };
}
- (NSDictionary *)FanUrlRefundCancel:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"取消退票成功",
             };
}
- (NSDictionary *)FanUrlOrderTicket:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"取票成功",
             };
}
- (NSDictionary *)FanUrlOrderDetail:(FanRequestItem *)item{
//    int status = arc4random_uniform(9);
    int status = 4;
    return @{
             @"code":@"1",
             @"data":@{
                     @"orderInfo":@{
                             @"number":DICTION_OBJECT(item.params, @"number"),
                             @"title":@"上海星空错觉艺术馆成人票",
                             @"count":@"2",
                             @"status":[NSString stringWithFormat:@"%d",status],
                             @"refundTxt":status == 4 ? @"商家审核中" : status == 5 ? @"退票已入账" :@"",
                             @"totalprice":@"320.00",
                             @"playtime":@"1563245564",
                             @"paytime":@"1563245564",
                             @"payType":@"在线支付",
                             @"endTime":@"1563245564",
                             @"touristInfo":@[
                                     @{@"name":@"游客1",@"phone":@"18978993134",@"card":@"417899199310218392"},
                                     @{@"name":@"游客1",@"phone":@"18978993134",@"card":@"417899199310218392"},
                                     @{@"name":@"游客1",@"phone":@"18978993134",@"card":@"417899199310218392"},
                                     ],
                             @"codeImgUrl":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1563255741616&di=06f3c09c39cc2a72a84f7b88d0b8e6ba&imgtype=0&src=http%3A%2F%2Fi9.hexun.com%2F2018-07-09%2F193397294.jpg",
                             },
                     @"scenicInfo":@{
                             @"title":@"上海星空错觉艺术馆",
                             @"url":@"ticket://scenic/detail?id=1001",
                             @"adress":@"上海市浦东新区陆家嘴1903号负2楼",
                             @"interTime":@"每天08:00-18:00",
                             @"interType":@"无需换票，持商家劵码直接入园",
                             },
                     @"ticketInfo":@{
                             @"title":@"上海星空错觉艺术馆成人票",
                             @"price":@"160",
                             @"refund":@"未消费可随时退票，\n3个工作日内完成退票审核。\n过期后未消费自动申请退票。\n一笔订单多张票不支持部分退票。",
                             
                             }
                     }
             };
}
- (NSDictionary *)FanUrlPayResult:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             };
}

- (NSDictionary *)FanUrlOrderPay:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"data":@[
                     @{
                         @"title":@"钱包支付",
                         @"icon":@"order_wallet",
                         @"discount":[FanWallet shareInstance].walletModel.balance,
                         @"type":@"wallet",
                         },
                     @{
                         @"title":@"支付宝支付",
                         @"icon":@"order_zhifubao",
                         @"discount":@"",
                         @"type":@"zhifubao",
                         },
                     @{
                         @"title":@"微信支付",
                         @"icon":@"order_weixin",
                         @"discount":@"",
                         @"type":@"weixin",
                         },
                     ],
             };
}
- (NSDictionary *)FanUrlOrderSubmit :(FanRequestItem *)item{
    CGFloat count = [NSString stringWithFormat:@"%@",DICTION_OBJECT(item.params, @"count")].floatValue;
    CGFloat price = [NSString stringWithFormat:@"%@",DICTION_OBJECT(item.params, @"price")].floatValue;

    return @{
             @"code":@"1",
             @"msg":@"提交成功",
             @"data":@{
                     @"number":@"21313131",
                     @"title":@"上海星空错觉艺术馆全天成人票",
                     @"totalPrice":[NSString stringWithFormat:@"%.2f",count * price],
                     @"endTime":@"1563257379",
                     }
             };
}
- (NSDictionary *)FanUrlTouristInfoDelete :(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"删除成功",
             };
}
- (NSDictionary *)FanUrlTouristInfoPost :(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"新增成功",
             };
}
- (NSDictionary *)FanUrlTouristInfoOption :(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"修改成功",
             };
}
- (NSDictionary *)FanUrlTouristInfoGet :(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"data":@[
                     @{
                         @"name":@"名称1",
                         @"phone":@"18939019304",
                         @"card":@"",
                         @"id":@"0",
                         },
                     @{
                         @"name":@"名称1",
                         @"phone":@"18939019304",
                         @"card":@"",
                         @"id":@"1",
                         },
                     @{
                         @"name":@"名称1",
                         @"phone":@"18939019304",
                         @"card":@"47189394940300443",
                         @"id":@"2",
                         }
                     ],
             };
}
- (NSDictionary *)FanUrlTicketPrice :(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"data":@[
                     @{
                         @"date":@"2019-07-10",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-11",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-12",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-13",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-14",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-15",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-16",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-17",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-18",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-19",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-20",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-21",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-22",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-23",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-24",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-25",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-26",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-27",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-28",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-29",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-30",
                         @"prize":@"￥160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     @{
                         @"date":@"2019-07-31",
                         @"prize":@"160.0",
                         @"canOrder":@"1",
                         @"count":@"0",
                         },
                     ],
             };
}

- (NSDictionary *)FanUrlOrderWill :(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"data":@{
                     @"ticketinfo":@{
                             @"title":@"上海星空错觉艺术馆全天成人票",
                             @"notes":@"购票须知",
                             @"interType":@"换票入园",
                             @"UUrefund_rule":@"极速退",
                             @"UUtourist_info":@"1",
                             @"UUbuy_limit":@"每单限购2张",
                             },
                     @"prices":@[
                             @{
                                 @"date":@"2019-07-10",
                                 @"prize":@"160.0",
                                 @"canOrder":@"1",
                                 @"count":@"0",
                                 @"id":@"0",
                                 },
                             @{
                                 @"date":@"2019-07-11",
                                 @"prize":@"170.0",
                                 @"canOrder":@"1",
                                 @"count":@"0",
                                 @"id":@"1",
                                 },
                             @{
                                 @"date":@"2019-07-12",
                                 @"prize":@"180.0",
                                 @"canOrder":@"1",
                                 @"count":@"0",
                                 @"id":@"2",
                                 },
                            
                             ],
                     
                     },
             };
}
- (NSDictionary *)FanUrlOrderList :(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"data":@[
                     @{@"number":@"0",
                       @"title":@"上海星空错觉艺术馆全天情侣票", @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562664908439&di=2b89d5a9799de8e50b966204dab31b3c&imgtype=0&src=http%3A%2F%2Fpic.lvmama.com%2Fuploads%2Fpc%2Fplace2%2F2018-03-08%2F14384efd-1427-43c1-90a6-0e23ec9c58a4.jpg",
                       @"count":@"1",
                       @"totalprice":@"160.00",
                       @"unitprice":@"160.00",
                       @"status":@"0",
                       @"playtime":@"1563245564",
                       @"paytime":@"1563245564",
                       @"endTime":@"1563245564",
                       @"scenicInfo":@{
                               @"url":@"ticket://scenic/detail?id=1",
                               @"title":@"上海星空错觉艺术馆",
                               }
                       },
                     @{@"number":@"1",
                       @"title":@"上海星空错觉艺术馆全天单人票", @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562664908439&di=2b89d5a9799de8e50b966204dab31b3c&imgtype=0&src=http%3A%2F%2Fpic.lvmama.com%2Fuploads%2Fpc%2Fplace2%2F2018-03-08%2F14384efd-1427-43c1-90a6-0e23ec9c58a4.jpg",
                       @"count":@"2",
                       @"totalprice":@"160.00",
                       @"unitprice":@"160.00",
                       @"status":@"1",
                       @"playtime":@"1563245564",
                       @"paytime":@"1563245564",
                       @"endTime":@"1563245564",
                       @"scenicInfo":@{
                               @"url":@"ticket://scenic/detail?id=1",
                               @"title":@"上海星空错觉艺术馆",
                               }
                       },
                     @{@"number":@"2",
                       @"title":@"上海星空错觉艺术馆全天情侣票", @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562664908439&di=2b89d5a9799de8e50b966204dab31b3c&imgtype=0&src=http%3A%2F%2Fpic.lvmama.com%2Fuploads%2Fpc%2Fplace2%2F2018-03-08%2F14384efd-1427-43c1-90a6-0e23ec9c58a4.jpg",
                       @"count":@"1",
                       @"totalprice":@"160.00",
                       @"unitprice":@"160.00",
                       @"status":@"2",
                       @"playtime":@"1563245564",
                       @"paytime":@"1563245564",
                       @"endTime":@"1563245564",
                       @"scenicInfo":@{
                               @"url":@"ticket://scenic/detail?id=1",
                               @"title":@"上海星空错觉艺术馆",
                               }
                       },
                     @{@"number":@"3",
                       @"title":@"上海星空错觉艺术馆全天情侣票", @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562664908439&di=2b89d5a9799de8e50b966204dab31b3c&imgtype=0&src=http%3A%2F%2Fpic.lvmama.com%2Fuploads%2Fpc%2Fplace2%2F2018-03-08%2F14384efd-1427-43c1-90a6-0e23ec9c58a4.jpg",
                       @"count":@"1",
                       @"totalprice":@"160.00",
                       @"unitprice":@"160.00",
                       @"status":@"3",
                       @"playtime":@"1563245564",
                       @"paytime":@"1563245564",
                       @"endTime":@"1563245564",
                       @"scenicInfo":@{
                               @"url":@"ticket://scenic/detail?id=1",
                               @"title":@"上海星空错觉艺术馆",
                               }
                       },
                     @{@"number":@"4",
                       @"title":@"上海星空错觉艺术馆全天情侣票", @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562664908439&di=2b89d5a9799de8e50b966204dab31b3c&imgtype=0&src=http%3A%2F%2Fpic.lvmama.com%2Fuploads%2Fpc%2Fplace2%2F2018-03-08%2F14384efd-1427-43c1-90a6-0e23ec9c58a4.jpg",
                       @"count":@"1",
                       @"totalprice":@"160.00",
                       @"unitprice":@"160.00",
                       @"status":@"4",
                       @"playtime":@"1563245564",
                       @"paytime":@"1563245564",
                       @"endTime":@"1563245564",
                       @"scenicInfo":@{
                               @"url":@"ticket://scenic/detail?id=1",
                               @"title":@"上海星空错觉艺术馆",
                               }
                       },
                     @{@"number":@"5",
                       @"title":@"上海星空错觉艺术馆全天情侣票", @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562664908439&di=2b89d5a9799de8e50b966204dab31b3c&imgtype=0&src=http%3A%2F%2Fpic.lvmama.com%2Fuploads%2Fpc%2Fplace2%2F2018-03-08%2F14384efd-1427-43c1-90a6-0e23ec9c58a4.jpg",
                       @"count":@"1",
                       @"totalprice":@"160.00",
                       @"unitprice":@"160.00",
                       @"status":@"5",
                       @"playtime":@"1563245564",
                       @"paytime":@"1563245564",
                       @"endTime":@"1563245564",
                       @"scenicInfo":@{
                               @"url":@"ticket://scenic/detail?id=1",
                               @"title":@"上海星空错觉艺术馆",
                               }
                       },
                     @{@"number":@"6",
                       @"title":@"上海星空错觉艺术馆全天情侣票", @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562664908439&di=2b89d5a9799de8e50b966204dab31b3c&imgtype=0&src=http%3A%2F%2Fpic.lvmama.com%2Fuploads%2Fpc%2Fplace2%2F2018-03-08%2F14384efd-1427-43c1-90a6-0e23ec9c58a4.jpg",
                       @"count":@"1",
                       @"totalprice":@"160.00",
                       @"unitprice":@"160.00",
                       @"status":@"6",
                       @"playtime":@"1563245564",
                       @"paytime":@"1563245564",
                       @"endTime":@"1563245564",
                       @"scenicInfo":@{
                               @"url":@"ticket://scenic/detail?id=1",
                               @"title":@"上海星空错觉艺术馆",
                               }
                       },
                     @{@"number":@"7",
                       @"title":@"上海星空错觉艺术馆全天情侣票", @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562664908439&di=2b89d5a9799de8e50b966204dab31b3c&imgtype=0&src=http%3A%2F%2Fpic.lvmama.com%2Fuploads%2Fpc%2Fplace2%2F2018-03-08%2F14384efd-1427-43c1-90a6-0e23ec9c58a4.jpg",
                       @"count":@"1",
                       @"totalprice":@"160.00",
                       @"unitprice":@"160.00",
                       @"status":@"7",
                       @"playtime":@"1563245564",
                       @"paytime":@"1563245564",
                       @"endTime":@"1563245564",
                       @"scenicInfo":@{
                               @"url":@"ticket://scenic/detail?id=1",
                               @"title":@"上海星空错觉艺术馆",
                               }
                       },@{@"number":@"8",
                           @"title":@"上海星空错觉艺术馆全天情侣票", @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562664908439&di=2b89d5a9799de8e50b966204dab31b3c&imgtype=0&src=http%3A%2F%2Fpic.lvmama.com%2Fuploads%2Fpc%2Fplace2%2F2018-03-08%2F14384efd-1427-43c1-90a6-0e23ec9c58a4.jpg",
                           @"count":@"1",
                           @"totalprice":@"160.00",
                           @"unitprice":@"160.00",
                           @"status":@"8",
                           @"playtime":@"1563245564",
                           @"paytime":@"1563245564",
                           @"endTime":@"1563245564",
                           @"scenicInfo":@{
                                   @"url":@"ticket://scenic/detail?id=1",
                                   @"title":@"上海星空错觉艺术馆",
                                   }
                           },@{@"number":@"9",
                               @"title":@"上海星空错觉艺术馆全天情侣票", @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562664908439&di=2b89d5a9799de8e50b966204dab31b3c&imgtype=0&src=http%3A%2F%2Fpic.lvmama.com%2Fuploads%2Fpc%2Fplace2%2F2018-03-08%2F14384efd-1427-43c1-90a6-0e23ec9c58a4.jpg",
                               @"count":@"1",
                               @"totalprice":@"160.00",
                               @"unitprice":@"160.00",
                               @"status":@"9",
                               @"playtime":@"1563245564",
                               @"paytime":@"1563245564",
                               @"endTime":@"1563245564",
                               @"scenicInfo":@{
                                       @"url":@"ticket://scenic/detail?id=1",
                                       @"title":@"上海星空错觉艺术馆",
                                       }
                               },
                     ],
             };
}
- (NSDictionary *)FanUrlEvaluateDetail:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"data":@{
                     @"id":@"100001",
                     @"name":@"京小东",
                     @"img":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                     @"evaluateStar":@"5",@"time":@"5月10号",
                     @"content":@"超级好玩，超级好玩，",
                     @"imgs":@[@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                               @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                               @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                               @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                               @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                               @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                               @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                               @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                               @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                               @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                               @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                               @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                               ],
                     @"reply":@[
                             @{
                                 @"id":@"100001",
                                 @"name":@"京小东",
                                 @"time":@"5月10号",
                                 @"img":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                 @"content":@"回复一下，回复一，",
                             },
                             @{
                                 @"id":@"100001",
                                 @"name":@"京小东",
                                 @"time":@"5月10号",
                                 @"img":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                 @"content":@"回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，回复一回复一下，",
                                 },
                             @{
                                 @"id":@"100001",
                                 @"name":@"京小东",
                                 @"time":@"5月10号",
                                 @"img":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                 @"content":@"回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，回，回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，",
                                 }
                             , @{
                                 @"id":@"100001",
                                 @"name":@"京小东",
                                 @"time":@"5月10号",
                                 @"img":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                 @"content":@"回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，回复一下，",
                                 }
                             ]
                     
                     }
             };
}
- (NSDictionary *)FanUrlEvaluateList:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"data":@[
                     @{
                         @"id":@"100001",
                         @"name":@"京小东",
                         @"img":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                         @"evaluateStar":@"5",
                         @"time":@"5月10号",
                         @"content":@"超级好玩超级好玩，超级好玩，",
                         @"imgs":@[@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   ],
                         
                         },
                     @{
                         @"id":@"100001",
                         @"name":@"京小东",
                         @"img":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                         @"evaluateStar":@"5",
                         @"time":@"5月10号",
                         @"content":@"超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，",
                         @"imgs":@[@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   ],
                         
                         },
                     @{
                         @"id":@"100001",
                         @"name":@"京小东",
                         @"img":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                         @"evaluateStar":@"5",
                         @"time":@"5月10号",
                         @"content":@"超级好玩，超级超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，",
                         @"imgs":@[@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   ],
                         
                         },
                     @{
                         @"id":@"100001",
                         @"name":@"京小东",
                         @"img":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                         @"evaluateStar":@"5",
                         @"time":@"5月10号",
                         @"content":@"超级好玩，好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，",
                         @"imgs":@[@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   ],
                         
                         },
                     @{
                         @"id":@"100001",
                         @"name":@"京小东",
                         @"img":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                         @"evaluateStar":@"5",
                         @"time":@"5月10号",
                         @"content":@"超级好玩，超级好玩，超好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，",
                         @"imgs":@[@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   ],
                         
                         },
                     @{
                         @"id":@"100001",
                         @"name":@"京小东",
                         @"img":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                         @"evaluateStar":@"5",
                         @"time":@"5月10号",
                         @"content":@"超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，",
                         @"imgs":@[@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   ],
                         
                         },
                     @{
                         @"id":@"100001",
                         @"name":@"京小东",
                         @"img":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                         @"evaluateStar":@"5",
                         @"time":@"5月10号",
                         @"content":@"超级好玩，",
                         @"imgs":@[@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   ],
                         
                         },
                     @{
                         @"id":@"100001",
                         @"name":@"京小东",
                         @"img":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                         @"evaluateStar":@"5",
                         @"time":@"5月10号",
                         @"content":@"超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，",
                         @"imgs":@[@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   ],
                         
                         },
                     @{
                         @"id":@"100001",
                         @"name":@"京小东",
                         @"img":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                         @"evaluateStar":@"5",
                         @"time":@"5月10号",
                         @"content":@"超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，",
                         @"imgs":@[@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                   ],
                         
                         },
                     ],
             };
}
- (NSDictionary *)FanUrlEvaluateClass:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"data":@[
                     @{@"title":@"全部",
                       @"count":@"33133",
                       @"type":@"all",
                       },
                     @{@"title":@"晒图",
                       @"count":@"9300",
                       @"type":@"picture",
                       },
                     @{@"title":@"低分",
                       @"count":@"212",
                       @"type":@"low",
                       },
                     @{@"title":@"最新",
                       @"count":@"231",
                       @"type":@"new",
                       },
                     ],
             };
}
- (NSDictionary *)FanUrlViewClass:(FanRequestItem *)item{
    if ([DICTION_OBJECT(item.params, @"city") isEqualToString:@"上海市"]) {
        return @{
                 @"code":@"1",
                 @"data":@[@{@"title":@"推荐",@"type":@"recommend"},
                           @{@"title":@"周边游",@"type":@"near"},
                           @{@"title":@"一日游",@"type":@"oneday"},
                           @{@"title":@"推荐",@"type":@"recommend"},
                           @{@"title":@"周边游",@"type":@"near"},
                           @{@"title":@"一日游",@"type":@"oneday"},
                           @{@"title":@"推荐",@"type":@"recommend"},
                           @{@"title":@"周边游",@"type":@"near"},
                           @{@"title":@"一日游",@"type":@"oneday"}]
                 };
    }else
    return @{
             @"code":@"1",
             @"data":@[@{@"title":@"推荐",@"type":@"recommend"},
                       @{@"title":@"夏季景点",@"type":@"near"},
                       @{@"title":@"踏青必去",@"type":@"oneday"},
                       @{@"title":@"周末消遣",@"type":@"recommend"},
                       @{@"title":@"没钱别去",@"type":@"near"},
                       @{@"title":@"夜宿夜游",@"type":@"oneday"},
                       @{@"title":@"情侣约会",@"type":@"recommend"},
                       @{@"title":@"放飞自我",@"type":@"near"},
                       @{@"title":@"一日游",@"type":@"oneday"}
                       ]
             };
}
- (NSDictionary *)FanUrlUserInfoUpdate:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"更新成功",
             };
}
- (NSDictionary *)FanUrlUserBankResetPwdVerificate:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"密码验证成功",
             };
}
- (NSDictionary *)FanUrlUserBankUnBand:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"解绑成功",
             };
}
- (NSDictionary *)FanUrlUserBankVerificateCard:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"验证成功",
             @"data":@{
                     @"bank":@"中国银行",
                     @"card":@"389401300401304934",
                     @"type":@"储蓄卡"
                     }
             };
}
- (NSDictionary *)FanUrlUserBankSetPwd:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"设置成功",
             };
}
- (NSDictionary *)FanUrlUserBankVerificateCode:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"绑定成功",
             };
}

- (NSDictionary *)FanUrlUserBankGetCode:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"验证码已发送至手机",
             };
}
- (NSDictionary *)FanUrlUserBankInfoVerificate:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"验证通过",
             };
}
- (NSDictionary *)FanUrlUserBankVerificate:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"验证通过",
             @"data":@{
                     @"bank":@"中国银行",
                     @"card":@"6222011903022123903",
                     @"type":@"储蓄卡",
                     }
             };
}
- (NSDictionary *)FanUrlUserBankList:(FanRequestItem *)item{
   return  @{
      @"code":@"1",
      @"msg":@"获取成功",
      @"data":@[
              @{
                  @"id":@"122121",
                  @"title":@"招商银行",
                  @"card":@"6222011903022123903",
                  @"rate":@"0.5%",
                  @"rateMoney":@"5",
                  @"rateType":@"0",
                  @"limitOnce":@"10000",
                  @"limitDay":@"200000",
                  @"canUsed":@"1",
                  @"cardHeader":@"622202",
                  },
              @{
                  @"id":@"122121",
                  @"title":@"工商银行",
                  @"card":@"6222011903022123903",
                  @"rate":@"0.6%",
                  @"rateMoney":@"6",
                  @"rateType":@"1",
                  @"limitOnce":@"10000",
                  @"limitDay":@"200000",
                  @"canUsed":@"1",
                  @"cardHeader":@"622202",
                  },
              @{
                  @"id":@"122121",
                  @"title":@"农业银行",
                  @"card":@"6222011903022123903",
                  @"rate":@"0.7%",
                  @"rateMoney":@"7",
                  @"rateType":@"0",
                  @"limitOnce":@"10000",
                  @"limitDay":@"200000",
                  @"canUsed":@"1",
                  @"cardHeader":@"622202",
                  },
              @{
                  @"id":@"122121",
                  @"title":@"招商信用卡",
                  @"card":@"6222011903022123903",
                  @"cardHeader":@"622202",
                  @"rate":@"0.8%",
                  @"rateMoney":@"8",
                  @"rateType":@"1",
                  @"limitOnce":@"10000",
                  @"limitDay":@"200000",
                  @"canUsed":@"0",
                  }
              ]
      };
}
- (NSDictionary *)FanUrlUserCash:(FanRequestItem *)item{
//    return @{
//             @"code":@"2001",
//             @"msg":@"支付密码输入错误",
//             @"data":@{
//                     @"id":@"1002001",
//                     @"number":@"203010303033",
//                     @"amount":@"10000",
//                     @"from":@"钱包余额",
//                     @"to":@"工商银行(9839)",
//                     @"time":@"2019-01-02 10:20:21",
//                     @"type":@"支出",
//                     @"action":@"提现",
//                     }
//             };
    return @{
             @"code":@"1",
             @"msg":@"提现成功",
             @"data":@{
                     @"id":@"1002001",
                     @"number":@"203010303033",
                     @"amount_bank":@"10000",
                     @"rate":@"10",
                     @"amount":@"9900",
                     @"from":@"钱包余额",
                     @"to":@"工商银行(9839)",
                     @"time":@"2019-01-02 10:20:21",
                     @"type":@"支出",
                     @"action":@"提现",
                     }
             };
}
- (NSDictionary *)FanUrlUserCashConfig:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"获取成功",
             @"data":@[
                     @{
                         @"id":@"122121",
                         @"title":@"招商银行(9870)",
                         @"rate":@"0.5%",
                         @"rateMoney":@"5",
                         @"rateType":@"0",
                         @"limitOnce":@"10000",
                         @"limitDay":@"200000",
                         @"canUsed":@"1",
                         @"cardHeader":@"622202",
                         },
                     @{
                         @"id":@"122121",
                         @"title":@"工商银行(9870)",
                         @"rate":@"0.6%",
                         @"rateMoney":@"6",
                         @"rateType":@"1",
                         @"limitOnce":@"10000",
                         @"limitDay":@"200000",
                         @"canUsed":@"1",
                         @"cardHeader":@"622202",

                         },
                     @{
                         @"id":@"122121",
                         @"title":@"农业银行(9870)",
                         @"rate":@"0.7%",
                         @"rateMoney":@"7",
                         @"rateType":@"0",
                         @"limitOnce":@"10000",
                         @"limitDay":@"200000",
                         @"canUsed":@"1",
                         @"cardHeader":@"622202",

                         },
                     @{
                         @"id":@"122121",
                         @"title":@"招商信用卡(9870)",
                         @"rate":@"0.8%",
                         @"rateMoney":@"8",
                         @"rateType":@"1",
                         @"limitOnce":@"10000",
                         @"limitDay":@"200000",
                         @"canUsed":@"0",
                         @"cardHeader":@"622202",

                         }
                     ]
             };
}
- (NSDictionary *)FanUrlUserRecharge:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"充值成功",
             @"data":@{
                     @"id":@"1002001",
                     @"number":@"203010303033",
                     @"amount_bank":@"10000",
                     @"to":@"钱包余额",
                     @"from":@"工商银行(9839)",
                     @"time":@"2019-01-02 10:20:21",
                     @"type":@"收入",
                     @"action":@"充值",
                     }
             };
}
- (NSDictionary *)FanUrlUserRechargeConfig:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"获取成功",
             @"data":@[
                     @{
                         @"id":@"122121",
                         @"title":@"招商银行(9870)",
                         @"rate":@"0.5%",
                         @"rateMoney":@"5",
                         @"rateType":@"0",
                         @"limitOnce":@"10000",
                         @"limitDay":@"200000",
                         @"canUsed":@"1",
                         @"cardHeader":@"622202",
                         },
                     @{
                         @"id":@"122121",
                         @"title":@"工商银行(9870)",
                         @"rate":@"0.6%",
                         @"rateMoney":@"6",
                         @"rateType":@"1",
                         @"limitOnce":@"100000",
                         @"limitDay":@"200000",
                         @"canUsed":@"1",
                         @"cardHeader":@"622202",
                         },
                     @{
                         @"id":@"122121",
                         @"title":@"农业银行(9870)",
                         @"rate":@"0.7%",
                         @"rateMoney":@"7",
                         @"rateType":@"0",
                         @"limitOnce":@"8000",
                         @"limitDay":@"200000",
                         @"canUsed":@"1",
                         @"cardHeader":@"622202",
                         },
                     @{
                         @"id":@"122121",
                         @"title":@"招商信用卡(9870)",
                         @"rate":@"0.8%",
                         @"rateMoney":@"8",
                         @"rateType":@"1",
                         @"limitOnce":@"7000",
                         @"limitDay":@"200000",
                         @"canUsed":@"0",
                         @"cardHeader":@"622202",
                         }
                     ]
             };
}
- (NSDictionary *)FanUrlUserBillDetail:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"获取成功",
             @"data":@{
                     @"title":@"上海野生动物园门票",
                     @"time":@"2019-01-02 10:20:21",
                     @"amount":@"60.00",
                     @"id":@"100001",
                     @"number":@"2920301901003131",
                     @"action":@"消费",
                     @"type":@"支出",
                     @"from":@"钱包余额",
                     }
             };
}
- (NSDictionary *)FanUrlUserBill:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"获取成功",
             @"data":@[
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"消费",
                         @"type":@"支出",
                         @"from":@"钱包余额",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"消费",
                         @"type":@"支出",
                         @"from":@"钱包余额",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"消费",
                         @"type":@"支出",
                         @"from":@"钱包余额",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"消费",
                         @"type":@"支出",
                         @"from":@"钱包余额",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"充值",
                         @"type":@"收入",
                         @"from":@"招商银行(9830)",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"充值",
                         @"type":@"收入",
                         @"from":@"招商银行(9830)",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"充值",
                         @"type":@"收入",
                         @"from":@"招商银行(9830)",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"充值",
                         @"type":@"收入",
                         @"from":@"招商银行(9830)",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"充值",
                         @"type":@"收入",
                         @"from":@"招商银行(9830)",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"提现",
                         @"type":@"支出",
                         @"to":@"招商银行(9830)",
                         @"from":@"钱包余额",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"提现",
                         @"type":@"支出",
                         @"to":@"招商银行(9830)",
                         @"from":@"钱包余额",

                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"提现",
                         @"type":@"支出",
                         @"to":@"招商银行(9830)",
                         @"from":@"钱包余额",

                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"提现",
                         @"type":@"支出",
                         @"to":@"招商银行(9830)",
                         @"from":@"钱包余额",

                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"提现",
                         @"type":@"支出",
                         @"to":@"招商银行(9830)",
                         @"from":@"钱包余额",
                         },@{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"提现",
                         @"type":@"支出",
                         @"to":@"招商银行(9830)",
                         @"from":@"钱包余额",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"提现",
                         @"type":@"支出",
                         @"to":@"招商银行(9830)",
                         @"from":@"钱包余额",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"提现",
                         @"type":@"支出",
                         @"to":@"招商银行(9830)",
                         @"from":@"钱包余额",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"提现",
                         @"type":@"支出",
                         @"to":@"招商银行(9830)",
                         @"from":@"钱包余额",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"提现",
                         @"type":@"支出",
                         @"to":@"招商银行(9830)",
                         @"from":@"钱包余额",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"提现",
                         @"type":@"支出",
                         @"to":@"招商银行(9830)",
                         @"from":@"钱包余额",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"提现",
                         @"type":@"支出",
                         @"to":@"招商银行(9830)",
                         @"from":@"钱包余额",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"提现",
                         @"type":@"支出",
                         @"to":@"招商银行(9830)",
                         @"from":@"钱包余额",
                         },
                     @{
                         @"title":@"上海野生动物园门票",
                         @"time":@"2019-01-02 10:20:21",
                         @"amount":@"60.00",
                         @"id":@"100001",
                         @"number":@"2920301901003131",
                         @"action":@"提现",
                         @"type":@"支出",
                         @"to":@"招商银行(9830)",
                         @"from":@"钱包余额",
                         },
                     ],
             };
}
- (NSDictionary *)FanUrlUserWallet:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"获取成功",
             @"data":@{
                     @"balance":@"8830103.30",
                     @"addBank":@"1",
                     @"white":@"1",
                     @"realName":@"1",
                     @"paypwd":@"1",
                     }
             };
}
- (NSDictionary *)FanUrlUserResetPwd:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"密码设置成功",
             };
}
- (NSDictionary *)FanUrlUserSetPwd:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"密码设置成功",
             };
}
- (NSDictionary *)FanUrlUserVerificateCode:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"验证成功",
             @"data":@{
                     @"token":@"token",
                     @"name":@"小京东",
                     @"photo":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                     @"userId":@"100001",
                     @"sex":@"0",
                     @"adress":@"上海市浦东新区",
                     @"phone":@"18988888888",
                     @"birthday":@"1993-10-20",
                     }
             };
}
- (NSDictionary *)FanUrlUserGetCode:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"验证码以发送至你手机",
             @"data":@{
                     @"token":@"token",
                     @"name":@"小京东",
                     @"photo":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                     @"userId":@"100001",
                     @"sex":@"0",
                     @"adress":@"上海市浦东新区",
                     @"phone":@"18988888888",
                     @"birthday":@"1993-10-20",
                     }
             };
}
- (NSDictionary *)FanUrlUserRegister:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"msg":@"注册成功",
             @"data":@{
                     @"token":@"token",
                     @"name":@"小京东",
                     @"photo":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                     @"userId":@"100001",
                     @"sex":@"0",
                     @"adress":@"上海市浦东新区",
                     @"phone":@"18988888888",
                     @"birthday":@"1993-10-20",
                     }
             };
}
- (NSDictionary *)FanUrlUserLogin:(FanRequestItem *)item{
    return @{@"code":@"1",
             @"data":@{
                     @"token":@"token",
                     @"name":@"小京东",
                     @"photo":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                     @"userId":@"100001",
                     @"sex":@"0",
                     @"adress":@"上海市浦东新区",
                     @"phone":@"18988888888",
                     @"birthday":@"1993-10-20",
                     }
             };
}
- (NSDictionary *)FanUrlUserDetail:(FanRequestItem *)item{
    return @{@"code":@"1",
             @"data":@{
                     @"token":@"token",
                     @"name":@"小京东",
                     @"photo":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                     @"userId":@"100001",
                     @"sex":@"0",
                     @"adress":@"上海市浦东新区",
                     @"phone":@"18988888888",
                     @"birthday":@"1993-10-20",
                     }
             };
}
- (NSDictionary *)FanUrlHotScenic:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"data":@[@{@"title":@"上海欢乐谷",@"id":@"1"},
                       @{@"title":@"上海欢乐谷",@"id":@"1"},
                       @{@"title":@"上海欢乐谷",@"id":@"1"},
                       @{@"title":@"上海欢乐谷",@"id":@"1"},
                       @{@"title":@"上海欢乐谷",@"id":@"1"},
                       @{@"title":@"上海欢乐谷",@"id":@"1"},
                       @{@"title":@"上海欢乐谷",@"id":@"1"},
                       @{@"title":@"上海欢乐谷",@"id":@"1"}],
             };
}
- (NSDictionary *)FanUrlSearchScenic:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"data":@[
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1000002?id=1000002&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1000002?id=1000002&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1000002?id=1000002&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       }
                     ],
             };
}
- (NSDictionary *)FanUrlSearchCity:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"data":@[
                     @{@"title":@"上海",@"id":@"1"},
                     @{@"title":@"北京",@"id":@"1"},
                     @{@"title":@"苏州",@"id":@"1"},
                     @{@"title":@"杭州",@"id":@"1"},
                     @{@"title":@"武汉",@"id":@"1"},
                     @{@"title":@"南京",@"id":@"1"},
                     @{@"title":@"重庆",@"id":@"1"},
                     @{@"title":@"成都",@"id":@"1"},
                     ]
             };
}
- (NSDictionary *)FanUrlHotCity:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"data":@[
                     @{@"title":@"上海",@"id":@"1"},
                     @{@"title":@"北京",@"id":@"1"},
                     @{@"title":@"苏州",@"id":@"1"},
                     @{@"title":@"杭州",@"id":@"1"},
                     @{@"title":@"武汉",@"id":@"1"},
                     @{@"title":@"南京",@"id":@"1"},
                     @{@"title":@"重庆",@"id":@"1"},
                     @{@"title":@"成都",@"id":@"1"},
                     ]
             };
}
- (NSDictionary *)FanUrlScenic:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"data": @{
                     @"pictures":@[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562236822789&di=1d07bb1336e6b517adaeb60a3790f1be&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Fsinacn10104%2F94%2Fw640h254%2F20190704%2Fba39-hzfekep6384005.jpg",
                                   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562236822789&di=1d07bb1336e6b517adaeb60a3790f1be&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Fsinacn10104%2F94%2Fw640h254%2F20190704%2Fba39-hzfekep6384005.jpg",
                                   @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562236822789&di=1d07bb1336e6b517adaeb60a3790f1be&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Fsinacn10104%2F94%2Fw640h254%2F20190704%2Fba39-hzfekep6384005.jpg"],
                     @"tickets":@[
                             @{
                                 @"title":@"【成人票】门票",
                                 @"type":@"man",
                                 @"recommand":@"推荐门票",
                                 @"sellCount":@"9.0万+",
                                 @"labels":@[@"官方",@"极速退"],
                                 @"orderTxt":@"今日可定",
                                 @"price":@"￥155起",
                                 @"discount":@"返5元",
                                 @"canOrder":@"1",
                                 @"id":@"2121",
                                 }, @{
                                 @"title":@"【成人票】门票",
                                 @"type":@"man",
                                 @"recommand":@"推荐门票",
                                 @"sellCount":@"9.0万+",
                                 @"labels":@[@"官方",@"极速退"],
                                 @"orderTxt":@"",
                                 @"price":@"￥155起",
                                 @"discount":@"返5元",
                                 @"canOrder":@"1",
                                 @"id":@"2121",
                                 }, @{
                                 @"title":@"【成人票】门票",
                                 @"type":@"man",
                                 @"recommand":@"推荐门票",
                                 @"sellCount":@"9.0万+",
                                 @"labels":@[],
                                 @"orderTxt":@"今日可定",
                                 @"price":@"￥155起",
                                 @"discount":@"返5元",
                                 @"canOrder":@"1",
                                 @"id":@"2121",
                                 },
                             @{
                                 @"title":@"【成人票】门票",
                                 @"type":@"man",
                                 @"recommand":@"推荐门票",
                                 @"sellCount":@"9.0万+",
                                 @"labels":@[@"官方",@"极速退"],
                                 @"orderTxt":@"今日可定",
                                 @"price":@"￥155起",
                                 @"discount":@"",
                                 @"canOrder":@"0",
                                 @"id":@"2121",
                                 },
                           
                             
                             ],
                     @"recommend":@[
                             @{@"title":@"上海周庄",
                               @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562236990096&di=fc7fe144e2c1e44f847520e7c9627506&imgtype=0&src=http%3A%2F%2Fimg.redocn.com%2Fsheji%2F20160921%2Fshanjianjingquxiaoguotu_7167861.jpg",
                               @"url":@"ticket://ScenicSpot/detail/1000001?id=12&type=2",
                               @"star":@"4",
                               @"grade":@"4A景区",
                               @"sellCount":@"9893",
                               @"distance":@"距离您100公里",
                               @"score":@"5.0分",
                               @"recommend":@"90%",
                               @"price":@"￥66起"
                               },
                             @{@"title":@"上海周庄",
                               @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                               @"url":@"ticket://ScenicSpot/detail/1000001?id=13&type=2",
                               @"star":@"4",
                               @"grade":@"4A景区",
                               @"sellCount":@"9893",
                               @"distance":@"距离您100公里",
                               @"score":@"5.0分",
                               @"recommend":@"90%",
                               @"price":@"￥66起"
                               }
                             ],
                     @"scenicInfo":@{
                             @"title":@"上海欢乐谷",
                             @"desc":@"嵩明我的味道无服务范围分为范围分为",
                             @"star":@"4A景区",
                             @"price":@"￥66起",
                             @"recommend":@"90%",
                             @"sellCount":@"23113",
                             @"startTime":@"09:00",
                             @"distance":@"距离您100公里",
                             @"endTime":@"18:00",
                             @"score":@"5.0",
                             @"evaluateCount":@"2.5万+",
                             @"evaluateStar":@"4",
                             @"adress":@"上海市浦东新区陆家嘴1738号",
                             @"discount":@" 免票政策：身高1米(不含)以下儿童免费；优惠政策：身高1米(含)-1.4米(含)半票；",
                             @"timeTxt":@"全天09:00-18:00，17:30停止入场； 节假日及部分日期营业时间会有所调整 ",
                             @"duration":@"1天",
                             @"id":[NSString stringWithFormat:@"%@",DICTION_OBJECT(item.params, @"id")],
                             },
                     @"evaluateLabel":@[@"人气旺 3010",@"超值 20312",@"景色好 321",@"好吃好吃 33312",@"拍照打卡 203"],
                     @"evaluates":@[
                             @{
                                 @"id":@"100001",
                                 @"name":@"京小东",
                                 @"img":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                 @"evaluateStar":@"5",
                                 @"time":@"5月10号",
                                 @"content":@"超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，超级好玩，",
                                 @"imgs":@[@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                           @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                           @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                           @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                           @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                           @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                           @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                           @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                           @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                           @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                           @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                           @"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                                         ],
                                 
                                 }
                             ],
                     }
             };
    
}
- (NSDictionary *)FanUrlViewList:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"data":@[
                     @{@"title":@"上海周庄",
                       @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562236990096&di=fc7fe144e2c1e44f847520e7c9627506&imgtype=0&src=http%3A%2F%2Fimg.redocn.com%2Fsheji%2F20160921%2Fshanjianjingquxiaoguotu_7167861.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1000001?id=1000001&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1000002?id=1000002&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1000003?id=1000003&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1000004?id=1000004&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1000005?id=1000005&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1000006?id=1000006&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1000007?id=1000007&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1000008?id=1000008&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1000009?id=1000009&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1000011?id=1000011&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1000021?id=1000021&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1000301?id=1000301&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1004001?id=1004001&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     @{@"title":@"上海周庄",
                       @"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",
                       @"url":@"ticket://ScenicSpot/detail/1005001?id=1005001&type=2",
                       @"star":@"4",
                       @"grade":@"4A景区",
                       @"sellCount":@"9893",
                       @"distance":@"距离您100公里",
                       @"score":@"5.0分",
                       @"recommend":@"90%",
                       @"price":@"￥66起",
                       @"id":@"100002",
                       },
                     
                     ],
             };
}
- (NSDictionary *)index:(FanRequestItem *)item{
    return @{
             @"code":@"1",
             @"data":@[
                     @{@"title":@"顶部轮播",@"type":@"banner",@"data":@[
                               @{@"title":@"上海周庄",
                                 @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562236990096&di=fc7fe144e2c1e44f847520e7c9627506&imgtype=0&src=http%3A%2F%2Fimg.redocn.com%2Fsheji%2F20160921%2Fshanjianjingquxiaoguotu_7167861.jpg",
                                 @"url":@"ticket://ScenicSpot/detail/1000001?id=1000001&type=2",
                                 @"rating":@"4",
                                 @"sellCount":@"9893",
                                 @"distance":@"100公里",
                                 @"score":@"5.0分",
                                 @"recommend":@"90%",
                                 @"price":@"￥66",
                                 @"id":@"100002",
                                 },
                               @{@"title":@"上海周庄",
                                 @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562236990096&di=dbc30b8944b6b1dc732f8e97cff97e35&imgtype=0&src=http%3A%2F%2Fwww.gog.com.cn%2Fpic%2F0%2F14%2F31%2F88%2F14318800_303898.jpg",
                                 @"url":@"ticket://ScenicSpot/detail/1020001?id=1020001&type=2",
                                 @"rating":@"4",
                                 @"sellCount":@"9893",
                                 @"distance":@"100公里",
                                 @"score":@"5.0分",
                                 @"recommend":@"90%",
                                 @"price":@"￥66",
                                 @"id":@"100002",
                                 },
                               @{@"title":@"上海周庄",
                                 @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562236990095&di=efc6558031fa19b0611d478b252459f8&imgtype=0&src=http%3A%2F%2Fimg.ph.126.net%2Fc-k_2oLsm84Es7MuhWOtvA%3D%3D%2F6597594233704894088.jpg",
                                 @"url":@"ticket://ScenicSpot/detail/1003301?id=1003301&type=2",
                                 @"rating":@"4",
                                 @"sellCount":@"9893",
                                 @"distance":@"100公里",
                                 @"score":@"5.0分",
                                 @"recommend":@"90%",
                                 @"price":@"￥66",
                                 @"id":@"100002",
                                 },
                               @{@"title":@"上海周庄",
                                 @"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1562236990095&di=efc6558031fa19b0611d478b252459f8&imgtype=0&src=http%3A%2F%2Fimg.ph.126.net%2Fc-k_2oLsm84Es7MuhWOtvA%3D%3D%2F6597594233704894088.jpg",
                                 @"url":@"ticket://ScenicSpot/detail/1023001?id=1023001&type=2",
                                 @"rating":@"4",
                                 @"sellCount":@"9893",
                                 @"distance":@"100公里",
                                 @"score":@"5.0分",
                                 @"recommend":@"90%",
                                 @"price":@"￥66",
                                 @"id":@"100002",
                                 },
                               ]},
                     @{@"title":@"快捷入口",@"type":@"nav",@"data":@[
                               @{@"title":@"景点/门票",@"picture":@"home_tool_1",@"url":@"ticket://ScenicSpot/detail/1000001?id=1&type=2"},
                               @{@"title":@"主题乐园",@"picture":@"home_tool_2",@"url":@"ticket://ScenicSpot/detail/1000001?id=1&type=2"},
                               @{@"title":@"赏花踏青",@"picture":@"home_tool_3",@"url":@"ticket://ScenicSpot/detail/1000001?id=1&type=2"},
                               @{@"title":@"一日游",@"picture":@"home_tool_4",@"url":@"ticket://ScenicSpot/detail/1000001?id=1&type=2"},
                               @{@"title":@"每日推荐",@"picture":@"home_tool_5",@"url":@"ticket://ScenicSpot/detail/1000001?id=1&type=2"},
                               @{@"title":@"当季最热",@"picture":@"home_tool_6",@"url":@"ticket://ScenicSpot/detail/1000001?id=1&type=2"},
                               @{@"title":@"亲子游",@"picture":@"home_tool_7",@"url":@"ticket://ScenicSpot/detail/1000001?id=1&type=2"},
                               @{@"title":@"签到领钱",@"picture":@"home_tool_8",@"url":@"ticket://ScenicSpot/detail/1000001?id=1&type=2"}
                               ]},
                    @{@"title":@"上海周边最热景点",@"type":@"slider",@"data":@[
                              @{@"title":@"上海欢乐谷",@"descript":@"上海欢乐谷值得去吗",@"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559737117293&di=4f8c1b62d4c72901d73832164e209a17&imgtype=0&src=http%3A%2F%2Fgss0.baidu.com%2F9vo3dSag_xI4khGko9WTAnF6hhy%2Flvpics%2Fh%3D800%2Fsign%3D0687c684b199a901243556362d940a58%2Fd8f9d72a6059252dcd9d07943d9b033b5ab5b993.jpg",@"url":@"ticket://ScenicSpot/detail/1000441?id=1000441&type=2"},
                                       @{@"title":@"上海周庄",@"descript":@"上海欢乐谷值得去吗",@"picture":@"https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2526164378,898591155&fm=26&gp=0.jpg",@"url":@"ticket://ScenicSpot/detail/1004451?id=10044511&type=2"},
                                       @{@"title":@"上海水上乐园",@"descript":@"上海欢乐谷值得去吗",@"picture":@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3680610934,3728926095&fm=26&gp=0.jpg",@"url":@"ticket://ScenicSpot/detail/10444001?id=110444001&type=2"},
                                       @{@"title":@"上海星空错觉艺术馆",@"descript":@"上海欢乐谷值得去吗",@"picture":@"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=516637691,3304533835&fm=26&gp=0.jpg",@"url":@"ticket://ScenicSpot/detail/10004901?id=110004901&type=2"}
                                       ]},
                     @{@"title":@"上海当季最热景点",@"type":@"wall",@"data":@[
                                      @{@"title":@"上海欢乐谷",@"picture":@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1559737117293&di=4f8c1b62d4c72901d73832164e209a17&imgtype=0&src=http%3A%2F%2Fgss0.baidu.com%2F9vo3dSag_xI4khGko9WTAnF6hhy%2Flvpics%2Fh%3D800%2Fsign%3D0687c684b199a901243556362d940a58%2Fd8f9d72a6059252dcd9d07943d9b033b5ab5b993.jpg",@"url":@"ticket://ScenicSpot/detail/1000341?id=11000341&type=2"},
                                      ]},
                     ]
             };
}
@end
