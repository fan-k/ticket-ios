//
//  UIImage+Category.h
//  FanProduct
//
//  Created by 99epay on 2019/6/19.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define IMAGE_WITH_NAME(name) [UIImage imageNamed:name]


@interface UIImage (Category)
/**
 创建颜色图片
 
 @param color 颜色
 @param size  大小
 
 @return 颜色图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark  获取图片大小
+ (CGSize)getImageSizeWithUrl:(NSString *)imageUrl;
//  获取jpg图片的大小
+(CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request;

+(CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request;

//  获取PNG图片的大小
+(CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request;

/**根据宽度获取图片等比例高度*/
- (CGFloat)getImageHeightWithWidth:(CGFloat)width;
@end


@interface NSData (Category)
+ (NSData *)getImgWithUrl:(NSString *)urlStr;
@end


NS_ASSUME_NONNULL_END
