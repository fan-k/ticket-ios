//
//  OrderCell.m
//  FanProduct
//
//  Created by 99epay on 2019/7/9.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "OrderCell.h"

@implementation OrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
@interface OrderTouristInfoCell ()
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *descLb;
@property (nonatomic ,strong) UIButton *infoButton;
@property (nonatomic ,strong) OrderTouristInfoView* infoView;
@end

@implementation OrderTouristInfoCell

- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.bgView.frame =  CGRectMake(15, 10, self.width - 30, 200);
    self.titleLb.frame =  CGRectMake(15, 15, 70, 15);
    self.descLb.frame = CGRectMake(self.titleLb.right, 18, self.bgView.width - self.titleLb.right, 12);
    self.infoButton.frame =  CGRectMake(self.bgView.width - 30, 15, 17.5, 18.4);
    self.infoView.frame = CGRectMake(0, self.titleLb.bottom + 10, self.bgView.width, self.infoView.height);
    self.bgView.height = self.infoView.bottom ;
    OrderModel *model =  self.cellModel;
    model.cellHeight = self.bgView.bottom ;
}

- (void)cellModel:(id)cellModel{
    self.infoView.model = cellModel;
}
- (void)inifontt{
    if (self.customActionBlock) {
        self.customActionBlock(self.cellModel, cat_chance_touristinfo);
    }
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_PATTERN_STRING(@"_whiter_color");
        _bgView.layer.cornerRadius = 8;
        [self addSubview:_bgView];
    }return _bgView;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _titleLb.font = FanRegularFont(16);
        _titleLb.text  = @"游客信息";
        [self.bgView addSubview:_titleLb];
    }return _titleLb;
}

- (UILabel *)descLb{
    if (!_descLb) {
        _descLb = [UILabel new];
        _descLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _descLb.font = FanRegularFont(11);
        _descLb.text  = @"请填写游客信息，用于取票或入园凭证";
        [self.bgView addSubview:_descLb];
    }return _descLb;
}
- (UIButton *)infoButton{
    if (!_infoButton) {
        _infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_infoButton setImage:IMAGE_WITH_NAME(@"WechatIMG1319" ) forState:UIControlStateNormal];
        [_infoButton addTarget:self action:@selector(inifontt) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:_infoButton];
    }return _infoButton;
}

- (OrderTouristInfoView *)infoView{
    if (!_infoView) {
        _infoView = [OrderTouristInfoView new];
        __weak OrderTouristInfoCell*weakSelf = self;
        _infoView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(obj, cat_submit_touristinfo);
            }
        };
        [self.bgView addSubview:_infoView];
    }return _infoView;
}
@end

#import "FanTextField.h"
@interface OrderTouristInfoView ()
@property (nonatomic ,strong) FanTextField *nameField;
@property (nonatomic ,strong) FanTextField *phoneField;
@property (nonatomic ,strong) FanTextField *cardField;
@end
@implementation OrderTouristInfoView
- (void)initView{
    [self addSubview:self.nameField];
    [self addSubview:self.phoneField];
    [self addSubview:self.cardField];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.nameField.frame =  CGRectMake(15, 0, self.width -20, 50);
    self.phoneField.frame =  CGRectMake(15, 50, self.width -20, 50);
    self.cardField.frame =  CGRectMake(15, 100, self.width - 20, 50);
    
}
- (void)changeButtonStatus{
    if (!self.model.touristModel) {
        self.model.touristModel = [TouristModel new];
    }
    self.model.touristModel.name = self.nameField.text;
    self.model.touristModel.phone = self.phoneField.text;
    self.model.touristModel.card = self.cardField.text;
    if (self.customActionBlock) {
        self.customActionBlock(self.model.touristModel, cat_chance_touristinfo);
    }
}
- (void)setModel:(OrderModel *)model{
    _model = model;
    self.cardField.hidden = [model.UUtourist_info isEqualToString:@"0"];
    self.height =  [model.UUtourist_info isEqualToString:@"0"] ? 100: 150;
    self.nameField.text = model.touristModel.name;
    self.phoneField.text = model.touristModel.phone;
    self.cardField.text = model.touristModel.card;
}
- (FanTextField *)nameField{
    if (!_nameField) {
        _nameField = [FanTextField new];
        _nameField.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _nameField.font = FanMediumFont(16);
        _nameField.fan_placeholder_font = FanMediumFont(16);
        _nameField.placeholdercolor = COLOR_PATTERN_STRING(@"_bfbfbf_color");
        _nameField.leftViewWidth = 60;
        _nameField.leftLbTxt = @"姓名";
        _nameField.lineViewNomalColor = @"_line_color";
        _nameField.fan_placeholder = @"请输入姓名";
        __weak OrderTouristInfoView *weakSelf = self;
        _nameField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_textfield_keyboard_hide) {
                [weakSelf changeButtonStatus];
            }
        };
    }return _nameField;
}

