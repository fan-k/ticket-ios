//
//  RefundCell.m
//  FanProduct
//
//  Created by 99epay on 2019/7/17.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "RefundCell.h"

@implementation RefundCell

@end


@interface RefundOrderInfoCell()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) FanImageView *picture;
@property (nonatomic ,strong) UILabel *countLb;
@property (nonatomic ,strong) UILabel *totalprizeLb;
@end
@implementation RefundOrderInfoCell
- (void)layoutSubviews{
    [super layoutSubviews];
    self.picture.frame = CGRectMake(15, 15, 90, 66);
    self.titleLb.frame = CGRectMake(self.picture.right + 10 , self.picture.top, self.width - self.picture.right - 85, 20);
    self.totalprizeLb.frame = CGRectMake(self.titleLb.left, self.titleLb.bottom, 150, 20);
    self.countLb.frame = CGRectMake(self.totalprizeLb.left, self.totalprizeLb.bottom, 100, 20);
    RefundOrderInfoModel *model =  self.cellModel;
    model.cellHeight = self.picture.bottom + 15;
}

- (void)cellModel:(id)cellModel{
    RefundOrderInfoModel *model =  cellModel;
    [self.picture setImageWithUrl:model.img];
    [self.titleLb setText:model.title];
    [self.countLb setText:[NSString stringWithFormat:@"张数：%@",model.count]];
    [self.totalprizeLb setText:[NSString stringWithFormat:@"总价：%@元",model.totalprice]];
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
@end


@interface RefundReasonCell()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *descLb;
@end
@implementation RefundReasonCell
- (void)initView{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLb.frame = CGRectMake(15, 15, self.width/2 -15, 20);
    self.descLb.frame = CGRectMake(self.width/2 , 15, self.width/2 - 30, 20);
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //选择退票原因
    RefundReasonModel *model  = self.cellModel;
    __weak RefundReasonCell *weakSelf = self;
    RefundChanceView *chanceView = [[UIApplication sharedApplication].keyWindow viewWithTag:1231 ];
    if (!chanceView) {
        chanceView = [[RefundChanceView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT)];
        chanceView.tag = 1231;
        [[UIApplication sharedApplication].keyWindow addSubview:chanceView];
        chanceView.customActionBlock = ^(id obj, cat_action_type idx) {
            RefundReasonModel *model  = weakSelf.cellModel;
            model.currentModel  = obj;
            weakSelf.descLb.text = model.currentModel.title;
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(@{@"refundReason":[NSString stringWithFormat:@"%@",model.currentModel.type]}, cat_refund_update_info);
            }
        };
    }
    chanceView.list = model.refundReason;
    chanceView.title = @"退票原因";
}
- (void)cellModel:(id)cellModel{
    RefundReasonModel *model =  cellModel;
    [self.descLb setText:model.currentModel ? model.currentModel.title: @"请选择"];
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanFont(13);
        _titleLb.text = @"退票原因";
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}

- (UILabel *)descLb{
    if (!_descLb) {
        _descLb = [UILabel new];
        _descLb.font = FanFont(13);
        _descLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _descLb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_descLb];
    }return _descLb;
}


@end
#import "FanTextField.h"
@interface RefundInfoCell()
@property (nonatomic ,strong) UILabel *priceTitleLb;
@property (nonatomic ,strong) UILabel *priceLb;

