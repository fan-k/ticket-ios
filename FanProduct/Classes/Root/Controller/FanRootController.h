//
//  FanRootController.h
//  FanProduct
//
//  Created by 樊康鹏 on 2019/2/18.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FanRootController : UITabBarController

/**
 单例 -- 用于处理推送相关
 
 @return 单例
 */
+ (instancetype)initializeShare;

- (void)managerhandleOpenUrl:(NSURL *)url;
- (void)managerPushData:(NSDictionary *)push active:(BOOL)active;

@end
FanRootController *MainRootViewController();
UINavigationController *MainRootSelectNavController();
UIViewController *MainRootSelectTopViewController();
UIViewController *MainRootSelectFirstViewController();

NS_ASSUME_NONNULL_END
