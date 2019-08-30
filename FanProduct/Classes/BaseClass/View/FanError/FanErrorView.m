//
//  FanErrorView.m
//  FanProduct
//
//  Created by 99epay on 2019/6/17.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanErrorView.h"

@implementation FanErrorView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.Lb];
        [self addSubview:self.img];
        [self addSubview:self.loadbutton];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    UIImage *image = [UIImage imageNamed:@"error_load_error"];
    _img.frame = CGRectMake(FAN_SCREEN_WIDTH/2 - image.size.width/2, self.height/2 - image.size.height/2, image.size.width, image.size.height);
    _Lb.frame = CGRectMake(0,  _img.bottom  + 10, self.width, 20);
    _loadbutton.frame = CGRectMake(FAN_SCREEN_WIDTH/2 - 45, _Lb.bottom + 20, 90, 35);
    
}
- (void)setAddBack:(BOOL)addBack{
    if (addBack) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, FanNavSubViewTop(20), 40, 40);
        [button setImage:[UIImage imageNamed:@"nav_back"] forState:0];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)back{
    if (self.customActionBlock) {
        self.customActionBlock(self, cat_error_close);
    }
}
- (void)setItem:(FanRequestItem *)item{
    _item = item;
    self.type = item.errorType;
//    self.errorTxt = DICTION_OBJECT(item.responseObject, @"msg");
}
- (void)setType:(FanErrorType)type{
    _type = type;
    if (type == 0){
        _Lb.hidden = _img.hidden = _loadbutton.hidden = YES;
    }else{
        _Lb.hidden = _img.hidden = _loadbutton.hidden = NO;
        if (type == FanErrorTypeTimeOut) {
            _Lb.text = @"网络请求超时";
            self.errorImg = @"error_load_error";
            [_loadbutton setHidden:NO];
        }else if (type == FanErrorTypeNet) {
            _Lb.text = @"网络无法连接";
            self.errorImg = @"error_nonet";
            [_loadbutton setHidden:NO];
        }else if (type == FanErrorTypeNoData){
            _Lb.text = @"暂无相关内容";
            self.errorImg = @"error_no_collect";
            [_loadbutton setHidden:YES];
        }else{
            _Lb.text = @"哎呀，您访问的页面加载出错";
            self.errorImg = @"error_load_error";
            [_loadbutton setHidden:NO];
        }
    }
}
- (void)setErrorImg:(NSString *)errorImg{
    _errorImg = errorImg;
    _img.image = [UIImage imageNamed:errorImg];
}
- (void)setErrorTxt:(NSString *)errorTxt{
    if ([errorTxt isNotBlank]) {
        _errorTxt = errorTxt;
        _Lb.text = errorTxt;
    }
}
- (void)buttonClick{
    if (self.item) {
        [self.item startRequest];
    }
    if (self.customActionBlock) {
        self.customActionBlock(self, cat_error_button);
    }
}
- (UIImageView *)img{
    if (!_img) {
        UIImage *image = [UIImage imageNamed:@"error_load_error"];
        _img = [[UIImageView alloc] initWithImage:image];
    }
    return _img;
}
- (UILabel *)Lb{
    if (!_Lb) {
        _Lb = [UILabel new];
        _Lb.textAlignment = NSTextAlignmentCenter;
        _Lb.textColor = COLOR_PATTERN_STRING(@"_212121_color");
        _Lb.font = FanFont(16);
        _Lb.text = @"哎呀，您访问的页面出错了~";
    }
    return _Lb;
}
- (UIButton *)loadbutton{
    if (!_loadbutton) {
        _loadbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loadbutton.layer.borderColor = COLOR_PATTERN_STRING(@"_212121_color").CGColor;
        _loadbutton.layer.borderWidth = 1;
        _loadbutton.layer.cornerRadius = 2;
        _loadbutton.layer.masksToBounds = YES;
        [_loadbutton setTitleColor:COLOR_PATTERN_STRING(@"_212121_color") forState:UIControlStateNormal];
        [_loadbutton setTitle:@"重新加载" forState:UIControlStateNormal];
        _loadbutton.titleLabel.font = FanFont(15);
        [_loadbutton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loadbutton;
}
@end

@implementation ErrorAlertView

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, - FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_NAV_HEIGHT)];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self addSubview:self.Lb];
        [UIView animateWithDuration:0.3 animations:^{
            self.top = 0;
        }];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.showTime = 3;
        [self addSubview:self.Lb];
    }
    return self;
}
- (void)setErrorType:(FanErrorType)errorType{
    if (errorType == FanErrorTypeTopAlertTimeOut) {
        _Lb.text = @"网络请求超时";
    }else if (errorType == FanErrorTypeTopAlertNet) {
        _Lb.text = @"网络错误，请检查网络后重试";
    }else{
        _Lb.text = @"哎呀，您访问的页面出错了~";
    }
    [self remove];
}
- (NSUInteger)showTime{
    if (!_showTime) {
        _showTime = 3;
    }
    return _showTime;
}
- (void)remove{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.showTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            if (self.top > FAN_SCREEN_HEIGHT/2) {
                self.top += self.height;
            }else
                self.top = -self.height;
        } completion:^(BOOL finished) {
            if (finished) {
                UIWindow *window = [UIApplication sharedApplication].delegate.window;
                window.windowLevel = UIWindowLevelNormal;
                [self removeFromSuperview];
                if (self.customActionBlock) {
                    self.customActionBlock(self, cat_error_close);
                }
            }
        }];
    });
}
- (void)setErrorTxt:(NSString *)errorTxt{
    _Lb.text = errorTxt;
    [self remove];
}
- (UILabel *)Lb{
    if (!_Lb) {
        _Lb = [[UILabel alloc] initWithFrame:CGRectMake(15, FanNavSubViewTop(20), FAN_SCREEN_WIDTH - 30, 44)];
        _Lb.font = FanFont(17);
        _Lb.textColor = [UIColor whiteColor];
    }
    return _Lb;
}
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        [self addSubview:_icon];
    }
    return _icon;
}


