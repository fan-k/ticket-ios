//
//  FanRefresh.h
//  FanProduct
//
//  Created by 99epay on 2019/6/6.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FanRefreshHeader.h"
#import "FanRefreshFooter.h"
NS_ASSUME_NONNULL_BEGIN

@interface FanRefresh : NSObject


/**
 *  获取下拉控件
 */
+(FanRefreshHeader *)getHeadRefreshWithRefreshBlock:(void(^)())block;


/**
 *  获取上拉控件
 */
+(FanRefreshFooter *)getFooterRefreshWithRefreshBlock:(void(^)())block;
@end

NS_ASSUME_NONNULL_END
