//
//  VerificateInfoController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "VerificateInfoController.h"

#import "FanTextField.h"
@interface VerificateInfoController ()

@property (nonatomic ,strong) FanImageView *cardImg;
@property (nonatomic ,strong) UILabel *cardLb;
@property (nonatomic ,strong) FanImageView *codeImg;
@property (nonatomic ,strong) UILabel *codeLb;
@property (nonatomic ,strong) UILabel *lineLb;

@property (nonatomic ,strong) FanTextField *cardField;
@property (nonatomic ,strong) FanTextField *phoneField;
@property (nonatomic ,strong) FanTextField *codeField;

@property (nonatomic ,strong) UIButton *button;

@property (nonatomic ,copy) NSString *type;


@end

@implementation VerificateInfoController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"信息验证";
    //type = card 验证身份证 请求验证身份证接口 跳转 BankVerificateController type=code
    //type = code 验证短信验证码 请求验证短信接口  跳转BankPwdController  type=forget
    self.type = DICTION_OBJECT(self.urlParams, @"type");
    [self.view addSubview:self.cardImg];
    [self.view addSubview:self.cardLb];
    [self.view addSubview:self.codeImg];
    [self.view addSubview:self.codeLb];
    [self.view addSubview:self.lineLb];
    
    if ([self.type isEqualToString:@"card"]) {
        [self.view addSubview:self.cardField];
    }else{
        [self.view addSubview:self.phoneField];
        [self.view addSubview:self.codeField];
    }
    [self.view addSubview:self.button];
}
- (void)getCode{
    //验证手机号
    if ([self.phoneField.text isNotBlank]) {
        if (isValidPhoneNumber(self.phoneField.text)) {
            self.params[@"phone"] = self.phoneField.text;
            self.params[@"token"] = [UserInfo shareInstance].userModel.token;
            [self requestWithUrl:FanUrlUserGetCode loading:NO error:FanErrorTypeTopAlert];
        }else{
            self.phoneField.fan_placeholderalert = @"手机格式错误";
        }
    }else{
        self.phoneField.fan_placeholderalert = @"请输入手机号";
    }
    
}
- (void)valid{
    //
    if ([self.type isEqualToString:@"card"] ) {
        //验证身份证
        self.params[@"card"] = self.cardField.text;
        self.params[@"token"] = [UserInfo shareInstance].userModel.token;
        [self requestWithUrl:FanUrlUserBankVerificateCard loading:NO error:FanErrorTypeTopAlert];
       
    }else{
        //验证短信
        self.params[@"phone"] = self.phoneField.text;
        self.params[@"code"] = self.codeLb.text;
        self.params[@"token"] = [UserInfo shareInstance].userModel.token;
        [self requestWithUrl:FanUrlUserVerificateCode loading:NO error:FanErrorTypeTopAlert];
    }
}
- (void)handelFailureRequest:(FanRequestItem *)item{
   
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlUserBankVerificateCard]) {
        //验证身份证通过 进入一下不
        [self pushViewControllerWithUrl:[NSString stringWithFormat:@"VerificateInfoController?type=code&card=%@",DICTION_OBJECT(item.params, @"card")] transferData:nil hander:nil];
    }else if ([item.url isEqualToString:FanUrlUserVerificateCode]){
        //进入设置密码
        [FanAlert alertMessage:@"信息验证成功" type:AlertMessageTypeNomal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pushViewControllerWithUrl:@"BankPwdController?type=forget" transferData:nil hander:nil];
        });
    }else if ([item.url isEqualToString:FanUrlUserGetCode]){
        //开始倒计时
        [self.phoneField startTimeWithTime:60 timeColor:@"_red_color"];
        [FanAlert alertMessage:@"验证码已发送" type:AlertMessageTypeNomal];
    }
}

- (FanImageView *)cardImg{
    if (!_cardImg) {
        _cardImg = [FanImageView new];
        _cardImg.image = IMAGE_WITH_NAME(@"bank_v_card");
        _cardImg.left = FAN_SCREEN_WIDTH/4 - 22;
        _cardImg.centerY = FAN_NAV_HEIGHT  + 65;
        _cardImg.height = _cardImg.width =  44;
    }return _cardImg;
}
- (UILabel *)cardLb{
    if (!_cardLb) {
        _cardLb = [UILabel new];
        _cardLb .font = FanFont(15);
        _cardLb.text = @"身份证验证";
        _cardLb.textAlignment = NSTextAlignmentCenter;
        _cardLb.frame = CGRectMake(0, _cardImg.bottom + 10, FAN_SCREEN_WIDTH/2, 20);
        _cardLb.textColor = COLOR_PATTERN_STRING(@"_737373_color");
    }return _cardLb;
}

