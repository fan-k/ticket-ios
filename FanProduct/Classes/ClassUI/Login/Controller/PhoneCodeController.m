//
//  PhoneCodeController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "PhoneCodeController.h"
#import "FanTextField.h"
#import "PassWordView.h"

@interface PhoneCodeController ()

@property (nonatomic ,strong) FanTextField *phoneField;
@property (nonatomic ,strong) UIButton *sureButton;

@property (nonatomic ,strong) UILabel *descLb;
@property (nonatomic ,strong) UILabel *timeLb;
@property (nonatomic ,strong) PassWordView *password;
@property (nonatomic ,strong) UILabel *problemLb;
@property (nonatomic ,strong) UIButton *button;




/**页面类型*/
@property (nonatomic ,strong) NSString *type;
@end

@implementation PhoneCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = [self.type hasPrefix:@"login"]  ? @"手机号快捷登录" :  @"找回密码";
    if ([self.type isEqualToString:@"login"] || [self.type isEqualToString:@"forgetpwd"]) {
        [self.view addSubview:self.phoneField];
        [self.view addSubview:self.sureButton];
    }else{
        //验证验证码
        [self.view addSubview:self.descLb];
        [self.view addSubview:self.timeLb];
        [self.view addSubview:self.password];
        [self.view addSubview:self.problemLb];
        [self.view addSubview:self.button];
    }
 
    
    // Do any additional setup after loading the view.
}
- (void)nextEvent:(FanRequestItem *)item{
    //根据type 判断下一步操作
    NSString *type = DICTION_OBJECT(self.urlParams, @"type");
//  登录或找回密码 都前往验证验证码 页面
    if ([type isEqualToString:@"login"]) {
        [self pushViewControllerWithUrl:[NSString stringWithFormat:@"PhoneCodeController?type=login_code&phone=%@",self.phoneField.text] transferData:nil hander:nil];
    }else if([type isEqualToString:@"forgetpwd"]){
        [self pushViewControllerWithUrl:[NSString stringWithFormat:@"PhoneCodeController?type=forgetpwd_code&phone=%@",self.phoneField.text] transferData:nil hander:nil];
    }else if([type isEqualToString:@"login_code"]){//登录成功 保存信息
        UserModel *model = [UserModel modelWithJson:DICTION_OBJECT(item.responseObject, @"data")];
        if (model) {
            [UserInfo shareInstance].userModel = model;
            [UserInfo saveUserInfo];
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.customActionBlock) {
                    self.customActionBlock(self, cat_login_success);
                }
            }];
        }
    }else if([type isEqualToString:@"forgetpwd_code"]){
        [self pushViewControllerWithUrl:[NSString stringWithFormat:@"PassWordController?type=forgetpwd_code&token=%@",DICTION_OBJECT(DICTION_OBJECT(item.responseObject, @"data"), @"token")] transferData:nil hander:nil];
    }
}
- (void)changeSureButtonStatus{
    if ([self.phoneField.text isNotBlank]) {
        [self.sureButton setBackgroundColor:COLOR_PATTERN_STRING(@"_yellow_color")];
        self.sureButton.userInteractionEnabled = YES;
    }else{
        [self.sureButton setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        self.sureButton.userInteractionEnabled = YES;
    }
}
- (void)getCodeWithPhone:(NSString *)phone{
    self.params[@"phone"] = phone;
    self.params[@"type"] = self.type;
    [self requestWithUrl:FanUrlUserGetCode loading:NO];
}
- (void)sureButtonMethod{
    if (isValidPhoneNumber(self.phoneField.text)) {
        [self getCodeWithPhone:self.phoneField.text];
    }else{
        self.phoneField.fan_placeholderalert = @"手机号输入错误";
    }
}
- (void)getCode{
    if (_timeLb.isTime) {
        return;
    }
    [self getCodeWithPhone:DICTION_OBJECT(self.urlParams, @"phone")];
}
- (void)valid{
    [self.password fieldResignFirstResponder];
    self.params[@"phone"] = DICTION_OBJECT(self.urlParams, @"phone");
    self.params[@"code"] = self.password.passwordTextField.text;
    [self requestWithUrl:FanUrlUserVerificateCode loading:NO error:FanErrorTypeTopAlert];
}

- (void)handelFailureRequest:(FanRequestItem *)item{
    [FanAlert alertMessage:DICTION_OBJECT(item.responseObject, @"msg") type:AlertMessageTypeNomal];
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlUserGetCode]) {
        if ([self.type isEqualToString:@"login"] ||[self.type isEqualToString:@"forgetpwd"] ) {
             [self nextEvent:item];
        }else if ([self.type isEqualToString:@"login_code"] || [self.type isEqualToString:@"forgetpwd_code"] ) {
            [_timeLb startWithTimeInterval:60];
        }
    }else if ([item.url isEqualToString:FanUrlUserVerificateCode]) {
        if ([self.type isEqualToString:@"login_code"]) {
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
        }else if ([self.type isEqualToString:@"forgetpwd_code"]){
            //验证成功去设置密码
            [self pushViewControllerWithUrl:[NSString stringWithFormat:@"PassWordController?type=forget&token=%@",DICTION_OBJECT(DICTION_OBJECT(item.responseObject, @"data"), @"token")] transferData:nil hander:nil];
        }
    }
}


