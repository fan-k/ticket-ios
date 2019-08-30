//
//  FoundCollectionCell.m
//  FanProduct
//
//  Created by 99epay on 2019/7/1.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FoundCollectionCell.h"


@interface FoundCollectionCell ()
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) FanImageView *imgView;
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *prizeLb;
@property (nonatomic ,strong) UIView *youhuiLb;
@end

@implementation FoundCollectionCell
- (void)layoutSubviews{
    [super layoutSubviews];
    self.bgView.frame = CGRectMake(0, 0, self.width, self.height);
    self.imgView.frame = CGRectMake(0, 0, self.width, self.width);
    self.titleLb.frame = CGRectMake(10, self.imgView.bottom + 10, self.width - 20, 40);
    self.prizeLb.frame = CGRectMake(self.titleLb.left, self.titleLb.bottom , self.titleLb.width, 20);
}
- (void)setCellModel:(id)cellModel{
    HomeContentModel *model = cellModel;
    [self.imgView setImageWithUrl:model.picture];
    [self.titleLb setText:model.title];
    [self.prizeLb setAttributedText:model.found_price_att];
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_PATTERN_STRING(@"_whiter_color");
        _bgView.layer.cornerRadius  = 6;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
    }return _bgView;
}

- (FanImageView *)imgView{
    if (!_imgView) {
        _imgView = [FanImageView new];
        [self.bgView addSubview:_imgView];
    }return _imgView;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.numberOfLines = 2;
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _titleLb.font =  FanRegularFont(13);
        _titleLb.lineBreakMode = NSLineBreakByWordWrapping;
        [self.bgView addSubview:_titleLb];
    }return _titleLb;
}

- (UILabel *)prizeLb{
    if (!_prizeLb) {
        _prizeLb = [UILabel new];
        [self.bgView addSubview:_prizeLb];
    }return _prizeLb;
}
@end
