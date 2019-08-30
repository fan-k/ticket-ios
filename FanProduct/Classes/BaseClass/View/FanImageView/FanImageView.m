//
//  FanImageView.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/26.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "FanImageView.h"

@implementation FanImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }return self;
}
- (void)setImageWithUrl:(NSString *)imageUrl{
    if (![imageUrl isNotBlank]) {
        return;
    }
   
    if ([imageUrl isKindOfClass:[UIImage class]]) {
        self.image = (UIImage *)imageUrl;
        return;
    }
     _imgUrl = imageUrl;
    if ([imageUrl hasPrefix:@"http"]) {
        
        [self setImageWithURL:[NSURL URLWithString:imageUrl] placeholder:self.placeholderImage options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    }else{
        UIImage * image = [UIImage imageNamed:imageUrl];
        if (image) {
            self.image = image;
        }
    }
    
   
}

@end
