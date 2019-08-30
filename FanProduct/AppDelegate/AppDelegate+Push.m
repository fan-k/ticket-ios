//
//  AppDelegate+Push.m
//  FanProduct
//
//  Created by 99epay on 2019/7/2.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "AppDelegate+Push.h"
#import <UserNotifications/UserNotifications.h>
@implementation AppDelegate (Push)
- (void)initPUSH{
    UIApplication *application = [UIApplication sharedApplication];
    if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
        //iOS10必须加下面这段代码。
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UNAuthorizationOptions types10= UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                //这里可以添加一些自己的逻辑
            } else {
                //点击不允许
                //这里可以添加一些自己的逻辑
            }
        }];
        
        //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"打开应用";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"忽略";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
        actionCategory1.identifier = @"category1";//这组动作的唯一标示
        [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
        UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionForeground];
        //UNNotificationCategoryOptionNone
        //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
        //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
        UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
        NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
        [center setNotificationCategories:categories_ios10];
        [application registerForRemoteNotifications];
    }else{
        if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]){
            UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIRemoteNotificationTypeSound) categories:nil];
            
            [application registerUserNotificationSettings:notiSettings];
            [application registerForRemoteNotifications];
            
        } else{
            //iOS7
            [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge                                       |UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
        }
    }
}
@end
