//
//  FanRefreshFooter.m
//  FanProduct
//
//  Created by 99epay on 2019/6/18.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanRefreshFooter.h"

@interface FanRefreshFooter()
{
    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end


@implementation FanRefreshFooter
#pragma mark - 公共方法
#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
        _stateTitles[@(MJRefreshStateIdle)] = @"点击或上拉加载更多";
         _stateTitles[@(MJRefreshStateRefreshing)] = @"正在加载更多的数据...";
         _stateTitles[@(MJRefreshStateNoMoreData)] = @"你触碰到底线了~";
    }
    return _stateTitles;
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel mj_label]];
    }
    return _stateLabel;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

#pragma mark - 私有方法
- (void)stateLabelClick
{
    if (self.state == MJRefreshStateIdle) {
        [self beginRefreshing];
    }
}

- (void)prepare
{
    [super prepare];
    // 初始化文字
    [self setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
    [self setTitle:@"正在加载更多的数据..." forState:MJRefreshStateRefreshing];
    [self setTitle:@"你触碰到底线了~" forState:MJRefreshStateNoMoreData];
    
//    // 初始化间距
//    self.labelLeftInset = MJRefreshLabelLeftInset;
//
//    // 监听label
//    self.stateLabel.userInteractionEnabled = YES;
//    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    if (self.stateLabel.constraints.count) return;
    
    // 状态标签
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    if (self.isRefreshingTitleHidden && state == MJRefreshStateRefreshing) {
        self.stateLabel.text = nil;
    } else {
        self.stateLabel.text = self.stateTitles[@(state)];
    }
}

@end
