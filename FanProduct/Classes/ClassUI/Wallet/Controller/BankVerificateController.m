//
//  BankVerificateController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "BankVerificateController.h"
#import "FanTextField.h"

@interface BankVerificateController ()
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) FanImageView *bankImg;
@property (nonatomic ,strong) UILabel *bankLb;
@property (nonatomic ,strong) UILabel *cardLb;
@property (nonatomic ,strong) FanImageView *alertBgLb;
@property (nonatomic ,strong) UILabel *alertLb;
@property (nonatomic ,strong) FanTextField *nameField;
@property (nonatomic ,strong) FanTextField *cardField;
@property (nonatomic ,strong) FanTextField *phoneField;

@property (nonatomic ,strong) UIButton *selectbutton;
@property (nonatomic ,strong) YYLabel *agreementLb;

@property (nonatomic ,strong) UIButton *button;
@end
@implementation BankVerificateController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"信息验证";
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.bankImg];
    [self.view addSubview:self.bankLb];
    [self.view addSubview:self.cardLb];
    [self.view addSubview:self.alertBgLb];
    [self.view addSubview:self.nameField];
    [self.view addSubview:self.cardField];
    [self.view addSubview:self.phoneField];
    [self.view addSubview:self.selectbutton];
    [self.view addSubview:self.agreementLb];
    [self.view addSubview:self.button];
}
- (void)valid{
    self.params[@"bank"] = DICTION_OBJECT(self.urlParams, @"bank");
    self.params[@"card"] = DICTION_OBJECT(self.urlParams, @"card");
    self.params[@"name"] = self.nameField.text;
    self.params[@"idcard"] = self.cardField.text;
    self.params[@"phone"] = self.phoneField.text;
    [self requestWithUrl:FanUrlUserBankInfoVerificate loading:NO error:FanErrorTypeTopAlert];
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    [self pushViewControllerWithUrl:@"BankCodeController" transferData:item.params hander:nil];
}
- (void)selectbuttonMethod{
    self.selectbutton.selected = !self.selectbutton.selected;
    [self buttonstatus];
}
- (void)buttonstatus{
    if ([_nameField.text isNotBlank] && [_cardField.text isNotBlank] && [_phoneField.text isNotBlank] && _selectbutton.isSelected) {
        [self.button setBackgroundColor:COLOR_PATTERN_STRING(@"_yellow_color")];
        self.button.userInteractionEnabled = YES;
    }else{
        [self.button setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        self.button.userInteractionEnabled = NO;
    }
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.frame = CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, 74);
    }return _bgView;
}
- (FanImageView *)bankImg{
    if (!_bankImg) {
        _bankImg = [FanImageView new];
        _bankImg.frame = CGRectMake(15, FAN_NAV_HEIGHT + 15, 44, 44);
        _bankImg.layer.cornerRadius = 22;
        _bankImg.layer.masksToBounds = YES;
        NSString *imageName = [NSString stringWithFormat:@"%@ %@",DICTION_OBJECT(self.urlParams, @"bank"),DICTION_OBJECT(self.urlParams, @"type")].bankIcon;
        _bankImg.image = IMAGE_WITH_NAME(imageName);
    }return _bankImg;
}
- (UILabel *)bankLb{
    if (!_bankLb) {
        _bankLb = [UILabel new];
        _bankLb .font = FanFont(15);
        _bankLb.text = [NSString stringWithFormat:@"%@ %@",DICTION_OBJECT(self.urlParams, @"bank"),DICTION_OBJECT(self.urlParams, @"type")];
        _bankLb.frame = CGRectMake(_bankImg.right + 10, _bankImg.centerY - 20 , FAN_SCREEN_WIDTH - _bankImg.right - 20, 20);
        _bankLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
    }return _bankLb;
}
- (UILabel *)cardLb{
    if (!_cardLb) {
        _cardLb = [UILabel new];
        _cardLb .font = FanFont(13);
        NSString *card = DICTION_OBJECT(self.urlParams, @"card");
        _cardLb.text = [card formatterBankCardNum];
        _cardLb.frame = CGRectMake(_bankLb.left, _bankLb.bottom + 5, _bankLb.width, 20);
        _cardLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
    }return _cardLb;
}
- (FanImageView *)alertBgLb{
    if (!_alertBgLb) {
        _alertBgLb = [FanImageView new];
        _alertBgLb.backgroundColor = COLOR_PATTERN_STRING(@"_ffecb9_color");
        _alertBgLb.frame = CGRectMake(0, _bankImg.bottom + 15, FAN_SCREEN_WIDTH, 28);
        [_alertBgLb addSubview:self.alertLb];
    }return _alertBgLb;
}
- (UILabel *)alertLb{
    if (!_alertLb) {
        _alertLb = [UILabel new];
        _alertLb .font = FanFont(12);
        _alertLb.text = @"提醒：后续只能绑定该持卡人的银行卡";
        _alertLb.frame = CGRectMake(15, 4, FAN_SCREEN_WIDTH - 30, 20);
        _alertLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
    }return _alertLb;
}

