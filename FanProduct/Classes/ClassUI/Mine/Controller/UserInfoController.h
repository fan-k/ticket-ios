//
//  UserInfoController.h
//  FanProduct
//
//  Created by 99epay on 2019/6/12.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanController.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserInfoController : FanController

@end



typedef enum : NSUInteger {
    PickerViewType_Sex = 0,//性别
    PickerViewType_City,//居住地
}PickerViewType;

/**性别 居住地*/
@interface FanMinePickerView : FanView
<UIPickerViewDataSource,
UIPickerViewDelegate>

@property (nonatomic, strong, readwrite) UIView *maskView;
@property (nonatomic,strong) UIButton *confirmButton;
@property (nonatomic,strong) UIButton *cancelButton;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *subPickerView;

@property (nonatomic,strong) NSMutableArray *dataSoureArray;//数据源

@property (nonatomic,assign) PickerViewType type;

@property (nonatomic,copy) NSString *select_text;

@property (nonatomic,copy) NSString *default_text;


- (void)pickViewShow;
- (void)hideMyPicker;

@end


/**时间选择器*/
@interface FanDatePicker : FanView

@property (nonatomic, strong, readwrite) UIView *maskView;
@property (nonatomic,strong)UIButton *confirmButton;
@property (nonatomic,strong)UIButton *cancelButton;
@property (nonatomic,strong)UIDatePicker *datePicker;
@property (nonatomic,strong)UIView *headerView;
@property (nonatomic,strong)UIView *subPickerView;

@property (nonatomic,copy)NSString *time;//传过去时间

- (void)pickViewShow;
- (void)hideMyPicker;

@end

/**昵称*/
@interface FanUserInfoInputView : FanView


@end

@interface UserAccountImgCell : FanTableViewCell

@end

@interface UserInfoCell : FanTableViewCell

@end


@interface UserAccountImgCellModel : FanModel

@end

@interface UserInfoCellModel : FanModel
@property (nonatomic ,copy) NSString *title;

@property (nonatomic ,copy) NSString *descript;


@end
NS_ASSUME_NONNULL_END
