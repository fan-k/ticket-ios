//
//  BankController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "BankController.h"

@interface BankController ()
@property (nonatomic ,strong) FanTableView *tableView;
@end
@implementation BankController
- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"我的银行卡";
    [self initBankList];
}
- (void)initBankList{
    self.params[@"token"]  = [UserInfo shareInstance].userModel.token;
    [self requestWithUrl:FanUrlUserBankList object:nil loading:YES error:FanErrorTypeTopAlert];
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    BankCardModel *model = [BankCardModel modelWithJson:item.responseObject];
    [model.contentList addObject:[BankAddModel modelWithJson:@{@"title":@"添加银行卡"}]];
    [self.tableView.viewModel setList:model.contentList type:0];
}
- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        __weak BankController *weakSelf = self;
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_cell_click || idx == cat_action_click) {
                FanModel *model = obj;
                [weakSelf pushViewControllerWithUrl:model.urlScheme transferData:nil hander:nil];
            }
        };
        _tableView.headRefreshblock = ^{
            [weakSelf initBankList];
        };
    }return _tableView;
}
@end





@interface BankAddCell()
@property (nonatomic ,strong) UIButton *addButton;
@end
@implementation BankAddCell
- (void)initView{
    self.backgroundColor = [UIColor clearColor];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.addButton.frame = CGRectMake(15, self.height/2 - 22, self.width - 30, 44);
}
- (void)addCard{
    if (self.customActionBlock) {
        self.customActionBlock(self.cellModel, cat_action_click);
    }
}
- (void)cellModel:(id)cellModel{
    BankAddModel *model = cellModel;
    [self.addButton setTitle:model.title forState:UIControlStateNormal];
    if ([model.color isNotBlank]) {
        [self.addButton setBackgroundColor:COLOR_PATTERN_STRING(model.color)];
    }else{
        [_addButton setBackgroundColor:COLOR_PATTERN_STRING(@"_whiter_color")];
    }
}
- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.layer.cornerRadius = 4;
        [_addButton setBackgroundColor:COLOR_PATTERN_STRING(@"_whiter_color")];
        [_addButton setTitle:@"添加银行卡" forState:UIControlStateNormal];
        [_addButton setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:UIControlStateNormal];
        [_addButton.titleLabel setFont:FanFont(17)];
        [_addButton addTarget:self action:@selector(addCard) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addButton];
    }return _addButton;
}
@end

@interface BankCardCell()
@property (nonatomic ,strong) FanView *bgView; // 5：2
@property (nonatomic ,strong) FanImageView *bgImg; // 5：2
@property (nonatomic ,strong) FanView *iconBg;
@property (nonatomic ,strong) FanImageView *iconImg;
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *cardLb;
@end

@implementation BankCardCell
- (void)initView{
    self.backgroundColor = [UIColor clearColor];
}
- (void)cellModel:(id)cellModel{
    BankCardModel *model = cellModel;
    [self.bgView setBackgroundColor:COLOR_PATTERN_STRING(model.bgColor)];
    [self.bgImg setImageWithUrl:model.bgImg];
    [self.iconImg setImageWithUrl:model.iconImg];
    [self.titleLb setText:model.title];
    [self.cardLb setText: model.card_att];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.bgView.frame = CGRectMake(15, 15, self.width - 30, self.height - 15);
    self.bgImg.frame = CGRectMake(self.bgView.width - 125, self.bgView.height - 92, 125, 92);
    self.iconBg.frame = CGRectMake(30, 30, 43, 43);
    self.iconImg.frame = CGRectMake(7, 7, 29, 29);
    self.titleLb.frame = CGRectMake(self.iconBg.right + 5, self.iconBg.centerY - 10, self.bgView.width - self.iconBg.right - 10, 20);
    self.cardLb.frame = CGRectMake(self.titleLb.left, self.titleLb.bottom + 20, self.titleLb.width, 20);
}
- (FanImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [FanImageView new];
    }return _bgImg;
}
- (FanView *)bgView{
    if (!_bgView) {
        _bgView = [FanView new];
        _bgView.layer.cornerRadius = 5;
        _bgView.layer.masksToBounds = YES;
        [self addSubview:_bgView];
        [_bgView addSubview:self.bgImg];
        [_bgView addSubview:self.iconBg];
        [_iconBg addSubview:self.iconImg];
        [_bgView addSubview:self.titleLb];
        [_bgView addSubview:self.cardLb];
    }return _bgView;
}
- (FanView *)iconBg{
    if (!_iconBg) {
        _iconBg = [FanView new];
        _iconBg.layer.cornerRadius = 21.5;
        _iconBg.layer.masksToBounds = YES;
        _iconBg.backgroundColor = COLOR_PATTERN_STRING(@"_whiter_color");
    }return _iconBg;
}
- (FanImageView *)iconImg{
    if (!_iconImg) {
        _iconImg = [FanImageView new];
    }return _iconImg;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanRegularFont(16);
        [_titleLb setTextColor:COLOR_PATTERN_STRING(@"_whiter_color")];
    }return _titleLb;
}
- (UILabel *)cardLb{
    if (!_cardLb) {
        _cardLb = [UILabel new];
        _cardLb.font = FanMediumFont(22);
        [_cardLb setTextColor:COLOR_PATTERN_STRING(@"_whiter_color")];
    }return _cardLb;
}

@end
@interface BankQuotaCell()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *descLb;
@end

@implementation BankQuotaCell
- (void)initView{
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle0_0;
}
- (void)cellModel:(id)cellModel{
    BankQuotaModel *model = cellModel;
    [self.titleLb setText:model.title];
    [self.descLb setText: model.desc];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLb.frame = CGRectMake(15, 15, 150, 20);
    self.descLb.frame = CGRectMake(self.width - 150 - 15, self.titleLb.top, 150, 20);
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanFont(15);
        [_titleLb setTextColor:COLOR_PATTERN_STRING(@"_333333_color")];
        [self addSubview:_titleLb];
    }return _titleLb;
}
- (UILabel *)descLb{
    if (!_descLb) {
        _descLb = [UILabel new];
        _descLb.font = FanFont(15);
        _descLb.textAlignment = NSTextAlignmentRight;
        [_descLb setTextColor:COLOR_PATTERN_STRING(@"_333333_color")];
        [self addSubview:_descLb];
    }return _descLb;
}

@end
