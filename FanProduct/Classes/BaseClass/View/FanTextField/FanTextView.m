//
//  FanTextView.m
//  Baletu
//
//  Created by fangkangpeng on 2019/1/2.
//  Copyright © 2019 Fan. All rights reserved.
//

#import "FanTextView.h"
#import "UIColor+HexString.h"

@interface FanTextView()<UITextViewDelegate>
@property (nonatomic ,strong) UILabel * placeholderLb;
@end

@implementation FanTextView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        _placeholder_font = 15;
        _placeholdercolor = [UIColor colorWithHexString:@"#b5b5b5"];
        self.backgroundColor = [UIColor colorWithHexString:@"#f8f8f8"];
        self.font = FanFont(15);
        self.textColor = [UIColor colorWithHexString:@"#1c1c1c"];
        self.delegate = self;
    }return self;
}
- (void)textViewDidChange:(UITextView *)textView{
    if (self.text.length == 0) {
        [_placeholderLb setHidden:NO];
    }else{
        [_placeholderLb setHidden:YES];
    }
}
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLb.text = placeholder;
}
- (void)setPlaceholder_font:(NSInteger)placeholder_font{
    _placeholder_font = placeholder_font;
    self.placeholderLb.font = FanFont(placeholder_font);
}
- (void)setPlaceholdercolor:(UIColor *)placeholdercolor{
    _placeholdercolor = placeholdercolor;
    self.placeholderLb.textColor = placeholdercolor;
}

- (UILabel *)placeholderLb{
    if(!_placeholderLb){
        _placeholderLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, self.frame.size.width - 30, 20)];
        _placeholderLb.textColor = _placeholdercolor;
        _placeholderLb.font = FanFont(_placeholder_font);
        [self addSubview:_placeholderLb];
    }return _placeholderLb;
}

@end
