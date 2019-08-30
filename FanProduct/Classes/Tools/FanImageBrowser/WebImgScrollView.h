//
//  WebImgScrollView.h
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/21.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebImgScrollView : UIView<UIScrollViewDelegate>
/** imgUrl  图像地址*/
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, strong) NSArray *imgUrlArr;

//图片的大小
@property (nonatomic, assign) CGSize imgSize;
//图片
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIScrollView *scrollView;


@property (nonatomic,strong) UILabel * countLabel;

@property (nonatomic, strong) UIButton *downLoadBtn;

/**若想开始定位到某个图片 在urlArr最后面 添加一个定位图片 [urlArr addobject:@"当前图片"]*/
+ (WebImgScrollView *)showImageWithImageArr:(NSArray *)urlArr;
@end
