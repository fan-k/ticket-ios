//
//  FanImageView.h
//  Baletu
//
//  Created by fangkangpeng on 2018/12/26.
//  Copyright © 2018 Fan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit.h>

/*
 * UIImageView的基类
 * 重写了SDWebImg加载网络图片的方法
 * 占位图
 */
@interface FanImageView : YYAnimatedImageView
/**图片名称或图片地址*/
@property (nonatomic ,copy) NSString *imgUrl;
/**占位图 在加载网络图片之前设置*/
@property (nonatomic ,copy) UIImage *placeholderImage;
/*根据URL 加载网络图片 */
- (void)setImageWithUrl:(NSString *)imageUrl;
@end
