//
//  AppDelegate.m
//  FanProduct
//
//  Created by 樊康鹏 on 2019/2/17.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "AppDelegate.h"
#import "FanRootController.h"
#import "YYFPSLabel.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "AppDelegate+Push.h"

@interface AppDelegate ()
@property (nonatomic ,strong) FanRootController *rootController;
@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];//此方法 -- plus系列手机横屏启动app 状态栏缺失的问题
    [FanRequestTool startNotifier];
    [self initLuanchView:launchOptions];
    [self layoutios11];
    [self initPublicConfig];
    return YES;
}
- (void)initPublicConfig{
    [AMapServices sharedServices].apiKey = AMapKey;

}
//iOS11
- (void)layoutios11{
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[UIButton appearance] setExclusiveTouch:YES];
    [self addCache];
    [self initPUSH];
    return YES;
}

- (void)addCache{
    int cacheSizeMemory = 1*1024*1024; // 4MB
    int cacheSizeDisk = 5*1024*1024; // 32MB
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
    [NSURLCache setSharedURLCache:sharedCache];
}
//横竖屏开关
-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {//如果设置了allowRotation属性，支持横屏
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;//默认全局不支持横屏
}

- (void)initLuanchView:(NSDictionary *)launchOptions{
    self.rootController = [FanRootController initializeShare];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:self.rootController];
    
#if defined(DEBUG)||defined(_DEBUG)
    YYFPSLabel *fpsLabel = [YYFPSLabel new];
    fpsLabel.frame = CGRectMake(FAN_SCREEN_WIDTH - 60, FAN_CONTENT_HEIGHT, 50, 30);
    [fpsLabel sizeToFit];
    [self.window addSubview:fpsLabel];;
#endif
   
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *tmp = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSString *myDeviceToken = [tmp stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"myDeviceToken--%@",myDeviceToken);
    FanRequestItem *item = [FanRequestItem new];
    item.method = @"GET";
    item.url =  FanUrlToken;
    item.params = [NSMutableDictionary dictionaryWithDictionary:@{@"token":myDeviceToken,@"version":@"6.0"}];
    [[FanRequestTool shareInstance] requestWithItem:item completeBlock:^(FanRequestItem *item) {
    } inQueue:nil];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    if (application.applicationState == UIApplicationStateInactive) {
        [[FanRootController initializeShare] managerPushData:userInfo active:YES];
    }else
        [[FanRootController initializeShare] managerPushData:userInfo active:NO];
}

//iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler __IOS_AVAILABLE(10.0) __TVOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0){
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        if (!self.option) {
            [[FanRootController initializeShare] managerPushData:userInfo active:YES];
        }
    }
}
//iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler __IOS_AVAILABLE(10.0) __WATCHOS_AVAILABLE(3.0) __TVOS_PROHIBITED{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        if (!self.option) {
            [[FanRootController initializeShare] managerPushData:userInfo active:NO];
        }
        
    }else{
        //应用处于后台时的本地推送接受
        
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//ios 9
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    
    return  [self managerOpenUrl:url application:app options:options sourceApplication:nil];
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * __nullable restorableObjects))restorationHandler NS_AVAILABLE_IOS(8_0){
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb])
    {
        
    }
    return YES;
}
- (BOOL)managerOpenUrl:(NSURL *)url application:(UIApplication *)application options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options sourceApplication:(NSString *)sourceApplication{
    //主要拦截登录回调
    if ([url.absoluteString hasPrefix:FAN_KEY_WEIXIN_APPID]) {
        [FanWeChat handleOpenURL:url];
    }else if ([url.absoluteString hasPrefix:FAN_KEY_ALIPAY_APPID]) {
        [FanAliPay handleOpenURL:url];
    }
    return YES;
    
}
//ios 9 一下
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [self managerOpenUrl:url application:application options:nil sourceApplication:nil];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [self managerOpenUrl:url application:application options:nil sourceApplication:sourceApplication];
}

+ (AppDelegate *)appDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
@end
