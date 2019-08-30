//
//  FanSize.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/20.
//  Copyright © 2018 Fan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FanSize : NSObject
/**根据字体和字号和宽度获取高度*/
+ (CGFloat)getHeightWithString:(NSString *)str
                      fontSize:(CGFloat)fontSize
                         width:(CGFloat)width;
/**根据字体和字号获取宽度*/
+ (CGFloat)getWidthWithString:(NSString *)str
                     fontSize:(CGFloat)fontSize;

/**获取图片的大小 (单位M)*/
+ (CGFloat)getImageSizeWithImage:(UIImage *)image;


@end