@property (nonatomic ,strong) UILabel *explainTitleLb;
@property (nonatomic ,strong) FanTextField *explainTextField;
@property (nonatomic ,strong) UILabel *typeTitleLb;
@property (nonatomic ,strong) UILabel *typeLb;
@end
@implementation RefundInfoCell
- (void)layoutSubviews{
    [super layoutSubviews];
    self.priceTitleLb.frame = CGRectMake(15, 15, 80, 15);
    self.priceLb.frame = CGRectMake(self.priceTitleLb.right, self.priceTitleLb.top, 80, 15);
    self.explainTitleLb.frame = CGRectMake(15, self.priceTitleLb.bottom + 15, 80, 15);
    self.explainTextField.frame = CGRectMake(self.explainTitleLb.right, self.explainTitleLb.top, self.width - 15 - self.explainTitleLb.right, 15);
    self.typeTitleLb.frame = CGRectMake(15, self.explainTitleLb.bottom + 15, 80, 15);
    self.typeLb.frame = CGRectMake(self.typeTitleLb.right, self.typeTitleLb.top, 100, 15);
    RefundInfoModel *model  = self.cellModel;
    model.cellHeight = self.typeTitleLb.bottom + 15;
}
- (void)cellModel:(id)cellModel{
    RefundInfoModel *model  = cellModel;
    self.priceLb.text = [NSString stringWithFormat:@"%@元",model.refundPrice];
    self.explainTextField.text = [model.refundExplain isNotBlank] ? model.refundExplain :@"";
    self.typeLb.text = model.currentModel ? model.currentModel.title :@"请选择退票方式";
}
- (void)chanceRefundType{
    RefundInfoModel *model  = self.cellModel;
    __weak RefundInfoCell *weakSelf = self;
    RefundChanceView *chanceView = [[UIApplication sharedApplication].keyWindow viewWithTag:1231 ];
    if (!chanceView) {
        chanceView = [[RefundChanceView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT)];
        chanceView.tag = 1231;
        chanceView.customActionBlock = ^(id obj, cat_action_type idx) {
            RefundInfoModel *model  = weakSelf.cellModel;
            model.currentModel  = obj;
            weakSelf.typeLb.text = model.currentModel.title;
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(@{@"refundType":[NSString stringWithFormat:@"%@",model.currentModel.type]}, cat_refund_update_info);
            }
        };
        [[UIApplication sharedApplication].keyWindow addSubview:chanceView];
    }
    chanceView.list = model.refundType;
    chanceView.title = @"退票方式";
}
- (UILabel *)priceTitleLb{
    if (!_priceTitleLb) {
        _priceTitleLb = [UILabel new];
        _priceTitleLb.font = FanRegularFont(13);
        _priceTitleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _priceTitleLb.text = @"退票方式";
        [self addSubview:_priceTitleLb];
    }return _priceTitleLb;
}
- (UILabel *)priceLb{
    if (!_priceLb) {
        _priceLb = [UILabel new];
        _priceLb.font  = FanRegularFont(13);
        _priceLb.textColor  = COLOR_PATTERN_STRING(@"_red_color");
        [self addSubview:_priceLb];
    }return _priceLb;
}
- (UILabel *)explainTitleLb{
    if (!_explainTitleLb) {
        _explainTitleLb = [UILabel new];
        _explainTitleLb.font = FanRegularFont(13);
        _explainTitleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _explainTitleLb .text = @"退票说明";
        [self addSubview:_explainTitleLb];
    }return _explainTitleLb;
}
- (FanTextField *)explainTextField{
    if (!_explainTextField) {
        _explainTextField = [FanTextField new];
        _explainTextField.fan_placeholder_font = FanRegularFont(13);
        _explainTextField.textColor = COLOR_PATTERN_STRING(@"_8c8c8c_color");
        _explainTextField.fan_placeholder = @"请输入退票说明";
        [self addSubview:_explainTextField];
        __weak RefundInfoCell* weakSelf = self;
        _explainTextField.customActionBlock = ^(id obj, cat_action_type idx) {
            RefundInfoModel *model  = weakSelf.cellModel;
            model.refundExplain = weakSelf.explainTextField.text;
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(@{@"refundExpalin":[NSString stringWithFormat:@"%@",weakSelf.explainTextField.text]}, cat_refund_update_info);
            }
        };
    }return _explainTextField;
}
- (UILabel *)typeTitleLb{
    if (!_typeTitleLb) {
        _typeTitleLb = [UILabel new];
        _typeTitleLb.font =  FanRegularFont(13);
        _typeTitleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _typeTitleLb.text = @"退票方式";
        [self addSubview:_typeTitleLb];
    }return _typeTitleLb;
}
- (UILabel *)typeLb{
    if (!_typeLb) {
        _typeLb = [UILabel new];
        _typeLb.font = FanRegularFont(13);
        _typeLb.textColor = COLOR_PATTERN_STRING(@"_8c8c8c_color");
        [self addSubview:_typeLb];
        __weak RefundInfoCell *weakSelf = self;
        _typeLb.viewClickBlock = ^(id obj, cat_action_type idx) {
            [weakSelf chanceRefundType];
        };
    }return _typeLb;
}
@end