- (FanTextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [FanTextField new];
        _phoneField.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _phoneField.font = FanMediumFont(16);
        _phoneField.fan_placeholder_font = FanMediumFont(16);
        _phoneField.placeholdercolor = COLOR_PATTERN_STRING(@"_bfbfbf_color");
        _phoneField.leftViewWidth = 60;
        _phoneField.leftLbTxt = @"手机号";
        _phoneField.style_count = YES;
        _phoneField.lineViewNomalColor = @"_line_color";
        _phoneField.fan_placeholder = @"请输入手机号";
        __weak OrderTouristInfoView *weakSelf = self;
        _phoneField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_textfield_keyboard_hide) {
                [weakSelf changeButtonStatus];
            }
        };
    }return _phoneField;
}



- (FanTextField *)cardField{
    if (!_cardField) {
        _cardField = [FanTextField new];
        _cardField.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _cardField.font = FanMediumFont(16);
        _cardField.fan_placeholder_font = FanMediumFont(16);
        _cardField.placeholdercolor = COLOR_PATTERN_STRING(@"_bfbfbf_color");
        _cardField.leftViewWidth = 60;
        _cardField.leftLbTxt = @"身份证";
        _cardField.style_count = YES;
        _cardField.lineViewNomalColor = @"_line_color";
        _cardField.fan_placeholder = @"请输入身份证号";
        __weak OrderTouristInfoView *weakSelf = self;
        _cardField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_textfield_keyboard_hide) {
                [weakSelf changeButtonStatus];
            }
        };
    }return _cardField;
}


@end

@interface OrderScenicTicketInfoCell ()
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *line1Lb;
@property (nonatomic ,strong) UILabel *dateTitleLb;
@property (nonatomic ,strong) OrderMoreDateView *moreView;

@property (nonatomic ,strong) UILabel *ticketLabelLb;

