//
//  HomeContentCell.m
//  FanProduct
//
//  Created by 99epay on 2019/6/6.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "HomeContentCell.h"
#import <SDCycleScrollView.h>


@interface HomeContentCell ()
@property (nonatomic ,strong) FanImageView *img;
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *labelLb;
@property (nonatomic ,strong) UILabel *recommendLb;
@property (nonatomic ,strong) UILabel *countLb;
@property (nonatomic ,strong) UILabel *distanceLb;
@property (nonatomic ,strong) UILabel *priceLb;
@property (nonatomic ,strong) HomeStarView *starView;
@end

@implementation HomeContentCell

- (void)layoutSubviews{
    [super layoutSubviews];
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle15_15;
    self.img.frame = CGRectMake(15, 15, FanWidth(109), FanWidth(109));
    self.titleLb.frame = CGRectMake(self.img.right + 10, 15, self.width - 25 - self.img.right, 20);
    self.distanceLb.frame = CGRectMake(self.titleLb.left , self.titleLb.bottom, self.titleLb.width, 20);
    self.starView.frame = CGRectMake(self.titleLb.left, self.distanceLb.bottom + 5, 80, 40);
    self.recommendLb.frame = CGRectMake(self.starView.right, self.starView.top, self.width - 15 - self.starView.right, 20);
    self.priceLb.frame = CGRectMake(self.starView.left, self.img.bottom - 25, 100, 20);
    self.countLb.frame = CGRectMake(self.priceLb.right, self.priceLb.top, self.width - 15 - self.priceLb.right, 20);
}
- (void)cellModel:(id)cellModel{
    HomeContentModel *model = cellModel;
    [self.img setImageWithUrl:model.picture];
    [self.titleLb setText:model.title];
    [self.distanceLb setText:model.distance_star_att];
    self.priceLb.attributedText = model.price_att;
    self.recommendLb.attributedText = model.recommend_score_att;
    [self.countLb setText:[NSString stringWithFormat:@"已售%@件",model.sellCount]];
    self.starView.star = [model.star integerValue];
}
- (FanImageView *)img{
    if (!_img) {
        _img = [FanImageView new];
        _img.layer.cornerRadius = 8;
        _img.placeholderImage = IMAGE_WITH_NAME(@"default_80_80");
        _img.layer.masksToBounds = YES;
        [self addSubview:_img];
    }return _img;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanRegularFont(14);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}
- (UILabel *)distanceLb{
    if (!_distanceLb) {
        _distanceLb = [UILabel new];
        _distanceLb.font = FanRegularFont(12);
        _distanceLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        [self addSubview:_distanceLb];
    }return _distanceLb;
}

- (UILabel *)recommendLb{
    if (!_recommendLb) {
        _recommendLb = [UILabel new];
        _recommendLb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_recommendLb];
    }return _recommendLb;
}
- (HomeStarView *)starView{
    if (!_starView) {
        _starView = [HomeStarView new];
        [self addSubview:_starView];
    }return _starView;
}

- (UILabel *)priceLb{
    if (!_priceLb) {
        _priceLb = [UILabel new];
        [self addSubview:_priceLb];
    }return _priceLb;
}

- (UILabel *)countLb{
    if (!_countLb) {
        _countLb = [UILabel new];
        _countLb.font = FanRegularFont(11);
        _countLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _countLb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_countLb];
    }return _countLb;
}
@end

@implementation HomeStarView
- (void)setStar:(NSInteger)star{
    _star =  star;
    for (int i = 0; i < 5;  i ++) {
        FanImageView *starImg = [self viewWithTag:212 + i];
        if (!starImg) {
            starImg = [[FanImageView alloc] initWithFrame:CGRectMake(15 * i, 0, 13, 13)];
            starImg.tag = 212 + i;
            [self addSubview:starImg];
        }
        if (i < star) {
            starImg.image = IMAGE_WITH_NAME(@"home_star_1");
        }else
            starImg.image = IMAGE_WITH_NAME(@"home_star_0");
    }
}
@end

@interface HomeSliderCell ()<SDCycleScrollViewDelegate>
@property (nonatomic ,strong) SDCycleScrollView *ImgScrollView;
@end
@implementation HomeSliderCell
- (void)cellModel:(id)cellModel{
    HomeCellTypeModel *model = cellModel;
    self.ImgScrollView.imageURLStringsGroup = model.imgUrls;
}
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    HomeCellTypeModel *model = self.cellModel;
    HomeContentModel *contentModel = model.contentList[index];
    if (self.customActionBlock) {
        self.customActionBlock(contentModel, cat_action_cell_click);
    }
}
- (SDCycleScrollView *)ImgScrollView{
    if (!_ImgScrollView) {
        _ImgScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_WIDTH/2) delegate:self placeholderImage:nil];
        _ImgScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _ImgScrollView.placeholderImage = IMAGE_WITH_NAME(@"default_375_177");
        _ImgScrollView.currentPageDotColor = COLOR_PATTERN_STRING(@"_yellow_color");
        _ImgScrollView.pageDotColor = COLOR_PATTERN_STRING(@"_ffffff_color");
