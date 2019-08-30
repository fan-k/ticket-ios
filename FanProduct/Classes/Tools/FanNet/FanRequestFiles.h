//
//  FanRequestFiles.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/17.
//  Copyright © 2018 Fan. All rights reserved.
//
// 所有的接口字段


#pragma mark -- BaseUrl
/**baseUrl*/

#ifdef DEBUG

/**测试*/
static NSString *FanBaseUrl = @"http://47.104.198.112:8800";
#else

/**生产*/
static NSString *FanBaseUrl = @"http://47.104.198.112:8800";

#endif


/*
 * 推送tokentoken
 * token
 * params:token
 */
static NSString *const FanUrlToken= @"FanUrlToken";

#pragma mark -- 首页
/*
 *首页
 * index
 * params:coor
 */
static NSString *const FanUrlIndex= @"/rcmd/index";
/*
 *首页列表
 * index
 * params:coor
 */
static NSString *const FanUrlViewList= @"FanUrlViewList";

/*
 * 发现主题
 * index
 * params:city
 */
static NSString *const FanUrlViewClass= @"FanUrlViewClass";

/*
 *景点详情
 * scenic
 * params:coor
 */
static NSString *const FanUrlScenic= @"FanUrlScenic";
/*
 *景点评价类型
 * scenic
 * params: id
 */
static NSString *const FanUrlEvaluateClass= @"FanUrlEvaluateClass";
/*
 *景点评价列表
 * scenic
 * params:type id
 */
static NSString *const FanUrlEvaluateList= @"FanUrlEvaluateList";
/*
 *景点评价详情
 * scenic
 * params: id
 */
static NSString *const FanUrlEvaluateDetail= @"FanUrlEvaluateDetail";
/*
 *热门景点
 * hotScenic
 * params:coor
 */
static NSString *const FanUrlHotScenic = @"FanUrlHotScenic";
/*
 *景区搜索
 * SearchScenic
 * params:coor
 */
static NSString *const FanUrlSearchScenic = @"FanUrlSearchScenic";

/*
 *热门城市
 * hotCity
 * params:coor
 */
static NSString *const FanUrlHotCity = @"FanUrlHotCity";

/*
 *城市搜索
 * SearchCity
 * params:coor
 */
static NSString *const FanUrlSearchCity = @"FanUrlSearchCity";
#pragma mark --用户信息
/*
 * 用户信息接口
 * User/getDetail.html
 * params :id --> user_id
 */
static NSString *const FanUrlUserDetail= @"User/getDetail.html";


/*
 * 登录
 * FanUrlUserLogin
 * params
 */
static NSString *const FanUrlUserLogin= @"FanUrlUserLogin";

/*
 * 注册
 * FanUrlUserRegister
 * params :
 */
static NSString *const FanUrlUserRegister= @"User/FanUrlUserRegister";

/*
 * 获取验证码
 * User/FanUrlUserGetCode
 * params
 */
static NSString *const FanUrlUserGetCode= @"User/FanUrlUserGetCode";

/*
 * 验证验证码
 * User/FanUrlUserVerificateCode
 * params
 */
static NSString *const FanUrlUserVerificateCode= @"User/FanUrlUserVerificateCode";

/*
 * 设置密码
 * User/FanUrlUserSetPwd
 * params
 */
static NSString *const FanUrlUserSetPwd= @"User/FanUrlUserSetPwd";

/*
 * 修改密码
 * User/FanUrlUserResetPwd
 * params
 */
static NSString *const FanUrlUserResetPwd= @"User/FanUrlUserResetPwd";

#pragma mark -- 钱包

/*
 * 钱包余额以及钱包配置信息
 * User/FanUrlUserWallet
 * params
 */
static NSString *const FanUrlUserWallet= @"User/FanUrlUserWallet";
/*
 * 账单明细
 * User/FanUrlUserBill
 * params
 */
static NSString *const FanUrlUserBill= @"User/FanUrlUserBill";
/*
 * 账单明细详情
 * User/FanUrlUserBillDetail
 * params
 */
static NSString *const FanUrlUserBillDetail= @"User/FanUrlUserBillDetail";
/*
 * 获取充值配置 可使用的银行卡
 * User/FanUrlUserRechargeConfig
 * params
 */
static NSString *const FanUrlUserRechargeConfig= @"User/FanUrlUserRechargeConfig";
/*
 * 充值
 * User/FanUrlUserRecharge
 * params
 */
static NSString *const FanUrlUserRecharge= @"User/FanUrlUserRecharge";
/*
 * 获取提现配置
 * User/FanUrlUserCashConfig
 * params
 */
static NSString *const FanUrlUserCashConfig= @"User/FanUrlUserCashConfig";
/*
 * 提现
 * User/FanUrlUserCash
 * params
 */
static NSString *const FanUrlUserCash= @"User/FanUrlUserCash";

/*
 * 银行卡
 * User/FanUrlUserWallet
 * params
 */
static NSString *const FanUrlUserBankList= @"User/FanUrlUserBankList";

/*
 * 银行卡信息验证 以及实名 手机号信息验证
 * User/FanUrlUserBankInfoVerificate
 * params
 */
static NSString *const FanUrlUserBankInfoVerificate= @"User/FanUrlUserBankInfoVerificate";
/*
 * 验证输入的卡号正确性 返回银行
 * User/FanUrlUserBankVerificate
 * params
 */
