//
//  MineCell.m
//  FanProduct
//
//  Created by 99epay on 2019/6/12.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "MineCell.h"
#import "MineHeaderView.h"

@interface MineCell ()
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) MineToolView *walletView;
@property (nonatomic ,strong) MineToolView *bankView;
@property (nonatomic ,strong) MineToolView *kefuView;
@property (nonatomic ,strong) MineToolView *aboutView;

@end
@implementation MineCell

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.bgView.frame = CGRectMake(15, 0, self.width - 30, self.height);
    self.titleLb.frame = CGRectMake(15, 15, 150, 15);
    self.walletView.frame = CGRectMake(0, 40, self.bgView.width/4, self.bgView.height - 40);
    self.bankView.frame = CGRectMake(self.walletView.right, 40, self.bgView.width/4, self.bgView.height - 40);
    self.kefuView.frame = CGRectMake(self.bankView.right, 40, self.bgView.width/4, self.bgView.height - 40);
    self.aboutView.frame = CGRectMake(self.kefuView.right, 40, self.bgView.width/4, self.bgView.height - 40);
}
- (void)cellModel:(id)cellModel{
    MineModel *model = cellModel;
    [self.titleLb setText:model.title];
    self.walletView.dict = model.contentList[0];
    self.bankView.dict = model.contentList[1];
    self.kefuView.dict = model.contentList[2];
    self.aboutView.dict = model.contentList[3];
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.cornerRadius = 8;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
    }return _bgView;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _titleLb.font = FanBoldFont(15);
        [self.bgView addSubview:_titleLb];
    }return _titleLb;
}


- (MineToolView *)walletView{
    if (!_walletView) {
        _walletView = [MineToolView new];
        __weak MineCell *weakSelf = self;
        _walletView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(obj, cat_action_cell_click);
            }
        };
        [self.bgView addSubview:_walletView];
    }return _walletView;
}

- (MineToolView *)bankView{
    if (!_bankView) {
        _bankView = [MineToolView new];
        __weak MineCell *weakSelf = self;
        _bankView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(obj, cat_action_cell_click);
            }
        };
        [self.bgView addSubview:_bankView];
    }return _bankView;
}

- (MineToolView *)kefuView{
    if (!_kefuView) {
        _kefuView = [MineToolView new];
        __weak MineCell *weakSelf = self;
        _kefuView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(obj, cat_action_cell_click);
            }
        };
        [self.bgView addSubview:_kefuView];
    }return _kefuView;
}


- (MineToolView *)aboutView{
    if (!_aboutView) {
        _aboutView = [MineToolView new];
        __weak MineCell *weakSelf = self;
        _aboutView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(obj, cat_action_cell_click);
            }
        };
        [self.bgView addSubview:_aboutView];
    }return _aboutView;
}
@end


@interface MineListCell ()
@property (nonatomic ,strong) FanImageView *img;
@end

@implementation MineListCell

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.img.frame = CGRectMake(15, 0, self.width - 30, self.height);
}
- (void)cellModel:(id)cellModel{
    MineListCellModel *model = cellModel;
    [self.img  setImageWithUrl:model.picture];
    
}

- (FanImageView *)img{
    if (!_img) {
        _img = [FanImageView new];
        [self addSubview:_img];
    }return _img;
}
@end