@end


@implementation FanAlert

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message _cancletitle_:(NSString *)_cancletitle_ _confirmtitle_:(NSString *)_confirmtitle_ handler1:(void (^ _Nullable)(UIAlertAction *))hander1 handler2:(void (^ _Nullable)(UIAlertAction *))hander2{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if ([_cancletitle_ isNotBlank]) {
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:_cancletitle_ style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (hander1) {
                hander1(action);
            }
        }];
        [alertController addAction:cancel];
    }
    if ([_confirmtitle_ isNotBlank]) {
        UIAlertAction *defult = [UIAlertAction actionWithTitle:_confirmtitle_ style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (hander2) {
                hander2(action);
            }
        }];
        
        [alertController addAction:defult];
    }
    [[FanUrlScheme currentViewController] presentViewController:alertController animated:YES completion:nil];
}
+ (void)showPresentAlertController:(UIViewController *)vc Title:(NSString *)title message:(NSString *)message _cancletitle_:(NSString *)_cancletitle_ _confirmtitle_:(NSString *)_confirmtitle_ handler1:(void (^ __nullable)(UIAlertAction *action))hander1 handler2:(void (^ __nullable)(UIAlertAction *action))hander2{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if ([_cancletitle_ isNotBlank]) {
        UIAlertAction *cancel=[UIAlertAction actionWithTitle:_cancletitle_ style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (hander1) {
                hander1(action);
            }
        }];
        [alertController addAction:cancel];
    }
    if ([_confirmtitle_ isNotBlank]) {
        UIAlertAction *defult = [UIAlertAction actionWithTitle:_confirmtitle_ style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (hander2) {
                hander2(action);
            }
        }];
        
        [alertController addAction:defult];
    }
    if (vc) {
        [vc presentViewController:alertController animated:YES completion:nil];
    }
    
}

+ (void)alertErrorWithItem:(FanRequestItem *)item{
     dispatch_async(dispatch_get_main_queue(), ^{
    ErrorAlertView *errorAlert = [ErrorAlertView new];
    errorAlert.errorType = item.errorType;
    errorAlert.errorTxt = DICTION_OBJECT(item.responseObject, @"msg");
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:errorAlert];
     });

}
+ (void)alertErrorWithMessage:(NSString *)message{
     dispatch_async(dispatch_get_main_queue(), ^{
    ErrorAlertView *errorAlert = [ErrorAlertView new];
    errorAlert.errorType = FanErrorTypeTopAlert;
    errorAlert.errorTxt = message;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:errorAlert];
     });
   
}

+ (void)alertMessage:(NSString *)message type:(AlertMessageType)type{
    if (![message isNotBlank]) {
        return;
    }
     dispatch_async(dispatch_get_main_queue(), ^{
    if (type == AlertMessageTypeNomal) {
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [MBProgressHUD hideHUDForView:window animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
        hud.label.text = message;
        hud.label.textColor = COLOR_PATTERN_STRING(@"_666666_color");
        hud.label.textAlignment = NSTextAlignmentCenter;
        hud.label.font = FanFont(16);
        hud.centerY = FAN_SCREEN_HEIGHT/4 * 3;
        //    hud.bezelView.backgroundColor = [UIColor redColor];
        hud.backgroundView.backgroundColor = [UIColor clearColor];
        hud.mode = MBProgressHUDModeText;
        [hud showAnimated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                hud.transform = CGAffineTransformMakeScale(0.7, 0.7);
                [hud hideAnimated:YES];
            }];
        });
    }
     });
}
+ (void)showLoadingWithCompletion:(void (^)())completion{
    UIActivityIndicatorView *_loadIng = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle :UIActivityIndicatorViewStyleWhite];
    _loadIng.transform = CGAffineTransformMakeScale(1.3, 1.3);
    _loadIng.center = CGPointMake(FAN_SCREEN_WIDTH/2, FAN_SCREEN_HEIGHT/2 - 20);
    [[UIApplication sharedApplication].delegate.window addSubview:_loadIng];
    [_loadIng startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_loadIng stopAnimating];
        [_loadIng removeFromSuperview];
        if (completion) {
            completion();
        }
    });
}
+ (void)showLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
        hud.backgroundView.backgroundColor = [UIColor clearColor];
        [hud showAnimated:YES];
        [hud hideAnimated:YES afterDelay:60];
    });
   
}
+ (void)hideLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].delegate.window animated:YES];
    });
}
@end
