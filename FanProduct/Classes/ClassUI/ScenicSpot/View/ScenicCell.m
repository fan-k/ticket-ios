//
//  ScenicCell.m
//  FanProduct
//
//  Created by 99epay on 2019/6/10.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "ScenicCell.h"

@interface ScenicCell ()

@end

@implementation ScenicCell

@end


@interface ScenicTicketCell ()
@property (nonatomic ,strong) UILabel *recommandLb;
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) FanImageView *orderImg;
@property (nonatomic ,strong) UILabel *orderLb;
@property (nonatomic ,strong) UILabel *sellCountLb;
@property (nonatomic ,strong) UILabel *priceLb;
@property (nonatomic ,strong) UILabel *discountLb;
@property (nonatomic ,strong) UIButton *orderButton;
@end
@implementation ScenicTicketCell

- (void)layoutSubviews{
    [super layoutSubviews];
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle15_15;
    ScenicTicketModel *model = self.cellModel;
    self.recommandLb.frame = CGRectMake(15, 15, model.recommand.length * 10 + 9, 14);
    self.recommandLb.hidden = ![model.recommand isNotBlank];
    self.titleLb.frame = CGRectMake(self.recommandLb.hidden ? 15 : self.recommandLb.right + 3, 15, self.recommandLb.hidden ? self.width - 100 : self.width - 100 - self.recommandLb.width, 15);
    self.orderImg.frame = CGRectMake(15, self.titleLb.bottom + 9, 13, 13);
    self.orderLb.frame = CGRectMake(self.orderImg.right + 5, self.orderImg.top, self.width - 100 -self.orderImg.right - 5, 13);
    self.orderImg.hidden  = self.orderLb.hidden = ![model.orderTxt isNotBlank];
    
    self.sellCountLb.frame = CGRectMake(15, self.height - 28, self.width - 100, 13);
    self.discountLb.frame = CGRectMake(self.width - 80, self.height/2 - 6, 65, 12);
    self.discountLb.hidden  = ![model.discount isNotBlank];
    self.priceLb.frame = CGRectMake(self.width - 80, self.discountLb.hidden ? self.height/2 - 20: self.discountLb.top - 20, 65, 15);
    self.orderButton.frame = CGRectMake(self.width - 80, self.discountLb.hidden ? self.height/2 + 5: self.discountLb.bottom + 5, 65, 27);
    self.orderButton.backgroundColor = model.canOrder ? COLOR_PATTERN_STRING(@"_ff8925_color") :COLOR_PATTERN_STRING(@"_line_color");
}
- (void)cellModel:(id)cellModel{
    ScenicTicketModel *model = cellModel;
    self.recommandLb.text = model.recommand;
    [self.titleLb setText:model.title];
    [self.orderLb setText:model.orderTxt];
    [self.sellCountLb setText:[NSString stringWithFormat:@"已售%@ | 购票须知",model.sellCount]];
    [self.priceLb setAttributedText:model.price_att];
    [self.discountLb setText:model.discount];
    CGFloat height = 30;
    if ([model.orderTxt isNotBlank]) {
        height = 51;
    }
    for (UIView *view in self.subviews) {
        if (view.tag >= 111) {
            view.hidden =  YES;
        }
    }
    CGFloat width = 15;
    for (int i = 0; i < model.labels.count; i ++) {
        UILabel *label = [self viewWithTag:111 + i];
        if (!label) {
            label = [UILabel new];
            label.layer.cornerRadius = 1;
            label.layer.borderColor = COLOR_PATTERN_STRING(@"_35b5f8_color").CGColor;
            label.layer.borderWidth = FAN_LINE_HEIGHT;
            label.layer.masksToBounds = YES;
            label.textColor = COLOR_PATTERN_STRING(@"_35b5f8_color");
            label.font = FanRegularFont(10);
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 111 + i;
            [self addSubview:label];
        }
        label.hidden = NO;
        NSString *labelText = model.labels[i];
        label.frame = CGRectMake(width ,height + 9,labelText.length * 10 + 8,12);
        label.text = labelText;
        width += label.width + 5;
    }
}

- (void)order{
    ScenicTicketModel *model = self.cellModel;
    if (model.canOrder) {
        if (self.customActionBlock) {
            self.customActionBlock(model.o_id, cat_scenic_order);
        }
    }
}

