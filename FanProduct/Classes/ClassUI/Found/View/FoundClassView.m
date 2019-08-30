//
//  FoundClassView.m
//  FanProduct
//
//  Created by 99epay on 2019/6/10.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FoundClassView.h"



@interface FoundClassView ()
@property (nonatomic ,strong) UILabel *lineLb;
@property (nonatomic ,strong) UIButton *currenButton;
@property (nonatomic ,strong) UIButton *addButton;
@property (nonatomic ,strong) NSMutableArray *buttonArr;
@property (nonatomic ,strong) NSMutableArray *collectViewArray;
@property (nonatomic ,strong) UIScrollView *classTitleScrollView;
@property (nonatomic ,strong) UIScrollView *contentScrollView;
@end

@implementation FoundClassView


- (void)managerListWithItem:(FanRequestItem *)item{
    FanViewModel *vm = item.object;
    HomeSectionHeaderModel *model =  vm.obj;
    NSInteger index = [self.menus indexOfObject:model];
    FanCollectionDelegate *delegate = self.collectViewArray[index];
    [model managerFoundList:item];
    [delegate setCollectionList:model.contentList type:0];
    delegate.more = model.ismore;
}





#pragma mark -- initView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }return self;
}

- (void)initView{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.classTitleScrollView];
    [self addSubview:self.contentScrollView];
    [self addSubview:self.addButton];
    
}
#pragma mark -- init  Button
- (void)setMenus:(NSArray *)menus{
    __block NSMutableArray *models = [NSMutableArray array];
    [menus enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HomeSectionHeaderModel *model1 = [HomeSectionHeaderModel modelWithJson:obj];
        [models addObject:model1];
    }];
    _menus = models;
    [self initClassButton:models];
}
- (void)initClassButton:(NSMutableArray *)models{
    CGFloat width = 0;
    [self.classTitleScrollView removeAllSubviews];
    [self.contentScrollView removeAllSubviews];
    _buttonArr = [NSMutableArray array];
    _collectViewArray = [NSMutableArray array];
    for (int i = 0;  i < models.count;  i ++) {
        HomeSectionHeaderModel *model = models[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 108 +i;
        button.frame = CGRectMake(width , 0, model.titleWidth, self.classTitleScrollView.height);
        width += model.titleWidth;
        width += 10;
        [button setTitleColor:COLOR_PATTERN_STRING(@"_363636_color") forState:UIControlStateNormal];
        [button setTitle:model.title forState:UIControlStateNormal];
        if (i == 0) {
            //首次默认选中第一个
            self.lineLb.center = CGPointMake(button.center.x, button.bottom - 5);
            self.currenButton = button;
            button.titleLabel.font = FanMediumFont(16);
        }else{
            button.titleLabel.font = FanRegularFont(14);
        }
        [button addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.classTitleScrollView addSubview:button];
        [_buttonArr addObject:button];
        [self initCollectWithModel:model idx:i];
    }
    [self.classTitleScrollView setContentSize:CGSizeMake(width, 44)];
    [self.contentScrollView setContentSize:CGSizeMake(FAN_SCREEN_WIDTH *models.count, self.contentScrollView.height)];
}
- (void)initCollectWithModel:(HomeSectionHeaderModel *)model idx:(NSInteger)index{
   UICollectionViewFlowLayout * _gridLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = floorf((FAN_SCREEN_WIDTH - 30) * 0.5);
    _gridLayout.itemSize = CGSizeMake(width, width+80);
    _gridLayout.minimumLineSpacing = 10;
    _gridLayout.minimumInteritemSpacing = 10;
    _gridLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
     FanCollection*collect = [[FanCollection alloc]initWithFrame:CGRectMake(FAN_SCREEN_WIDTH * index, 0, FAN_SCREEN_WIDTH,self.contentScrollView.height) collectionViewLayout:_gridLayout];
    [collect registerClass:[NSClassFromString(@"FoundCollectionCell") class] forCellWithReuseIdentifier:@"HomeContentCell"];
    __weak FoundClassView *weakSelf = self;
    collect.headRefreshblock = ^{
        FanCollectionDelegate *delegate = weakSelf.collectViewArray[index];
        if (weakSelf.customActionBlock) {
            weakSelf.customActionBlock(delegate, cat_table_refresh);
        }
    };
    collect.footRefreshblock = ^{
        FanCollectionDelegate *delegate = weakSelf.collectViewArray[index];
        if (weakSelf.customActionBlock) {
            weakSelf.customActionBlock(delegate,cat_table_load);
        }
    };
    FanCollectionDelegate *delegate = [FanCollectionDelegate initWithCollection:collect];
    delegate.customActionBlock = ^(id obj, cat_action_type idx) {
        if (weakSelf.customActionBlock) {
            weakSelf.customActionBlock(obj, idx);
        }
    };
    delegate.obj = model;
    [self.collectViewArray addObject:delegate];
    [self.contentScrollView addSubview:collect];
}
#pragma mark -- button method
- (void)buttonClickMethod:(UIButton *)button{
    NSUInteger index = button.tag - 108;
    _index = index;
    self.currenButton.transform = CGAffineTransformIdentity;
    [self.currenButton.titleLabel setFont: FanRegularFont(14)];
    [button.titleLabel setFont:FanMediumFont(16)];
    [UIView animateWithDuration:0.2 animations:^{
        self.lineLb.center = CGPointMake(button.center.x, button.bottom - 5);
    }];
    self.currenButton = button;
    
    //获取当前button位置 >>>>影响_titleScrollView是否动 往哪动
    float X = (button.center.x - (FAN_SCREEN_WIDTH - 44*2)/2) > 0 ? (button.center.x - (FAN_SCREEN_WIDTH - self.classTitleScrollView.height)/2) : 0;
    //获取最大可偏移量
    float maxOffsetX = fabs(self.classTitleScrollView.contentSize.width - (FAN_SCREEN_WIDTH - self.classTitleScrollView.height));
    if (X > maxOffsetX) {
        [UIView animateWithDuration:0.25f animations:^{
            [self.classTitleScrollView setContentOffset:CGPointMake(maxOffsetX, 0)];
        }];
    }else{
        [UIView animateWithDuration:0.25f animations:^{
            [self.classTitleScrollView setContentOffset:CGPointMake(X, 0)];
        }];
    }
    if (self.contentScrollView.contentSize.width > FAN_SCREEN_WIDTH - self.classTitleScrollView.height) {
        [self.contentScrollView setContentOffset:CGPointMake(FAN_SCREEN_WIDTH * index, 0) animated:NO];
    }
    //判断 如果切换的列表未请求过数据 则请求数据 ，请求过数据则不请求
    FanCollectionDelegate *delegate = self.collectViewArray[index];
    if (!delegate.isRequested) {
        if (self.customActionBlock) {
            self.customActionBlock(delegate, cat_table_refresh);
        }
    }
    self.currenButton = button;
}
- (void)addButtonMethod:(UIButton *)addButton{
    if (self.customActionBlock) {
        self.customActionBlock(self.menus, cat_found_class_add);
    }
}
- (void)setIndex:(NSUInteger)index{
    _index = index;
    UIButton *button = _buttonArr[index];
    [self buttonClickMethod:button];
}
#pragma mark -- UIScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //找页码
    if (scrollView == _contentScrollView) {
        NSUInteger page = scrollView.contentOffset.x/FAN_SCREEN_WIDTH;
        if (page < _buttonArr.count) {
            UIButton *button = _buttonArr[page];
            [self buttonClickMethod:button];
        }
    }
}
#pragma mark -- set methods
- (UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setBackgroundColor:COLOR_PATTERN_STRING(@"_whiter_color")];
        [_addButton setImage:[UIImage imageNamed:@"home_class_add"] forState:UIControlStateNormal];
        _addButton.frame = CGRectMake(self.classTitleScrollView.right, 0, self.classTitleScrollView.height, self.classTitleScrollView.height);
        [_addButton addTarget:self action:@selector(addButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 15);
        [_addButton setTitle:@"+" forState:UIControlStateNormal];
    }
    return _addButton;
}
- (UILabel *)lineLb{
    if (!_lineLb) {
        _lineLb = [[UILabel alloc] initWithFrame:CGRectMake(0, self.classTitleScrollView.height - 5, 50, 2)];
        _lineLb.backgroundColor = COLOR_PATTERN_STRING(@"_yellow_color");
        _lineLb.layer.cornerRadius = 1;
        _lineLb.layer.masksToBounds = YES;
        [self.classTitleScrollView addSubview:_lineLb];
    }
    return _lineLb;
}
- (UIScrollView *)classTitleScrollView{
    if (!_classTitleScrollView) {
        _classTitleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH - 44 , 44)];
        _classTitleScrollView.showsVerticalScrollIndicator = NO;
        _classTitleScrollView.showsHorizontalScrollIndicator = NO;
        _classTitleScrollView.bounces = NO;
        _classTitleScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _classTitleScrollView;
}
- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, FAN_SCREEN_WIDTH, self.height - 44)];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.backgroundColor = [UIColor clearColor];
        _contentScrollView.delegate = self;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = NO;
    }
    return _contentScrollView;
}
@end
