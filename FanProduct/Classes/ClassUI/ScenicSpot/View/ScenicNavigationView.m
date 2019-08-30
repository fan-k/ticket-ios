//
//  ScenicNavigationView.m
//  FanProduct
//
//  Created by 99epay on 2019/6/10.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "ScenicNavigationView.h"

@interface ScenicNavigationView ()
@property (nonatomic ,strong) UILabel *titlelb;
@property (nonatomic ,strong) UIButton *leftButton;
@property (nonatomic ,strong) UIButton *collectButton;
//@property (nonatomic ,strong) UIButton *shareButton;
@property (nonatomic ,strong) UIView *navigationLine;
@property (nonatomic ,strong) CAGradientLayer * gradient;

@end

@implementation ScenicNavigationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = self.bounds;
        gradient.colors = @[(id)[UIColor clearColor].CGColor,(id)[UIColor clearColor].CGColor];
        gradient.startPoint = CGPointMake(1, 1);
        gradient.endPoint = CGPointMake(0, 0);
        [self.layer addSublayer:gradient];
        self.gradient = gradient;
        [self addSubview:self.leftButton];
        [self addSubview:self.titlelb];
        [self addSubview:self.collectButton];
        [self addSubview:self.navigationLine];
    }return self;
}


- (void)setAlpha:(CGFloat)alpha{
    UIColor *startColor =  [UIColor colorWithRed:253/255.0 green:192/255.0 blue:22/255.0 alpha:alpha];
    UIColor *endColor =  [UIColor colorWithRed:254/255.0 green:231/255.0 blue:15/255.0 alpha:alpha];
    self.gradient.colors = @[(id)startColor.CGColor,(id)endColor.CGColor];
    _navigationLine.alpha = alpha;
    _titlelb.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:alpha];
    if (alpha <= 0.5) {
        [_leftButton setImage:[UIImage imageNamed:@"home_back"] forState:UIControlStateNormal] ;
        _leftButton.imageView.alpha = 1 - alpha;
        [_collectButton setImage:[UIImage imageNamed:@"home_collect_0"] forState:UIControlStateNormal] ;
        [_collectButton setImage:[UIImage imageNamed:@"home_collect_0_1"] forState:UIControlStateSelected] ;
        _collectButton.imageView.alpha = 1 - alpha;
    }else{
        [_leftButton setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal] ;
        _leftButton.imageView.alpha =  alpha;
        [_collectButton setImage:[UIImage imageNamed:@"home_collect_1_0"] forState:UIControlStateNormal] ;
        [_collectButton setImage:[UIImage imageNamed:@"home_collect_1_1"] forState:UIControlStateSelected] ;
        _collectButton.imageView.alpha =  alpha;
    }
}

- (void)leftClick{
    if (self.customActionBlock) {
        self.customActionBlock(self, cat_nav_left_click);
    }
}
- (void)setScenicModel:(ScenicModel *)scenicModel{
    _scenicModel = scenicModel;
    //查询收藏信息
    self.collectButton.selected  = [[FanDataBase shareInstance] selectedCollectWidthId:scenicModel.o_id];
    //加入浏览记录
    [[FanDataBase shareInstance] deleteHistoryWidthId:scenicModel.o_id];
    [[FanDataBase shareInstance] insertHistoryWidthId:_scenicModel.o_id title:_scenicModel.title picture:_scenicModel.pictures[0] url:_scenicModel.urlScheme star:_scenicModel.star sellCount:_scenicModel.sellCount distance:_scenicModel.distance score:_scenicModel.score recommend:_scenicModel.recommend price:_scenicModel.price];
}
- (void)collectClick{
    //本地收藏
    if (_collectButton.selected) {
        //取消收藏
        [[FanDataBase shareInstance] deleteCollectWidthId:_scenicModel.o_id];
        [FanAlert alertMessage:@"取消收藏" type:AlertMessageTypeNomal];
    }else{
        //k加入收藏
        if (_scenicModel) {
            [[FanDataBase shareInstance] insertCollectWidthId:_scenicModel.o_id title:_scenicModel.title picture:_scenicModel.pictures[0] url:_scenicModel.urlScheme star:_scenicModel.star sellCount:_scenicModel.sellCount distance:_scenicModel.distance score:_scenicModel.score recommend:_scenicModel.recommend price:_scenicModel.price];
            [FanAlert alertMessage:@"收藏成功" type:AlertMessageTypeNomal];
        }
    }
    _collectButton.selected  = !_collectButton.selected;
}

-  (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, FanNavSubViewTop(20), 59, 44);
        UIImage *image = [UIImage imageNamed:@"home_back"];
        _leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 16, 21);
        [_leftButton setImage:image forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftClick) forControlEvents:UIControlEventTouchUpInside];
    }return _leftButton;
}
- (UIButton *)collectButton{
    if (!_collectButton) {
        _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectButton.frame = CGRectMake(FAN_SCREEN_WIDTH - 54, FanNavSubViewTop(20), 44, 44);
        UIImage *image = [UIImage imageNamed:@"home_collect_0"];
        _collectButton.imageEdgeInsets = UIEdgeInsetsMake(0, 16, 16, 0);
        [_collectButton setImage:image forState:UIControlStateNormal];
        [_collectButton setImage:[UIImage imageNamed:@"home_collect_0_1"] forState:UIControlStateSelected];
        [_collectButton addTarget:self action:@selector(collectClick) forControlEvents:UIControlEventTouchUpInside];
    }return _collectButton;
}
- (UILabel *)titlelb{
    if (!_titlelb) {
        _titlelb = [[UILabel alloc] initWithFrame:CGRectMake(self.width/2 - 80, FanNavSubViewTop(20), 160, 40)];
        _titlelb.text = @"景点详情";
        _titlelb.textAlignment = NSTextAlignmentCenter;
        _titlelb.font = FanBoldFont(18);
        _titlelb.textColor =[UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:0];
    }return _titlelb;
}
- (UIView *)navigationLine{
    if (!_navigationLine) {
        _navigationLine = [[UIView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT - FAN_LINE_HEIGHT, FAN_SCREEN_WIDTH, FAN_LINE_HEIGHT)];
        [_navigationLine setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        _navigationLine.alpha = 0;
    }
    return _navigationLine;
}
@end
