//
//  FanUrlScheme.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/29.
//  Copyright © 2018 Fan. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 * 通过urlScheme页面跳转的处理类
 * 通过类名映射的方法 获取VC
 * 通过分类属性的方法 传值赋值
 */
@interface FanUrlScheme : NSObject
/**单例*/
+ (instancetype)shareInstance;
/**当前的viewController*/
+ (UIViewController *)currentViewController;

/**
 pushVc
 * 传参可通过url 和 transferData进行传参
 @param url url
 @param transferData 需要传递的参数
 @param hander 回调
 */
- (void)pushViewControllerWithUrl:(NSString *)url
                     transferData:(id)transferData
                           hander:(void (^ __nullable)(id obj,int idx))hander;

/**presentVc*/
- (void)presentViewControllerWithUrl:(NSString *)url
                        transferData:(id)transferData
                              hander:(void (^ __nullable)(id obj,int idx))hander;
@end




@interface UIViewController (passValue)
/**
 页面push 或presnt时 需要传递的参数 -- 多个参数 可使用字典 或model 或array 或other
 */
@property (nonatomic ,strong) id transferData;

/**
 页面push 或presnt时 URL中包含的参数-- 固定字典，
 * 若URL中不包含 “=” 或& ，字典键值为key:url
 */
@property (nonatomic ,strong) NSDictionary * urlParams;

/**
 页面push 或presnt时 的path参数，
 * path 指向页面内的一种action
 */
@property (nonatomic ,copy) NSString * path;

/**
 pushVc
 * 传参可通过url 和 transferData进行传参
 @param url url
 @param transferData 需要传递的参数
 @param hander 回调
 */
- (void)pushViewControllerWithUrl:(NSString *)url
                     transferData:(id)transferData
                           hander:(void (^ __nullable)(id obj,int idx))hander;

/**presentVc*/
- (void)presentViewControllerWithUrl:(NSString *)url
                        transferData:(id)transferData
                              hander:(void (^ __nullable)(id obj,int idx))hander;


@end
