//
//  FanCodeDefine.h
//  FanProduct
//
//  Created by 99epay on 2019/6/26.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#ifndef FanCodeDefine_h
#define FanCodeDefine_h



#pragma mark-- error code
static NSString *const code_2002  = @"2002";    //支付失败 余额不足
static NSString *const code_112   = @"112";     //网络错误
static NSString *const code_2001  = @"2001";    //支付密码错误



static NSString *const code_110   = @"110";     //请求频繁
static NSString *const code_1001  = @"1001";    //jwt解密错误
static NSString *const code_1002  = @"1002";    //缺少参数
static NSString *const code_1004  = @"1004";    //验证码错误
static NSString *const code_1005  = @"1005";    //验证码过期
static NSString *const code_1006  = @"1006";    //token生成错误
static NSString *const code_1007  = @"1007";    //手机号不存在
static NSString *const code_1008  = @"1008";    //手机号已存在
static NSString *const code_1009  = @"1009";    //token不存在
static NSString *const code_1010  = @"1010";    //token失效 请登录
static NSString *const code_1011  = @"1011";    //参数错误
static NSString *const code_1012  = @"1012";    //登录错误，手机号不存在或密码错误
static NSString *const code_2010  = @"2010";    //还未设置支付密码,请先设置
static NSString *const code_2016  = @"2016";    //支持密码被锁定
static NSString *const code_2020  = @"2020";    //您有正在处理中的订单，请稍后再试


#endif /* FanCodeDefine_h */
