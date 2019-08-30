//
//  PassWordView.m
//  FanProduct
//
//  Created by 99epay on 2019/6/19.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "PassWordView.h"

#define kFieldSize CGSizeMake(210.0f,45.0f)
#define kLineCount 5
#define kDotCount 6
#define kLineMarginTop 5.0f



@implementation PassWordView


- (void)initView{
    __weak PassWordView *weakSelf =  self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
        if ([note.object isEqual:weakSelf.passwordTextField]){
            [weakSelf setDotWithCount:weakSelf.passwordTextField.text.length];
            if (weakSelf.passwordTextField.text.length == 6){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (weakSelf.customActionBlock) {
                        weakSelf.customActionBlock(weakSelf.passwordTextField.text, cat_input_password);
                    }
                });
            }else{
                if (weakSelf.customActionBlock) {
                    weakSelf.customActionBlock(weakSelf.passwordTextField.text, cat_input_password_start);
                }
            }
        }
        
    }];
    [self initPasswordView];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        __weak PassWordView *weakSelf =  self;
        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
            if ([note.object isEqual:weakSelf.passwordTextField]){
                [weakSelf setDotWithCount:weakSelf.passwordTextField.text.length];
                
                if (weakSelf.passwordTextField.text.length == 6){
                    if (weakSelf.customActionBlock) {
                        weakSelf.customActionBlock(weakSelf.passwordTextField.text, cat_input_password);
                    }
                }else{
                    if (weakSelf.customActionBlock) {
                        weakSelf.customActionBlock(weakSelf.passwordTextField.text, cat_input_password_start);
                    }
                }
            }
        }];
        [self initPasswordView];
    }
    
    return self;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)fieldBecomeFirstResponder{
    [_passwordTextField becomeFirstResponder];
}
-(void)fieldResignFirstResponder{
    [_passwordTextField resignFirstResponder];
}
- (NSMutableArray *)passwordIndicatorArrary{
    if (!_passwordIndicatorArrary) {
        _passwordIndicatorArrary = [NSMutableArray array];
    }
    return _passwordIndicatorArrary;
}
- (void)initPasswordView{
    self.backgroundColor = [UIColor whiteColor];
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kFieldSize.width, kFieldSize.height)];
    _passwordTextField.hidden = YES;
    _passwordTextField.delegate = self;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_passwordTextField];
    
    CGFloat width = self.bounds.size.width / kDotCount;
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.bounds];
    [imgView setImage:[UIImage imageNamed:@"kuang"]];
    [self addSubview:imgView];
    for (int i = 0; i < kDotCount; i++){
        UIButton * dotImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        dotImageView.frame = CGRectMake(i * width, 0, width, self.height);
//        [dotImageView setImage:IMAGE_WITH_NAME(@"dian") forState:UIControlStateNormal];
//        [dotImageView setImageEdgeInsets:UIEdgeInsetsMake(dotImageView.height/2 - 5, dotImageView.width/2 - 5, dotImageView.height/2 -5, dotImageView.width/2 - 5)];
        [dotImageView setTitleColor:COLOR_PATTERN_STRING(@"_212121_color") forState:UIControlStateNormal];
        [dotImageView.titleLabel setFont: FanRegularFont(20)];
        dotImageView.clipsToBounds = YES;
        dotImageView.hidden = YES;
        [self addSubview:dotImageView];
        
        [self.passwordIndicatorArrary addObject:dotImageView];
    }
}
- (void)setSecureTextEntry:(BOOL)secureTextEntry{
    _secureTextEntry = secureTextEntry;
    if (secureTextEntry) {
        for (UIButton *dotImageView in self.passwordIndicatorArrary) {
            [dotImageView setImage:IMAGE_WITH_NAME(@"dian") forState:UIControlStateNormal];
            [dotImageView setImageEdgeInsets:UIEdgeInsetsMake(dotImageView.height/2 - 5, dotImageView.width/2 - 5, dotImageView.height/2 -5, dotImageView.width/2 - 5)];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string isEqualToString:@"\n"]){
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    }else if(string.length == 0){
        //判断是不是删除键
        return YES;
    }else if(textField.text.length >= kDotCount){
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    }else{
        return YES;
    }
}

- (void)setDotWithCount:(NSInteger)count{
    for (UIButton *dotImageView in self.passwordIndicatorArrary) {
        dotImageView.hidden = YES;
        if (!self.secureTextEntry) {
            [dotImageView setTitle:@"" forState:UIControlStateNormal];
        }
    }
    for (int i = 0; i< count; i++){
        UIButton *button = (UIButton *)[self.passwordIndicatorArrary objectAtIndex:i];
        button.hidden = NO;
        if (!self.secureTextEntry) {
            [button setTitle:[NSString stringWithFormat:@"%@",[self.passwordTextField.text substringWithRange:NSMakeRange(i, 1)]] forState:UIControlStateNormal];
        }
    }
}

- (void)clearUpPassword{
    _passwordTextField.text = @"";
    [self setDotWithCount:_passwordTextField.text.length];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_passwordTextField becomeFirstResponder];
}

@end










@interface FanPayAlertView()
@property (nonatomic ,strong) UIView *maskView;
@property (nonatomic ,strong) UIButton *closeButton;
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *lineLb;
@property (nonatomic ,strong) UILabel *messageLb;
@property (nonatomic ,strong) UILabel *moneyLb;
@property (nonatomic ,strong) PassWordView *passwordView;
@property (nonatomic ,strong) UIButton *forgetButton;
@property (nonatomic ,strong) UILabel *resultLb;
@end
@implementation FanPayAlertView