- (FanTextField *)nameField{
    if (!_nameField) {
        _nameField = [[FanTextField alloc] initWithFrame:CGRectMake(0, _alertBgLb.bottom, FAN_SCREEN_WIDTH, 50)];
        _nameField.backgroundColor = [UIColor whiteColor];
        _nameField.lineViewNomalColor = @"_line_color";
        _nameField.fan_placeholder = @"请输入持卡人姓名";
        _nameField.leftViewWidth = FAN_SCREEN_WIDTH/5;
        _nameField.leftLbTxt = @"持卡人";
        __weak BankVerificateController *weakself = self;
        _nameField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx ==cat_textfield_content_changed_nil || idx == cat_textfield_content_changed_unnil) {
                [weakself buttonstatus];
            }
        };
    }return _nameField;
}
- (FanTextField *)cardField{
    if (!_cardField) {
        _cardField = [[FanTextField alloc] initWithFrame:CGRectMake(0, _nameField.bottom, FAN_SCREEN_WIDTH, 50)];
        _cardField.backgroundColor = [UIColor whiteColor];
        _cardField.fan_placeholder = @"请输入身份证";
        _cardField.lineViewNomalColor = @"_line_color";
        _cardField.leftViewWidth = FAN_SCREEN_WIDTH/5;
        _cardField.leftLbTxt = @"身份证";
        _cardField.style_count = YES;
        __weak BankVerificateController *weakself = self;
        _cardField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx ==cat_textfield_content_changed_nil || idx == cat_textfield_content_changed_unnil) {
                [weakself buttonstatus];
            }
        };
    }return _cardField;
}
- (FanTextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [[FanTextField alloc] initWithFrame:CGRectMake(0, _cardField.bottom, FAN_SCREEN_WIDTH, 50)];
        _phoneField.backgroundColor = [UIColor whiteColor];
        _phoneField.fan_placeholder = @"银行预留手机号";
        _phoneField.leftViewWidth = FAN_SCREEN_WIDTH/5;
        _phoneField.leftLbTxt = @"手机号";
        _phoneField.style_count = YES;
        _phoneField.rightViewWidth = 60;
        _phoneField.rightBtnImg = @"cell_accessView";
        __weak BankVerificateController *weakself = self;
        _phoneField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx ==cat_textfield_content_changed_nil || idx == cat_textfield_content_changed_unnil) {
                [weakself buttonstatus];
            }else if (idx == cat_textfield_right_btn){
                [FanAlert showAlertControllerWithTitle:@"提示" message:@"银行预留手机号是在银行办卡时填写的手机号,若遗忘、换号可联系银行处理" _cancletitle_:@"知道了" _confirmtitle_:nil handler1:nil handler2:nil];
            }
        };
    }return _phoneField;
}
- (UIButton *)selectbutton{
    if (!_selectbutton) {
        _selectbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectbutton.frame = CGRectMake(15, _phoneField.bottom + 20 , 15, 15);
        [_selectbutton setBackgroundImage:IMAGE_WITH_NAME(@"xieyi_0") forState:UIControlStateNormal];
        [_selectbutton setBackgroundImage:IMAGE_WITH_NAME(@"xieyi_1") forState:UIControlStateSelected];
        [_selectbutton addTarget:self action:@selector(selectbuttonMethod) forControlEvents:UIControlEventTouchUpInside];
    }return _selectbutton;
}
- (YYLabel *)agreementLb{
    if (!_agreementLb) {
        _agreementLb = [YYLabel new];
        _agreementLb.frame = CGRectMake(_selectbutton.right + 10, _selectbutton.top, 200, 15);
        _agreementLb.text = @"同意《用户服务协议》";
        _agreementLb.font = FanFont(14);
        _agreementLb.textColor = COLOR_PATTERN_STRING(@"_8c8c8c_color");
        NSString *text = @"同意《用户服务协议》";
        _agreementLb.attributedText = [text xieyi_changeColor:@"《用户服务协议》" withAlignment:NSTextAlignmentLeft];
        __weak BankVerificateController *weakself = self;
        _agreementLb.highlightTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [weakself pushViewControllerWithUrl:@"FanWebController?title=服务协议" transferData:nil hander:nil];
        };
    }return _agreementLb;
}
- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(15, _agreementLb.bottom + 50 , FAN_SCREEN_WIDTH - 30, 44);
        [_button setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        [_button  setTitle:@"验证信息" forState:UIControlStateNormal];
        [_button setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:UIControlStateNormal];
        [_button.titleLabel setFont:FanFont(17)];
        _button.layer.cornerRadius = 3;
        _button.layer.masksToBounds = YES;
        [_button addTarget:self action:@selector(valid) forControlEvents:UIControlEventTouchUpInside];
        _button.userInteractionEnabled = NO;
    }return _button;
}
@end
