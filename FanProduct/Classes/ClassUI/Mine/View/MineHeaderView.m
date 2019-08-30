//
//  MineHeaderView.m
//  FanProduct
//
//  Created by 99epay on 2019/6/12.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "MineHeaderView.h"


@interface MineHeaderView()
@property (nonatomic ,strong) FanImageView *bgView;
@property (nonatomic ,strong) UIButton *setBtn;
@property (nonatomic ,strong) FanImageView *img;
@property (nonatomic ,strong) UILabel *nameLb;

@property (nonatomic ,strong) UIView *buttonBgView;

@property (nonatomic ,strong) MineToolView *collectBtn;
@property (nonatomic ,strong) MineToolView *recommendBtn;
@property (nonatomic ,strong) MineToolView *historyBtn;

@end
@implementation MineHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.bgView];
        [self addSubview:self.setBtn];
        [self addSubview:self.img];
        [self addSubview:self.nameLb];
        [self addSubview:self.buttonBgView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initUserInfo) name:NotificationUserInfoChanged object:nil];
        [self initUserInfo];
    }return self;
}
- (void)initUserInfo{
    if ([UserInfo shareInstance].isLogin) {
        [_nameLb setText:[UserInfo shareInstance].userModel.name];
        if([[UserInfo shareInstance].userModel.photo_str isNotBlank]){
            UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:[UserInfo shareInstance].userModel.photo_str options:NSDataBase64DecodingIgnoreUnknownCharacters]];
            if (image) {
                [self.img setImage:image];
                return;
            }
        }
        [self.img setImageWithUrl:[UserInfo shareInstance].userModel.photo];
    }else{
        _img.image = [UIImage imageNamed:@"default_accoumt"];
        [_nameLb setText:@"去登录"];
    }
}
- (void)setOffset:(CGFloat)offset{
    if (offset < 0) {
        self.bgView.top  = offset;
        self.bgView.height = self.height + ABS(offset) - 70;
    }else{
        self.bgView.top = 0;
        self.bgView.height = self.height - 70;
    }
}
- (void)setbtnClick{
    if (self.customActionBlock) {
        self.customActionBlock(self, cat_mine_set);
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point  = [touch locationInView:self];
    if (CGRectContainsPoint(CGRectMake(_img.left, _img.top, _nameLb.right - _img.left, _img.height), point)) {
        if (self.customActionBlock) {
            if ([UserInfo shareInstance].isLogin) {
                self.customActionBlock(self, cat_mine_userinfo);
            }else{
                self.customActionBlock(self, cat_login);
            }
        }
    }
}
- (FanImageView *)bgView{
    if (!_bgView) {
        _bgView = [[FanImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 50)];
        _bgView.image = IMAGE_WITH_NAME(@"mine_bg");
    }return _bgView;
}
- (UIButton *)setBtn{
    if (!_setBtn) {
        _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _setBtn.frame = CGRectMake(FAN_SCREEN_WIDTH - 50, FanNavSubViewTop(20), 40, 40);
        [_setBtn setImage:IMAGE_WITH_NAME(@"mine_set") forState:UIControlStateNormal];
        [_setBtn addTarget:self action:@selector(setbtnClick) forControlEvents:UIControlEventTouchUpInside];
    }return _setBtn;
}
- (FanImageView *)img{
    if (!_img) {
        _img = [FanImageView new];
        UIImage *image = [UIImage imageNamed:@"default_accoumt"];
        _img.frame = CGRectMake(15 , FAN_NAV_HEIGHT, image.size.width, image.size.height);
        _img.layer.cornerRadius = _img.width/2;
        _img.layer.masksToBounds = YES;
//        _img.layer.borderColor = [UIColor whiteColor].CGColor;
//        _img.layer.borderWidth = 2;
        _img.image = image;
        _img.placeholderImage = image;
    }return _img;
}
- (UILabel *)nameLb{
    if (!_nameLb) {
        _nameLb = [UILabel new];
        _nameLb.frame = CGRectMake(self.img.right + 10, self.img.centerY , self.width/2 - 10, 20);
        _nameLb.textColor = COLOR_PATTERN_STRING(@"_212121_color");
        _nameLb.font = FanBoldFont(16);
    }return _nameLb;
}
- (UIView *)buttonBgView{
    if (!_buttonBgView) {
        _buttonBgView = [UIView new];
        _buttonBgView.backgroundColor = COLOR_PATTERN_STRING(@"_whiter_color");
        _buttonBgView.layer.cornerRadius = 8;
        _buttonBgView.layer.masksToBounds = YES;
        _buttonBgView.frame = CGRectMake(15, self.height - 90, self.width - 30, 75);
        [_buttonBgView addSubview:self.collectBtn];
        [_buttonBgView addSubview:self.recommendBtn];
        [_buttonBgView addSubview:self.historyBtn];
    }return _buttonBgView;
}

- (MineToolView *)collectBtn{
    if (!_collectBtn) {
        _collectBtn = [[MineToolView alloc] initWithFrame:CGRectMake(0, 0, _buttonBgView.width/3, _buttonBgView.height)];
        _collectBtn.dict = @{@"title":@"收藏",@"image":@"mine_collect",@"urlScheme":@"CollectController?type=collect"};
        __weak MineHeaderView *weakSelf = self;
        _collectBtn.customActionBlock = ^(id obj, cat_action_type idx) {
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(obj, cat_action_cell_click);
            }
        };
        
    }return _collectBtn;
}
- (MineToolView *)recommendBtn{
    if (!_recommendBtn) {
        _recommendBtn = [[MineToolView alloc] initWithFrame:CGRectMake(_buttonBgView.width/3, 0, _buttonBgView.width/3, _buttonBgView.height)];
        _recommendBtn.dict = @{@"title":@"评价",@"image":@"mine_recommend",@"urlScheme":@"CommentController"};
        __weak MineHeaderView *weakSelf = self;
        _recommendBtn.customActionBlock = ^(id obj, cat_action_type idx) {
            if (weakSelf.customActionBlock) {
                if ([UserInfo shareInstance].isLogin) {
                     weakSelf.customActionBlock(obj, cat_action_cell_click);
                }else{
                    weakSelf.customActionBlock(obj, cat_login);
                }
               
            }
        };
    }return _recommendBtn;
}
- (MineToolView *)historyBtn{
    if (!_historyBtn) {
        _historyBtn = [[MineToolView alloc] initWithFrame:CGRectMake(_buttonBgView.width/3 * 2, 0, _buttonBgView.width/3, _buttonBgView.height)];
        _historyBtn.dict = @{@"title":@"最近浏览",@"image":@"mine_history",@"urlScheme":@"CollectController?type=history"};
        __weak MineHeaderView *weakSelf = self;
        _historyBtn.customActionBlock = ^(id obj, cat_action_type idx) {
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(obj, cat_action_cell_click);
            }
        };
        
    }return _historyBtn;
}
@end


@interface MineToolView ()
@property (nonatomic ,strong) FanImageView *icon;
@property (nonatomic ,strong) UILabel *titleLb;

@end

@implementation MineToolView

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.customActionBlock) {
        FanModel *model = [FanModel new];
        model.urlScheme = DICTION_OBJECT(self.dict, @"urlScheme");
        self.customActionBlock(model, cat_action_cell_click);
    }
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.icon.frame = CGRectMake(self.width/2 - 12.5, 10, 25, 25);
    self.titleLb.frame = CGRectMake(0, self.icon.bottom + 10, self.width, 12);
}
- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    [self.icon setImageWithUrl:DICTION_OBJECT(dict, @"image")];
    [self.titleLb setText:DICTION_OBJECT(dict, @"title")];
}
- (FanImageView *)icon{
    if (!_icon) {
        _icon = [FanImageView new];
        [self addSubview:_icon];
    }return _icon;
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _titleLb.font = FanMediumFont(12);
        _titleLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLb];
    }return _titleLb;
}

@end
