//
//  WebImageZoomScrollView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/2/19.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "WebImageZoomScrollView.h"
#import <SDWebImageManager.h>
static CGFloat const animationDutation = 0.25f;
@implementation WebImageZoomScrollView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}




#pragma mark - UIScrollView  delegate
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.scaleView;
}

#pragma mark - private method
- (void)initSubViews{
    
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0.f;
    
    
    [self.scrollView addSubview:self.scaleView];
    [self.scaleView addSubview:self.imageView];
 
    
    [UIView animateWithDuration:animationDutation animations:^{
        self.alpha = 1;
    }];
    
}

- (void)calculateImageFrame:(UIImage *)image{
    
    self.imageView.image = image;
    CGFloat imageWidth  = image ? image.size.width :[UIScreen mainScreen].bounds.size.width;
    CGFloat imageHeight = image ? image.size.height : [UIScreen mainScreen].bounds.size.height/2;
    float scaleX = self.scrollView.width/imageWidth;
    float scaleY = self.scrollView.height/imageHeight;
    
    if (scaleX > scaleY){
        float imgViewWidth =image ? image.size.width * scaleY :[UIScreen mainScreen].bounds.size.width * scaleY;
        
        self.imageView.frame = CGRectMake((self.scrollView.width - imgViewWidth) * 0.5,0 ,imgViewWidth, self.scrollView.height);
    }else{
        float imgViewHeight =image ? image.size.height*scaleX : [UIScreen mainScreen].bounds.size.height/2 *scaleX;
        
        self.imageView.frame = CGRectMake(0, (self.scrollView.height - imgViewHeight) * 0.5, self.scrollView.width, imgViewHeight);
    }
    
    self.imageView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:animationDutation animations:^{
        self.imageView.transform = CGAffineTransformIdentity;
    }];
    
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeView];
}

- (void)removeView{
    float scaleX = self.scrollView.zoomScale;
    
    if (scaleX>1) {
        [UIView animateWithDuration:animationDutation animations:^{
            [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
        }completion:^(BOOL finished) {
        }];
    }
    else
    {
        if (self.RemoveView) {
             _RemoveView();
        }
        [UIView animateWithDuration:animationDutation animations:^{
            self.imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            self.alpha = 0.3;
        }completion:^(BOOL finished) {
           //移除
            [self removeFromSuperview];
            [self.scrollView removeFromSuperview];
        }];
    }
    
}
-(void)doubleTap{
    [UIView animateWithDuration:animationDutation animations:^{
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
    }];
}
#pragma mark - setter and getter
- (void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    if ([imgUrl isKindOfClass:[UIImage class]]) {
        UIImage *image = (UIImage *)imgUrl;
        self.image = image;
         [self calculateImageFrame:image];
    }else{
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        [manager downloadImageWithURL:[NSURL URLWithString:imgUrl] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            self.image = image;
            [self calculateImageFrame:image];
        }];
    }
    [self addSubview:self.scrollView];
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bouncesZoom = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 5;
        _scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 40);
    }
    return _scrollView;
}

- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UIView *)scaleView{
    if (_scaleView == nil) {
        _scaleView = [[UIView alloc] init];
        _scaleView.frame = _scrollView.frame;
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeView)];
        [singleTapGestureRecognizer setNumberOfTapsRequired:1];
        [_scaleView addGestureRecognizer:singleTapGestureRecognizer];
        
        UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap)];
        [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
        [_scaleView addGestureRecognizer:doubleTapGestureRecognizer];
        
        //这行很关键，意思是只有当没有检测到doubleTapGestureRecognizer 或者 检测doubleTapGestureRecognizer失败，singleTapGestureRecognizer才有效
        [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
        _scaleView.backgroundColor = [UIColor clearColor];
    }
    return _scaleView;
}




@end

