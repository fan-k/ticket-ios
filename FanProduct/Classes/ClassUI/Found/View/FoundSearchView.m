//
//  FoundSearchView.m
//  FanProduct
//
//  Created by 99epay on 2019/6/6.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FoundSearchView.h"



@interface FoundSearchView ()

@property (nonatomic ,strong) UIButton *cityButton;
@property (nonatomic ,strong) UIView *searchBgView;
@property (nonatomic ,strong) UIImageView *searchImg;
@property (nonatomic ,strong) UILabel *searchPlaceholder;
@property (nonatomic ,strong) UIView *navigationLine;
@end

@implementation FoundSearchView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.cityButton];
        [self addSubview:self.searchBgView];
        [self addSubview:self.navigationLine];
    }return self;
}
- (void)setCity:(NSString *)city{
    _city = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    [self.cityButton setTitle:_city forState:UIControlStateNormal];
}
- (void)cityClick{
    if (self.customActionBlock) {
        self.customActionBlock(self, cat_search_city);
    }
}
- (void)searchClick{
    if (self.customActionBlock) {
        self.customActionBlock(self, cat_search_ScenicSpot);
    }
}

-  (UIButton *)cityButton{
    if (!_cityButton) {
        _cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cityButton.frame = CGRectMake(15, FanNavSubViewTop(20), 60, 40);
        [_cityButton setTitle:@"上海" forState:UIControlStateNormal];
        [_cityButton.titleLabel adjustsFontSizeToFitWidth];
        [_cityButton setImage:IMAGE_WITH_NAME(@"home_xiala_1") forState:UIControlStateNormal];
        _cityButton.titleEdgeInsets = UIEdgeInsetsMake(_cityButton.titleEdgeInsets.top, -20, _cityButton.titleEdgeInsets.bottom, 25);
        _cityButton.imageEdgeInsets = UIEdgeInsetsMake(_cityButton.imageEdgeInsets.top, 35, _cityButton.imageEdgeInsets.bottom, 10);
        [_cityButton.titleLabel setFont:FanRegularFont(15)];
        [_cityButton addTarget:self action:@selector(cityClick) forControlEvents:UIControlEventTouchUpInside];
        [_cityButton setTitleColor:COLOR_PATTERN_STRING(@"_363636_color") forState:UIControlStateNormal];
    }return _cityButton;
}
- (UIView *)searchBgView{
    if (!_searchBgView) {
        _searchBgView = [[UIView alloc] initWithFrame:CGRectMake(_cityButton.right, FanNavSubViewTop(20) + 5, FAN_SCREEN_WIDTH - _cityButton.right - 20, 30)];
        _searchBgView.layer.cornerRadius = 15;
        _searchBgView.backgroundColor = COLOR_PATTERN_STRING(@"_f8f8f8_color");
        [_searchBgView addSubview:self.searchImg];
        [_searchBgView addSubview:self.searchPlaceholder];
        __weak FoundSearchView *weakSelf = self;
        _searchBgView.viewClickBlock = ^(id obj, cat_action_type idx) {
            [weakSelf searchClick];
        };
    }return _searchBgView;
}
- (UIImageView *)searchImg{
    if (!_searchImg) {
        _searchImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 16, 16)];
        _searchImg.image = IMAGE_WITH_NAME(@"sousuo");
    }return _searchImg;
}
- (UILabel *)searchPlaceholder{
    if (!_searchPlaceholder) {
        _searchPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(_searchImg.right + 5, 7, _searchBgView.width - 50, 16)];
        _searchPlaceholder.text = @"搜索关键字/目的地/名称";
        _searchPlaceholder.font = FanRegularFont(12);
        _searchPlaceholder.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
    }return _searchPlaceholder;
}
- (UIView *)navigationLine{
    if (!_navigationLine) {
        _navigationLine = [[UIView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT - FAN_LINE_HEIGHT, FAN_SCREEN_WIDTH, FAN_LINE_HEIGHT)];
        [_navigationLine setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1]];
    }
    return _navigationLine;
}
@end
