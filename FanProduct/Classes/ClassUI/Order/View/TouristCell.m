//
//  TouristCell.m
//  FanProduct
//
//  Created by 99epay on 2019/7/11.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "TouristCell.h"

@interface TouristCell ()
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) FanImageView *selectImg;
@property (nonatomic ,strong) UILabel *nameLb;
@property (nonatomic ,strong) UILabel *phoneLb;
@property (nonatomic ,strong) UILabel *cardLb;
@property (nonatomic ,strong) UILabel *alertLb;
@property (nonatomic ,strong) UIButton *editButton;
@end

@implementation TouristCell
- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.bgView.frame = CGRectMake(15, 0, self.width - 30, self.height - 10);
    self.nameLb.frame = CGRectMake(40, 15, self.bgView.width - 80, 20);
    self.phoneLb.frame = CGRectMake(self.nameLb.left, self.nameLb.bottom + 5, self.nameLb.width, self.nameLb.height);
    self.cardLb.frame = CGRectMake(self.phoneLb.left, self.phoneLb.bottom + 5, self.phoneLb.width, self.phoneLb.height);
    self.alertLb.frame = CGRectMake(self.phoneLb.left, self.phoneLb.bottom + 5, 150, self.phoneLb.height);
    self.selectImg.frame = CGRectMake(10, self.bgView.height/2 - 10, 20, 20);
    self.editButton.frame = CGRectMake(self.bgView.width - 50, self.height/2 - 10, 40, 20);
}
- (void)cellModel:(id)cellModel{
    TouristModel *model = cellModel;
    [self.nameLb setText:model.name];
    [self.phoneLb setText:[NSString stringWithFormat:@"手机号：%@",model.phone]];
    [self.cardLb setText:[NSString stringWithFormat:@"身份证号：%@",model.card]];
    if (model.UUtourist_info.integerValue > 0) {//需要验证
        self.cardLb.hidden = ![model.card isNotBlank];
    }else{
        self.cardLb.hidden = YES;
    }
    if (model.selected && ![model.card isNotBlank] && model.UUtourist_info.integerValue > 0) {
        self.alertLb.hidden = NO;
    }else{
        self.alertLb.hidden = YES;
    }
    self.selectImg.image = model.selected ? IMAGE_WITH_NAME(@"order_select_1") :IMAGE_WITH_NAME(@"order_select_0");
}
- (void)edit{
    if (self.customActionBlock) {
        self.customActionBlock(self.cellModel, cat_action_click);
    }
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.masksToBounds = YES;
        _bgView.backgroundColor = COLOR_PATTERN_STRING(@"_whiter_color");
        [self addSubview:_bgView];
    }return _bgView;
}
- (FanImageView *)selectImg{
    if (!_selectImg) {
        _selectImg = [FanImageView new];
        _selectImg.image = IMAGE_WITH_NAME(@"order_select_0");
        [self.bgView addSubview:_selectImg];
    }return _selectImg;
}
- (UILabel *)nameLb{
    if (!_nameLb) {
        _nameLb = [UILabel new];
        _nameLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _nameLb.font =  FanRegularFont(13);
        [self.bgView addSubview:_nameLb];
    }return _nameLb;
}

- (UILabel *)phoneLb{
    if (!_phoneLb) {
        _phoneLb = [UILabel new];
        _phoneLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _phoneLb.font =  FanRegularFont(13);
        [self.bgView addSubview:_phoneLb];
    }return _phoneLb;
}

- (UILabel *)cardLb{
    if (!_cardLb) {
        _cardLb = [UILabel new];
        _cardLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _cardLb.font =  FanRegularFont(13);
        [self.bgView addSubview:_cardLb];
    }return _cardLb;
}

- (UILabel *)alertLb{
    if (!_alertLb) {
        _alertLb = [UILabel new];
        _alertLb.layer.cornerRadius = 3;
        _alertLb.layer.borderColor = COLOR_PATTERN_STRING(@"_red_color").CGColor;
        _alertLb.layer.borderWidth =  FAN_LINE_HEIGHT;
        _alertLb.textColor = COLOR_PATTERN_STRING(@"_red_color");
        _alertLb.font = FanFont(12);
        _alertLb.textAlignment = NSTextAlignmentCenter;
        _alertLb.text = @"证件待完善，请点击补充";
        __weak TouristCell*weakSelf = self;
        _alertLb.viewClickBlock = ^(id obj, cat_action_type idx) {
            [weakSelf edit];
        };
        [self.bgView addSubview:_alertLb];
    }return _alertLb;
}

- (UIButton *)editButton{
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitleColor:COLOR_PATTERN_STRING(@"_363636_color") forState:UIControlStateNormal];
        [_editButton.titleLabel setFont:FanRegularFont(12)];
        _editButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _editButton.contentVerticalAlignment =  UIControlContentVerticalAlignmentCenter;
        [_editButton addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_editButton];
    }return _editButton;
}
@end


@interface TouristAddCell ()
@property (nonatomic ,strong) UIButton * addButton;
@end
@implementation TouristAddCell

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.addButton.frame = CGRectMake(15, 10, self.width - 30, 40);
    TouristAddModel *model = self.cellModel;
    model.cellHeight = 60;
}
- (void)add{
    if (self.customActionBlock) {
        self.customActionBlock(self.cellModel, cat_action_cell_click);
    }
}
- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.layer.cornerRadius = 5;
        _addButton.layer.masksToBounds = YES;
        [_addButton setBackgroundColor:COLOR_PATTERN_STRING(@"_whiter_color")];
        [_addButton setTitle:@"新增常用取票人" forState:UIControlStateNormal];
        [_addButton setTitleColor:COLOR_PATTERN_STRING(@"_363636_color") forState:UIControlStateNormal];
        [_addButton.titleLabel setFont:FanRegularFont(12)];
        [_addButton setImage:IMAGE_WITH_NAME(@"") forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addButton];
    }return _addButton;
}
@end
