//
//  FanFontDefine.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/20.
//  Copyright © 2018 Fan. All rights reserved.
//

#ifndef FanFontDefine_h
#define FanFontDefine_h

#endif /* FanFontDefine_h */

/**系统字体名称*/
static inline NSString * SystemFontName(BOOL bold){
    if (bold) {
        return [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Semibold" : @"Helvetica";
    }
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0 ? @"PingFangSC-Regular" : @"Helvetica";
}

/**默认字体大小方法*/
//static inline UIFont *FanFont(CGFloat fontSize){
//    return  [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight];
//}
//static inline UIFont *FanLightFont(CGFloat fontSize){
//    return  [UIFont systemFontOfSize:fontSize weight:UIFontWeightLight];
//}
//static inline UIFont *FanRegularFont(CGFloat fontSize){
//    return  [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
//}
//static inline UIFont *FanBoldFont(CGFloat fontSize){
//    return  [UIFont systemFontOfSize:fontSize weight:UIFontWeightBold];
//}
//static inline UIFont *FanHeavyFont(CGFloat fontSize){
//    return  [UIFont systemFontOfSize:fontSize weight:UIFontWeightHeavy];
//}
//static inline UIFont *FanUltraLightFont(CGFloat fontSize){
//    return  [UIFont systemFontOfSize:fontSize weight:UIFontWeightUltraLight];
//}
//static inline UIFont *FanMediumFont(CGFloat fontSize){
//    return  [UIFont systemFontOfSize:fontSize weight:UIFontWeightMedium];
//}

static inline UIFont *FanFont(CGFloat fontSize){
    return   [UIFont fontWithName:@"PingFangSC-Regular" size: fontSize];
}
static inline UIFont *FanRegularFont(CGFloat fontSize){
    return  [UIFont fontWithName:@"PingFangSC-Regular" size: fontSize];
}
static inline UIFont *FanBoldFont(CGFloat fontSize){
    return  [UIFont fontWithName:@"PingFangSC-Semibold" size: fontSize];
}
static inline UIFont *FanMediumFont(CGFloat fontSize){
    return  [UIFont fontWithName:@"PingFangSC-Regular" size: fontSize];
}

