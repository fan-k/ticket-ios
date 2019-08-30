//
//  LoginController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/12.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "LoginController.h"
#import "FanTextField.h"

@interface LoginController ()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) YYLabel *descriptLb;
@property (nonatomic ,strong) FanTextField *phoneField;
@property (nonatomic ,strong) FanTextField *codeField;
@property (nonatomic ,strong) UIButton *sureButton;
@property (nonatomic ,strong) UIButton *phoneLoginButton;
@property (nonatomic ,strong) UIButton *forgetButton;


/**页面类型 默认为空，空为登录，register 为注册，setpwd 为注册后设置密码*/
@property (nonatomic ,strong) NSString *type;
@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftImage = @"nav_close";
    self.navigationLine.hidden = YES;
    self.view.backgroundColor = COLOR_PATTERN_STRING(@"_whiter_color");
    [self.view addSubview:self.titleLb];
    [self.view addSubview:self.descriptLb];
    [self.view addSubview:self.phoneField];
    [self.view addSubview:self.codeField];
    [self.view addSubview:self.sureButton];
    [self.view addSubview:self.phoneLoginButton];
    [self.view addSubview:self.forgetButton];
    
    // Do any additional setup after loading the view.
}
- (void)leftNavBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)loginByPhone{
    [self pushViewControllerWithUrl:@"PhoneCodeController?type=login" transferData:nil hander:self.customActionBlock];
}
- (void)forgetPwd{
    [self pushViewControllerWithUrl:@"PhoneCodeController?type=forgetpwd" transferData:nil hander:nil];
}
- (void)loginWithPhone:(NSString *)phone pwd:(NSString *)pwd{
    [self requestWithUrl:FanUrlUserLogin loading:YES error:FanErrorTypeTopAlert];
}
- (void)registerWithPhone:(NSString *)phone code:(NSString *)code{
    [self requestWithUrl:FanUrlUserRegister loading:YES error:FanErrorTypeTopAlert];
}
- (void)setpwdWithPhone:(NSString *)phone code:(NSString *)code{
    [self requestWithUrl:FanUrlUserSetPwd loading:YES error:FanErrorTypeTopAlert];
}
- (void)sureButtonMethod{
    //登录 先判断手机号格式
    if ([self.type isEqualToString:@"login"]) {
        if (isValidPhoneNumber(self.phoneField.text)) {
            [self loginWithPhone:self.phoneField.text pwd:self.codeField.text];
        }else{
            self.phoneField.fan_placeholderalert = @"手机号输入错误";
        }
    }else if([self.type isEqualToString:@"register"]){
        //注册
        [self registerWithPhone:self.phoneField.text code:self.codeField.text];
    }else{
        //设置密码
        if (![self.phoneField.text isEqualToString:self.codeField.text]) {
            self.codeField.fan_placeholderalert = @"两次输入密码不一致";
        }else{
            //
            [self setpwdWithPhone:self.phoneField.text code:self.codeField.text];
        }
    }
    
}
- (void)getcode{
    //先验证输入的手机号的正确性
    if ([self.phoneField.text isNotBlank]) {
        if (isValidPhoneNumber(self.phoneField.text)) {
            self.params[@"phone"] = self.phoneField.text;
            [self requestWithUrl:FanUrlUserGetCode loading:NO error:FanErrorTypeTopAlert];
        }else{
            self.phoneField.fan_placeholderalert = @"手机号输入错误";
        }
    }else{
        self.phoneField.fan_placeholderalert = @"请输入手机号";
    }
    
    
}
- (void)changeButtonStatus{
    if ([self.phoneField.text isNotBlank] && [self.codeField.text isNotBlank]) {
        [self.sureButton setBackgroundColor:COLOR_PATTERN_STRING(@"_yellow_color")];
        self.sureButton.userInteractionEnabled = YES;
    }else{
        [self.sureButton setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        self.sureButton.userInteractionEnabled = YES;
    }
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    [FanAlert alertMessage:DICTION_OBJECT(item.responseObject, @"msg") type:AlertMessageTypeNomal];
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlUserLogin]) {
        //登录成功
        UserModel *model = [UserModel modelWithJson:DICTION_OBJECT(item.responseObject, @"data")];
        if (model) {
            [UserInfo shareInstance].userModel = model;
            [UserInfo saveUserInfo];
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.customActionBlock) {
                    self.customActionBlock(nil, cat_login_success);
                }
            }];
        }else{
            [FanAlert alertMessage:@"登录失败" type:AlertMessageTypeNomal];
        }
    }else if ([item.url isEqualToString:FanUrlUserGetCode]){
        [FanAlert alertMessage:DICTION_OBJECT(item.responseObject, @"msg") type:AlertMessageTypeNomal];
        [self.codeField startTimeWithTime:60 timeColor:@"_red_color"];
    }else if ([item.url isEqualToString:FanUrlUserRegister]){
        //注册后去设置密码
        [self pushViewControllerWithUrl:[NSString stringWithFormat:@"LoginController?type=setpwd&token=%@",DICTION_OBJECT(DICTION_OBJECT(item.responseObject, @"data"), @"token")] transferData:nil hander:nil];
    }else if ([item.url isEqualToString:FanUrlUserSetPwd]){
        //注册后的设置密码
        [FanAlert alertMessage:@"注册成功" type:AlertMessageTypeNomal];
        [self leftNavBtnClick];
    }
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _titleLb.frame = CGRectMake(30, FAN_NAV_HEIGHT + 30, 60, 30);
        _titleLb.width = [self.type isEqualToString:@"setpwd"] ? 120 : 60;
        _titleLb.text = [self.type isEqualToString:@"register"] ? @"您好" : [self.type isEqualToString:@"setpwd"]?@"设置密码":@"登录";
        _titleLb.font =  FanBoldFont(30);
        UIView *line = [UIView new];
        line.frame = CGRectMake(_titleLb.left, _titleLb.bottom - 5, _titleLb.width, 8);
        line.layer.cornerRadius = 4;
        line.layer.masksToBounds = YES;
        line.backgroundColor = COLOR_PATTERN_STRING(@"_yellow_color");
        [self.view addSubview:line];
    }return _titleLb;
}
- (YYLabel *)descriptLb{
    if (!_descriptLb) {
        _descriptLb = [YYLabel new];
        _descriptLb.frame = CGRectMake(_titleLb.left, _titleLb.bottom + 15, 200, 20);
        _descriptLb.textColor = COLOR_PATTERN_STRING(@"_8c8c8c_color");
        _descriptLb.font = FanMediumFont(16);
        if (![self.type isEqualToString:@"login"]) {
            _descriptLb.text = @"欢迎注册账号";
        }else{
            NSString *text = @"还没有账号,立即注册";
            NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text];
            att.font = FanMediumFont(16);
            att.color = COLOR_PATTERN_STRING(@"_8c8c8c_color");
            [att changeStringStyleWithText:@"注册" color:COLOR_PATTERN_STRING(@"_yellow_color") font:FanMediumFont(16)];
            att = [att xieyi_changeColor:@"注册" color:@"_yellow_color"];
            _descriptLb.attributedText = att;
            __weak LoginController *weakself = self;
            _descriptLb.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                [weakself presentViewControllerWithUrl:@"LoginController?type=register" transferData:nil hander:nil];
            };
        }
    }return _descriptLb;
}
- (FanTextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [[FanTextField alloc] initWithFrame:CGRectMake(_titleLb.left, _descriptLb.bottom + 80, FAN_SCREEN_WIDTH - _titleLb.left * 2, 50)];
        _phoneField.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _phoneField.font = FanMediumFont(16);
        _phoneField.fan_placeholder_font = FanMediumFont(16);
        _phoneField.placeholdercolor = COLOR_PATTERN_STRING(@"_bfbfbf_color");
        _phoneField.lineViewNomalColor = @"_line_color";
        _phoneField.lineViewHightColor = @"_yellow_color";
        _phoneField.style_count = YES;
        _phoneField.secureTextEntry = [self.type isEqualToString:@"setpwd"];
        _phoneField.fan_placeholder = [self.type isEqualToString:@"setpwd"] ? @"请输入密码" : @"请输入手机号";
        __weak LoginController *weakSelf = self;
        _phoneField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_textfield_content_changed_nil || idx == cat_textfield_content_changed_unnil) {
                [weakSelf changeButtonStatus];
            }
        };
    }return _phoneField;
}