//        _ImgScrollView.currentPageDotImage = [UIImage imageNamed:@"home_banner_currentpage"];
//        _ImgScrollView.pageDotImage = [UIImage imageNamed:@"home_banner_page"];
        _ImgScrollView.delegate = self;
    }
    [self addSubview:_ImgScrollView];
    return _ImgScrollView;
}
@end
@interface HomeToolsCell ()
@property (nonatomic ,strong) UIView *bgView;
@end

@implementation HomeToolsCell
- (void)initView{
    self.backgroundColor = [UIColor clearColor];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.bgView.frame = CGRectMake(15, 5, self.width - 30, self.height - 10);
}
- (void)cellModel:(id)cellModel{
    HomeCellTypeModel *model = cellModel;
    for (UIView * view in self.bgView.subviews) {
        if ([view isKindOfClass:[HomeToolsView class]]) {
            view.hidden = YES;
        }
    }
    __weak HomeToolsCell *weakSelf = self;
    for (int i = 0 ; i < model.contentList.count; i ++) {
        HomeContentModel *hotModel = model.contentList[i];
        HomeToolsView *button = [self.bgView viewWithTag:101 + i];
        if (!button) {
            button = [HomeToolsView new];
            button.tag = 101 + i;
            button.customActionBlock = ^(id obj, cat_action_type idx) {
                if (weakSelf.customActionBlock) {
                    weakSelf.customActionBlock(obj, idx);
                }
            };
            [self.bgView addSubview:button];
        }
        button.hidden =  NO;
        [button setModel:hotModel];
        button.frame = CGRectMake(hotModel.left, hotModel.top, hotModel.width, hotModel.width);
    }
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_PATTERN_STRING(@"_ffffff_color");
        _bgView.layer.cornerRadius = 8;
        [self addSubview:_bgView];
    }return _bgView;
}
@end

@interface HomeToolsView ()
@property (nonatomic ,strong) FanImageView *img;
@property (nonatomic ,strong) UILabel *titleLb;
@end
@implementation HomeToolsView

- (void)layoutSubviews{
    [super layoutSubviews];
    self.img.frame = CGRectMake(20, 10, self.width - 40, self.width - 40);
    self.img.layer.cornerRadius = self.img.width/7 * 3;
    self.img.layer.masksToBounds  = YES;
    self.titleLb.frame = CGRectMake(0, self.img.bottom, self.width, 20);
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.customActionBlock) {
        self.customActionBlock(self.model, cat_action_cell_click);
    }
}
- (void)setModel:(HomeContentModel *)model{
    _model = model;
    [self.img setImageWithUrl:model.picture];
    [self.titleLb setText:model.title];
}
- (FanImageView *)img{
    if (!_img) {
        _img = [FanImageView new] ;
        _img.placeholderImage = IMAGE_WITH_NAME(@"default_80_80");
        [self addSubview:_img];
    }return _img;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.font = FanRegularFont(12);
        [self addSubview:_titleLb];
    }return _titleLb;
}

@end

@interface HomeRecommendCell ()
@property (nonatomic ,strong) UIScrollView *scrollView;
@end
@implementation HomeRecommendCell

- (void)cellModel:(id)cellModel{
    HomeCellTypeModel *model = cellModel;
    for (UIView *view in self.scrollView.subviews) {
        view.hidden = YES;
    }
    __weak HomeRecommendCell *weakSelf  =self;
    for (int i = 0; i < model.contentList.count; i ++) {
        HomeContentModel *contentModel = model.contentList[i];
        HomeRecommendView *view = [self.scrollView viewWithTag:111 + i];
        if (!view) {
            view = [[HomeRecommendView alloc] initWithFrame:CGRectMake(15 * (i + 1) + FanWidth(263) * i, 0, FanWidth(263), FanHeight(194))];
            view.customActionBlock = ^(id obj, cat_action_type idx) {
                if (weakSelf.customActionBlock) {
                    weakSelf.customActionBlock(obj, idx);
                }
            };
            view.tag = 111 + i;
            [self.scrollView addSubview:view];
        }
        view.frame = CGRectMake(15 * (i + 1) + FanWidth(263) * i, 0, FanWidth(263), FanHeight(194));
        view.hidden = NO;
        view.model = contentModel;
    }
    self.scrollView.contentSize = CGSizeMake(FanWidth(263) * model.contentList.count + 15 * model.contentList.count + 15, self.scrollView.height);
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0, 0, self.width, self.height);
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = COLOR_PATTERN_STRING(@"_base_background_color");
        [self addSubview:_scrollView];
    }return _scrollView;
}
@end


