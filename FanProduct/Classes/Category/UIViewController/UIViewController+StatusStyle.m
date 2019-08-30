//
//  UIViewController+StatusStyle.m
//  Baletu
//
//  Created by fangkangpeng on 2019/1/4.
//  Copyright © 2019 Fan. All rights reserved.
//

#import "UIViewController+StatusStyle.h"
#import <objc/runtime.h>

@implementation UIViewController (StatusStyle)
/**使用时打开 不使用注释掉*/
//+ (void)load{
//    [super load];
//    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(init)), class_getInstanceMethod([self class], @selector(blt_init)));
//}
- (instancetype)blt_init{
    [self blt_init];
    //记录状态栏的色值 退出页面时设置状态
    return self;
}
@end



static const char *static_title = "static_title";
static const char *static_leftName = "static_leftName";
static const char *static_leftSelectedName = "static_leftSelectedName";
static const char *static_leftImgName = "static_leftImgName";
static const char *static_leftSelectedImgName = "static_leftSelectedImgName";

static const char *static_rightName = "static_rightName";
static const char *static_rightSelectedName = "static_rightSelectedName";
static const char *static_rightImgName = "static_rightImgName";
static const char *static_rightSelectedImgName = "static_rightSelectedImgName";


static const char *static_leftButton = "static_leftButton";
static const char *static_navigationTitleLb = "static_navigationTitleLb";
static const char *static_rightButton = "static_rightButton";
static const char *static_navigationView = "static_navigationView";
static const char *static_navigationLine = "static_navigationLine";


/*
 * 导航
 */
@implementation UIViewController (Navigation)

#pragma mark -- 导航
- (void)rightButtomMethod{
    if ([self respondsToSelector:@selector(rightNavBtnCilck)]) {
        [self rightNavBtnCilck];
    }
}