- (FanTextField *)codeField{
    if (!_codeField) {
        _codeField = [[FanTextField alloc] initWithFrame:CGRectMake(_titleLb.left, _phoneField.bottom + 10, FAN_SCREEN_WIDTH - _titleLb.left * 2, 50)];
        _codeField.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _codeField.font = FanMediumFont(16);
        _codeField.fan_placeholder_font = FanMediumFont(16);
        _codeField.placeholdercolor = COLOR_PATTERN_STRING(@"_bfbfbf_color");
        _codeField.lineViewNomalColor = @"_line_color";
        _codeField.lineViewHightColor = @"_yellow_color";
        _codeField.fan_placeholder = [self.type isEqualToString:@"setpwd"] ? @"请确认密码" : [self.type isEqualToString:@"register"] ? @"请输入验证码": @"请输入密码";
        _codeField.secureTextEntry = ![self.type isEqualToString:@"register"];
        if ([self.type isEqualToString:@"register"]) {
            //添加获取验证码
            _codeField.rightViewWidth = 100;
            _codeField.rightTxtColor = @"_red_color";
            _codeField.rightBtnTxt = @"获取验证码";
        }
        __weak LoginController *weakSelf = self;
        _codeField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_textfield_content_changed_nil || idx == cat_textfield_content_changed_unnil) {
                [weakSelf changeButtonStatus];
            }else if (idx == cat_textfield_right_btn){
                [weakSelf getcode];
            }
        };
    }return _codeField;
}
- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(_titleLb.left, _codeField.bottom + 35, FAN_SCREEN_WIDTH - _titleLb.left * 2, 44);
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 22;
        [_sureButton setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:UIControlStateNormal];
        [_sureButton.titleLabel setFont:FanMediumFont(17)];
        [_sureButton setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        _sureButton.userInteractionEnabled = NO;
        [_sureButton addTarget:self action:@selector(sureButtonMethod) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitle:[self.type isEqualToString:@"register"] ? @"下一步" : [self.type isEqualToString:@"setpwd"] ? @"确认提交":@"登录" forState:UIControlStateNormal];
    }return _sureButton;
}

