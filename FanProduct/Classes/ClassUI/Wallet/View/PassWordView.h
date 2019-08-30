//
//  PassWordView.h
//  FanProduct
//
//  Created by 99epay on 2019/6/19.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PassWordView : FanView<UITextFieldDelegate>
@property (nonatomic ,assign) BOOL  secureTextEntry;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) NSMutableArray *passwordIndicatorArrary;
/***键盘成为第一响应*/
-(void)fieldBecomeFirstResponder;
/***键盘失去第一响应*/
-(void)fieldResignFirstResponder;
/***清除密码*/
-(void)clearUpPassword;
@end


@interface FanPayAlertView : FanView

- (instancetype)initWithFrame:(CGRect)frame message:(NSString *)message money:(NSString *)money;
@end
NS_ASSUME_NONNULL_END