- (void)leftButtomMethod{
    if ([self respondsToSelector:@selector(leftNavBtnClick)]) {
        [self leftNavBtnClick];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)leftNavBtnClick{
     [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightNavBtnCilck{
    
}
- (void)setNavTitle:(NSString *)navTitle{
    objc_setAssociatedObject(self, static_title, navTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.navigationTitleLb setText:navTitle];
}
- (void)setLeftTxt:(NSString *)leftTxt{
    objc_setAssociatedObject(self, static_leftName, leftTxt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([leftTxt isNotBlank]) {
        CGFloat width = [FanSize getWidthWithString:leftTxt fontSize:15] + 10;
        self.leftButton.width = width;
        self.leftButton.titleLabel.font = FanFont(15);
        self.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [self.leftButton setTitle:leftTxt forState:UIControlStateNormal];
    }
}
- (void)setLeftSelectedTxt:(NSString *)leftSelectedTxt{
    objc_setAssociatedObject(self, static_leftSelectedName, leftSelectedTxt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self.leftButton setTitle:leftSelectedTxt forState:UIControlStateSelected];
    self.leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
}
- (void)setLeftImage:(NSString *)leftImage{
    objc_setAssociatedObject(self, static_leftImgName, leftImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if([leftImage isNotBlank]){
        UIImage *image = [UIImage imageNamed:leftImage];
        self.leftButton.imageEdgeInsets = UIEdgeInsetsMake(22 - image.size.height/2, 10, 22 - image.size.height/2, 22 - image.size.width/2);
        [self.leftButton setImage:image forState:UIControlStateNormal];
    }
}
- (void)setLeftSelectedImage:(NSString *)leftSelectedImage{
    objc_setAssociatedObject(self, static_leftSelectedImgName, leftSelectedImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if([leftSelectedImage isNotBlank])
        [self.leftButton setImage:[UIImage imageNamed:leftSelectedImage] forState:UIControlStateSelected];
}
- (void)setRightTxt:(NSString *)rightTxt{
    objc_setAssociatedObject(self, static_rightName, rightTxt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([rightTxt isNotBlank]) {
        CGFloat width = [FanSize getWidthWithString:rightTxt fontSize:15];
        self.rightButton.left = FAN_SCREEN_WIDTH - 15 - width;
        self.rightButton.width = width;
        self.rightButton.titleLabel.font = FanFont(15);
        [self.rightButton setTitle:rightTxt forState:UIControlStateNormal];
    }
}
- (void)setRightSelectedTxt:(NSString *)rightSelectedTxt{
    objc_setAssociatedObject(self, static_rightSelectedName, rightSelectedTxt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([rightSelectedTxt isNotBlank]) {
        [self.rightButton setTitle:rightSelectedTxt forState:UIControlStateSelected];
    }
}
- (void)setRightImage:(NSString *)rightImage{
    objc_setAssociatedObject(self, static_rightImgName, rightImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([rightImage isNotBlank]) {
        UIImage *image = [UIImage imageNamed:rightImage];
        self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(22 - image.size.height/2, 22 - image.size.width/2, 22 - image.size.height/2, 0);
        [self.rightButton setImage:image forState:UIControlStateNormal];
    }
}
- (void)setRightSelectedImage:(NSString *)rightSelectedImage{
    objc_setAssociatedObject(self, static_rightSelectedName, rightSelectedImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([rightSelectedImage isNotBlank]) {
        [self.rightButton setImage:[UIImage imageNamed:rightSelectedImage] forState:UIControlStateSelected];
    }
}
- (NSString *)navTitle{
    NSString *className =  objc_getAssociatedObject(self,static_title);
    if (!className) {
        className = @"";
        objc_setAssociatedObject(self, static_title, className, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return className;
}
- (NSString *)leftTxt{
    NSString *className =  objc_getAssociatedObject(self,static_leftName);
    if (!className) {
        className = @"";
        objc_setAssociatedObject(self, static_leftName, className, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return className;
}

- (NSString *)rightTxt{
    NSString *className =  objc_getAssociatedObject(self,static_rightName);
    if (!className) {
        className = @"";
        objc_setAssociatedObject(self, static_rightName, className, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return className;
}
- (NSString *)leftSelectedTxt{
    NSString *className =  objc_getAssociatedObject(self,static_leftSelectedName);
    if (!className) {
        className = @"";
        objc_setAssociatedObject(self, static_leftSelectedName, className, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return className;
}
- (NSString *)rightSelectedTxt{
    NSString *className =  objc_getAssociatedObject(self,static_rightSelectedName);
    if (!className) {
        className = @"";
        objc_setAssociatedObject(self, static_rightSelectedName, className, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return className;
}
- (NSString *)leftImage{
    NSString *className =  objc_getAssociatedObject(self,static_leftImgName);
    if (!className) {
        className = @"";
        objc_setAssociatedObject(self, static_leftImgName, className, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return className;
}
- (NSString *)leftSelectedImage{
    NSString *className =  objc_getAssociatedObject(self,static_leftSelectedImgName);
    if (!className) {
        className = @"";
        objc_setAssociatedObject(self, static_leftSelectedImgName, className, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return className;
}
- (NSString *)rightImage{
    NSString *className =  objc_getAssociatedObject(self,static_rightImgName);
    if (!className) {
        className = @"";
        objc_setAssociatedObject(self, static_rightImgName, className, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return className;
}
- (NSString *)rightSelectedImage{
    NSString *className =  objc_getAssociatedObject(self,static_rightSelectedImgName);
    if (!className) {
        className = @"";
        objc_setAssociatedObject(self, static_rightSelectedImgName, className, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return className;
}
- (UIView *)navigationView{
    UIView * view = objc_getAssociatedObject(self,static_navigationView);
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_NAV_HEIGHT)];
        [view setBackgroundColor:COLOR_PATTERN_STRING(@"_ffffff_color")];
        [view addSubview:self.navigationLine];
        [self.view addSubview:view];
        [self.view bringSubviewToFront:view];
        objc_setAssociatedObject(self, static_navigationView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return view;
}
- (UIView *)navigationLine{
    UIView * view = objc_getAssociatedObject(self,static_navigationLine);
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT - FAN_LINE_HEIGHT, FAN_SCREEN_WIDTH, FAN_LINE_HEIGHT)];
        [view setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        objc_setAssociatedObject(self, static_navigationLine, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return view;
}
- (UIButton *)leftButton{
    UIButton *leftButton = objc_getAssociatedObject(self,static_leftButton);
    if (!leftButton) {
        leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(5, FanNavSubViewTop(20), 59, 44);
        [leftButton setTitleColor:COLOR_PATTERN_STRING(@"_212121_color") forState:UIControlStateNormal];
        [leftButton setTitleColor:COLOR_PATTERN_STRING(@"_212121_color") forState:UIControlStateSelected];
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [leftButton addTarget:self action:@selector(leftButtomMethod) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationView addSubview:leftButton];
        objc_setAssociatedObject(self, static_leftButton, leftButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return leftButton;
}
- (UIButton *)rightButton{
    UIButton *rightButton = objc_getAssociatedObject(self,static_rightButton);
    if (!rightButton) {
        rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(FAN_SCREEN_WIDTH - 15 - 44, FanNavSubViewTop(20), 44, 44);
        [rightButton setTitleColor:COLOR_PATTERN_STRING(@"_212121_color") forState:UIControlStateNormal];
        [rightButton setTitleColor:COLOR_PATTERN_STRING(@"_212121_color") forState:UIControlStateSelected];
        rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [rightButton addTarget:self action:@selector(rightButtomMethod) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationView addSubview:rightButton];
        objc_setAssociatedObject(self, static_rightButton, rightButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return rightButton;
}
- (UILabel *)navigationTitleLb{
     UILabel *navigationTitleLb = objc_getAssociatedObject(self,static_navigationTitleLb);
    if (!navigationTitleLb) {
        navigationTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(60, FanNavSubViewTop(33), FAN_SCREEN_WIDTH - 120, 20)];
        navigationTitleLb.textColor = COLOR_PATTERN_STRING(@"_212121_color");
        navigationTitleLb.font = FanBoldFont(18);
        navigationTitleLb.textAlignment = NSTextAlignmentCenter;
        navigationTitleLb.tag = 9090;
        [self.navigationView addSubview:navigationTitleLb];
         objc_setAssociatedObject(self, static_navigationTitleLb, navigationTitleLb, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return navigationTitleLb;
}
@end