static NSString *const FanUrlUserBankVerificate= @"User/FanUrlUserBankVerificate";
/*
 * 获取银行卡绑定手机号的验证码
 * User/FanUrlUserBankGetCode
 * params
 */
static NSString *const FanUrlUserBankGetCode= @"User/FanUrlUserBankGetCode";
/*
 * 验证银行卡绑定手机号的验证码--最终绑定
 * User/FanUrlUserBankVerificateCode
 * params
 */
static NSString *const FanUrlUserBankVerificateCode= @"User/FanUrlUserBankVerificateCode";
/*
 * 银行卡支付密码设置
 * User/FanUrlUserBankSetPwd
 * params
 */
static NSString *const FanUrlUserBankSetPwd= @"User/FanUrlUserBankSetPwd";
/*
 * 银行卡支付密码修改--验证原密码
 * User/FanUrlUserBankResetPwd
 * params
 */
static NSString *const FanUrlUserBankResetPwdVerificate= @"User/FanUrlUserBankResetPwdVerificate";


/*
 * 银行卡支付密码找回 --验证身份证
 * User/FanUrlUserBankVerificateCard
 * params
 */
static NSString *const FanUrlUserBankVerificateCard= @"User/FanUrlUserBankVerificateCard";

/*
 * 银行卡解绑
 * User/FanUrlUserBankUnBand
 * params
 */
static NSString *const FanUrlUserBankUnBand= @"User/FanUrlUserBankUnBand";


#pragma mark -- 设置

/*
 * 客服配置信息
 * User/FanUrlUserCustomer
 * params
 */
static NSString *const FanUrlUserCustomer= @"User/FanUrlUserCustomer";

/*
 * 意见反馈
 * User/FanUrlUserFeedback
 * params
 */
static NSString *const FanUrlUserFeedback= @"User/FanUrlUserFeedback";


#pragma mark -- 个人中心

/*
 * 我的评价
 * User/FanUrlUserCommend
 * params
 */
static NSString *const FanUrlUserCommend= @"User/FanUrlUserCommend";


/*
 * 更新用户信息
 * User/FanUrlUserInfoUpdate
 * params
 */
static NSString *const FanUrlUserInfoUpdate= @"User/FanUrlUserInfoUpdate";



#pragma mrk --  订单
/*
 * 订单列表
 * index
 * params:type
 */
static NSString *const FanUrlOrderList= @"FanUrlOrderList";
/*
 * 订单详情
 * index
 * params:id
 */
static NSString *const FanUrlOrderDetail= @"FanUrlOrderDetail";
/*
 * 订单预下单
 * index
 * params:id
 */
static NSString *const FanUrlOrderWill= @"FanUrlOrderWill";
/*
 * 订单下单
 * index
 * params:id
 */
static NSString *const FanUrlOrderSubmit= @"FanUrlOrderSubmit";
/*
 * 取消订单
 * index
 * params:id
 */
static NSString *const FanUrlOrderCancel= @"FanUrlOrderCancel";
/*
 * 删除订单
 * index
 * params:id
 */
static NSString *const FanUrlOrderDelete= @"FanUrlOrderDelete";
/*
 * 订单评价
 * index
 * params:id
 */
static NSString *const FanUrlOrderEvaluate= @"FanUrlOrderEvaluate";
/*
 * 订单取票
 * index
 * params:id
 */
static NSString *const FanUrlOrderTicket= @"FanUrlOrderTicket";

/*
 * 订单发起退票
 * index
 * params:id
 */
static NSString *const FanUrlOrderRefund= @"FanUrlOrderRefund";
/*
 * 提交退票
 * index
 * params:id
 */
static NSString *const FanUrlRefund= @"FanUrlRefund";

/*
 * 退票详情
 * index
 * params:id
 */
static NSString *const FanUrlRefundDetail = @"FanUrlRefundDetail";

/*
 * 取消退票
 * index
 * params:id
 */
static NSString *const FanUrlRefundCancel = @"FanUrlRefundCancel";


/*
 * 获取游客信息
 * index
 * params:id
 */
static NSString *const FanUrlTouristInfoGet = @"FanUrlTouristInfoGet";


/*
 * 添加游客信息
 * index
 * params:id
 */
static NSString *const FanUrlTouristInfoPost = @"FanUrlTouristInfoPost";

/*
 * 编辑游客信息
 * index
 * params:id
 */
static NSString *const FanUrlTouristInfoOption = @"FanUrlTouristInfoOption";

/*
 * 删除游客信息
 * index
 * params:id
 */
static NSString *const FanUrlTouristInfoDelete = @"FanUrlTouristInfoDelete";
/*
 * 获取价格日历
 * index
 * params:id
 */
static NSString *const FanUrlTicketPrice = @"FanUrlTicketPrice";

#pragma mark -- 支付

/*
 * 订单发起支付
 * index
 * params:id
 */
static NSString *const FanUrlOrderPay= @"FanUrlOrderPay";

/*
 * 提交支付
 * index
 * params:id
 */
static NSString *const FanUrlPay= @"FanUrlPay";

/*
 * 支付结果
 * index
 * params:id
 */
static NSString *const FanUrlPayResult= @"FanUrlPayResult";
