//
//  FanRefresh.m
//  FanProduct
//
//  Created by 99epay on 2019/6/6.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanRefresh.h"

@implementation FanRefresh
+ (FanRefreshHeader *)getHeadRefreshWithRefreshBlock:(void (^)())block{
    FanRefreshHeader *header = [FanRefreshHeader headerWithRefreshingBlock:^{
        if (block) {
            block();
        }
    }];
    
    //隐藏时间
    //    header.lastUpdatedTimeLabel.hidden = YES;
    //隐藏状态
    //    header.stateLabel.hidden = YES;
    
    return header;
}

+ (FanRefreshFooter *)getFooterRefreshWithRefreshBlock:(void (^)())block{
    FanRefreshFooter *footer = [FanRefreshFooter footerWithRefreshingBlock:^{
        block();
    }];
    return footer;
}
@end
