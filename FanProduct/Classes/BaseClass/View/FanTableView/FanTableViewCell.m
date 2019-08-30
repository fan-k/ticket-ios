//
//  FanTableViewCell.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/20.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "FanTableViewCell.h"

@implementation FanTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        self.backgroundColor = self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}
- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    self.contentView.backgroundColor = backgroundColor;
}
- (void)initView{}
- (void)awakeFromNib {
    [super awakeFromNib];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //更改分割线样式
     self.FanSeparatorStyle = self.FanSeparatorStyle;
//    if (self.accessoryView) {
//        self.accessoryType = self.accessoryType;
//    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.customActionBlock  = nil;
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType{
    if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        UIImage *image = [UIImage imageNamed:@"cell_accessView"];
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - 25, self.height/2 - image.size.height/2, image.size.width, image.size.height)];
        img.image = image;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = img;
    }else{
        [super setAccessoryType:accessoryType];
    }
}
- (void)setFanSeparatorStyle:(FanTableViewCellSeparatorStyle)FanSeparatorStyle{
    _FanSeparatorStyle = FanSeparatorStyle;
    if (FanSeparatorStyle == FanTableViewCellSeparatorStyle0_0) {
        self.dividingLine.hidden = NO;
        self.dividingLine.frame = CGRectMake(0, self.height - FAN_LINE_HEIGHT, self.width, FAN_LINE_HEIGHT);
    }else if (FanSeparatorStyle == FanTableViewCellSeparatorStyle15_15) {
        self.dividingLine.hidden = NO;
        self.dividingLine.frame = CGRectMake(15, self.height - FAN_LINE_HEIGHT, self.width - 30, FAN_LINE_HEIGHT);
    }else if (FanSeparatorStyle == FanTableViewCellSeparatorStyle15_0) {
        self.dividingLine.hidden = NO;
        self.dividingLine.frame = CGRectMake(15, self.height - FAN_LINE_HEIGHT, self.width - 15, FAN_LINE_HEIGHT);
    }else if (FanSeparatorStyle == FanTableViewCellSeparatorStyle0_0_15_15) {
        self.dividingLine.hidden = NO;
        self.dividingLine.frame = CGRectMake(15, 0, self.width - 30, FAN_LINE_HEIGHT);
    }else if (FanSeparatorStyle == FanTableViewCellSeparatorStyle41_15){
        self.dividingLine.hidden = NO;
        self.dividingLine.frame = CGRectMake(41, self.height - FAN_LINE_HEIGHT, self.width - 15 - 41, FAN_LINE_HEIGHT);
    }
    else {
        self.dividingLine.hidden = YES;
    }
}
- (void)setCellModel:(id)cellModel{
    _cellModel = cellModel;
    if ([self respondsToSelector:@selector(cellModel:)]) {
        [self cellModel:cellModel];
    }
}
- (UIView *)dividingLine{
    if (!_dividingLine) {
        _dividingLine = [UIView new];
        _dividingLine.backgroundColor = COLOR_PATTERN_STRING(@"_line_color");
        [self addSubview:_dividingLine];
    }return _dividingLine;
}

@end


@implementation FanNilCell
- (void)initView{
    self.backgroundColor = COLOR_PATTERN_STRING(@"_base_background_color");
}
@end


@interface FanErrorCell ()

@property (nonatomic ,strong) FanErrorView *errorView;
@end
@implementation FanErrorCell
- (void)layoutSubviews{
    [super layoutSubviews];
    self.errorView.frame = CGRectMake(0, 0, self.width, self.height);
    self.backgroundColor = [UIColor clearColor];
}
- (void)cellModel:(id)cellModel{
    FanErrorCellModel *model = cellModel;
    self.errorView.type = [model.errorType integerValue];
    self.errorView.errorTxt = model.title;
}
- (FanErrorView *)errorView{
    if (!_errorView) {
        _errorView = [FanErrorView new];
        _errorView.backgroundColor = [UIColor clearColor];
        [self addSubview:_errorView];
    }return _errorView;
}

@end

@interface FanHeaderCell()
@property (nonatomic ,strong) FanImageView *img;
@property (nonatomic ,strong) UILabel *titleLb;


@property (nonatomic ,strong) FanImageView *rightNxtImg;
@property (nonatomic ,strong) UILabel *moreTitle;

