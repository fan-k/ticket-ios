//
//  WalletHeaderView.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "WalletHeaderView.h"

@interface WalletHeaderView()
@property (nonatomic ,strong) FanView *bgView;
@property (nonatomic ,strong) UILabel *banacleLb;
@property (nonatomic ,strong) UILabel *descLb;
@end

@implementation WalletHeaderView
- (void)initView{
    [self addSubview:self.bgView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfo) name:NotificationWalletInfoChanged object:nil];
    [self updateInfo];
   
}
- (void)updateInfo{
    [self.banacleLb setText:[NSString stringWithFormat:@"%.2f",[[FanWallet shareInstance].walletModel.balance floatValue]]];
}
- (void)setOffset:(CGFloat)offset{
    if (offset < 0) {
        self.bgView.top  = offset;
        self.bgView.height = self.height + ABS(offset);
    }else{
        self.bgView.top = 0;
        self.bgView.height = self.height;
    }
    _banacleLb.top = self.bgView.height - 100;
    _descLb.top = _banacleLb.bottom + 5;
}
- (void)setModel:(WalletModel *)model{
    _model = model;
}
- (FanView *)bgView{
    if (!_bgView) {
        _bgView = [[FanView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _bgView.backgroundColor = COLOR_PATTERN_STRING(@"_yellow_color");
        [_bgView addSubview:self.banacleLb];
        [_bgView addSubview:self.descLb];
    }return _bgView;
}
- (UILabel *)banacleLb{
    if (!_banacleLb) {
        _banacleLb = [UILabel new];
        _banacleLb.frame = CGRectMake(15, _bgView.height/2, FAN_SCREEN_WIDTH - 30, 40);
        _banacleLb.font =  FanBoldFont(45);
        _banacleLb.textAlignment = NSTextAlignmentCenter;
        _banacleLb.textColor = COLOR_PATTERN_STRING(@"_212121_color");
    }return _banacleLb;
}
- (UILabel *)descLb{
    if (!_descLb) {
        _descLb = [UILabel new];
        _descLb.frame = CGRectMake(15, _banacleLb.bottom + 5, FAN_SCREEN_WIDTH - 30, 20);
        _descLb.font =  FanFont(15);
        _descLb.text = @"钱包总额(元)";
        _descLb.textAlignment = NSTextAlignmentCenter;
        _descLb.textColor = COLOR_PATTERN_STRING(@"_212121_color");
    }return _descLb;
}
@end