- (UILabel *)recommandLb{
    if (!_recommandLb) {
        _recommandLb = [UILabel new];
        _recommandLb.layer.cornerRadius = 3;
        _recommandLb.layer.masksToBounds = YES;
        _recommandLb.backgroundColor = COLOR_PATTERN_STRING(@"_yellow_color");
        _recommandLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _recommandLb.font = FanRegularFont(10);
        _recommandLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_recommandLb];
    }return _recommandLb;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanRegularFont(12);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}
- (FanImageView *)orderImg{
    if (!_orderImg) {
        _orderImg = [FanImageView new];
        _orderImg.image = IMAGE_WITH_NAME(@"home_order_img");
        [self addSubview:_orderImg];
    }return _orderImg;
}
- (UILabel *)orderLb{
    if (!_orderLb) {
        _orderLb = [UILabel new];
        _orderLb.font = FanRegularFont(11);
        _orderLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        [self addSubview:_orderLb];
    }return _orderLb;
}
- (UILabel *)sellCountLb{
    if (!_sellCountLb) {
        _sellCountLb = [UILabel new];
        _sellCountLb.font = FanRegularFont(12);
        _sellCountLb.textColor = COLOR_PATTERN_STRING(@"_999999_color");
        [self addSubview:_sellCountLb];
        __weak ScenicTicketCell *weakself = self;
        _sellCountLb.viewClickBlock = ^(id obj, cat_action_type idx) {
            if (weakself.customActionBlock) {
                weakself.customActionBlock(weakself, cat_scenic_info);
            }
        };
    }return _sellCountLb;
}
- (UILabel *)priceLb{
    if (!_priceLb) {
        _priceLb = [UILabel new];
        _priceLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_priceLb];
    }return _priceLb;
}
- (UILabel *)discountLb{
    if (!_discountLb) {
        _discountLb = [UILabel new];
        _discountLb.font = FanRegularFont(11);
        _discountLb.textColor = COLOR_PATTERN_STRING(@"_fdc716_color");
        _discountLb.textAlignment = NSTextAlignmentCenter;
        _discountLb.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_discountLb];
    }return _discountLb;
}
- (UIButton *)orderButton{
    if (!_orderButton) {
        _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _orderButton.layer.cornerRadius = 3;
        _orderButton.layer.masksToBounds = YES;
        [_orderButton setBackgroundColor:COLOR_PATTERN_STRING(@"_ff8925_color")];
        [_orderButton setTitleColor:COLOR_PATTERN_STRING(@"_whiter_color") forState:UIControlStateNormal];
        [_orderButton.titleLabel setFont:FanRegularFont(13)];
        [_orderButton setTitle:@"立即预定" forState:UIControlStateNormal];
        [_orderButton addTarget:self action:@selector(order) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_orderButton];
    }return _orderButton;
}
@end

@interface ScenicAdressCell ()
@property (nonatomic ,strong) FanImageView *adressImg;
@property (nonatomic ,strong) UILabel *adressLb;
@end
@implementation ScenicAdressCell
- (void)initView{
    self.backgroundColor = COLOR_PATTERN_STRING(@"_whiter_color");
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self addSubview:self.adressImg];
    [self addSubview:self.adressLb];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle15_15;
}
- (void)cellModel:(id)cellModel{
    ScenicAdressModel *model = cellModel;
    [self.adressLb setText:model.adress];
    self.adressLb.height = model.adressHeight;
    self.adressImg.centerY = self.adressLb.centerY;
}
- (FanImageView *)adressImg{
    if (!_adressImg) {
        _adressImg = [FanImageView new];
        _adressImg.image = IMAGE_WITH_NAME(@"home_adress");
        _adressImg.frame = CGRectMake(15, 10, 10, 13);
    }return _adressImg;
}
- (UILabel *)adressLb{
    if (!_adressLb) {
        _adressLb = [UILabel new];
        _adressLb.frame = CGRectMake(30, 10, FAN_SCREEN_WIDTH - 60,20);
        _adressLb.font = FanFont(13);
        _adressLb.numberOfLines = 0;
        _adressLb.lineBreakMode =  NSLineBreakByCharWrapping;
        _adressLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
    }return _adressLb;
}
@end


@interface ScenicInfoCell ()
@property (nonatomic ,strong) UILabel *titleLb1;
@property (nonatomic ,strong) UILabel *titleLb2;
@property (nonatomic ,strong) UILabel *titleLb3;


