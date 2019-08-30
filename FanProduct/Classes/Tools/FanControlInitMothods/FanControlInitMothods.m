//
//  FanControlInitMothods.m
//  FanProduct
//
//  Created by 99epay on 2019/7/5.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanControlInitMothods.h"

@implementation FanControlInitMothods
#pragma mark - init with UIView

/**
 初始化一个View
 
 @param superView       父视图
 @param rect            view的坐标
 @param backgroundColor 背景颜色
 
 @return view
 */
UIView *initView(id superView, CGRect rect, UIColor *backgroundColor){
    return initViewWithBorder(superView, rect, backgroundColor, 0, nil);
}


/**
 初始化一个带边框的View
 
 @param superView       父视图
 @param rect            坐标
 @param backgroundColor 背景颜色
 @param borderWidth     边框宽度
 @param borderColor     边框颜色
 
 @return view
 */
UIView *initViewWithBorder(id superView, CGRect rect, UIColor *backgroundColor, CGFloat borderWidth, UIColor *borderColor){
    return initViewWithBorderAndCornerRadius(superView, rect, backgroundColor, borderWidth, borderColor, 0);
}

/**
 初始化一个带边框和圆角的View
 
 @param superView       父视图
 @param rect            坐标
 @param backgroundColor 背景颜色
 @param borderWidth     边框宽度
 @param borderColor     边框颜色
 @param radius          圆角大小
 
 @return view
 */
UIView *initViewWithBorderAndCornerRadius(id superView, CGRect rect, UIColor *backgroundColor, CGFloat borderWidth, UIColor *borderColor, CGFloat radius){
    UIView *v = [[UIView alloc]initWithFrame:rect];
    v.backgroundColor = backgroundColor;
    if (borderWidth != 0 && borderColor) {
        v.layer.borderWidth = borderWidth;
        v.layer.borderColor = borderColor.CGColor;
    }
    
    if (radius != 0) {
        v.layer.cornerRadius = radius;
    }
    
    if (superView) {
        [superView addSubview:v];
    }
    return v;
    
}
#pragma mark - init with UILabel
/**
 初始化一个label
 
 @param superView 父视图
 @param rect      坐标
 @param alignment 对齐方式
 @param text      文本
 @param font      字体大小
 @param textColor 字体颜色
 
 @return label
 */
UILabel *initLabel(id superView, CGRect rect, NSTextAlignment alignment, NSString *text, UIFont *font, UIColor *textColor){
    UILabel *l = [[UILabel alloc]initWithFrame:rect];
    l.text = text;
    l.textAlignment = alignment;
    l.font = font;
    l.textColor = textColor;
    if (superView) {
        [superView addSubview:l];
    }
    
    return l;
}
#pragma mark - init with UIButton
/**
 初始化一个button
 
 @param superView       父视图
 @param rect            坐标
 @param backgroundColor 背景颜色
 @param tag             tag值
 @param title           标题
 @param titleColor      标题颜色
 @param font            字体大小
 @param target          目标事件
 @param action          绑定事件
 
 @return button
 */
UIButton *initButton(id superView, CGRect rect, UIColor *backgroundColor, NSInteger tag, NSString *title, UIColor *titleColor, UIFont *font, id target, SEL action){
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = rect;
    if (backgroundColor != nil) {
        b.backgroundColor = backgroundColor;
    }
    [b setTag:tag];
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:titleColor forState:UIControlStateNormal];
    
    if (font != nil){
        b.titleLabel.font = font;
    }
    [b addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (superView) {
        [superView addSubview:b];
    }
    return b;
}
/**
 初始化一个图片button
 
 @param superView 父视图
 @param rect      坐标
 @param tag       tag值
 @param img       图片
 @param target    目标事件
 @param action    绑定事件
 
 @return button
 */
