//
//  FanControlInitMothods.h
//  FanProduct
//
//  Created by 99epay on 2019/7/5.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FanControlInitMothods : NSObject
/**
 初始化一个View
 
 @param superView       父视图
 @param rect            view的坐标
 @param backgroundColor 背景颜色
 
 @return view
 */
UIView *initView(id superView, CGRect rect, UIColor *backgroundColor);

/**
 初始化一个带边框的View
 
 @param superView       父视图
 @param rect            坐标
 @param backgroundColor 背景颜色
 @param borderWidth     边框宽度
 @param borderColor     边框颜色
 
 @return view
 */
UIView *initViewWithBorder(id superView, CGRect rect, UIColor *backgroundColor, CGFloat borderWidth, UIColor *borderColor);

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
UIView *initViewWithBorderAndCornerRadius(id superView, CGRect rect, UIColor *backgroundColor, CGFloat borderWidth, UIColor *borderColor, CGFloat radius);

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
UILabel *initLabel(id superView, CGRect rect, NSTextAlignment alignment, NSString *text, UIFont *font, UIColor *textColor);

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
UIButton *initButton(id superView, CGRect rect, UIColor *backgroundColor, NSInteger tag, NSString *title, UIColor *titleColor, UIFont *font, id target, SEL action);

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
UIButton *initImageButton(id superView, CGRect rect, NSInteger tag, UIImage *img, id target, SEL action);

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
UIButton *initImageAndTitleButton(id superView, CGRect rect, NSInteger tag, NSString *title, UIColor *titleColor, UIFont *font, UIImage *image, id target, SEL action);

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
UIButton *initButtonWithBorderAndCornerRadius(id superView, CGRect rect, UIColor *backgroundColor,NSInteger tag, NSString *title, UIColor *titleColor, UIFont *font, id target, SEL action, CGFloat borderWidth, UIColor *borderColor, CGFloat radius, BOOL clipsToBounds);


#pragma mark - init with UIImageView
/**
 初始化一个imageView
 
 @param superView 父视图
 @param rect      坐标
 @param image     图片
 
 @return imageView
 */
UIImageView *initImageView(id superView, CGRect rect, UIImage *image);

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
UITextField *initTextField(id superView, CGRect rect, id delegate, NSString *placeholder, UIFont *font, UIColor *textColor);

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
UITextField *initWithLeftTextModeTextField(id superView, CGRect rect, id delegate, NSString *placeholder, UIFont *font, UIColor *textColor, CGRect leftRect, NSString *leftTitle, UIColor *leftTitleColor);

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
UITextField *initWithLeftImageModeTextField(id superView, CGRect rect, id delegate, NSString *placeholder, UIFont *font, UIColor *textColor, CGRect leftRect, UIImage *image);

#pragma mark - init with UITableView

/**
 初始化一个tableView
 
 @param superView 父视图
 @param rect      坐标
 @param dataSoure 数据源
 @param delegate  代理
 @param style     plain || group tab类型
 @param cellStyle 分割线类型
 
 @return tableView
 */
UITableView *initTableView(id superView, CGRect rect, id<UITableViewDataSource> dataSoure, id<UITableViewDelegate> delegate, UITableViewStyle style, UITableViewCellSeparatorStyle cellStyle);

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
UIScrollView *initScrollView(id superView, CGRect rect, NSInteger tag,id<UIScrollViewDelegate> delegate, BOOL showsHorizontalScrollIndicator, BOOL showsVerticalScrollIndicator, UIColor *backgroundColor);

#pragma mark - init with UISearchBar
/**
 初始化一个搜索框-searchBar
 
 @param superView   父视图
 @param rect        坐标
 @param delegate    代理
 @param placeholder 默认文字
 
 @return searchBar
 */
UISearchBar *initSearchBar(id superView, CGRect rect, id delegate, NSString *placeholder);

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
UISearchBar *initCustomSearchBar(id superView, CGRect rect, id delegate, NSString *placeholder, UISearchBarStyle style, UIColor *tintColor, UIColor *barColor, UIImage *backgroundImage);
@end

NS_ASSUME_NONNULL_END