@property (nonatomic ,strong) UILabel *descriptlb1;
@property (nonatomic ,strong) UILabel *descriptlb2;
@property (nonatomic ,strong) UILabel *descriptlb3;


@end
@implementation ScenicInfoCell
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLb2.top = self.descriptlb1.bottom + 10;
    self.descriptlb2.top = self.titleLb2.top;
    self.titleLb3.top = self.descriptlb2.bottom + 10;
    self.descriptlb3.top = self.titleLb3.top;
    ScenicInfoModel *model = self.cellModel;
    model.cellHeight = self.descriptlb3.bottom + 15;
}
- (void)cellModel:(id)cellModel{
    ScenicInfoModel *model = cellModel;
    self.descriptlb1.width = FAN_SCREEN_WIDTH - self.titleLb1.right - 15;
    self.descriptlb1.text = model.discount;
    [self.descriptlb1 sizeToFit];
    self.descriptlb2.width = FAN_SCREEN_WIDTH - self.titleLb1.right - 15;
    self.descriptlb2.text = model.timeTxt;
    [self.descriptlb2 sizeToFit];
    self.descriptlb3.width = FAN_SCREEN_WIDTH - self.titleLb1.right - 15;
    self.descriptlb3.text = model.duration;
    [self.descriptlb3 sizeToFit];
}

- (UILabel *)titleLb1{
    if (!_titleLb1) {
        _titleLb1 = [UILabel new];
        _titleLb1.frame = CGRectMake(15, 15, 80, 15);
        _titleLb1.font =  FanRegularFont(13);
        _titleLb1.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _titleLb1.text  = @"优惠政策";
        [self addSubview:_titleLb1];
    }return _titleLb1;
}
- (UILabel *)titleLb2{
    if (!_titleLb2) {
        _titleLb2 = [UILabel new];
        _titleLb2.frame = CGRectMake(15, self.descriptlb1.bottom + 10, 80, 15);
        _titleLb2.font =  FanRegularFont(13);
        _titleLb2.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _titleLb2.text  = @"开放时间";
        [self addSubview:_titleLb2];
    }return _titleLb2;
}
- (UILabel *)titleLb3{
    if (!_titleLb3) {
        _titleLb3 = [UILabel new];
        _titleLb3.frame = CGRectMake(15, self.descriptlb2.bottom + 10, 80, 15);
        _titleLb3.font =  FanRegularFont(13);
        _titleLb3.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _titleLb3.text  = @"使用时长";
        [self addSubview:_titleLb3];
    }return _titleLb3;
}
- (UILabel *)descriptlb1{
    if (!_descriptlb1) {
        _descriptlb1 = [UILabel new];
        _descriptlb1.frame = CGRectMake(self.titleLb1.right , self.titleLb1.top, FAN_SCREEN_WIDTH - self.titleLb1.right - 15, 15);
        _descriptlb1.font =  FanRegularFont(13);
        _descriptlb1.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _descriptlb1.numberOfLines = 0;
        [self addSubview:_descriptlb1];
    }return _descriptlb1;
}
- (UILabel *)descriptlb2{
    if (!_descriptlb2) {
        _descriptlb2 = [UILabel new];
        _descriptlb2.frame = CGRectMake(self.titleLb2.right , self.titleLb2.top, FAN_SCREEN_WIDTH - self.titleLb2.right - 15, 15);
        _descriptlb2.font =  FanRegularFont(13);
        _descriptlb2.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _descriptlb2.numberOfLines = 0;
        [self addSubview:_descriptlb2];
    }return _descriptlb2;
}
- (UILabel *)descriptlb3{
    if (!_descriptlb3) {
        _descriptlb3 = [UILabel new];
        _descriptlb3.frame = CGRectMake(self.titleLb3.right , self.titleLb3.top, FAN_SCREEN_WIDTH - self.titleLb3.right - 15, 15);
        _descriptlb3.font =  FanRegularFont(13);
        _descriptlb3.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _descriptlb3.numberOfLines = 0;
        [self addSubview:_descriptlb3];
    }return _descriptlb3;
}
@end



#import "HomeContentCell.h"
@interface ScenicEvaluateCell ()
@property (nonatomic ,strong) FanImageView *accountImg;
@property (nonatomic ,strong) UILabel *nameLb;
@property (nonatomic ,strong) UILabel *timeLb;
@property (nonatomic ,strong) UILabel *contentLb;