@property (nonatomic ,strong) UILabel *countTitleLb;
@property (nonatomic ,strong) FanImageView *subImg;
@property (nonatomic ,strong) UILabel *countLb;
@property (nonatomic ,strong) FanImageView *addImg;
@property (nonatomic ,strong) UILabel *countRuleLb;
@end
@implementation OrderScenicTicketInfoCell
- (void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    self.bgView.frame =  CGRectMake(15, 10, self.width - 30, 200);
    OrderModel *model =  self.cellModel;
    self.titleLb.frame = CGRectMake(10, 10, self.bgView.width  - 20, 20);
    self.line1Lb.frame = CGRectMake(10, self.titleLb.bottom + 16, self.titleLb.width, FAN_LINE_HEIGHT);
    self.dateTitleLb.frame = CGRectMake(self.titleLb.left, self.line1Lb.bottom + 15, 150, 15);
    CGFloat width = ((self.bgView.width - 90) - model.orderPriceModel.contentList.count * 5 + 5 )/model.orderPriceModel.contentList.count;
    CGFloat height = 52;
    self.moreView.frame = CGRectMake(self.bgView.width - 72, self.dateTitleLb.bottom + 15, 62, 52);
    __weak OrderScenicTicketInfoCell*weakSelf = self;
    [model.orderPriceModel.contentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        OrderDatePriceView *priceView = [self viewWithTag:111 + idx];
        if (!priceView) {
            priceView = [OrderDatePriceView new];
            priceView.tag =  111 + idx;
            [self.bgView addSubview:priceView];
            priceView.customActionBlock = ^(id obj, cat_action_type idx) {
                OrderModel *sssmodel =  weakSelf.cellModel;
                //当切换时 把上一个的数量切回1
                weakSelf.countLb.text = @"1";
                sssmodel.orderPriceModel.currentPriceModel.ticketCount = @"1";
                sssmodel.orderPriceModel.currentPriceModel = sssmodel.orderPriceModel.contentList[[obj integerValue]];
                sssmodel.orderPriceModel.currentIndex = [obj integerValue];
                [weakSelf setNeedsLayout];
                //刷新底部价格
                if (weakSelf.customActionBlock) {
                    weakSelf.customActionBlock(nil, cat_check_price_date);
                }
            };
        }
        priceView.frame = CGRectMake(self.titleLb.left + (width + 5) * idx, self.dateTitleLb.bottom + 15, width, height);
        priceView.model = obj;
        priceView.selected = model.orderPriceModel.currentIndex == idx;
    }];
    
    self.ticketLabelLb.frame = CGRectMake(self.titleLb.left, self.moreView.bottom + 10, self.titleLb.width, 20);
    self.countTitleLb.frame = CGRectMake(self.titleLb.left,self.ticketLabelLb.hidden  ? self.moreView.bottom + 15: self.ticketLabelLb.bottom + 15, 100, 20);
    self.addImg.frame = CGRectMake(self.bgView.width - 45, self.countTitleLb.centerY - 15.5, 31, 31);
    self.countLb.frame = CGRectMake(self.addImg.left - 40 , self.addImg.top, 40, 31);
    self.subImg.frame = CGRectMake(self.countLb.left - 31, self.addImg.top, 31, 31);
    self.countRuleLb.frame = CGRectMake(self.titleLb.left, self.countTitleLb.bottom + 15, self.titleLb.width, 20);
    self.bgView.height = self.countRuleLb.hidden ? self.countTitleLb.bottom + 20 : self.countRuleLb.bottom + 15;
    model.cellHeight = self.bgView.bottom;
}
- (void)cellModel:(id)cellModel{
    OrderModel *model =  cellModel;
    [self.titleLb setText:model.title];
    self.ticketLabelLb.attributedText = model.lableAtt;
    self.ticketLabelLb.hidden = !model.lableAtt.length ;
    self.countLb.text = model.orderPriceModel.currentPriceModel.ticketCount;
    self.countRuleLb.text =  model.UUbuy_limit;
    self.countRuleLb.hidden = !model.UUbuy_limit.length ;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = COLOR_PATTERN_STRING(@"_whiter_color");
        _bgView.layer.cornerRadius = 8;
        [self addSubview:_bgView];
    }return _bgView;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _titleLb.font = FanRegularFont(16);
        _titleLb.numberOfLines = 0;
        [self.bgView addSubview:_titleLb];
    }return _titleLb;
}

- (UILabel *)line1Lb{
    if (!_line1Lb) {
        _line1Lb = [UILabel new];
        _line1Lb.backgroundColor = COLOR_PATTERN_STRING(@"_line_color");
        [self.bgView addSubview:_line1Lb];
    }return _line1Lb;
}

- (UILabel *)dateTitleLb{
    if (!_dateTitleLb) {
        _dateTitleLb = [UILabel new];
        _dateTitleLb.font =  FanRegularFont(16);
        _dateTitleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _dateTitleLb.text = @"使用日期";
        [self.bgView addSubview:_dateTitleLb];
    }return _dateTitleLb;
}
- (OrderMoreDateView *)moreView{
    if (!_moreView) {
        _moreView = [OrderMoreDateView new];
        [self.bgView addSubview:_moreView];
    }return _moreView;
}

- (UILabel *)ticketLabelLb{
    if (!_ticketLabelLb) {
        _ticketLabelLb = [UILabel new];
        _ticketLabelLb.font = FanRegularFont(11);
        _ticketLabelLb.backgroundColor = COLOR_PATTERN_STRING(@"_fefbf1_color");
        _ticketLabelLb.layer.cornerRadius = 3;
        [self.bgView addSubview:_ticketLabelLb];
    }return _ticketLabelLb;
}

- (FanImageView *)subImg{
    if (!_subImg) {
        _subImg = [FanImageView new];
        _subImg.image = IMAGE_WITH_NAME(@"order_count_0");
        [self.bgView addSubview:_subImg];
        __weak OrderScenicTicketInfoCell*weakSelf = self;
        _subImg.viewClickBlock = ^(id obj, cat_action_type idx) {
            //减
            OrderModel *model =  weakSelf.cellModel;
            NSInteger count = model.orderPriceModel.currentPriceModel.ticketCount.integerValue;
            count --;
            model.orderPriceModel.currentPriceModel.ticketCount = [NSString stringWithFormat:@"%ld",count];
            [weakSelf.countLb setText:model.orderPriceModel.currentPriceModel.ticketCount];
            //刷新底部价格
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(nil, cat_check_price_date);
            }
        };
    }return _subImg;
}

