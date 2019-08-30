//
//  FanTextField.h
//  FanProduct
//
//  Created by 99epay on 2019/6/19.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol FanTextFieldDelegate;
@interface FanTextField : UITextField<UITextFieldDelegate>
/**开启4字一组的数字搁置  xxxx xxxx xxxx*/
@property (nonatomic ,assign) BOOL style_count;
/**自定义代理*/
@property (nonatomic ,assign) id <FanTextFieldDelegate> fandelegate;
/**光标位置 或者左视图开始的位置*/
@property (nonatomic ,assign) NSInteger leftOffset;
/**是否直接释放第一响应*/
@property (nonatomic ,assign) BOOL RightoffresignFirstResponder;
/**设置错误提示文字*/
@property (nonatomic ,copy) NSString *fan_placeholderalert;
/**设置默认文字字号*/
@property (nonatomic ,strong) UIFont *fan_placeholder_font;
/**设置默认文字*/
@property (nonatomic ,copy) NSString *fan_placeholder;
/**默认文字颜色*/
@property (nonatomic ) UIColor *placeholdercolor;
/**输入警告*/
@property (nonatomic ,strong) UILabel *alertLb;
/**底线*/
@property (nonatomic ,strong) FanView *lineView;
/**底线的默认颜色*/
@property (nonatomic ,copy) NSString *lineViewNomalColor;
/**底线的高亮颜色*/
@property (nonatomic ,copy) NSString *lineViewHightColor;
/***先设置color  font****/
/**右文字字体颜色*/
@property (nonatomic ,copy) NSString * rightTxtColor;
/**右文字字体大小*/
@property (nonatomic ,assign) NSInteger rightTxtFont;
/**左文字字体颜色*/
@property (nonatomic ,copy) NSString * leftTxtColor;
/**左文字字体大小*/
@property (nonatomic ,assign) NSInteger  leftTxtFont;
/**左视图宽度*/
@property (nonatomic ,assign) CGFloat  leftViewWidth;
/**右视图宽度*/
@property (nonatomic ,assign) CGFloat  rightViewWidth;

/***再设置视图 视图使用color font****/
/**左图片视图*/
@property (nonatomic ,copy) NSString * leftImg;
/**左文字视图*/
@property (nonatomic ,copy) NSString * leftLbTxt;
/**右图片视图*/
@property (nonatomic ,copy) NSString * rightImg;
/**右文字视图*/
@property (nonatomic ,copy) NSString * rightLbTxt;
/**右文字按钮视图*/
@property (nonatomic ,copy) NSString * rightBtnTxt;
/**右图片按钮视图*/
@property (nonatomic ,copy) NSString * rightBtnImg;
/**键盘上方inputView*/
@property (nonatomic ,strong) FanView *inputView_;
/**inputView上placeholder  label*/
@property (nonatomic ,strong) UILabel *inputView_lb;
/**右侧按钮为倒计时 倒计时时长和字体颜色*/
- (void)startTimeWithTime:(NSUInteger)time timeColor:(NSString *)timeColor;
@end



@protocol FanTextFieldDelegate <NSObject>
@optional
- (BOOL)FanTextFieldShouldBeginEditing:(UITextField *)textField;        // return NO to disallow editing.
- (void)FanTextFieldDidBeginEditing:(UITextField *)textField;           // became first responder
- (BOOL)FanTextFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
- (void)FanTextFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)FanTextFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0); // if implemented, called in place of textFieldDidEndEditing:

- (BOOL)FanTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text

- (BOOL)FanTextFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)
- (BOOL)FanTextFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.

@end




NS_ASSUME_NONNULL_END