UIButton *initImageButton(id superView, CGRect rect, NSInteger tag, UIImage *img, id target, SEL action)
{
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    b.frame = rect;
    [b setTag:tag];
    [b addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (img != nil) {
        [b setImage:img forState:UIControlStateNormal];
    }
    if (superView) {
        [superView addSubview:b];
    }
    return b;
}
/**
 初始化一个带文字和图片的button
 
 @param superView  父视图
 @param rect       坐标
 @param tag        tag值
 @param title      标题
 @param titleColor 标题颜色
 @param font       字体大小
 @param image      图片
 @param target     目标
 @param action     绑定事件
 
 @return button
 */
UIButton *initImageAndTitleButton(id superView, CGRect rect, NSInteger tag, NSString *title, UIColor *titleColor, UIFont *font, UIImage *image, id target, SEL action){
    UIButton *b = initImageButton(superView, rect, tag, image, target, action);
    if (title != nil && [title isEqualToString:@""]) {
        [b setTitle:title forState:UIControlStateNormal];
    }
    if (titleColor != nil) {
        [b setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (image != nil) {
        [b setImage:image forState:UIControlStateNormal];
    }
    
    return b;
    
}
/**
 初始化一个带圆角的button
 
 @param superView       父视图
 @param rect            坐标
 @param backgroundColor 背景颜色
 @param tag             tag
 @param title           标题
 @param titleColor      标题颜色
 @param font            字体大小
 @param target          目标
 @param action          绑定事件
 @param borderWidth     边框粗细
 @param borderColor     边框亚瑟
 @param radius          圆角大小
 @param clipsToBounds   BOOL
 
 @return button
 */
UIButton *initButtonWithBorderAndCornerRadius(id superView, CGRect rect, UIColor *backgroundColor,NSInteger tag, NSString *title, UIColor *titleColor, UIFont *font, id target, SEL action, CGFloat borderWidth, UIColor *borderColor, CGFloat radius, BOOL clipsToBounds){
    UIButton *b = initButton(superView, rect, backgroundColor, tag, title, titleColor, font, target, action);
    if (borderWidth != 0) {
        b.layer.borderWidth = borderWidth;
    }
    if (borderColor != nil) {
        b.layer.borderColor = borderColor.CGColor;
    }
    if (radius != 0) {
        b.layer.cornerRadius = radius;
    }
    if (clipsToBounds) {
        b.clipsToBounds = clipsToBounds;
    }
    if (superView) {
        [superView addSubview:b];
    }
    return b;
}

#pragma mark - init with UIImageView
/**
 初始化一个imageView
 
 @param superView 父视图
 @param rect      坐标
 @param image     图片
 
 @return imageView
 */
UIImageView *initImageView(id superView, CGRect rect, UIImage *image){
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:rect];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.userInteractionEnabled = YES;
    if (image != nil) {
        [imgView setImage:image];
    }
    if (superView) {
        [superView addSubview:imgView];
    }
    return imgView;
}
#pragma mark - init with UITextField

/**
 初始化一个textField
 
 @param superView   父视图
 @param rect        坐标
 @param delegate    代理
 @param placeholder 默认文字
 @param font        字体大小
 @param textColor   字体颜色
 
 @return textField
 */
UITextField *initTextField(id superView, CGRect rect, id delegate, NSString *placeholder, UIFont *font, UIColor *textColor){
    UITextField *t = [[UITextField alloc]initWithFrame:rect];
    t.delegate = delegate;
    t.placeholder = placeholder;
    if (font != nil) {
        t.font = font;
    }
    t.autocorrectionType = UITextAutocorrectionTypeNo;//定义文本是否使用iPhone的自动更正功能。
    t.autocapitalizationType = UITextAutocapitalizationTypeNone;//关闭自动大写
    //t.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//居中对齐
    if (textColor != nil) {
        t.textColor = textColor;
    }
    if (superView) {
        [superView addSubview:t];
    }
    return t;
}
/**
 初始化一个带有文字左视图的textField
 
 @param superView      父视图
 @param rect           坐标
 @param delegate       代理
 @param placeholder    默认文字
 @param font           字体大小
 @param textColor      字体颜色
 @param leftRect       左视图坐标
 @param leftTitle      左视图标题
 @param leftTitleColor 左视图标题颜色
 
 @return textField
 */
UITextField *initWithLeftTextModeTextField(id superView, CGRect rect, id delegate, NSString *placeholder, UIFont *font, UIColor *textColor, CGRect leftRect, NSString *leftTitle, UIColor *leftTitleColor){
    UITextField *t = initTextField(superView, rect, delegate, placeholder, font, textColor);
    if (leftTitle && [leftTitle isEqualToString:@""]) {
        UILabel *l = [[UILabel alloc]initWithFrame:leftRect];
        l.text = leftTitle;
        l.textColor = leftTitleColor;
        l.textAlignment = NSTextAlignmentCenter;
        t.leftView = l;
        t.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return t;
}
/**
 初始化一个带有图片左视图的textField
 
 @param superView      父视图
 @param rect           坐标
 @param delegate       代理
 @param placeholder    默认文字
 @param font           字体大小
 @param textColor      字体颜色
 @param leftRect       左视图坐标
 
 @return textField
 */
UITextField *initWithLeftImageModeTextField(id superView, CGRect rect, id delegate, NSString *placeholder, UIFont *font, UIColor *textColor, CGRect leftRect, UIImage *image){
    UITextField *t = initTextField(superView, rect, delegate, placeholder, font, textColor);
    if (image != nil) {
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:leftRect];
        imgV.image = image;
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        t.leftView = imgV;
        t.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return t;
}
#pragma mark - init with UITableView

/**
 初始化一个tableView
 
 @param superView 父视图
 @param rect      坐标
 @param dataSoure 数据源
 @param delegate  代理
 @param style     plain || group <tab类型>
 @param cellStyle 分割线类型
 
 @return tableView
 */
UITableView *initTableView(id superView, CGRect rect, id<UITableViewDataSource> dataSoure, id<UITableViewDelegate> delegate, UITableViewStyle style, UITableViewCellSeparatorStyle cellStyle){
    UITableView *tab = [[UITableView alloc]initWithFrame:rect style:style];
    tab.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tab.dataSource = dataSoure;
    tab.delegate = delegate;
    tab.separatorStyle = cellStyle;
    if (superView) {
        [superView addSubview:tab];
    }
    return tab;
}
#pragma mark - init with UIScrollView

/**
 初始化一个scrollView
 
 @param superView                      父视图
 @param rect                           坐标
 @param tag                            tag值
 @param delegate                       代理
 @param showsHorizontalScrollIndicator 是否显示水平滑动条
 @param showsVerticalScrollIndicator   是否显示垂直滑动条
 @param backgroundColor                背景颜色
 
 @return scrollView
 */
UIScrollView *initScrollView(id superView, CGRect rect, NSInteger tag,id<UIScrollViewDelegate> delegate, BOOL showsHorizontalScrollIndicator, BOOL showsVerticalScrollIndicator, UIColor *backgroundColor){
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    //    scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.tag = tag;
    if (backgroundColor != nil) {
        scrollView.backgroundColor = backgroundColor;
    }
    scrollView.delegate = delegate;
    scrollView.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    scrollView.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
    if (superView){
        [superView addSubview:scrollView];
    }
    
    return scrollView;
}
#pragma mark - init with UISearchBar
/**
 初始化一个搜索框-searchBar
 
 @param superView   父视图
 @param rect        坐标
 @param delegate    代理
 @param placeholder 默认文字
 
 @return searchBar
 */
UISearchBar *initSearchBar(id superView, CGRect rect, id delegate, NSString *placeholder){
    return initCustomSearchBar(superView, rect, delegate, placeholder, 0, nil, nil, nil);
}

/**
 初始化一个自定义搜索框
 
 @param superView       父视图
 @param rect            坐标
 @param delegate        代理
 @param placeholder     默认文字
 @param style           搜索框的风格、类型
 @param tintColor       bar的颜色(具有渐变效果)搜索栏闪动条和选择栏边框,取消按钮和选择栏被选中时候都会变成设置的颜色
 @param barColor        除搜索栏框框,就像贴了一张镂空了搜索栏的颜色贴图,不影响其他任何设置的颜色
 @param backgroundImage 背景图片
 
 @return searchBar
 */
UISearchBar *initCustomSearchBar(id superView, CGRect rect, id delegate, NSString *placeholder, UISearchBarStyle style, UIColor *tintColor, UIColor *barColor, UIImage *backgroundImage){
    UISearchBar *s = [[UISearchBar alloc]initWithFrame:rect];
    s.delegate = delegate;
    s.placeholder = placeholder;
    if (style != 0 && [s respondsToSelector:@selector(setSearchBarStyle:)]) {
        s.searchBarStyle = UISearchBarStyleMinimal;
    }
    if (tintColor && [s respondsToSelector:@selector(setTintColor:)]) {
        s.tintColor = tintColor;
    }
    if (barColor && [s respondsToSelector:@selector(setBarTintColor:)]) {
        s.barTintColor = barColor;
    }
    if (backgroundImage && [s respondsToSelector:@selector(setBackgroundImage:)]) {
        s.backgroundImage = backgroundImage;
    }
    
    return s;
}
@end
