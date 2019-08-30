//
//  UIViewController+StatusStyle.h
//  Baletu
//
//  Created by fangkangpeng on 2019/1/4.
//  Copyright © 2019 Fan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (StatusStyle)

@end


@interface UIViewController (Navigation)

#pragma mark -- 导航
/**左按钮*/
@property (nonatomic ,strong) UIButton *leftButton;
/**title*/
@property (nonatomic ,strong) UILabel *navigationTitleLb;
/**右按钮*/
@property (nonatomic ,strong) UIButton *rightButton;
/**导航视图*/
@property (nonatomic ,strong) UIView *navigationView;
/**分割线*/
@property (nonatomic ,strong) UIView *navigationLine;

/**navtitle*/
@property (nonatomic ,copy) NSString *navTitle;
/**左按钮文字*/
@property (nonatomic ,copy) NSString *leftTxt;
/**左按钮选中时的文字*/
@property (nonatomic ,copy) NSString *leftSelectedTxt;
/**右按钮文字*/
@property (nonatomic ,copy) NSString *rightTxt;
/**右按钮选中时文字*/
@property (nonatomic ,copy) NSString *rightSelectedTxt;
/**左按钮图片*/
@property (nonatomic ,copy) NSString *leftImage;
/**左按钮选中时图片*/
@property (nonatomic ,copy) NSString *leftSelectedImage;
/**右按钮图片*/
@property (nonatomic ,copy) NSString *rightImage;
/**右按钮选中时图片*/
@property (nonatomic ,copy) NSString *rightSelectedImage;


/**左侧按钮点击 可子类实现*/
-(void)leftNavBtnClick;
/**右侧按钮点击 可子类实现*/
-(void)rightNavBtnCilck;
@end
