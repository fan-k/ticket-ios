//
//  ScenicHeaderView.m
//  FanProduct
//
//  Created by 99epay on 2019/6/10.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "ScenicHeaderView.h"
#import <SDCycleScrollView.h>
#import "HomeContentCell.h"

@interface ScenicHeaderView ()<SDCycleScrollViewDelegate>
@property (nonatomic ,strong) SDCycleScrollView *ImgScrollView;

@property (nonatomic ,strong) UILabel *pictureCountLb;

@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *descriptLb;
@property (nonatomic ,strong) UILabel *infoLb;
@property (nonatomic ,strong) UILabel *scoreLb;
@property (nonatomic ,strong) UILabel *countLb;
@property (nonatomic ,strong) FanImageView *nextImg;
@property (nonatomic ,strong) UILabel *line1;
@property (nonatomic ,strong) UILabel *line2;

@property (nonatomic ,strong) HomeStarView *starView;

@end

@implementation ScenicHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = COLOR_PATTERN_STRING(@"_whiter_color");
        [self addSubview:self.ImgScrollView];
        [self addSubview:self.titleLb];
        [self addSubview:self.infoLb];
        [self addSubview:self.descriptLb];
        [self addSubview:self.line1];
        [self addSubview:self.starView];
        [self addSubview:self.scoreLb];
        [self addSubview:self.countLb];
        [self addSubview:self.nextImg];
        [self addSubview:self.line2];
        
    }return self;
}
- (void)setModel:(ScenicModel *)model{
    _model = model;
    self.ImgScrollView.imageURLStringsGroup = model.pictures;
    [self.pictureCountLb setText:[NSString stringWithFormat:@"1/%ld",self.model.pictures.count]];
    [self.titleLb setText:[NSString stringWithFormat:@"%@",model.title]];
    self.infoLb.text = [NSString stringWithFormat:@"%@开园 | 购票须知 | 游玩攻略>",model.startTime];
    self.descriptLb.text = model.desc;
    self.starView.star = [model.evaluateStar integerValue];
    self.scoreLb.text = [NSString stringWithFormat:@"%@分",model.score];
    self.countLb.text = [NSString stringWithFormat:@"%@评价",model.evaluateCount];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(CGRectMake(0, _line1.top, _line1.right, _line1.height), point)) {
        //点击左边 去景点详情页
        if (self.customActionBlock) {
            self.customActionBlock(_model, cat_scenic_info);
        }
    }else if (CGRectContainsPoint(CGRectMake(_line1.right, _line1.top, self.width - _line1.right,  _line1.height), point)){
        if (self.customActionBlock) {
            self.customActionBlock(_model, cat_scenic_evaluate);
        }
    }else{
        [super touchesEnded:touches  withEvent:event];
    }
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSMutableArray *arr=  _model.pictures.mutableCopy;
    [arr addObject:_model.pictures[index]];
    [WebImgScrollView showImageWithImageArr:arr];
}
/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    [self.pictureCountLb setText:[NSString stringWithFormat:@"%ld/%ld",index + 1,self.model.pictures.count]];
}
- (SDCycleScrollView *)ImgScrollView{
    if (!_ImgScrollView) {
        _ImgScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_WIDTH/2) delegate:self placeholderImage:nil];
        _ImgScrollView.showPageControl = NO;
        _ImgScrollView.delegate = self;
        _ImgScrollView.placeholderImage = IMAGE_WITH_NAME(@"default_375_177");
        [_ImgScrollView addSubview:self.pictureCountLb];
    }
    return _ImgScrollView;
}
- (UILabel *)pictureCountLb{
    if (!_pictureCountLb) {
        _pictureCountLb = [UILabel  new];
        _pictureCountLb.layer.cornerRadius = 10;
        _pictureCountLb.layer.masksToBounds = YES;
        _pictureCountLb.font = FanRegularFont(11);
        _pictureCountLb.textColor = COLOR_PATTERN_STRING(@"_whiter_color");
        _pictureCountLb.textAlignment = NSTextAlignmentCenter;
        [_pictureCountLb setBackgroundColor:COLOR_PATTERN_STRING(@"_cover_color")];
        _pictureCountLb.frame = CGRectMake(_ImgScrollView.width - 60, _ImgScrollView.bottom - 30, 45, 20);
    }return _pictureCountLb;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel  new];
        _titleLb.font = FanMediumFont(15);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _titleLb.frame = CGRectMake(15, _ImgScrollView.bottom + 15, self.width/2 + 20, 20);
    }return _titleLb;
}
- (UILabel *)infoLb{
    if (!_infoLb) {
        _infoLb = [UILabel new];
        _infoLb.frame = CGRectMake(_titleLb.left, _titleLb.bottom, _titleLb.width, 15);
        _infoLb.font = FanRegularFont(11);
        _infoLb.textColor = COLOR_PATTERN_STRING(@"_fdc716_color");
    }return _infoLb;
}
- (UILabel *)descriptLb{
    if (!_descriptLb) {
        _descriptLb = [UILabel new];
        _descriptLb.font = FanRegularFont(11);
        _descriptLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _descriptLb.frame = CGRectMake(_infoLb.left, _infoLb.bottom, _infoLb.width, 20);
    }return _descriptLb;
}
- (UILabel *)line1{
    if (!_line1) {
        _line1 = [UILabel new];
        _line1.frame = CGRectMake(_titleLb.right, _titleLb.top, FAN_LINE_HEIGHT, _descriptLb.bottom - _titleLb.top);
        _line1.backgroundColor = COLOR_PATTERN_STRING(@"_line_color");
    }return _line1;
}
- (HomeStarView *)starView{
    if (!_starView) {
        _starView = [[HomeStarView alloc] initWithFrame:CGRectMake(_line1.right + 10, _titleLb.top + 3, 75, 15)];
    }return _starView;
}
- (UILabel *)scoreLb{
    if (!_scoreLb) {
        _scoreLb = [UILabel new];
        _scoreLb.font = FanRegularFont(15);
        _scoreLb.textColor = COLOR_PATTERN_STRING(@"_ff8925_color");
        _scoreLb.frame = CGRectMake(_starView.right, _starView.top, self.width - _starView.right, 15);
    }return _scoreLb;
}
- (UILabel *)countLb{
    if (!_countLb) {
        _countLb = [UILabel new];
        _countLb.font = FanRegularFont(11);
        _countLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _countLb.frame = CGRectMake(_starView.left, _starView.bottom + 10, self.width - _starView.left - 30, 20);
    }return _countLb;
}
- (FanImageView *)nextImg{
    if (!_nextImg) {
        _nextImg = [FanImageView new];
        _nextImg.image = IMAGE_WITH_NAME(@"cell_accessView");
        _nextImg.frame = CGRectMake(self.width - 25, _countLb.top, 6, 10);
    }return _nextImg;
}
- (UILabel *)line2{
    if (!_line2) {
        _line2 = [UILabel new];
        _line2.frame = CGRectMake(_titleLb.left, _descriptLb.bottom + 15, self.width - 30, FAN_LINE_HEIGHT);
        _line2.backgroundColor = COLOR_PATTERN_STRING(@"_line_color");
    }return _line2;
}
@end
