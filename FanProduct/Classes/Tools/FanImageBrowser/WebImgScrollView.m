//
//  WebImgScrollView.m
//  smarter.LoveLog
//
//  Created by 樊康鹏 on 16/1/21.
//  Copyright © 2016年 FanKing. All rights reserved.
//

#import "WebImgScrollView.h"
#import "SDWebImageManager.h"
#import "WebImageZoomScrollView.h"



@interface WebImgScrollView  ()




@end

@implementation WebImgScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

+ (WebImgScrollView *)showImageWithImageArr:(NSArray *)urlArr{
    
    WebImgScrollView *imgSV = [[self alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imgSV.alpha = 0.3;
    [[UIApplication sharedApplication].delegate.window addSubview:imgSV];
    [UIView animateWithDuration:1 animations:^{
        imgSV.alpha = 1;
    }];
    //设定最后一个 为当前点击的图片
    imgSV.imgUrl = [urlArr lastObject];
    
    NSMutableArray * arr =[NSMutableArray array];
    for (int i =0; i < urlArr.count -1 ; i++) {
        [arr addObject:urlArr[i]];
    }
    if (arr.count == 0) {
        [arr addObjectsFromArray: urlArr];
    }
    
    imgSV.imgUrlArr = arr;
    
    return imgSV;
}




#pragma mark - private method
- (void)initSubViews{
    
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.downLoadBtn];
    
    [self addSubview:self.countLabel];
}

- (void)downLoadImg{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [FanAlert alertErrorWithMessage:@"无法读取相册"];
    }
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    int page = (int)_scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    [manager downloadImageWithURL:[NSURL URLWithString:self.imgUrlArr[page]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        self.image = image;
        if (self.image) {
            UIImageWriteToSavedPhotosAlbum(self.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        }
    }];
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if (error) {
        if (error.code == -3310) {
            [FanAlert alertErrorWithMessage:@"无读取相册权限，无法保存"];
        }else
            [FanAlert alertErrorWithMessage:@"保存失败"];
    }else
        [FanAlert alertErrorWithMessage:@"保存成功"];
}
//停止滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = (int)scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    _countLabel.text =[NSString stringWithFormat:@"%d/%lu",page+1,(unsigned long)_imgUrlArr.count];
}

#pragma mark - setter and getter
- (void)setImgUrlArr:(NSArray *)imgUrlArr{
    _imgUrlArr = imgUrlArr;
    __weak WebImgScrollView *weakSelf = self;
    [[UIApplication sharedApplication].delegate.window addSubview:self.scrollView];
    self.scrollView.contentSize =  CGSizeMake([UIScreen mainScreen].bounds.size.width * imgUrlArr.count,  [UIScreen mainScreen].bounds.size.height - 40);
    for (int  i  = 0; i < imgUrlArr.count; i++) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;

        WebImageZoomScrollView * imageScrollView = [[WebImageZoomScrollView alloc] initWithFrame:frame];
        imageScrollView.imgUrl= imgUrlArr[i];
        imageScrollView.RemoveView = ^{
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.alpha = 0.3;
            }completion:^(BOOL finished) {
                [weakSelf removeFromSuperview];
                [weakSelf.scrollView removeFromSuperview];
            }];
        };
       
        [self.scrollView addSubview:imageScrollView];
    }
    if (_imgUrl) {
        NSUInteger  index =  [_imgUrlArr indexOfObject:_imgUrl];
        [self.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width* index, 0)];
        _countLabel.text =[NSString stringWithFormat:@"%lu/%lu",(unsigned long)index+1,(unsigned long)_imgUrlArr.count];
    }
   
}


- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate =self;
        _scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 110);
    }
    return _scrollView;
}




- (UIButton *)downLoadBtn{
    if (_downLoadBtn == nil) {
        _downLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downLoadBtn addTarget:self action:@selector(downLoadImg) forControlEvents:UIControlEventTouchUpInside];
        [_downLoadBtn setImage:[UIImage imageNamed:@"News_Picture_Save"] forState:UIControlStateNormal];
        _downLoadBtn.left = [UIScreen mainScreen].bounds.size.width - 50;
        _downLoadBtn.top = [UIScreen mainScreen].bounds.size.height - 110;
        [_downLoadBtn sizeToFit];
    }
    return _downLoadBtn;
}

-(UILabel *)countLabel{
    if (!_countLabel) {
        _countLabel = [UILabel new];
        _countLabel . textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont systemFontOfSize:15];
        _countLabel.left = 30;
        _countLabel.top = [UIScreen mainScreen].bounds.size.height- 110;
        _countLabel.width=60;
        _countLabel.height=30;
        
    }
    return _countLabel;
}
@end
