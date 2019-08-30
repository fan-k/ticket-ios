//
//  FeedbackController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FeedbackController.h"
#import "FanTextField.h"
#import "FanTextView.h"

@interface FeedbackController ()
@property (nonatomic ,strong) FanTextView *textView;
@property (nonatomic ,strong) FanTextField *textField;
@property (nonatomic ,strong) UIButton *sendBtn;
@end

@implementation FeedbackController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"意见反馈";
    
    [self.view addSubview:self.textView];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.sendBtn];
    
}
- (void)nextmethod{
    if ([self.textView.text isNotBlank]) {
        [self.params removeAllObjects];
        self.params[@"message"] = _textView.text;
        self.params[@"contact"] = _textField.text;
        [self requestWithUrl:FanUrlIndex loading:YES];
    }else{
        [FanAlert alertMessage:@"请填写反馈内容" type:AlertMessageTypeNomal];
    }
    
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    [FanAlert alertErrorWithItem:item];
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    [FanAlert alertMessage:@"感谢您的反馈" type:AlertMessageTypeNomal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}
#pragma mark - getter

- (FanTextView *)textView{
    if (!_textView) {
        _textView = [[FanTextView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, 160)];
        _textView.placeholder = @"请留下您的宝贵意见或建议";
    }return _textView;
}
- (FanTextField *)textField{
    if (!_textField) {
        _textField = [[FanTextField alloc] initWithFrame:CGRectMake(0, _textView.bottom + 9, FAN_SCREEN_WIDTH, 55)];
        _textField.leftOffset = 20;
        _textField.backgroundColor = COLOR_PATTERN_STRING(@"_whiter_color");
        _textField.leftTxtFont = 16;
        _textField.leftViewWidth = 90;
        _textField.leftLbTxt = @"联系方式";
        _textField.fan_placeholder = @"非必填";
        
    }return _textField;
}
- (UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBtn.frame = CGRectMake(20, _textField.bottom + 30, FAN_SCREEN_WIDTH - 40, 50);
        [_sendBtn setTitle:@"提交" forState:0];
        [_sendBtn setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:0];
        [_sendBtn setBackgroundColor:COLOR_PATTERN_STRING(@"_yellow_color")];
        _sendBtn.layer.cornerRadius = 3;
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.titleLabel.font = FanRegularFont(18);
        [_sendBtn addTarget:self action:@selector(nextmethod) forControlEvents:UIControlEventTouchUpInside];
    }return _sendBtn;
}
@end