@property (nonatomic ,strong) HomeStarView *starView;

@property (nonatomic ,strong) UIView *imgBgView;
@end

@implementation ScenicEvaluateCell
- (void)layoutSubviews{
    [super layoutSubviews];
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle15_15;
    self.imgBgView.top = self.contentLb.bottom + 10;
    ScenicEvaluateModel *model = self.cellModel;
    model.cellHeight = self.imgBgView.bottom + 15;
}

- (void)cellModel:(id)cellModel{
    ScenicEvaluateModel *model = cellModel;
    [self.accountImg setImageWithUrl:model.img];
    [self.nameLb setText:model.name];
    [self.timeLb setText:model.time];
    self.starView.star = [model.evaluateStar integerValue];
    [self.contentLb setText:model.content];
    self.contentLb.width = FAN_SCREEN_WIDTH - 15 - self.nameLb.left;
    [self.contentLb sizeToFit];
    for (UIView *subView in self.imgBgView.subviews) {
        subView.hidden = YES;
    }
    CGFloat height = 0;
    for (int i = 0; i < model.imgs.count; i ++) {
        FanImageView *img = [self viewWithTag:111 + i];
        if (!img) {
            img = [FanImageView new];
            img.tag = 111 + i;
            img.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
            [img addGestureRecognizer:tap];
            [self.imgBgView addSubview:img];
        }
        //设置frame
        img.frame = [self rectWithIdx:i];
        img.hidden = NO;
        [img setImageWithUrl:model.imgs[i]];
        height = img.bottom;
    }
    self.imgBgView.height = height;
}
- (CGRect)rectWithIdx:(NSUInteger)idx{
    CGFloat width = (self.imgBgView.width - 24)/5;
    CGFloat height = width;
    NSUInteger index = idx%5;
    NSUInteger hang = idx/5;
    return CGRectMake(index * width + index * 6, hang * (height + 5), width, height);
}
- (void)imageTap:(UITapGestureRecognizer *)tap{
    UIView *img = tap.view;
    NSUInteger tag = img.tag - 111;
    ScenicEvaluateModel *model = self.cellModel;
    NSMutableArray *arr = [NSMutableArray arrayWithArray:model.imgs];
    [arr addObject:model.imgs[tag]];
    [WebImgScrollView showImageWithImageArr:arr];
}
- (UIView *)imgBgView{
    if (!_imgBgView) {
        _imgBgView = [UIView new];
        CGFloat width = FAN_SCREEN_WIDTH - self.contentLb.left - 15;
        _imgBgView.frame = CGRectMake(self.contentLb.left, self.contentLb.bottom + 10, width, width/5);
        [self addSubview:_imgBgView];
    }return _imgBgView;
}
- (FanImageView *)accountImg{
    if (!_accountImg) {
        _accountImg = [FanImageView new];
        _accountImg.frame = CGRectMake(15, 15, 21, 21);
        _accountImg.layer.cornerRadius = _accountImg.width/2;
        _accountImg.layer.masksToBounds = YES;
        _accountImg.placeholderImage = IMAGE_WITH_NAME(@"default_80_80");
        [self addSubview:_accountImg];
    }return _accountImg;
}
- (UILabel *)nameLb{
    if (!_nameLb) {
        _nameLb = [UILabel new];
        _nameLb.frame = CGRectMake(self.accountImg.right + 5, 15, 200, 15);
        _nameLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _nameLb.font = FanFont(13);
        [self addSubview:_nameLb];
    }return _nameLb;
}
- (UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.frame = CGRectMake(self.nameLb.right, self.nameLb.top, FAN_SCREEN_WIDTH - self.nameLb.right - 15, 15);
        _timeLb.textColor = COLOR_PATTERN_STRING(@"_bfbfbf_color");
        _timeLb.textAlignment = NSTextAlignmentRight;
        _timeLb.font = FanFont(10);
        [self addSubview:_timeLb];
    }return _timeLb;
}
- (HomeStarView *)starView{
    if (!_starView) {
        _starView = [[HomeStarView alloc] initWithFrame:CGRectMake(self.nameLb.left, self.nameLb.bottom + 7, 75, 15)];
        [self addSubview:_starView];
    }return _starView;
}
- (UILabel *)contentLb{
    if (!_contentLb) {
        _contentLb = [UILabel new];
        _contentLb.frame = CGRectMake(self.nameLb.left, self.starView.bottom + 8, FAN_SCREEN_WIDTH - 15 - self.nameLb.left, 40);
        _contentLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _contentLb.font = FanRegularFont(13);
        _contentLb.numberOfLines = 0;
        [self addSubview:_contentLb];
    }return _contentLb;
}
@end

