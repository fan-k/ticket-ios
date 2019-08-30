//
//  HomeSectionHeaderView.m
//  FanProduct
//
//  Created by 99epay on 2019/6/6.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "HomeSectionHeaderView.h"

@interface HomeSectionHeaderView ()
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIView *lineView;
@property (nonatomic ,strong) UIView *bottomlineView;
@end

@implementation HomeSectionHeaderView


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        weak_self
        self.resultActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_scrollView_didScroll) {
                [weakSelf buttonClick:[weakSelf viewWithTag:[obj integerValue] + 100]];
            }
        };
        [self addSubview:self.scrollView];
        [self addSubview:self.bottomlineView];
    }return self;
}
- (void)initButton{
    __block CGFloat left = 10;
    [self.model.contentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HomeSectionHeaderModel *model = obj;
        CGFloat width = self.buttonWidth ? self.buttonWidth : model.titleWidth;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(left, 0, width, self.height);
        [button setTitle:model.title forState:UIControlStateNormal];
        [button setTitleColor:COLOR_PATTERN_STRING(@"_363636_color") forState:UIControlStateNormal];
        if (idx == 0) {
            [button.titleLabel setFont:FanMediumFont(16)];
            self.lineView.width =  [FanSize getWidthWithString:model.title fontSize:15];
            self.lineView.centerX = button.centerX;
            [button setTitleColor:COLOR_PATTERN_STRING(@"_fdc716_color") forState:UIControlStateNormal];
        }else{
            [button.titleLabel setFont:FanRegularFont(15)];
        }
        left += width;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + idx;
        [self.scrollView addSubview:button];
    }];
    self.scrollView.contentSize = CGSizeMake(left + 10, self.height);
}
- (void)buttonClick:(UIButton *)button{
    UIButton *laseBtn = [self viewWithTag:100 + self.selectIndex];
    [laseBtn.titleLabel setFont:FanRegularFont(15)];
    [laseBtn setTitleColor:COLOR_PATTERN_STRING(@"_363636_color") forState:UIControlStateNormal];
    [button setTitleColor:COLOR_PATTERN_STRING(@"_fdc716_color") forState:UIControlStateNormal];
    [button.titleLabel setFont:FanMediumFont(16)];
    HomeSectionHeaderModel *model = self.model.contentList[button.tag - 100];
    self.lineView.width =  [FanSize getWidthWithString:model.title fontSize:15];
    self.lineView.centerX = button.centerX;
    self.selectIndex = button.tag - 100;
}
- (void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    self.model.currentIndex = selectIndex;
    //变button
    if (self.customActionBlock) {
        self.customActionBlock([NSString stringWithFormat:@"%ld",(long)selectIndex], cat_action_click);
    }
}
- (void)setMenus:(NSArray *)menus{
    _menus = menus;
    [menus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HomeSectionHeaderModel *model1 = [HomeSectionHeaderModel modelWithJson:obj];
        [self.model.contentList addObject:model1];
    }];
    [self initButton];
}
- (HomeSectionHeaderModel *)model{
    if (!_model) {
        _model = [HomeSectionHeaderModel new];
    }return _model;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake((FAN_SCREEN_WIDTH/self.model.contentList.count)/2  - 25, self.height /2 + 15, 50, 2)];
        _lineView.backgroundColor = COLOR_PATTERN_STRING(@"_fdc716_color");
        _lineView.layer.cornerRadius = 1;
        _lineView.layer.masksToBounds = YES;
        [self.scrollView addSubview:_lineView];
    }return _lineView;
}

- (UIView *)bottomlineView{
    if (!_bottomlineView) {
        _bottomlineView = [[UIView alloc] initWithFrame:CGRectMake(15,self.height - FAN_LINE_HEIGHT,self.width - 30,FAN_LINE_HEIGHT)];
        _bottomlineView.backgroundColor = COLOR_PATTERN_STRING(@"_line_color");
    }return _bottomlineView;
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width , self.height - FAN_LINE_HEIGHT)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
@end
