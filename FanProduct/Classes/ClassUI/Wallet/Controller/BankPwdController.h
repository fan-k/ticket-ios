//
//  BankPwdController.h
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanController.h"

NS_ASSUME_NONNULL_BEGIN



@interface BankPwdController : FanController

/*
 * t ype = set   设置支付密码  返回上级
 *  type = set_sure 确认支付密码  返回设置密码的上级页面
 *  type = forget   找回密码的设置密码 返回上级
 *  type = forget_sure   找回密码的确认密码  返回paysetcontroller
 *  type = reset   修改密码    返回上级
 *  type = reset_set   修改密码-设置密码    返回上级
 *  type = reset_set_sure   修改密码-确认密码    返回上级paysetcontroller
 */


@end

NS_ASSUME_NONNULL_END
