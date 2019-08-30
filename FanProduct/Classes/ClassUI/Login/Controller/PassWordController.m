//
//  PassWordController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "PassWordController.h"
#import "FanTextField.h"

@interface PassWordController ()
@property (nonatomic ,strong) FanTextField *inputPwdField;
@property (nonatomic ,strong) FanTextField *surePwdField;
@property (nonatomic ,strong) UIButton *sureButton;
@end

@implementation PassWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = [DICTION_OBJECT(self.urlParams, @"type")  isEqualToString:@"resetpwd"] ? @"修改密码":@"设置密码";
    
    [self.view addSubview:self.inputPwdField];
    [self.view addSubview:self.surePwdField];
    [self.view addSubview:self.sureButton];
    
    // 设置密码页面逻辑
    //1 根据上级页面类型：找回密码、修改密码 ，上级页面传递参数type/token
    //2  设置成功后的跳转  找回密码跳转回登录页面 ，左侧按钮d返回返回上级 修改密码 回到上级
    
    // Do any additional setup after loading the view.
}
- (void)resetpwd{
    self.params[@"oldpwd"] = self.inputPwdField.text;
    self.params[@"newpwd"] = self.surePwdField.text;
    self.params[@"token"] = DICTION_OBJECT(self.urlParams, @"token");
     [self requestWithUrl:FanUrlUserResetPwd loading:YES];
}
- (void)setpwd{
    if ([self.inputPwdField.text isEqualToString:self.surePwdField.text]) {
        self.params[@"newpwd"] = self.surePwdField.text;
        self.params[@"token"] = DICTION_OBJECT(self.urlParams, @"token");
        [self requestWithUrl:FanUrlUserSetPwd loading:YES];
    }else{
        self.surePwdField.fan_placeholderalert = @"两次密码输入不一致";
    }
}
- (void)changeSureButtonStatus{
    if ([self.inputPwdField.text isNotBlank] && [self.surePwdField.text isNotBlank]) {
        [self.sureButton setBackgroundColor:COLOR_PATTERN_STRING(@"_yellow_color")];
        self.sureButton.userInteractionEnabled = YES;
    }else{
        [self.sureButton setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        self.sureButton.userInteractionEnabled = YES;
    }
}
- (void)sureButtonMethod{
    [DICTION_OBJECT(self.urlParams, @"type")  isEqualToString:@"resetpwd"]?[self resetpwd] :[self setpwd];
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    [FanAlert alertMessage:DICTION_OBJECT(item.responseObject, @"msg") type:AlertMessageTypeNomal];
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
     [FanAlert alertMessage:DICTION_OBJECT(item.responseObject, @"msg") type:AlertMessageTypeNomal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [DICTION_OBJECT(self.urlParams, @"type")  isEqualToString:@"resetpwd"] ? [self leftNavBtnClick] : [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (FanTextField *)inputPwdField{
    if (!_inputPwdField) {
        _inputPwdField = [[FanTextField alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT + 46, FAN_SCREEN_WIDTH, 50)];
        _inputPwdField.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _inputPwdField.backgroundColor = COLOR_PATTERN_STRING(@"_whiter_color");
        _inputPwdField.font = FanRegularFont(17);
        _inputPwdField.lineViewNomalColor = @"_line_color";
        _inputPwdField.lineViewHightColor = @"_yellow_color";
        _inputPwdField.fan_placeholder_font = FanMediumFont(15);
        _inputPwdField.placeholdercolor = COLOR_PATTERN_STRING(@"_bfbfbf_color");
        _inputPwdField.fan_placeholder = [DICTION_OBJECT(self.urlParams, @"type")  isEqualToString:@"resetpwd"]  ? @"请输入原密码" :@"请输入新密码";
        _inputPwdField.leftViewWidth = 100;
        _inputPwdField.leftLbTxt = [DICTION_OBJECT(self.urlParams, @"type")  isEqualToString:@"resetpwd"]  ? @"原密码" :@"新密码";
        _inputPwdField.leftTxtFont = 15;
        _inputPwdField.leftTxtColor = @"_333333_color";
        _inputPwdField.secureTextEntry = YES;
        __weak PassWordController *weakSelf = self;
        _inputPwdField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_textfield_content_changed_nil || idx == cat_textfield_content_changed_unnil) {
                [weakSelf changeSureButtonStatus];
            }
        };
    }return _inputPwdField;
}

- (FanTextField *)surePwdField{
    if (!_surePwdField) {
        _surePwdField = [[FanTextField alloc] initWithFrame:CGRectMake(0,_inputPwdField.bottom, FAN_SCREEN_WIDTH, 50)];
        _surePwdField.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _surePwdField.backgroundColor = COLOR_PATTERN_STRING(@"_whiter_color");
        _surePwdField.font = FanRegularFont(17);
        _surePwdField.lineViewNomalColor = @"_line_color";
        _surePwdField.lineViewHightColor = @"_yellow_color";
        _surePwdField.fan_placeholder_font = FanMediumFont(15);
        _surePwdField.placeholdercolor = COLOR_PATTERN_STRING(@"_bfbfbf_color");
        _surePwdField.fan_placeholder = [DICTION_OBJECT(self.urlParams, @"type")  isEqualToString:@"resetpwd"]  ? @"请输入新密码" :@"请确认密码";
        _surePwdField.leftViewWidth = 100;
        _surePwdField.leftLbTxt = [DICTION_OBJECT(self.urlParams, @"type")  isEqualToString:@"resetpwd"]  ? @"新密码" :@"确认密码";
        _surePwdField.leftTxtFont = 15;
        _surePwdField.secureTextEntry = YES;
        _surePwdField.leftTxtColor = @"_333333_color";
        __weak PassWordController *weakSelf = self;
        _surePwdField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_textfield_content_changed_nil || idx == cat_textfield_content_changed_unnil) {
                [weakSelf changeSureButtonStatus];
            }
        };
    }return _surePwdField;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(15, _surePwdField.bottom + 60, FAN_SCREEN_WIDTH - 30, 44);
        _sureButton.layer.masksToBounds = YES;
        _sureButton.layer.cornerRadius = 4;
        [_sureButton setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:UIControlStateNormal];
        [_sureButton.titleLabel setFont:FanMediumFont(17)];
        [_sureButton setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        _sureButton.userInteractionEnabled = NO;
        [_sureButton addTarget:self action:@selector(sureButtonMethod) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton setTitle:@"提交" forState:UIControlStateNormal];
    }return _sureButton;
}

@end