@interface HomeRecommendView ()
@property (nonatomic ,strong) FanImageView *img;
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *descLb;
@property (nonatomic ,strong) UILabel *labelLb;
@end
@implementation HomeRecommendView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        self.backgroundColor = COLOR_PATTERN_STRING(@"_ffffff_color");
        [self addSubview:self.img];
        [self addSubview:self.labelLb];
        [self addSubview:self.titleLb];
        [self addSubview:self.labelLb];
    }return self;
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.customActionBlock) {
        self.customActionBlock(self.model, cat_action_cell_click);
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.img.frame = CGRectMake(0, 0, self.width, FanHeight(130));
    self.labelLb.frame = CGRectMake(10, self.img.bottom - 30, 70, 20);
    self.titleLb.frame = CGRectMake(10, self.img.bottom + 5, self.width - 20, 20);
    self.descLb.frame = CGRectMake(10, self.titleLb.bottom, self.titleLb.width, 20);
}
-  (void)setModel:(HomeContentModel *)model{
    _model = model;
    [self.img setImageWithUrl:model.picture];
    [self.labelLb setText:model.discount];
    [self.labelLb setHidden:![model.discount isNotBlank]];
    [self.titleLb setText:model.title];
    [self.descLb setText:model.descript];
}
- (FanImageView *)img{
    if (!_img) {
        _img = [FanImageView new];
        _img.placeholderImage = IMAGE_WITH_NAME(@"default_375_177");
    }return _img;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _titleLb.font = FanRegularFont(13);
    }return _titleLb;
}
- (UILabel *)descLb{
    if (!_descLb) {
        _descLb = [UILabel new];
        _descLb.textColor = COLOR_PATTERN_STRING(@"_999999_color");
        _descLb.font = FanRegularFont(12);
    }return _descLb;
}
- (UILabel *)labelLb{
    if (!_labelLb) {
        _labelLb = [UILabel new];
        _labelLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _labelLb.textAlignment = NSTextAlignmentCenter;
        _labelLb.font = FanMediumFont(13);
        _labelLb.backgroundColor = COLOR_PATTERN_STRING(@"_yellow_color");
        _labelLb.layer.cornerRadius = 6;
        _labelLb.layer.masksToBounds = YES;
    }return _labelLb;
}
@end


@interface HomeRecommendNearCell()
@property (nonatomic ,strong) FanImageView *img;
@property (nonatomic ,strong) FanImageView *adressIcon;
@property (nonatomic ,strong) UILabel *titleLb;
@end

@implementation HomeRecommendNearCell
- (void)layoutSubviews{
    [super layoutSubviews];
    self.img.frame = CGRectMake(15, 0, self.width - 30, self.height - 10);
    self.adressIcon .frame = CGRectMake(25, self.img.bottom - 20, 13, 10);
    self.titleLb.frame = CGRectMake(40, self.img.bottom - 20, self.width - 60, 20);
    self.backgroundColor = [UIColor clearColor];
}
- (void)cellModel:(id)cellModel{
    HomeContentModel *model = cellModel;
    [self.img setImageWithUrl:model.picture];
    [self.titleLb setText:model.title];
}
- (FanImageView *)img{
    if (!_img) {
        _img = [FanImageView new] ;
        _img.layer.cornerRadius = 8;
        _img.layer.masksToBounds  = YES;
        _img.placeholderImage = IMAGE_WITH_NAME(@"default_375_177");
        [self addSubview:_img];
    }return _img;
}
- (FanImageView *)adressIcon{
    if (!_adressIcon) {
        _adressIcon = [FanImageView new] ;
        _adressIcon.image = IMAGE_WITH_NAME(@"xiala");
        [self addSubview:_adressIcon];
    }return _adressIcon;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanRegularFont(13);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_ffffff_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}

@end

@interface HomeHeaderCell()
@property (nonatomic ,strong) UILabel *titleLb;
@end

@implementation HomeHeaderCell
- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.titleLb.frame = CGRectMake(15, 12, 200, 20);
}
- (void)cellModel:(id)cellModel{
    HomeHeaderModel *model = cellModel;
    [self.titleLb setText:model.title];
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textAlignment = NSTextAlignmentLeft;
        _titleLb.font = FanMediumFont(16);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}
@end
