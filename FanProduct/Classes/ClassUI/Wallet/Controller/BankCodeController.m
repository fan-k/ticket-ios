//
//  BankCodeController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "BankCodeController.h"
#import "PassWordView.h"

@interface BankCodeController()
@property (nonatomic ,strong) UILabel *descLb;
@property (nonatomic ,strong) UILabel *timeLb;
@property (nonatomic ,strong) PassWordView *password;
@property (nonatomic ,strong) UILabel *problemLb;
@property (nonatomic ,strong) UIButton *button;
@end

@implementation BankCodeController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"验证短信";
    [self.view addSubview:self.descLb];
    [self.view addSubview:self.timeLb];
    [self.view addSubview:self.password];
    [self.view addSubview:self.problemLb];
    [self.view addSubview:self.button];
}
- (void)dealloc{
     self.timeLb.endTime = YES;
}
- (void)leftNavBtnClick{
    
    [FanAlert showAlertControllerWithTitle:@"是否放弃此次绑定" message:nil _cancletitle_:@"放弃" _confirmtitle_:@"继续绑定" handler1:^(UIAlertAction * _Nonnull action) {
        __block FanController *rootVc ;
        __block BOOL isBank ;
        [self.navigationController.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([NSStringFromClass([obj class]) isEqualToString:@"BankController"]) {
                isBank = YES;
                rootVc = obj;
                *stop = YES;
            }
        }];
        if (!isBank) {
            rootVc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 4];
        }
        [self.navigationController popToViewController:rootVc animated:YES];
    } handler2:nil];
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlUserBankInfoVerificate]) {
        [self.timeLb startWithTimeInterval:60];
    }else if ([item.url isEqualToString:FanUrlUserBankVerificateCode]){
        //绑定成功 返回我的银行卡列表
        [FanAlert alertMessage:@"添加成功" type:AlertMessageTypeNomal];
        [FanWallet shareInstance].walletModel.hasBank = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationWalletInfoChanged object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([FanWallet shareInstance].walletModel.setPayPwd) {
                //跳转到银行卡列表
                [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 4] animated:YES];
            }else{
                //未设置支付密码
                [self pushViewControllerWithUrl:@"BankPwdController?type=set" transferData:nil hander:nil];
            }
        });
    }
}
- (void)getCode{
    if (_timeLb.isTime) {
        return;
    }
    [self.params addEntriesFromDictionary:self.transferData];
    [self requestWithUrl:FanUrlUserBankInfoVerificate loading:NO error:FanErrorTypeTopAlert];
}
- (void)valid{
    [self.password fieldResignFirstResponder];
    //验证银行卡
    [self.params addEntriesFromDictionary:self.transferData];
    self.params[@"code"] = self.password.passwordTextField.text;
    [self requestWithUrl:FanUrlUserBankVerificateCode loading:NO error:FanErrorTypeTopAlert];
}
- (UILabel *)descLb{
    if (!_descLb) {
        _descLb = [UILabel new];
        _descLb.frame = CGRectMake(15, FAN_NAV_HEIGHT + 25, FAN_SCREEN_WIDTH - 30, 20);
        _descLb.textAlignment = NSTextAlignmentCenter;
        _descLb.font = FanFont(16);
        _descLb.textColor = COLOR_PATTERN_STRING(@"_212121_color");
        _descLb.text = [NSString stringWithFormat:@"验证码已发送至%@",DICTION_OBJECT(self.transferData, @"phone")];
    }
    return _descLb;
}
- (UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.frame = CGRectMake(15, _descLb.bottom + 5, FAN_SCREEN_WIDTH - 30, 20);
        _timeLb.textAlignment = NSTextAlignmentCenter;
        _timeLb.font = FanFont(14);
        _timeLb.textColor = COLOR_PATTERN_STRING(@"_212121_color");
        _timeLb.self_text = @"后重新获取";
        [_timeLb startWithTimeInterval:60];
        __weak BankCodeController *weakSelf = self;
        _timeLb.viewClickBlock = ^(id obj, cat_action_type idx) {
            [weakSelf getCode];
        };
    }
    return _timeLb;
}
- (PassWordView *)password{
    if (!_password) {
        UIImage *img = [UIImage imageNamed:@"kuang"];
        _password = [[PassWordView alloc] initWithFrame:CGRectMake(_descLb.left, _timeLb.bottom + 15, _descLb.width, [img getImageHeightWithWidth:_descLb.width])];
        __weak BankCodeController *weakSelf = self;
        _password.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx ==cat_input_password_start) {
                [weakSelf.button setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
                weakSelf.button.userInteractionEnabled = NO;
            }else if (idx ==cat_input_password) {
                [weakSelf.button setBackgroundColor:COLOR_PATTERN_STRING(@"_yellow_color")];
                weakSelf.button.userInteractionEnabled = YES;
            }
        };
        [_password fieldBecomeFirstResponder];
    }return _password;
}
- (UILabel *)problemLb{
    if (!_problemLb) {
        _problemLb = [UILabel new];
        _problemLb.frame = CGRectMake(15, _password.bottom + 5, FAN_SCREEN_WIDTH - 30, 20);
        _problemLb.textAlignment = NSTextAlignmentCenter;
        _problemLb.font = FanFont(14);
        _problemLb.textColor = COLOR_PATTERN_STRING(@"_red_color");
        _problemLb.text = @"收不到验证码吗？";
        _problemLb.viewClickBlock = ^(id obj, cat_action_type idx) {
            [FanAlert showAlertControllerWithTitle:@"收不到验证码" message:@"1:请检查输入手机号是否正确\n2:请检查手机通讯状态\n3:请检查网络连接~" _cancletitle_:@"确定" _confirmtitle_:nil handler1:nil handler2:nil];
        };
    }return _problemLb;
}
- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(15, _password.bottom + 70 , FAN_SCREEN_WIDTH - 30, 44);
        [_button setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        [_button  setTitle:@"下一步" forState:UIControlStateNormal];
        [_button setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:UIControlStateNormal];
        [_button.titleLabel setFont:FanFont(17)];
        _button.layer.cornerRadius = 3;
        _button.layer.masksToBounds = YES;
        [_button addTarget:self action:@selector(valid) forControlEvents:UIControlEventTouchUpInside];
        _button.userInteractionEnabled = NO;
    }return _button;
}
@end
