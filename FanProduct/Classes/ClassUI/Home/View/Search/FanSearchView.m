//
//  FanSearchView.m
//  FanProduct
//
//  Created by 99epay on 2019/6/11.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanSearchView.h"

@interface FanSearchView ()<UITextFieldDelegate>
@property (nonatomic ,strong) UIView *searchView;
@property (nonatomic ,strong) UIImageView *img;
@property (nonatomic ,strong) UITextField *textField;
@property (nonatomic ,strong) UIButton *searchButton;
@end

@implementation FanSearchView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.searchView];
        [self addSubview:self.searchButton];
        [self.searchView addSubview:self.img];
        [self.searchView addSubview:self.textField];
        [_textField becomeFirstResponder];
        
    }return self;
}
- (void)searchButtonClick{
    if ([_searchButton.titleLabel.text isEqualToString:@"搜索"]) {
        [_searchButton setTitle:@"取消" forState:UIControlStateNormal];
        [_textField resignFirstResponder];
        if ([_textField.text isNotBlank]) {
            if (self.customActionBlock) {
                self.customActionBlock(_textField.text, cat_search);
            }
        }
    }else{
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        _textField.text = nil;
            if (self.customActionBlock) {
                self.customActionBlock(nil, cat_nav_left_click);
            }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text isNotBlank]) {
        [self searchButtonClick];
    }else{
        return YES;
    }
    return YES;
}
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes: @{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:FanFont(14)}];
}
- (UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width - 50, self.height)];
        _searchView.backgroundColor = COLOR_PATTERN_STRING(@"_base_background_color");
        _searchView.layer.cornerRadius = self.height/2;
    }return _searchView;
}
- (UIImageView *)img{
    if (!_img) {
        UIImage *image = [UIImage imageNamed:@"search_img"];
        _img = [[UIImageView alloc] initWithFrame:CGRectMake(self.height/2, self.height/2 - image.size.height/2, image.size.width, image.size.height)];
        _img.image = image;
    }return _img;
}
- (UIButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] initWithFrame:CGRectMake(_searchView.right, 0, 50, self.height)];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _searchButton.titleLabel.font = FanFont(14);
        [_searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }return _searchButton;
}
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(_img.right + 5, 5, self.searchView.width - _img.right -_img.left - 10, self.height - 10)];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.textColor = [UIColor blackColor];
        _textField.font = FanFont(14);
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes: @{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:FanFont(14)}];
        _textField.returnKeyType  = UIReturnKeySearch;
        _textField.delegate = self;
    }return _textField;
}
@end