@interface RefundChanceView ()
@property (nonatomic ,strong) FanTableView *tableView;
@property (nonatomic ,strong) UIButton *subButton;
@property (nonatomic ,strong) RefundChanceHeader *headerView;
@property (nonatomic ,strong) RefundChanceCellModel *currentModel;
@end

@implementation RefundChanceView
- (void)initView{
    self.backgroundColor = COLOR_PATTERN_STRING(@"_cover_color");
    [self addSubview:self.tableView];
    [self addSubview:self.subButton];
}
- (void)setTitle:(NSString *)title{
    self.headerView.title = title;
}

- (void)setList:(NSArray *)list{
    _list = list;
    NSMutableArray *contentList = [NSMutableArray array];
    for (NSDictionary *json in list) {
        RefundChanceCellModel *model = [RefundChanceCellModel modelWithJson:json];
        if (model) {
            [contentList addObject:model];
        }
    }
    [self.tableView.viewModel setList:contentList type:0];
    self.tableView.frame = CGRectMake(0, self.height - self.subButton.height - self.tableView.contentSize.height, self.width, self.tableView.contentSize.height);
}
- (void)reloadList:(id)obj{
    if (self.currentModel) {
        self.currentModel.selected = NO;
    }
    RefundChanceCellModel *model = obj;
    model.selected = YES;
    self.currentModel = model;
    [self.tableView reloadData];
}
- (void)submit{
    if (self.currentModel) {
        if (self.customActionBlock) {
            self.customActionBlock(self.currentModel, cat_submit_order);
        }
        [self removeFromSuperview];
    }else{
        [FanAlert alertMessage:@"您尚未选择" type:AlertMessageTypeNomal];
    }
}
- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [FanTableView new];
        _tableView.frame = CGRectMake(0, 0, self.width, 0);
        __weak  RefundChanceView *weakSelf = self;
        _tableView.fanTableViewHeightBlock = ^CGFloat(id obj, int idx) {
            return 45;
        };
        _tableView.fanTableViewBlock = ^id(id obj, int idx) {
            return weakSelf.headerView;
        };
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            [weakSelf reloadList:obj];
        };
    }return _tableView;
}
- (UIButton *)subButton{
    if (!_subButton) {
        _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _subButton.frame = CGRectMake(0, FAN_SCREEN_HEIGHT - FAN_TABBAR_HEIGHT, FAN_SCREEN_WIDTH, FAN_TABBAR_HEIGHT);
        [_subButton setBackgroundColor:COLOR_PATTERN_STRING(@"_yellow_color")];
        [_subButton setTitle:@"确定" forState:UIControlStateNormal];
        [_subButton.titleLabel setFont:FanRegularFont(16)];
        [_subButton setTitleColor:COLOR_PATTERN_STRING(@"_363636_color") forState:UIControlStateNormal];
        [_subButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    }return _subButton;
}
- (RefundChanceHeader *)headerView{
    if (!_headerView) {
        _headerView = [[RefundChanceHeader alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, 45)];
        __weak  RefundChanceView *weakSelf = self;
        _headerView.customActionBlock = ^(id obj, cat_action_type idx) {
            [weakSelf removeFromSuperview];
        };
    }return _headerView;
}
@end



@interface RefundChanceCell()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) FanImageView *img;
@end
@implementation RefundChanceCell

- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLb.frame = CGRectMake(15, self.height/2 - 10, 200, 20);
    self.img.frame = CGRectMake(self.width - 30, self.height/2 - 6, 12, 12);
}

- (void)cellModel:(id)cellModel{
    RefundChanceCellModel *model = cellModel;
    [self.titleLb setText:model.title];
    self.img.image = model.selected ? IMAGE_WITH_NAME(@"order_select_1") : IMAGE_WITH_NAME(@"order_select_0");
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanRegularFont(16);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}
- (FanImageView *)img{
    if (!_img) {
        _img = [FanImageView new];
        [self addSubview:_img];
    }return _img;
}
@end

