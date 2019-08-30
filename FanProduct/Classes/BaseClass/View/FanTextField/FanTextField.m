//
//  FanTextField.m
//  FanProduct
//
//  Created by 99epay on 2019/6/19.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanTextField.h"

@implementation FanTextField

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.inputAccessoryView = self.inputView_;
}
- (FanView *)inputView_{
    if (!_inputView_) {
        _inputView_ = [[FanView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH,40)];
        _inputView_.backgroundColor = COLOR_PATTERN_STRING(@"_ffffff_color");
        [_inputView_ addSubview:self.inputView_lb];
        UILabel *line_1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, FAN_TABBAR_HEIGHT, 1)];
        line_1.backgroundColor = COLOR_PATTERN_STRING(@"_keyword_bg_color");
        [_inputView_ addSubview:line_1];
        UILabel *line_2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, FAN_TABBAR_HEIGHT, 1)];
        line_2.backgroundColor = COLOR_PATTERN_STRING(@"_keyword_bg_color");
        [_inputView_ addSubview:line_2];
        UIButton *finish_b = [UIButton buttonWithType:UIButtonTypeCustom];
        finish_b.frame = CGRectMake(_inputView_.width - 75, 0, 55, _inputView_.height);
        [finish_b addTarget:self action:@selector(buttonMethod) forControlEvents:UIControlEventTouchUpInside];
        [finish_b setTitle:@"完成" forState:UIControlStateNormal];
        [finish_b setTitleColor:COLOR_PATTERN_STRING(@"_212121_color") forState:UIControlStateNormal];
        finish_b.titleLabel.font = FanFont(17);
        finish_b.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_inputView_ addSubview:finish_b];
    }
    return _inputView_;
}

