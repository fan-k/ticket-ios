//
//  FanViewDefine.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/20.
//  Copyright © 2018 Fan. All rights reserved.
//

#ifndef FanViewDefine_h
#define FanViewDefine_h

/**随机颜色*/
#define FanRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
/**导航高度*/
#define  FAN_NAV_HEIGHT  FAN_NAV_HEIGHTFunction()

/**tabbar高度*/
#define FAN_TABBAR_HEIGHT FAN_TABBAR_HEIGHTFunction()

/**设备宽*/
#define  FAN_SCREEN_WIDTH FAN_SCREEN_WIDTHFunction()

/**设备高*/
#define FAN_SCREEN_HEIGHT FAN_SCREEN_HEIGHTFunction()

/**去导航去tabbar 的高度*/
#define FAN_CONTENT_HEIGHT FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT - FAN_TABBAR_HEIGHT
/**分割线高度*/
#define FAN_LINE_HEIGHT FAN_LINE_HEIGHTFunction()
#endif /* FanViewDefine_h */

/**是否为iPhoneX系列*/
static inline BOOL FaniPhoneX() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    
    return iPhoneXSeries;
}
/**导航高度*/
static inline  CGFloat FAN_NAV_HEIGHTFunction(){
    if(FaniPhoneX()){
        return 88.0f;
    }else{
        return 64.0f;
    }
}
/**导航子视图距顶高度*/
static inline CGFloat FanNavSubViewTop(CGFloat height){
    if(FaniPhoneX()){
        return 20.0f + height;
    }else{
        return height;
    }
}
/**tabbar高度*/
static inline  CGFloat FAN_TABBAR_HEIGHTFunction(){
    if(FaniPhoneX()){
        return 83.0f;
    }else{
        return 49.0f;
    }
}
/**tabbbar内部子视图高度计算*/
static inline  CGFloat FanTabbarSubViewHeight(CGFloat height){
    if(FaniPhoneX()){
        return height - 34.0f;
    }else{
        return height;
    }
}
/**tabbar 视图高度*/
static inline  CGFloat FanTabbarViewHeight(CGFloat height){
    if(FaniPhoneX()){
        return height + 34.0f;
    }else{
        return height;
    }
}
/**设备宽*/
static inline  CGFloat FAN_SCREEN_WIDTHFunction(){
    CGFloat ssss  = [[UIScreen mainScreen] bounds].size.width;
    return ssss;
}
/**设备高*/
static inline  CGFloat FAN_SCREEN_HEIGHTFunction(){
    CGFloat ssss  = [[UIScreen mainScreen] bounds].size.height;
    return ssss;
}

/**分割线高度*/
static inline CGFloat FAN_LINE_HEIGHTFunction(){
    return  (1 / [UIScreen mainScreen].scale);
}

/**以375为基础 适配比例后的宽*/
static inline CGFloat FanWidth(CGFloat width){
    return width * FAN_SCREEN_WIDTHFunction()/375;
}
/**以667为基础 适配比例后的高*/
static inline CGFloat FanHeight(CGFloat height){
    return height * FAN_SCREEN_HEIGHTFunction()/667;
}


/**键盘高度  适配iPhoneX*/
static inline  int Fan_KeyBoard_Height(){
    if (FaniPhoneX()) {
        return 340;
    }else
        return 270;
}
