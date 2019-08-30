//
//  FanSize.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/20.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "FanSize.h"

@implementation FanSize
/**根据字体和字号和宽度获取高度*/
+ (CGFloat)getHeightWithString:(NSString *)str
                      fontSize:(CGFloat)fontSize
                         width:(CGFloat)width
{
    
    UILabel * tV = [[UILabel alloc] init];
    tV.numberOfLines = 0;
    if ([str isKindOfClass:[NSString class]]) {
        tV.text = str;
        tV.font = FanFont(fontSize);
    }else if ([str isKindOfClass:[NSAttributedString class]]){
        tV.attributedText  = (NSAttributedString *)str;
    }
    tV.frame = CGRectMake(0, 0, width, 0);
    [tV sizeToFit];
    return tV.frame.size.height;
}
/**根据字体和字号获取宽度*/
+ (CGFloat)getWidthWithString:(NSString *)str
                     fontSize:(CGFloat)fontSize
{
    NSString *detailStr = str;
    NSDictionary *attribute = @{NSFontAttributeName:FanFont(fontSize)};
    CGSize size = [detailStr sizeWithAttributes:attribute];
    //    CGSize ziTiSize = [detailStr boundingRectWithSize:CGSizeMake(MAXFLOAT , K_LINE_HEIGHT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    //
    //    float wid = ziTiSize.width;
    
    return size.width;
}

/**获取图片的大小 (单位M)*/
+ (CGFloat)getImageSizeWithImage:(UIImage *)image
{
    NSData *imgData = UIImageJPEGRepresentation(image,1.0);
    float length = imgData.length;
    
    float folderSize = 0.0;
    folderSize =length/(1024.0*1024.0);
    
    return folderSize;
}
@end
