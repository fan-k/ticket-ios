//
//  FanUrlScheme.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/29.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "FanUrlScheme.h"
#import <objc/runtime.h>

@implementation FanUrlScheme

+ (instancetype)shareInstance{
    static FanUrlScheme *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tools = [[FanUrlScheme alloc] init];
    });
    return tools;
}
+ (UIViewController *)currentViewController{
    return [FanUrlScheme topViewController];
}
+ (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

+ (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [FanUrlScheme _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [FanUrlScheme _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}
- (void)pushViewControllerWithUrl:(NSString *)url transferData:(id)transferData hander:(void (^ _Nullable)(id, int))hander{
    if(url.length == 0) return;
    if ([url hasPrefix:@"http"]) {
        //区分下网页 暂时return 不处理
        return;
    }
    if ([url rangeOfString:@"://"].location == NSNotFound) {
        url = [@"ticket://" stringByAppendingString:url];
    }
    //取链接内的参数
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url];
    NSString *host = urlComponents.host;
    NSString *path = urlComponents.path;
    NSDictionary *params = [url urlToParamDict];
    host = [host toClassController];
    id urlClass = [NSClassFromString(host) new];
    if([urlClass isKindOfClass:[UIViewController class]]){
        UIViewController *vc = (UIViewController *)urlClass;
        vc.transferData = transferData;
        vc.urlParams = params;
        vc.path = path;
        vc.customActionBlock = ^(id obj, cat_action_type idx) {
            if(hander){
                hander(obj ,idx);
            }
        };
        vc.hidesBottomBarWhenPushed = YES;
        [[FanUrlScheme currentViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (void)presentViewControllerWithUrl:(NSString *)url transferData:(id)transferData hander:(void (^ _Nullable)(id, int))hander{
    if(url.length == 0) return;
    if ([url hasPrefix:@"http"]) {
        //区分下网页 暂时return 不处理
        return;
    }
    if ([url rangeOfString:@"://"].location == NSNotFound) {
        url = [@"ticket://" stringByAppendingString:url];
    }
    //取链接内的参数
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url];
    NSString *host = urlComponents.host;
    NSString *path = urlComponents.path;
    NSDictionary *params = [url urlToParamDict];
    host = [host toClassController];
    id urlClass = [NSClassFromString(host) new];
    if([urlClass isKindOfClass:[UIViewController class]]){
        UIViewController *vc = (UIViewController *)urlClass;
        vc.transferData = transferData;
        vc.urlParams = params;
        vc.path = path;
        vc.customActionBlock = ^(id obj, cat_action_type idx) {
            if(hander){
                hander(obj ,idx);
            }
        };
        vc.hidesBottomBarWhenPushed = YES;
        if ([host isEqualToString:@"LoginController"]) {
            //登陆页添加导航
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [[FanUrlScheme currentViewController] presentViewController:nav animated:YES completion:nil];
        }else
            [[FanUrlScheme currentViewController] presentViewController:vc animated:YES completion:nil];
    }
}
@end


static const char *FanVCPassValue = "FanVCPassValue";
static const char *FanVCPassUrlParams = "FanVCPassUrlParams";
static const char *FanVCPath = "FanVCPath";
@implementation UIViewController (passValue)

- (void)setTransferData:(id)transferData{
    objc_setAssociatedObject(self, FanVCPassValue, transferData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (id)transferData{
    return objc_getAssociatedObject(self,FanVCPassValue);
}
- (void)setUrlParams:(NSDictionary *)urlParams{
    objc_setAssociatedObject(self, FanVCPassUrlParams, urlParams, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSDictionary *)urlParams{
    return objc_getAssociatedObject(self,FanVCPassUrlParams);
}
- (void)setPath:(NSString *)path{
    objc_setAssociatedObject(self, FanVCPath, path, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)path{
    return objc_getAssociatedObject(self,FanVCPath);
}

/**
 pushVc
 * 传参可通过url 和 transferData进行传参
 @param url url
 @param transferData 需要传递的参数
 @param hander 回调
 */
- (void)pushViewControllerWithUrl:(NSString *)url
                     transferData:(id)transferData
                           hander:(void (^ __nullable)(id obj,int idx))hander{
    [[FanUrlScheme shareInstance] pushViewControllerWithUrl:url transferData:transferData hander:hander];
}

/**presentVc*/
- (void)presentViewControllerWithUrl:(NSString *)url
                        transferData:(id)transferData
                              hander:(void (^ __nullable)(id obj,int idx))hander{
    [[FanUrlScheme shareInstance] presentViewControllerWithUrl:url transferData:transferData hander:hander];
}
@end