@end
@implementation FanHeaderCell

- (void)initView{
    [self addSubview:self.img];
    [self addSubview:self.titleLb];
    [self addSubview:self.rightNxtImg];
    [self addSubview:self.moreTitle];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle15_15;
    self.titleLb.left = self.img.hidden ? 15 : self.img.right + 5;
    self.img.centerY = self.titleLb.centerY = self.rightNxtImg.centerY = self.moreTitle.centerY = self.height/2;
    self.rightNxtImg.left = self.accessoryView ? self.width - 40 : self.width - 21;
    self.moreTitle.left = self.rightNxtImg.left - self.moreTitle.width - 5;
}

- (void)cellModel:(id)cellModel{
    FanHeaderModel *model = self.cellModel;
    [self.img setImageWithUrl:model.img];
    self.img.hidden = ![model.img isNotBlank];
    [self.titleLb setText:model.title];
    self.titleLb.hidden = ![model.title isNotBlank];
    self.moreTitle.hidden = self.rightNxtImg.hidden = ![model.more isNotBlank];
    [self.moreTitle setText:model.more];
    self.accessoryType = model.accessView ? UITableViewCellAccessoryDisclosureIndicator :UITableViewCellAccessoryNone ;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch  = [touches anyObject];
    CGPoint point  = [touch locationInView:self];
    FanHeaderModel *model = self.cellModel;
    if ([model.more isNotBlank] && CGRectContainsPoint(CGRectMake(_moreTitle.left, 0, self.width - _moreTitle.left, self.height), point)) {
        if (self.customActionBlock) {
            self.customActionBlock(model, cat_action_cell_click);
            return;
        }
    }
    [super touchesEnded:touches withEvent:event];
}
- (FanImageView *)img{
    if (!_img) {
        _img = [FanImageView new];
        _img.frame = CGRectMake(15, 10, 20, 20);
    }return _img;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.frame = CGRectMake(0, 10, 200, 20);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_363636_color");
        _titleLb.font = FanMediumFont(16);
    }return _titleLb;
}
- (FanImageView *)rightNxtImg{
    if (!_rightNxtImg) {
        _rightNxtImg = [FanImageView new];
        _rightNxtImg.frame = CGRectMake(self.width - 21, 10, 6, 10);
        _rightNxtImg.image = IMAGE_WITH_NAME(@"home_next_1");
    }return _rightNxtImg;
}
- (UILabel *)moreTitle{
    if (!_moreTitle) {
        _moreTitle = [UILabel new];
        _moreTitle.frame = CGRectMake(self.width - 100, 10, 80, 20);
        _moreTitle.textColor = COLOR_PATTERN_STRING(@"_fdc716_color");
        _moreTitle.font = FanRegularFont(13);
        _moreTitle.textAlignment = NSTextAlignmentRight;
    }return _moreTitle;
}
@end



@interface FanNomalCell ()
@property (nonatomic ,strong) UILabel *mainTitleLab;
@property (nonatomic ,strong) UILabel *sizeLb;
@end
@implementation FanNomalCell
- (void)initView{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle15_0;
}

- (void)cellModel:(id)cellModel{
    FanNomalModel *model =  cellModel;
    self.mainTitleLab.text = model.title;
    self.sizeLb.text  = model.descript;
}
- (UILabel *)sizeLb{
    if (!_sizeLb) {
        _sizeLb = [[UILabel alloc] initWithFrame:CGRectMake(FAN_SCREEN_WIDTH - 30 - 200, 20, 200, 18)];
        _sizeLb.textAlignment = NSTextAlignmentRight;
        _sizeLb.font = FanRegularFont(15);
        _sizeLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        [self.contentView addSubview:_sizeLb];
    }
    return _sizeLb;
}
- (UILabel *)mainTitleLab{
    if (!_mainTitleLab){
        _mainTitleLab = [[UILabel alloc]init];
        _mainTitleLab.frame = CGRectMake(24, 18, 100, 20);
        _mainTitleLab.textColor  = COLOR_PATTERN_STRING(@"_333333_color");
        _mainTitleLab.font = FanRegularFont(15);
        [self.contentView addSubview:_mainTitleLab];
    }
    return _mainTitleLab;
}

@end
