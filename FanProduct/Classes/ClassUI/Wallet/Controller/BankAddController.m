//
//  BankAddController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "BankAddController.h"
#import "FanTextField.h"

@interface BankAddController ()
@property (nonatomic ,strong) UILabel *codeLb;
@property (nonatomic ,strong) FanTextField *cardField;
@property (nonatomic ,strong) UIButton *button;
@end

@implementation BankAddController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"添加银行卡";
    [self.view addSubview:self.codeLb];
    [self.view addSubview:self.cardField];
    [self.view addSubview:self.button];
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    NSString *bank = DICTION_OBJECT(DICTION_OBJECT(item.responseObject, @"data"), @"bank");
    NSString *card = DICTION_OBJECT(DICTION_OBJECT(item.responseObject, @"data"), @"card");
    NSString *type = DICTION_OBJECT(DICTION_OBJECT(item.responseObject, @"data"), @"type");
    [self pushViewControllerWithUrl:[NSString stringWithFormat:@"BankVerificateController?card=%@&bank=%@&type=%@",card,bank,type] transferData:nil hander:nil];
}
- (void)valid{
    //验证银行卡
    self.params[@"card"] = self.cardField.text;
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    [self requestWithUrl:FanUrlUserBankVerificate loading:NO error:FanErrorTypeTopAlert];
}
- (UILabel *)codeLb{
    if (!_codeLb) {
        _codeLb = [UILabel new];
        _codeLb .font = FanFont(13);
        _codeLb.text = @"为保证您的资金安全，请绑定账户本人的银行卡";
        _codeLb.frame = CGRectMake(15, FAN_NAV_HEIGHT + 20, FAN_SCREEN_WIDTH - 30, 20);
        _codeLb.textColor = COLOR_PATTERN_STRING(@"_737373_color");
    }return _codeLb;
}
- (FanTextField *)cardField{
    if (!_cardField) {
        _cardField = [[FanTextField alloc] initWithFrame:CGRectMake(0, _codeLb.bottom + 10, FAN_SCREEN_WIDTH, 50)];
        _cardField.backgroundColor = [UIColor whiteColor];
        _cardField.fan_placeholder = @"请输入银行卡号";
        _cardField.leftViewWidth = FAN_SCREEN_WIDTH/7;
        _cardField.leftLbTxt = @"卡号";
        _cardField.style_count = YES;
        __weak BankAddController *weakself = self;
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
- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(15, _cardField.bottom + 70 , FAN_SCREEN_WIDTH - 30, 44);
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
