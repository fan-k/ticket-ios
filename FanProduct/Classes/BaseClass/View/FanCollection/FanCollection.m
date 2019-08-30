//
//  FanCollection.m
//  FanProduct
//
//  Created by 99epay on 2019/6/18.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanCollection.h"

@implementation FanCollection
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }return self;
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


- (FanCollectionDelegate *)viewModel{
    if (!_viewModel) {
        _viewModel = [FanCollectionDelegate initWithCollection:self];
        __weak FanCollection *weakSelf = self;
        _viewModel.customActionBlock = ^(id obj, cat_action_type idx) {
            if (weakSelf.customActionBlock) {
                weakSelf.customActionBlock(obj, idx);
            }
        };
    }return _viewModel;
}
@end