- (FanImageView *)codeImg{
    if (!_codeImg) {
        _codeImg = [FanImageView new];
        _codeImg.image =  [self.type isEqualToString:@"card"] ? IMAGE_WITH_NAME(@"bank_v_sms_0") :IMAGE_WITH_NAME(@"bank_v_sms_1");
        _codeImg.left = FAN_SCREEN_WIDTH/4 * 3 - 22;
        _codeImg.centerY = FAN_NAV_HEIGHT  + 65;
        _codeImg.height = _codeImg.width =  44;
    }return _codeImg;
}
- (UILabel *)codeLb{
    if (!_codeLb) {
        _codeLb = [UILabel new];
        _codeLb .font = FanFont(16);
        _codeLb.text = @"短信验证";
        _codeLb.textAlignment = NSTextAlignmentCenter;
        _codeLb.frame = CGRectMake(FAN_SCREEN_WIDTH/2, _codeImg.bottom + 10, FAN_SCREEN_WIDTH/2, 20);
        _codeLb.textColor = COLOR_PATTERN_STRING(@"_737373_color");
    }return _codeLb;
}
- (UILabel *)lineLb{
    if (!_lineLb) {
        _lineLb = [UILabel new];
        _lineLb.backgroundColor = COLOR_PATTERN_STRING(@"_text_ploacher_color");
        _lineLb.frame = CGRectMake(_cardImg.right  + 10, _cardImg.centerY , _codeImg.left - 20 - _cardImg.right, 1);
    }return _lineLb;
}

- (FanTextField *)cardField{
    if (!_cardField) {
        _cardField = [[FanTextField alloc] initWithFrame:CGRectMake(0, _cardLb.bottom + 40, FAN_SCREEN_WIDTH, 50)];
        _cardField.backgroundColor = [UIColor whiteColor];
        _cardField.fan_placeholder = @"请输入身份证号码";
        _cardField.leftViewWidth = FAN_SCREEN_WIDTH/4;
        _cardField.leftLbTxt = @"身份证号";
        __weak VerificateInfoController *weakself = self;
        _cardField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx ==cat_textfield_content_changed_nil) {
                [weakself.button setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
                weakself.button.userInteractionEnabled = NO;
            }else if (idx ==cat_textfield_content_changed_unnil) {
                [weakself.button setBackgroundColor:COLOR_PATTERN_STRING(@"_yellow_color")];
                weakself.button.userInteractionEnabled = YES;
            }
        };
    }return _cardField;
}
- (FanTextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [[FanTextField alloc] initWithFrame:CGRectMake(0, _cardLb.bottom + 40, FAN_SCREEN_WIDTH, 50)];
        _phoneField.backgroundColor = [UIColor whiteColor];
        _phoneField.fan_placeholder = @"请输入手机号";
        _phoneField.leftViewWidth = FAN_SCREEN_WIDTH/4;
        _phoneField.leftLbTxt = @"手机号";
        _phoneField.rightTxtColor = @"_red_color";
        _phoneField.rightViewWidth = FAN_SCREEN_WIDTH/4;
        _phoneField.rightBtnTxt = @"获取验证码";
        __weak VerificateInfoController *weakSelf = self;
        _phoneField.customActionBlock = ^(id  _Nonnull obj, int idx) {
            if (idx == cat_textfield_right_btn) {
                //获取验证码
                [weakSelf getCode];
            }
        };
    }return _phoneField;
}

- (FanTextField *)codeField{
    if (!_codeField) {
        _codeField = [[FanTextField alloc] initWithFrame:CGRectMake(0, _phoneField.bottom, FAN_SCREEN_WIDTH, 50)];
        _codeField.backgroundColor = [UIColor whiteColor];
        _codeField.fan_placeholder = @"请输入验证码";
        _codeField.leftViewWidth = FAN_SCREEN_WIDTH/4;
        _codeField.leftLbTxt = @"验证码";
        __weak VerificateInfoController *weakself = self;
        _codeField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx ==cat_textfield_content_changed_nil) {
                [weakself.button setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
                weakself.button.userInteractionEnabled = NO;
            }else if (idx ==cat_textfield_content_changed_unnil) {
                [weakself.button setBackgroundColor:COLOR_PATTERN_STRING(@"_yellow_color")];
                weakself.button.userInteractionEnabled = YES;
            }
        };
    }return _codeField;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat top = [self.type isEqualToString:@"card"] ? self.cardField.bottom + 40 : self.codeField.bottom + 40;
        _button.frame = CGRectMake(15, top , FAN_SCREEN_WIDTH - 30, 44);
        [_button setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        [_button  setTitle:@"验证信息" forState:UIControlStateNormal];
        [_button setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:UIControlStateNormal];
        [_button.titleLabel setFont:FanFont(17)];
        _button.layer.cornerRadius = 3;
        _button.layer.masksToBounds = YES;
        _button.userInteractionEnabled = NO;
        [_button addTarget:self action:@selector(valid) forControlEvents:UIControlEventTouchUpInside];
    }return _button;
}
@end