@implementation ScenicEvaluateLabelCell
//- (void)layoutSubviews{
//    [super layoutSubviews];
//    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle15_15;
//}

- (void)cellModel:(id)cellModel{
    ScenicEvaluateLabelModel *model = cellModel;
    for (UIView *view in self.subviews) {
        view.hidden = YES;
    }
    for (int i = 0; i < model.contentList.count; i ++) {
        ScenicEvaluateLabelModel *labelModel = model.contentList[i];
        UILabel *label = [self viewWithTag: 111 + i];
        if (!label) {
            label = [UILabel new];
            label.layer.cornerRadius = 15;
            label.layer.borderColor = COLOR_PATTERN_STRING(@"_fdc716_color").CGColor;
            label.layer.borderWidth = FAN_LINE_HEIGHT;
            label.layer.masksToBounds = YES;
            label.textColor = COLOR_PATTERN_STRING(@"_fdc716_color");
            label.font = FanRegularFont(13);
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 111 + i;
            [self addSubview:label];
        }
        label.hidden = NO;
        NSString *labelText = labelModel.title;
        label.frame = CGRectMake(labelModel.cellLeft ,labelModel.cellTop + 15,labelModel.titleWidth,30);
        label.text = labelText;
        
    }
}
@end



@interface ScenicSonEvaluateCell()
@property (nonatomic ,strong) FanImageView *accountImg;
@property (nonatomic ,strong) UILabel *nameLb;
@property (nonatomic ,strong) UILabel *timeLb;
@property (nonatomic ,strong) UILabel *contentLb;

@end

@implementation ScenicSonEvaluateCell
- (void)layoutSubviews{
    [super layoutSubviews];
    ScenicSonEvaluateModel *model = self.cellModel;
    model.cellHeight = self.contentLb.bottom + 15;
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle41_15;
}

- (void)cellModel:(id)cellModel{
    ScenicSonEvaluateModel *model = cellModel;
    [self.accountImg setImageWithUrl:model.img];
    [self.nameLb setText:model.name];
    [self.timeLb setText:model.time];
    [self.contentLb setText:model.content];
    self.contentLb.width = FAN_SCREEN_WIDTH - 15 - self.nameLb.left;
    [self.contentLb sizeToFit];
    
}
- (FanImageView *)accountImg{
    if (!_accountImg) {
        _accountImg = [FanImageView new];
        _accountImg.frame = CGRectMake(41, 15, 21, 21);
        _accountImg.layer.cornerRadius = _accountImg.width/2;
        _accountImg.layer.masksToBounds = YES;
        _accountImg.placeholderImage = IMAGE_WITH_NAME(@"default_80_80");
        [self addSubview:_accountImg];
    }return _accountImg;
}
- (UILabel *)nameLb{
    if (!_nameLb) {
        _nameLb = [UILabel new];
        _nameLb.frame = CGRectMake(self.accountImg.right + 5, 15, 200, 15);
        _nameLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _nameLb.font = FanFont(13);
        [self addSubview:_nameLb];
    }return _nameLb;
}
- (UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.frame = CGRectMake(self.nameLb.right, self.nameLb.top, FAN_SCREEN_WIDTH - self.nameLb.right - 15, 15);
        _timeLb.textColor = COLOR_PATTERN_STRING(@"_bfbfbf_color");
        _timeLb.textAlignment = NSTextAlignmentRight;
        _timeLb.font = FanFont(10);
        [self addSubview:_timeLb];
    }return _timeLb;
}

- (UILabel *)contentLb{
    if (!_contentLb) {
        _contentLb = [UILabel new];
        _contentLb.frame = CGRectMake(self.nameLb.left, self.nameLb.bottom + 8, FAN_SCREEN_WIDTH - 15 - self.nameLb.left, 40);
        _contentLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _contentLb.font = FanRegularFont(13);
        _contentLb.numberOfLines = 0;
        [self addSubview:_contentLb];
    }return _contentLb;
}
@end
