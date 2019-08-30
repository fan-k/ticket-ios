//
//  FanClassView.m
//  FanProduct
//
//  Created by 99epay on 2019/6/20.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanClassView.h"

@implementation FanClassView
- (instancetype)initWithFrame:(CGRect)frame tables:(NSArray<UIViewController *> *)tables titleView:(UIView *)titleView{
    self = [super initWithFrame:frame];
    if (self) {
        self.tables = tables;
        self.titleView = titleView;
        [self addSubview:self.titleView];
        [self addSubview:self.scrollView];
        weak_self
        titleView.customActionBlock = ^(id obj, cat_action_type idx) {
            [weakSelf selectIndex:[obj integerValue]];
        };
        [self createViewController:0];
    }
    return self;
}
- (void)selectIndex:(NSInteger)index{
    if (index < 0 || index > self.tables.count) {
        NSLog(@"滚动的位置大于条数");
        return;
    }
    [self createViewController:index];
    [self.scrollView setContentOffset:CGPointMake(FAN_SCREEN_WIDTH * index, 0) animated:NO];
}

- (void)createViewController:(NSInteger)index{
    UIViewController *table = self.tables[index];
    if (![_scrollView.subviews containsObject:table.view]) {
        table.view.frame = CGRectMake(_scrollView.width * index, 0, _scrollView.width, _scrollView.height);
        [_scrollView addSubview:table.view];
        table.resultActionBlock(table, cat_table_refresh);
    }
}
/**是否允许页面滑动*/
- (void)setCanSlide:(BOOL)canSlide{
    _canSlide = canSlide;
    self.scrollView.scrollEnabled = canSlide;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.scrollView) {
        NSInteger index = (int)scrollView.contentOffset.x/FAN_SCREEN_WIDTH;
        if (scrollView.contentOffset.x - FAN_SCREEN_WIDTH *(index) == 0) {
            if (self.titleView.resultActionBlock) {
                self.titleView.resultActionBlock([NSString stringWithFormat:@"%ld",(long)index], cat_action_scrollView_didScroll);
            }
            return;
        }
    }
}
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleView.bottom, FAN_SCREEN_WIDTH, self.height - self.titleView.bottom)];
        _scrollView.contentSize = CGSizeMake(self.tables.count * FAN_SCREEN_WIDTH, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

@end