- (instancetype)initWithFrame:(CGRect)frame message:(NSString *)message money:(NSString *)money{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_PATTERN_STRING(@"_cover_color");
        [self addSubview:self.maskView];
        NSMutableAttributedString *moneyAtt  = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",money]];
        [moneyAtt changeStringStyleWithText:@"￥" color:COLOR_PATTERN_STRING(@"_333333_color") font:FanRegularFont(13)];
        self.moneyLb.attributedText = moneyAtt;
        self.messageLb.text = message;
        __weak FanPayAlertView *weakSelf = self;
        self.resultActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_error_net) {
                weakSelf.resultLb.hidden = NO;
                weakSelf.messageLb.hidden = weakSelf.moneyLb.hidden = YES;
                weakSelf.resultLb.text = @"网络不佳~稍后重试";
            }else if (idx == cat_error_pwd) {
                weakSelf.resultLb.hidden = NO;
                weakSelf.messageLb.hidden = weakSelf.moneyLb.hidden = YES;
                weakSelf.resultLb.text = @"密码输入错误~";
            }
        };
        
    }return self;
}
- (void)forgetMethod{
    [_passwordView fieldResignFirstResponder];
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (self.customActionBlock) {
            self.customActionBlock(self, cat_forget);
        }
    }];
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(FanWidth(30), FAN_SCREEN_HEIGHT - Fan_KeyBoard_Height() - 210, FAN_SCREEN_WIDTH - FanWidth(60), 210)];
        _maskView.layer.cornerRadius = 10;
        _maskView.clipsToBounds = YES;
        _maskView.backgroundColor = COLOR_PATTERN_STRING(@"_ffffff_color");
        [_maskView addSubview:self.titleLb];
        [_maskView addSubview:self.lineLb];
        [_maskView addSubview:self.closeButton];
        [_maskView addSubview:self.messageLb];
        [_maskView addSubview:self.moneyLb];
        [_maskView addSubview:self.passwordView];
        [_maskView addSubview:self.forgetButton];
    }
    return _maskView;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.frame = CGRectMake(30, 15, _maskView.width - 60, 20);
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.font = FanFont(16);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _titleLb.text = @"请输入支付密码";
    }return _titleLb;
}

- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(_maskView.width - 15 - 10,_titleLb.top, 15, 15);
        [_closeButton setImage:IMAGE_WITH_NAME(@"nav_close") forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(buttonMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UILabel *)lineLb{
    if (!_lineLb) {
        _lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLb.bottom + 15, _maskView.width, FAN_LINE_HEIGHT)];
        _lineLb.backgroundColor = COLOR_PATTERN_STRING(@"_line_color");
    }return _lineLb;
}
- (UILabel *)messageLb{
    if (!_messageLb) {
        _messageLb = [[UILabel alloc] initWithFrame:CGRectMake(0, _lineLb.bottom + 10, _lineLb.width, 20)];
        _messageLb.textAlignment = NSTextAlignmentCenter;
        _messageLb.textColor = COLOR_PATTERN_STRING(@"_8c8c8c_color");
        _messageLb.font = FanFont(13);
    }
    return _messageLb;
}

- (UILabel *)moneyLb{
    if (!_moneyLb) {
        _moneyLb = [[UILabel alloc] initWithFrame:CGRectMake(0, _messageLb.bottom + 10, _lineLb.width, 20)];
        _moneyLb.textAlignment = NSTextAlignmentCenter;
        _moneyLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _moneyLb.font = FanBoldFont(17);
    }
    return _moneyLb;
}
- (UILabel *)resultLb{
    if (!_resultLb) {
        _resultLb = [[UILabel alloc] initWithFrame:CGRectMake(0, _lineLb.bottom + 10, _lineLb.width,50)];
        _resultLb.textAlignment = NSTextAlignmentCenter;
        _resultLb.textColor = COLOR_PATTERN_STRING(@"_red_color");
        _resultLb.backgroundColor = COLOR_PATTERN_STRING(@"_ffffff_color");
        _resultLb.font = FanFont(16);
        [_maskView addSubview:_resultLb];
    }
    return _resultLb;
}

- (PassWordView *)passwordView{
    if (!_passwordView) {
        UIImage *img = [UIImage imageNamed:@"kuang"];
        _passwordView = [[PassWordView alloc] initWithFrame:CGRectMake(15, _moneyLb.bottom + 10 , _maskView.width - 30, [img getImageHeightWithWidth:_maskView.width - 30])];
        _passwordView.secureTextEntry = YES;
        __weak FanPayAlertView *weakSelf = self;
        _passwordView.customActionBlock = ^(id obj, int idx) {
            if (idx == cat_input_password) {
                if (weakSelf.customActionBlock) {
                    weakSelf.customActionBlock(obj, cat_input_password);
                }
            }else if (idx == cat_input_password_start){
                weakSelf.resultLb.hidden = YES;
                weakSelf.messageLb.hidden = weakSelf.moneyLb.hidden = NO;
            }
        };
        [_passwordView fieldBecomeFirstResponder];
    }
    return _passwordView;
}

- (UIButton *)forgetButton{
    if (!_forgetButton) {
        _forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forgetButton.frame = CGRectMake(_maskView.width - 110 ,_passwordView.bottom + 10,100, 30);
        [_forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetButton setTitleColor:COLOR_PATTERN_STRING(@"_red_color") forState:UIControlStateNormal];
        [_forgetButton.titleLabel setFont:FanFont(13)];
        _forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_forgetButton addTarget:self action:@selector(forgetMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetButton;
}
- (void)buttonMethod{
    [_passwordView fieldResignFirstResponder];
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (self.customActionBlock) {
            self.customActionBlock(self, cat_close);
        }
    }];
    
}

@end
