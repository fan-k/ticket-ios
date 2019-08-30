//
//  FanTableView.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/28.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "FanTableView.h"


@implementation FanTableView
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeNone;
//        self.rowHeight  = UITableViewAutomaticDimension;
//        self.estimatedRowHeight = 50;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.estimatedRowHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
            self.estimatedSectionFooterHeight = 0;
        }
    }
    return self;
}
- (NSUInteger)numberOfAllRows{
    NSInteger section = [self numberOfSections];
    NSInteger row = 0;
    for (int i = 0; i < section; i ++) {
        NSUInteger sss = [self numberOfRowsInSection:i];
        row += sss;
    }
    return row;
}
- (void)reloadData{
    [super reloadData];
    [self endRefreshing];
    
}


- (void)setHeadRefreshblock:(void (^)())headRefreshblock{
    _headRefreshblock = headRefreshblock;
    if (headRefreshblock) {
        self.mj_header = [FanRefresh getHeadRefreshWithRefreshBlock:^{
            headRefreshblock();
        }];
    }
}
- (void)setFootRefreshblock:(void (^)())footRefreshblock{
    _footRefreshblock = footRefreshblock;
    if (footRefreshblock) {
        self.mj_footer = [FanRefresh getFooterRefreshWithRefreshBlock:^{
            footRefreshblock();
        }];
    }
}
- (void)setMore:(BOOL)more{
    if (!more) {
         [self.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mj_footer resetNoMoreData];
    }
}
- (void)endRefreshing{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}
- (FanViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [FanViewModel initWithTableView:self];
        __weak FanTableView *weakSelf = self;
        _viewModel.customActionBlock = ^(id obj, cat_action_type idx) {
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(obj, idx);
            }
        };
    }return _viewModel;
}
@end