@interface RefundChanceHeader()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) FanImageView *closeImg;
@end
@implementation RefundChanceHeader
- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = COLOR_PATTERN_STRING(@"_line_color").CGColor;
    self.layer.borderWidth = FAN_LINE_HEIGHT;
    [self addSubview:self.titleLb];
    [self addSubview:self.closeImg];
}

- (void)setTitle:(NSString *)title{
    [self.titleLb setText:title];
}
- (void)close{
    if (self.customActionBlock) {
        self.customActionBlock(nil, cat_close);
    }
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanRegularFont(16);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.frame = CGRectMake(self.width/2 - 50, self.height/2 - 10, 100, 20);
    }return _titleLb;
}
- (FanImageView *)closeImg{
    if (!_closeImg) {
        _closeImg = [FanImageView new];
        _closeImg.image  = IMAGE_WITH_NAME(@"nav_close");
        _closeImg.frame = CGRectMake(self.width - 30, self.height/2 - 6, 12, 12);
        __weak RefundChanceHeader *weakSelf = self;
        _closeImg.viewClickBlock = ^(id obj, cat_action_type idx) {
            [weakSelf close];
        };
    }return _closeImg;
}

@end


@interface RefundFlowHeaderCell()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *explainLb;

@end

@implementation RefundFlowHeaderCell

- (void)initView{
    self.backgroundColor = COLOR_PATTERN_STRING(@"_fdc716_color");
    [self addSubview:self.titleLb];
    [self addSubview:self.explainLb];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    RefundDetailHeaderModel *model = self.cellModel;
    model.cellHeight = self.explainLb.bottom + 15;
}

- (void)cellModel:(id)cellModel{
    RefundDetailHeaderModel *model = cellModel;
    [self.titleLb setText:model.title];
    [self.explainLb setText:[NSString stringWithFormat:@"预计%@到账",[FanTime TimeIntervalIntoString:model.expectTime.integerValue formatter:@"YYYY年MM月DD日"]]];
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanRegularFont(16);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_whiter_color");
        _titleLb.frame = CGRectMake(15, 15, 200, 15);
    }return _titleLb;
}
- (UILabel *)explainLb{
    if (!_explainLb) {
        _explainLb = [UILabel new];
        _explainLb.font = FanRegularFont(13);
        _explainLb.textColor = COLOR_PATTERN_STRING(@"_whiter_color");
        _explainLb.frame = CGRectMake(15, self.titleLb.bottom + 10, self.width - 30, 15);
    }return _explainLb;
}
@end

@interface RefundFlowCell ()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *timeLb;
@property (nonatomic ,strong) UILabel *explainLb;
@end

@implementation RefundFlowCell

- (void)initView{
    [self addSubview:self.titleLb];
    [self addSubview:self.timeLb];
    [self addSubview:self.explainLb];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    RefundDetailFlowModel *model = self.cellModel;
    model.cellHeight = self.explainLb.bottom + 15;
}

- (void)cellModel:(id)cellModel{
    RefundDetailFlowModel *model = cellModel;
    [self.titleLb setText:model.title];
    [self.timeLb setText:model.time];
    [self.explainLb setText:model.descript];
    self.explainLb.width = self.width - 30;
    [self.explainLb sizeToFit];
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanRegularFont(16);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _titleLb.frame = CGRectMake(15, 15, 200, 15);
    }return _titleLb;
}
- (UILabel *)timeLb{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.font = FanRegularFont(13);
        _timeLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _timeLb.frame = CGRectMake(15, self.titleLb.bottom + 10, 200, 15);
    }return _timeLb;
}
- (UILabel *)explainLb{
    if (!_explainLb) {
        _explainLb = [UILabel new];
        _explainLb.font = FanRegularFont(13);
        _explainLb.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
        _explainLb.frame = CGRectMake(15, self.timeLb.bottom + 10, self.width - 30, 15);
        _explainLb.numberOfLines = 0;
        [_explainLb sizeToFit];
    }return _explainLb;
}
@end