- (UILabel *)countLb{
    if (!_countLb) {
        _countLb = [UILabel new];
        _countLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _countLb.font = FanRegularFont(17);
        _countLb.textAlignment= NSTextAlignmentCenter;
        [self.bgView addSubview:_countLb];
    }return _countLb;
}
- (FanImageView *)addImg{
    if (!_addImg) {
        _addImg = [FanImageView new];
        _addImg.image  = IMAGE_WITH_NAME(@"order_count_1");
        [self.bgView addSubview:_addImg];
        __weak OrderScenicTicketInfoCell*weakSelf = self;
        _addImg.viewClickBlock = ^(id obj, cat_action_type idx) {
            //加
            OrderModel *model =  weakSelf.cellModel;
            NSInteger count = model.orderPriceModel.currentPriceModel.ticketCount.integerValue;
            count ++;
            model.orderPriceModel.currentPriceModel.ticketCount = [NSString stringWithFormat:@"%ld",count];
            [weakSelf.countLb setText:model.orderPriceModel.currentPriceModel.ticketCount];
            //刷新底部价格
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(nil, cat_check_price_date);
            }
        };
    }return _addImg;
}

- (UILabel *)countTitleLb{
    if (!_countTitleLb) {
        _countTitleLb = [UILabel new];
        _countTitleLb.font =  FanRegularFont(16);
        _countTitleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _countTitleLb.text = @"购买数量";
        [self.bgView addSubview:_countTitleLb];
    }return _countTitleLb;
}

- (UILabel *)countRuleLb{
    if (!_countRuleLb) {
        _countRuleLb = [UILabel new];
        _countRuleLb.font = FanRegularFont(11);
        _countRuleLb.backgroundColor = COLOR_PATTERN_STRING(@"_fefbf1_color");
        _countRuleLb.layer.cornerRadius = 3;
        [self.bgView addSubview:_countRuleLb];
    }return _countRuleLb;
}
@end

@interface OrderDatePriceView()
@property (nonatomic ,strong) UILabel *dateLb;
@property (nonatomic ,strong) UILabel *priceLb;
@end
@implementation OrderDatePriceView
- (void)initView{
    self.layer.borderColor = COLOR_PATTERN_STRING(@"_line_color").CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.dateLb.frame = CGRectMake(0, self.height/2 - 10, self.width, 11);
    self.priceLb.frame = CGRectMake(0, self.dateLb.bottom + 5 , self.width, 11);
}
- (void)setSelected:(BOOL)selected{
    self.backgroundColor = selected ? COLOR_PATTERN_STRING(@"_fdc716_color") : COLOR_PATTERN_STRING(@"_whiter_color");
    self.priceLb.textColor = _model.canOrder ? selected ? COLOR_PATTERN_STRING(@"_363636_color") :COLOR_PATTERN_STRING(@"_red_color") : COLOR_PATTERN_STRING(@"_9a9a9a_color");
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.customActionBlock) {
        self.customActionBlock([NSString stringWithFormat:@"%ld",self.tag - 111], cat_action_click);
    }
}
- (void)setModel:(OrderPriceModel *)model{
    _model = model;
    [self.dateLb setText:[NSString stringWithFormat:@"%@%@",[FanTime dateToStr:model.date],[model.date substringFromIndex:5]]];
    if (model.canOrder) {
        [self.priceLb setText:[NSString stringWithFormat:@"￥%@",model.prize]];
        self.priceLb.textColor = COLOR_PATTERN_STRING(@"_red_color");
        self.dateLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
    }else{
        [self.priceLb setText:[NSString stringWithFormat:@"￥%@",model.prize]];
        self.priceLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        self.dateLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
    }
}
- (UILabel *)dateLb{
    if (!_dateLb) {
        _dateLb = [UILabel new];
        _dateLb.font  = FanFont(11);
        _dateLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dateLb];
    }return _dateLb;
}
- (UILabel *)priceLb{
    if (!_priceLb) {
        _priceLb = [UILabel new];
        _priceLb.font  = FanFont(11);
        _priceLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_priceLb];
    }return _priceLb;
}
@end