- (FanTextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [[FanTextField alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT + 46, FAN_SCREEN_WIDTH, 50)];
        _phoneField.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _phoneField.backgroundColor = COLOR_PATTERN_STRING(@"_whiter_color");
        _phoneField.font = FanRegularFont(17);
        _phoneField.fan_placeholder_font = FanMediumFont(15);
        _phoneField.placeholdercolor = COLOR_PATTERN_STRING(@"_bfbfbf_color");
        _phoneField.fan_placeholder = @"请输入手机号";
        _phoneField.leftViewWidth = 80;
        _phoneField.leftLbTxt = @"手机号";
        _phoneField.leftTxtFont = 15;
        _phoneField.style_count = YES;
        _phoneField.leftTxtColor = @"_333333_color";
        __weak PhoneCodeController *weakSelf = self;
        _phoneField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_textfield_content_changed_nil || idx == cat_textfield_content_changed_unnil) {
                [weakSelf changeSureButtonStatus];
            }
        };
    }return _phoneField;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(15, _phoneField.bottom + 60, FAN_SCREEN_WIDTH - 30, 44);
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 4;
        [_sureButton setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:UIControlStateNormal];
        [_sureButton.titleLabel setFont:FanMediumFont(17)];
        [_sureButton setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        _sureButton.userInteractionEnabled = NO;
        [_sureButton addTarget:self action:@selector(sureButtonMethod) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitle:@"下一步" forState:UIControlStateNormal];
    }return _sureButton;
}
- (UILabel *)descLb{
    if (!_descLb) {
        _descLb = [UILabel new];
        _descLb.frame = CGRectMake(15, FAN_NAV_HEIGHT + 40, FAN_SCREEN_WIDTH - 30, 20);
        _descLb.font = FanRegularFont(15);
        _descLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _descLb.text = [NSString stringWithFormat:@"验证码已发送至%@",DICTION_OBJECT(self.urlParams, @"phone")];
    }
    return _descLb;
}
- (UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.frame = CGRectMake(15, _descLb.bottom + 15, FAN_SCREEN_WIDTH - 30, 20);
        _timeLb.font = FanRegularFont(13);
        _timeLb.textColor = COLOR_PATTERN_STRING(@"_8c8c8c_color");
        _timeLb.self_text = @"重新获取";
        [_timeLb startWithTimeInterval:60];
        __weak PhoneCodeController *weakSelf = self;
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
        __weak PhoneCodeController *weakSelf = self;
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
        _problemLb.frame = CGRectMake(15, _password.bottom + 45, FAN_SCREEN_WIDTH - 30, 20);
        _problemLb.textAlignment = NSTextAlignmentCenter;
        _problemLb.font = FanRegularFont(13);
        _problemLb.textColor = COLOR_PATTERN_STRING(@"_red_color");
        _problemLb.text = @"收不到验证码吗？";
        _problemLb.viewClickBlock = ^(id obj, cat_action_type idx) {
            [FanAlert showAlertControllerWithTitle:@"收不到验证码" message:@"1:请检查输入手机号是否正确\n2:请检查手机通讯状态\n 3:请检查网络连接~" _cancletitle_:@"确定" _confirmtitle_:nil handler1:nil handler2:nil];
        };
    }return _problemLb;
}
- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(15, _problemLb.bottom + 45 , FAN_SCREEN_WIDTH - 30, 44);
        [_button setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        [_button  setTitle:[self.type isEqualToString:@"login_code"]? @"快捷登录" :@"找回密码" forState:UIControlStateNormal];
        [_button.titleLabel setFont:FanRegularFont(17)];
        [_button setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:UIControlStateNormal];
        _button.layer.cornerRadius = 4;
        _button.layer.masksToBounds = YES;
        [_button addTarget:self action:@selector(valid) forControlEvents:UIControlEventTouchUpInside];
        _button.userInteractionEnabled = NO;
    }return _button;
}

- (NSString *)type{
    if (!_type) {
        _type = DICTION_OBJECT(self.urlParams, @"type");
    }return _type;
}
@end
