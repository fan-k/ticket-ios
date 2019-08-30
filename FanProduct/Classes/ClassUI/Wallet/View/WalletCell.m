//
//  WalletCell.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "WalletCell.h"

@interface WalletCell ()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *descLb;
@end

@implementation WalletCell
- (void)initView{
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle15_15;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.titleLb.frame = CGRectMake(15, self.height/2 - 10, self.width/2, 20);
    self.descLb.frame = CGRectMake(self.accessoryView.left -  105, self.height/2 - 10, 100, 20);
}
- (void)cellModel:(id)cellModel{
    WalletCellModel *model = cellModel;
    [self.titleLb setText:model.title];
    [self.descLb setText:model.desc];
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanFont(15);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}
- (UILabel *)descLb{
    if (!_descLb) {
        _descLb = [UILabel new];
        _descLb.font = FanFont(15);
        _descLb.textColor = COLOR_PATTERN_STRING(@"_red_color");
        _descLb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_descLb];
    }return _descLb;
}
@end