@interface OrderMoreDateView()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) FanImageView *moreImg;
@end
@implementation OrderMoreDateView
- (void)initView{
    self.layer.borderColor = COLOR_PATTERN_STRING(@"_line_color").CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLb.frame =  CGRectMake(self.width/2 - 20, self.height/2 - 20, 30, 40);
    self.moreImg.frame = CGRectMake(self.titleLb.right + 5, self.height/2 - 5, 6, 10);
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font  = FanFont(11);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _titleLb.text = @"更多日期";
        _titleLb.numberOfLines  = 2;
        _titleLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLb];
    }return _titleLb;
}
- (FanImageView *)moreImg{
    if (!_moreImg) {
        _moreImg = [FanImageView new];
        _moreImg.image =  IMAGE_WITH_NAME(@"order_More");
        [self addSubview:_moreImg];
    }return _moreImg;
}
@end


@interface OrderListCell ()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) FanImageView *picture;
@property (nonatomic ,strong) UILabel *statusLb;
@property (nonatomic ,strong) UILabel *countLb;
@property (nonatomic ,strong) UILabel *totalprizeLb;
@property (nonatomic ,strong) UIButton *rightButton;
@property (nonatomic ,strong) UIButton *refundButton;
@end

@implementation OrderListCell

- (void)layoutSubviews{
    [super layoutSubviews];
    self.picture.frame = CGRectMake(15, 15, 90, 66);
    self.titleLb.frame = CGRectMake(self.picture.right + 10 , self.picture.top, self.width - self.picture.right - 85, 20);
    self.totalprizeLb.frame = CGRectMake(self.titleLb.left, self.titleLb.bottom, 150, 20);
    self.countLb.frame = CGRectMake(self.totalprizeLb.left, self.totalprizeLb.bottom, 100, 20);
    self.statusLb.frame = CGRectMake(self.titleLb.right + 10, self.titleLb.top, 50, 20);
    self.rightButton.frame = CGRectMake(self.width - 75, self.picture.bottom - 18, 60, 18);
    self.refundButton.frame = CGRectMake(self.rightButton.left - 70, self.picture.bottom - 18, 60, 18);
    OrderListCellModel *model =  self.cellModel;
    model.cellHeight = self.picture.bottom + 15;
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle15_15;
}

- (void)cellModel:(id)cellModel{
    OrderListCellModel *model =  cellModel;
    [self.picture setImageWithUrl:model.picture];
    [self.titleLb setText:model.title];
    [self.statusLb setText:model.statusTxt];
    [self.countLb setText:[NSString stringWithFormat:@"张数：%@",model.count]];
    [self.totalprizeLb setText:[NSString stringWithFormat:@"总价：%@元",model.totalprice]];
    self.rightButton.hidden = ![model.rightTxt isNotBlank];
    self.refundButton.hidden = ![model.status isEqualToString:@"1"] && ![model.status isEqualToString:@"2"];
    [self.rightButton setTitle:model.rightTxt forState:UIControlStateNormal];
}

- (void)refundButtonMethod{
    //退票
    if (self.customActionBlock) {
        self.customActionBlock(self.cellModel, cat_order_refund);
    }
}
- (void)rightButtonMethod{
    OrderListCellModel *model =  self.cellModel;
    if ([model.status isEqualToString:@"0"]) {
        if (self.customActionBlock) {
            self.customActionBlock(self.cellModel, cat_order_pay_now);
        }
    }else if ([model.status isEqualToString:@"1"] || [model.status isEqualToString:@"2"]) {
        if (self.customActionBlock) {
            self.customActionBlock(self.cellModel, cat_order_ticket_out);
        }
    }else if ([model.status isEqualToString:@"3"] || [model.status isEqualToString:@"6"] || [model.status isEqualToString:@"7"]) {
        if (self.customActionBlock) {
            self.customActionBlock(self.cellModel, cat_order_evaluate);
        }
    }else if ([model.status isEqualToString:@"4"]) {
        if (self.customActionBlock) {
            self.customActionBlock(self.cellModel, cat_order_refund_cancel);
        }
    }else if ([model.status isEqualToString:@"5"]|| [model.status isEqualToString:@"8"]|| [model.status isEqualToString:@"9"]) {
        if (self.customActionBlock) {
            self.customActionBlock(self.cellModel, cat_order_buy_again);
        }
    }

}
- (FanImageView *)picture{
    if (!_picture) {
        _picture = [FanImageView new];
        _picture.placeholderImage = IMAGE_WITH_NAME(@"default_80_80");
        _picture.layer.cornerRadius = 3;
         _picture.layer.masksToBounds = YES;
        [self addSubview:_picture];
    }return _picture;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb  = [UILabel new];
        _titleLb.font = FanFont(13);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}


