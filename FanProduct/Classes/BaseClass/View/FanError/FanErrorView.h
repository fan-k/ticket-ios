//
//  FanErrorView.h
//  FanProduct
//
//  Created by 99epay on 2019/6/17.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanView.h"
#import <MBProgressHUD.h>
@class FanRequestItem;

typedef enum : NSUInteger {
    /**默认无error*/
    FanErrorTypeNil = 0,
    /**顶部提示方式 提供提示文字*/
    FanErrorTypeTopAlert = 1,
    /**顶部提示方式 提供提示文字*/
    FanErrorTypeTopAlertNet = 2,
    /**顶部提示方式 提供提示文字*/
    FanErrorTypeTopAlertTimeOut  = 3,
    /**页面形式 加载超时*/
    FanErrorTypeTimeOut ,
    /**页面形式 无网络*/
    FanErrorTypeNet,
    /**页面形式 加载失败*/
    FanErrorTypeError,
    /**页面形式 暂无数据 提供页面描述文字*/
    FanErrorTypeNoData,
    //新增的页面类型 加在FanErrorTypeTimeOut下面  提示类型 加FanErrorTypeTopAlertTimeOut上面
} FanErrorType;

typedef enum : NSUInteger {
    AlertMessageTypeNomal = 0,
    AlertMessageTypeSuccess,
    AlertMessageTypeFailure,
} AlertMessageType;


NS_ASSUME_NONNULL_BEGIN

@interface FanErrorView : FanView
@property (nonatomic ,assign) FanErrorType type;
@property (nonatomic ,strong) UIButton *loadbutton;//重新加载
@property (nonatomic ,strong) UIImageView *img;
@property (nonatomic ,strong) UILabel *Lb;
@property (nonatomic ,copy) NSString *errorTxt;//错误提示文字
@property (nonatomic ,copy) NSString *errorImg;//错误提示图片
/**在全覆盖页面 添加一个返回按钮*/
@property (nonatomic ,assign) BOOL addBack;
/**用于重新加载*/
@property (nonatomic ,strong) FanRequestItem *item;
@end


@interface ErrorAlertView : FanView
@property (nonatomic ,assign) FanErrorType errorType;
@property (nonatomic ,copy) NSString *errorTxt;//错误提示文字
@property (nonatomic ,strong) UILabel *Lb;
@property (nonatomic ,strong) UIImageView *icon;
@property (nonatomic ,assign) NSUInteger showTime;

@end
@interface FanAlert : FanView

/**error 顶部提示*/
+ (void)alertErrorWithMessage:(NSString *)message;
/**error 顶部提示*/
+ (void)alertErrorWithItem:(FanRequestItem *)item;
/**
 * YnAlertController
 */
+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message _cancletitle_:(NSString *)_cancletitle_ _confirmtitle_:(NSString *)_confirmtitle_ handler1:(void (^ __nullable)(UIAlertAction *action))hander1 handler2:(void (^ __nullable)(UIAlertAction *action))hander2;

/**
 * YnAlertController
 */
+ (void)showPresentAlertController:(UIViewController *)vc Title:(NSString *)title message:(NSString *)message _cancletitle_:(NSString *)_cancletitle_ _confirmtitle_:(NSString *)_confirmtitle_ handler1:(void (^ __nullable)(UIAlertAction *action))hander1 handler2:(void (^ __nullable)(UIAlertAction *action))hander2;

/**提示弹框*/
+ (void)alertMessage:(NSString *)message type:(AlertMessageType)type;
/**loading*/
+ (void)showLoadingWithCompletion:(void (^)())completion;
/**加载loading*/
+ (void)showLoading;
/**隐藏loading*/
+ (void)hideLoading;

@end

NS_ASSUME_NONNULL_END