- (UIButton *)phoneLoginButton{
    if (!_phoneLoginButton) {
        _phoneLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneLoginButton.frame = CGRectMake(_titleLb.left, _sureButton.bottom + 15, 150, 20);
        [_phoneLoginButton setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:UIControlStateNormal];
        [_phoneLoginButton.titleLabel setFont:FanRegularFont(13)];
        _phoneLoginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_phoneLoginButton addTarget:self action:@selector(loginByPhone) forControlEvents:UIControlEventTouchUpInside];
        [_phoneLoginButton setTitle:@"手机号快捷登录" forState:UIControlStateNormal];
        _phoneLoginButton.hidden = ![self.type isEqualToString:@"login"];
    }return _phoneLoginButton;
}

- (UIButton *)forgetButton{
    if (!_forgetButton) {
        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetButton.frame = CGRectMake(_phoneLoginButton.right, _sureButton.bottom + 15, _sureButton.right - _phoneLoginButton.right, 20);
        [_forgetButton setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:UIControlStateNormal];
        [_forgetButton.titleLabel setFont:FanRegularFont(13)];
        _forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_forgetButton addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchUpInside];
        [_forgetButton setTitle:@"忘记密码" forState:UIControlStateNormal];
        _forgetButton.hidden = ![self.type isEqualToString:@"login"];
    }return _forgetButton;
}

- (NSString *)type{
    if (!_type) {
        //默认login 登录
        NSString *type = DICTION_OBJECT(self.urlParams, @"type");
        if (![type isNotBlank]) {
            type = @"login";
        }
        _type = type;
    }return _type;
}
@end