- (UILabel *)totalprizeLb{
    if (!_totalprizeLb) {
        _totalprizeLb  = [UILabel new];
        _totalprizeLb.font = FanFont(12);
        _totalprizeLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        [self addSubview:_totalprizeLb];
    }return _totalprizeLb;
}



- (UILabel *)countLb{
    if (!_countLb) {
        _countLb  = [UILabel new];
        _countLb.font = FanFont(12);
        _countLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        [self addSubview:_countLb];
    }return _countLb;
}



- (UILabel *)statusLb{
    if (!_statusLb) {
        _statusLb  = [UILabel new];
        _statusLb.font = FanFont(13);
        _statusLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _statusLb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_statusLb];
    }return _statusLb;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitleColor:COLOR_PATTERN_STRING(@"_red_color") forState:UIControlStateNormal];
        _rightButton.layer.borderColor = COLOR_PATTERN_STRING(@"_red_color").CGColor;
        _rightButton.layer.borderWidth = FAN_LINE_HEIGHT;
        _rightButton.layer.cornerRadius = 3;
        [_rightButton.titleLabel setFont: FanFont(12)];
        [_rightButton addTarget:self action:@selector(rightButtonMethod) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_rightButton];
    }return _rightButton;
}

- (UIButton *)refundButton{
    if (!_refundButton) {
        _refundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refundButton setTitleColor:COLOR_PATTERN_STRING(@"_888888_color") forState:UIControlStateNormal];
        _refundButton.layer.borderColor = COLOR_PATTERN_STRING(@"_888888_color").CGColor;
        _refundButton.layer.borderWidth = FAN_LINE_HEIGHT;
        _refundButton.layer.cornerRadius = 3;
        [_refundButton.titleLabel setFont: FanFont(12)];
        [_refundButton setTitle:@"退票" forState:UIControlStateNormal];
        [_refundButton addTarget:self action:@selector(refundButtonMethod) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_refundButton];
    }return _refundButton;
}
@end



@interface OrderDetailCell ()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *descriptLb;
@property (nonatomic ,strong) FanImageView *codeImg;
@end
@implementation OrderDetailCell

- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)cellModel:(id)cellModel{
    OrderDetailListCellModel *model = cellModel;
    [self.titleLb setText:model.title];
    self.descriptLb.textColor = [model.color isNotBlank] ? COLOR_PATTERN_STRING(model.color) : COLOR_PATTERN_STRING(@"_9a9a9a_color");
    [self.descriptLb setText:model.descript];
    self.descriptLb.width = FAN_SCREEN_WIDTH -15 - self.titleLb.right;
    [self.descriptLb sizeToFit];
    [self.codeImg setImageWithUrl:model.img];
    self.codeImg.top = self.descriptLb.bottom + 10;
    self.codeImg.hidden = ![model.img isNotBlank];
    if (model.separatorStyle) {
        model.cellHeight = self.codeImg.hidden  ? self.descriptLb.bottom + 15 :self.codeImg.bottom + 15;
    }else{
        model.cellHeight = self.codeImg.hidden ? self.descriptLb.bottom : self.codeImg.bottom;
    }
    self.FanSeparatorStyle = model.separatorStyle;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.frame = CGRectMake(15, 10, 80, 20);
        _titleLb.font = FanRegularFont(14);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}
- (UILabel *)descriptLb{
    if (!_descriptLb) {
        _descriptLb = [UILabel new];
        _descriptLb.font  = FanRegularFont(14);
        _descriptLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _descriptLb.frame = CGRectMake(self.titleLb.right, self.titleLb.top, FAN_SCREEN_WIDTH -15 - self.titleLb.right, 20);
        _descriptLb.numberOfLines = 0;
        _descriptLb.lineBreakMode =  NSLineBreakByCharWrapping;
        [self addSubview:_descriptLb];
    }return _descriptLb;
}
- (FanImageView *)codeImg{
    if (!_codeImg) {
        _codeImg= [FanImageView new];
        _codeImg.frame = CGRectMake(self.titleLb.right, self.descriptLb.bottom + 10, 100, 100);
        [self addSubview:_codeImg];
        __weak OrderDetailCell *weakSelf = self;
        _codeImg.viewClickBlock = ^(id obj, cat_action_type idx) {
            [WebImgScrollView showImageWithImageArr:@[weakSelf.codeImg.imgUrl]];
        };
    }return _codeImg;
}
@end