- (UILabel *)inputView_lb{
    if (!_inputView_lb) {
        _inputView_lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, 40)];
        _inputView_lb.textColor = COLOR_PATTERN_STRING(@"_666666_color");
        _inputView_lb.font = FanFont(15);
        _inputView_lb.textAlignment = NSTextAlignmentCenter;
        _inputView_lb.adjustsFontSizeToFitWidth = YES;
        _inputView_lb.text = self.fan_placeholder;
    }
    return _inputView_lb;
}
- (UILabel *)alertLb{
    if (!_alertLb) {
        _alertLb = [[UILabel alloc] initWithFrame:CGRectMake(self.leftView ? self.leftView.right : 0, 0, self.leftView ? self.width - self.leftView.right : self.width, 15)];
        _alertLb.font = FanFont(11);
        _alertLb.textColor = COLOR_PATTERN_STRING(@"_red_color");
        [self addSubview:_alertLb];
    }return _alertLb;
}
- (void)buttonMethod{
    [self endEditing:YES];
}
- (FanView *)lineView{
    if (!_lineView) {
        _lineView = [[FanView alloc] initWithFrame:CGRectMake(0, self.height - 1, self.width, 1)];
        _lineView.backgroundColor = COLOR_PATTERN_STRING(_lineViewNomalColor);
        [self addSubview:_lineView];
    }return _lineView;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _lineView.frame = CGRectMake(0, self.height - 1, self.width, 1);
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        //设置占位文字的字体颜色 font
        [self setFont:FanFont(15)];
        [self setTextColor:COLOR_PATTERN_STRING(@"_333333_color")];
        _placeholdercolor = COLOR_PATTERN_STRING(@"_text_ploacher_color");
        _leftOffset = 10;
        _rightTxtFont = 15;
        _leftTxtFont = 15;
        _leftTxtColor = @"_212121_color";
        _rightTxtColor = @"_212121_color";
        _lineViewNomalColor = @"_clear_color";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldContentChanged) name:UITextFieldTextDidChangeNotification object:self];

    }
    return self;
}
- (void)dealloc{
    if (self.rightView && [self.rightView isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self.rightView;//结束倒计时
        if (button.isTime) {
            button.endTime = YES;
        }
    }
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (CGRect)textRectForBounds:(CGRect)bounds {
    
    CGFloat x = 0;
    
    CGFloat y = 3;
    CGFloat width =  self.width;
    CGFloat height = bounds.size.height - 3;
    if (self.leftView) {
        x = self.leftView.right;
        width = self.width - self.leftView.right;
    }
    if (self.rightView) {
        width = width - self.rightView.width;
    }
    return CGRectMake(x, y, width, height);
    
}
- (CGRect)editingRectForBounds:(CGRect)bounds {
    
    CGFloat x = 0;
    
    CGFloat y = 3;
    CGFloat width =  self.width;
    CGFloat height = bounds.size.height - 3;
    if (self.leftView) {
        x = self.leftView.right;
        width = self.width - self.leftView.right;
    }
    if (self.rightView) {
        width = width - self.rightView.width;
    }
    return CGRectMake(x, y, width, height);
    
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    return CGRectMake(_leftOffset, bounds.origin.y, self.leftView.width, bounds.size.height);
}
- (void)setFont:(UIFont *)font{
    [super setFont:font];
    _fan_placeholder_font = font;
}
- (void)setText:(NSString *)text{
    [super setText:text];
    [self textFieldContentChanged];
}
- (void)textFieldContentChanged{
    if ([self.text isNotBlank]) {
        if (self.customActionBlock) {
            self.customActionBlock(self, cat_textfield_content_changed_unnil);
        }
    }else{
        if (self.customActionBlock) {
            self.customActionBlock(self, cat_textfield_content_changed_nil);
        }
    }
    //修改警示文字为默认文字
    if (_fan_placeholderalert) {
        _fan_placeholderalert  = @"";
    }
}
- (void)rightBtnMethod:(UIButton *)btn{
    if (self.customActionBlock) {
        self.customActionBlock(self, cat_textfield_right_btn);
    }
    
}
- (void)startTimeWithTime:(NSUInteger)time timeColor:(NSString *)timeColor{
    UIButton *btn = (UIButton *)self.rightView;
    //开始倒计时
    [btn startWithTimeInterval:time title:btn.titleLabel.text timeColor:timeColor titleColor:_rightTxtColor];
}

- (void)setLineViewNomalColor:(NSString *)lineViewNomalColor{
    _lineViewNomalColor = lineViewNomalColor;
    self.lineView.backgroundColor = COLOR_PATTERN_STRING(lineViewNomalColor);
}

- (void)setLeftLbTxt:(NSString *)leftLbTxt{
    _leftLbTxt = leftLbTxt;
    
    CGFloat width;
    if (_leftViewWidth > 0) {
        width = _leftViewWidth;
    }else{
       width =  [FanSize getWidthWithString:leftLbTxt fontSize:_rightTxtFont] + 10;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height/2 - 15, width, 30)];
    label.text = leftLbTxt;
    label.textColor = COLOR_PATTERN_STRING(_leftTxtColor);
    label.font = FanFont(_leftTxtFont);
    self.leftView = label;
}
- (void)setLeftImg:(NSString *)leftImg{
    _leftImg = leftImg;
    UIImage *image = IMAGE_WITH_NAME(leftImg);
    FanImageView *leftView = [[FanImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 10, self.height/2 - image.size.height/2)];//加了10个间隔
    if (_leftViewWidth > 0) {
        leftView.width = _leftViewWidth;
    }
    leftView.image = image;
    leftView.contentMode = UIViewContentModeCenter;
    self.leftView = leftView;
}
- (void)setRightImg:(NSString *)rightImg{
    _rightImg = rightImg;
    UIImage *image = IMAGE_WITH_NAME(rightImg);
    FanImageView *rightView = [[FanImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width + 10, self.height/2 - image.size.height/2)];
    if (_rightViewWidth > 0) {
        rightView.width = _rightViewWidth;
    }
    rightView.image = image;
    rightView.contentMode = UIViewContentModeCenter;
    self.rightView = rightView;
}
- (void)setRightLbTxt:(NSString *)rightLbTxt{
    _rightLbTxt = rightLbTxt;
}
- (void)setRightBtnImg:(NSString *)rightBtnImg{
    _rightBtnImg = rightBtnImg;
    UIImage *img = IMAGE_WITH_NAME(rightBtnImg);
    UIButton * rightTxtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width;
    if (_rightViewWidth > 0) {
        width = _rightViewWidth;
    }else{
        width = img.size.width;
    }
    rightTxtBtn.frame = CGRectMake(0, 0, width, self.height/2 - img.size.height/2);
    [rightTxtBtn setImage:img forState:0];
    [rightTxtBtn addTarget:self action:@selector(rightBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.rightView = rightTxtBtn;
}
- (void)setRightBtnTxt:(NSString *)rightBtnTxt{
    _rightBtnTxt = rightBtnTxt;
    UIButton * rightTxtBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width;
    if (_rightViewWidth > 0) {
        width = _rightViewWidth;
    }else{
        width = [FanSize getWidthWithString:rightBtnTxt fontSize:_rightTxtFont] + 18;
    }
    rightTxtBtn.frame = CGRectMake(0, 0 , width, self.height);
    [rightTxtBtn setTitle:rightBtnTxt forState:0];
    [rightTxtBtn setTitleColor:COLOR_PATTERN_STRING(_rightTxtColor) forState:0];
    rightTxtBtn.titleLabel.font = FanFont(_rightTxtFont);
    [rightTxtBtn addTarget:self action:@selector(rightBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.rightView = rightTxtBtn;
}
- (void)setLeftView:(UIView *)leftView{
    [super setLeftView:leftView];
    self.leftViewMode = UITextFieldViewModeAlways;
}
- (void)setRightView:(UIView *)rightView{
    [super setRightView:rightView];
    self.rightViewMode = UITextFieldViewModeAlways;
}
- (void)setTextColor:(UIColor *)textColor{
    [super setTextColor:textColor];
}
- (void)setPlaceholdercolor:(UIColor *)placeholdercolor{
    _placeholdercolor = placeholdercolor;
    if (self.fan_placeholder) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.fan_placeholder attributes: @{NSForegroundColorAttributeName:_placeholdercolor,NSFontAttributeName:_fan_placeholder_font}];
    }
}
- (void)setFan_placeholder:(NSString *)fan_placeholder{
    _fan_placeholder = fan_placeholder;
    if (!fan_placeholder) {
        fan_placeholder = @"";
    }
    self.inputView_lb.text = fan_placeholder;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:fan_placeholder attributes: @{NSForegroundColorAttributeName:_placeholdercolor,NSFontAttributeName:_fan_placeholder_font}];
}

- (void)setFan_placeholderalert:(NSString *)fan_placeholderalert{
    _fan_placeholderalert = fan_placeholderalert;
    self.alertLb.text = fan_placeholderalert;
}
#pragma mark -- delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField        // return NO to disallow editing.
{
    self.alertLb.text  = @"";
    if (self.RightoffresignFirstResponder) {
        if (self.customActionBlock) {
            self.customActionBlock(self, cat_rightoffresignFirstResponder);
        }
        return NO;
    }
    if ([self.fandelegate respondsToSelector:@selector(FanTextFieldShouldBeginEditing:)]) {
        
        return [self.fandelegate FanTextFieldShouldBeginEditing:textField];
    }else
        return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField          // became first responder
{
    if (self.customActionBlock) {
        self.customActionBlock(self, cat_textfield_keyboard_show);
    }
    if (_lineViewHightColor) {
        self.lineView.backgroundColor = COLOR_PATTERN_STRING(_lineViewHightColor);
    }
    
    if ([self.fandelegate respondsToSelector:@selector(FanTextFieldDidBeginEditing:)]) {
        [self.fandelegate FanTextFieldDidBeginEditing:textField];
    }
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
{
    if (self.customActionBlock) {
        self.customActionBlock(self, cat_textfield_keyboard_hide);
    }
    self.lineView.backgroundColor = COLOR_PATTERN_STRING(_lineViewNomalColor);
    if ([self.fandelegate respondsToSelector:@selector(FanTextFieldShouldEndEditing:)]) {
        return [self.fandelegate FanTextFieldShouldEndEditing:textField];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField           // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
{
    
    if ([self.fandelegate respondsToSelector:@selector(FanTextFieldDidEndEditing:)]) {
        [self.fandelegate FanTextFieldDidEndEditing:textField];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0) // if implemented, called in place of textFieldDidEndEditing:
{
    if ([self.fandelegate respondsToSelector:@selector(FanTextFieldDidEndEditing:reason:)]) {
        [self.fandelegate FanTextFieldDidEndEditing:textField reason:reason];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string   // return NO to not change text
{
    if (self.style_count) {
        NSString *text = [self text];
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        [self setText:newString];
        return NO;
    }
    
    if ([self.fandelegate respondsToSelector:@selector(FanTextField:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.fandelegate FanTextField:textField shouldChangeCharactersInRange:range replacementString:string];
    }else
        return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField              // called when clear button pressed. return NO to ignore (no notifications)
{
    if ([self.fandelegate respondsToSelector:@selector(FanTextFieldShouldClear:)]) {
        return [self.fandelegate FanTextFieldShouldClear:textField];
    }else
        return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    if ([self.fandelegate respondsToSelector:@selector(FanTextFieldShouldReturn:)]) {
        return [self.fandelegate FanTextFieldShouldReturn:textField];
    }else
        return YES;
}

@end

