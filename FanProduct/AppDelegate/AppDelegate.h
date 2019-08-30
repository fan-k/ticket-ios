//
//  AppDelegate.h
//  FanProduct
//
//  Created by 樊康鹏 on 2019/2/17.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**屏幕旋转开关*/
@property (nonatomic ,assign) BOOL allowRotation;

/**记录推送数据*/
@property (nonatomic ,strong) NSDictionary *option;


+ (AppDelegate *)appDelegate;

@end

