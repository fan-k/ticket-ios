//
//  BankPwdController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "BankPwdController.h"
#import "PassWordView.h"

@interface BankPwdController()
@property (nonatomic ,strong) UILabel *descLb;
@property (nonatomic ,strong) PassWordView *password;
@end

@implementation BankPwdController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    
    NSString *type = DICTION_OBJECT(self.urlParams, @"type");
    if ([type isEqualToString:@"reset"]) {
        self.navTitle = @"修改支付密码";
    }else if ([type isEqualToString:@"set_sure"]) {
        self.navTitle = @"确定支付密码";
    }else if ([type isEqualToString:@"reset_set_sure"] || [type isEqualToString:@"forget_sure"] || [type isEqualToString:@"forget"] || [type isEqualToString:@"reset_set"]) {
        self.navTitle = @"新支付密码";
    }else{
        self.navTitle  =@"设置支付密码";
    }
    [self.view addSubview:self.descLb];
    [self.view addSubview:self.password];

}
/**验证原密码*/
- (void)ResetPwdVerificate:(NSString *)old{
    self.params[@"oldpwd"] = old;
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    [self requestWithUrl:FanUrlUserBankResetPwdVerificate loading:NO error:FanErrorTypeTopAlert];
}
/**提交新密码*/
- (void)pushNewPwd:(NSString *)old{
    //先本地验证两次密码的一致性
    NSString *oldpwd = DICTION_OBJECT(self.urlParams, @"pwd");
    if ([old isEqualToString:oldpwd]) {
        //提交
        self.params[@"newpwd"] = old;
        self.params[@"token"] = [UserInfo shareInstance].userModel.token;
        [self requestWithUrl:FanUrlUserBankSetPwd loading:NO error:FanErrorTypeTopAlert];
    }else{
        //密码不一致
        [FanAlert alertErrorWithMessage:@"两次输入密码不一致"];
    }
}

- (void)nextactionWithPwd:(NSString *)pwd{
    NSString *type = DICTION_OBJECT(self.urlParams, @"type");
    //修改密码 type = reset 验证原密码
    if ([type isEqualToString:@"reset"]) {
        [self ResetPwdVerificate:pwd];
    }else if ([type isEqualToString:@"reset_set"]){
        //修改密码 输入新密码 type = reset_set  跳转到确认密码
        [self pushViewControllerWithUrl:[NSString stringWithFormat:@"BankPwdController?type=reset_set_sure&pwd=%@",pwd] transferData:nil hander:nil];

    }else if ([type isEqualToString:@"reset_set_sure"]){
        //修改密码 验证新密码 type = reset_set_sure  提交密码 设置新密码
        [self pushNewPwd:pwd];
    }else if ([type isEqualToString:@"forget"]){
        //找回密码 输入新密码 type = forget  跳转到确认密码
        [self pushViewControllerWithUrl:[NSString stringWithFormat:@"BankPwdController?type=forget_sure&pwd=%@",pwd] transferData:nil hander:nil];
        
    }else if ([type isEqualToString:@"forget_sure"]){
        //找回密码 验证新密码 type = forget_sure  提交密码 设置新密码
        [self pushNewPwd:pwd];
    }else if ([type isEqualToString:@"set"]){
        //第一次设置密码 type = set  跳转到确认密码
        [self pushViewControllerWithUrl:[NSString stringWithFormat:@"BankPwdController?type=set_sure&pwd=%@",pwd] transferData:nil hander:nil];
        
    }else if ([type isEqualToString:@"set_sure"]){
        //第一次设置密码  验证新密码 type = set_sure  提交密码 设置新密码
        [self pushNewPwd:pwd];
    }
}

- (void)handelFailureRequest:(FanRequestItem *)item{
    
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlUserBankResetPwdVerificate]) {
        [self pushViewControllerWithUrl:@"BankPwdController?type=reset_set" transferData:nil hander:nil];
    }else if ([item.url isEqualToString:FanUrlUserBankSetPwd]){
        //密码设置成功 更新钱包配置
        //回跳页面 如果是第一次设置密码 回跳到钱包首页 或订单支付
        //如果是修改密码或找回密码 跳转到钱包首页
        
        [_password fieldResignFirstResponder];
        [FanAlert alertMessage:@"设置密码成功" type:AlertMessageTypeNomal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __block FanController *rootVc ;
            __block BOOL isWallet ;
            __block BOOL isBank;
            [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([NSStringFromClass([obj class]) isEqualToString:@"WalletController"]) {
                    isWallet = YES;
                    rootVc = obj;
                    *stop = YES;
                }
                if ([NSStringFromClass([obj class]) isEqualToString:@"BankController"]) {
                    isBank = YES;
                    rootVc = obj;
                    *stop = YES;
                }
            }];
            if (isWallet || isBank) {
                [self.navigationController popToViewController:rootVc animated:YES];
            }else{
               [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
            }
        });
    }
}

- (UILabel *)descLb{
    if (!_descLb) {
        _descLb = [UILabel new];
        _descLb.frame = CGRectMake(15, FAN_NAV_HEIGHT + 60, FAN_SCREEN_WIDTH - 30, 20);
        _descLb.textAlignment = NSTextAlignmentCenter;
        _descLb.font = FanFont(15);
        _descLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        NSString *type = DICTION_OBJECT(self.urlParams, @"type");
        if ([type isEqualToString:@"reset"]) {
            _descLb.text = @"请输入原支付密码";
        }else if ([type isEqualToString:@"set_sure"] || [type isEqualToString:@"reset_set_sure"] || [type isEqualToString:@"forget_sure"]) {
            _descLb.text = @"请确认支付密码";
        }else if ([type isEqualToString:@"forget"] || [type isEqualToString:@"reset_set"]) {
            _descLb.text = @"请输入新支付密码";
        }else{
            _descLb.text = @"请输入支付密码";
        }
    }
    return _descLb;
}
- (PassWordView *)password{
    if (!_password) {
        UIImage *img = [UIImage imageNamed:@"kuang"];
        _password = [[PassWordView alloc] initWithFrame:CGRectMake(_descLb.left, _descLb.bottom + 15, _descLb.width, [img getImageHeightWithWidth:_descLb.width])];
        _password.secureTextEntry = YES;
        __weak BankPwdController *weakSelf = self;
        _password.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_input_password) {
                [weakSelf nextactionWithPwd:obj];
            }
        };
        [_password fieldBecomeFirstResponder];
    }return _password;
}
@end
