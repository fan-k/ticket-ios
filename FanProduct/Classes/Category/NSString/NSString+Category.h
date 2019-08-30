//
//  NSString+Category.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/17.
//  Copyright © 2018 Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**根据银行卡名称 获取银行的信息*/
@interface NSString (bank)
/**银行卡背景颜色*/
- (NSString *)bankBgColor;
/**银行卡背景图片*/
- (NSString *)bankBgImage;
/**银行卡图标*/
- (NSString *)bankIcon;
@end

@interface NSString (Category)
/**排空*/
- (NSString *)toFilterSpace;
/**转换性别 0.1.2 -> 性别*/
- (NSString *)toConversionSex;
/**转换性别  性别 -> 0.1.2*/
- (NSString *)toChangedSexToNumber;

/**
 *  手机号字符替换<eg:185****6353>
 */
- (NSString *)phoneNumberReplace;

/**字符串银行卡格式化*/
- (NSString *)formatterBankCardNum;
/*
 * 映射表
 */
- (NSString *)toClassController;
@property (nonatomic ,strong) NSDictionary *classTable;
/**
 判断字符数非空

 @return yes/no
 */
- (BOOL)isNotBlank;

/**
 json字符串转字典

 @return NSDictionary
 */
- (NSDictionary *)toDict;


/**
 URL链接 转化为字典参数

 @return 字典
 */
- (NSMutableDictionary *)urlToParamDict;
/**
 比较俩字符串

 @param string
 */
- (BOOL)equal:(NSString *)string;

/**机型*/
+ (NSString *)iphoneType;

/**改变目标文字的字体大小 颜色*/
- (NSMutableAttributedString *)changetargetTextColor:(UIColor *)color font:(NSInteger)font withText:(NSString *)string;
/**协议文字改变字体颜色 可点*/
- (NSMutableAttributedString *)xieyi_changeColor:(NSString *)changeColorTxt withAlignment:(NSTextAlignment)alignment;
@end


@interface NSMutableAttributedString (Category)

/**
 改变指定文本的字体大小颜色样式

 @param color color
 @param font font
 @param text text
 */
- (void)changeStringStyleWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font;
/**协议文字改变字体颜色 可点*/
- (NSMutableAttributedString *)xieyi_changeColor:(NSString *)changeColorTxt color:(NSString *)color;
@end
