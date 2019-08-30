//
//  UserInfoController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/12.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "UserInfoController.h"

#import <AVFoundation/AVFoundation.h>


@interface UserInfoController ()
<UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UIActionSheetDelegate>
@property (nonatomic ,strong) FanTableView *tableView;
@property (nonatomic ,strong) FanUserInfoInputView *input_View;
@property (nonatomic ,strong) FanMinePickerView *pickerView;
@property (nonatomic ,strong) FanDatePicker *datePicker;
@end

@implementation UserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"个人资料";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initInfoList) name:NotificationUserInfoChanged object:nil];
    [self initInfoList];
    // Do any additional setup after loading the view.
}

- (void)initInfoList{
    NSMutableArray *infoList = @[].mutableCopy;
    [infoList addObject:[UserAccountImgCellModel new]];
    [infoList addObject:[UserInfoCellModel modelWithJson:@{@"descript":[NSString stringWithFormat:@"%@",[UserInfo shareInstance].userModel.name],@"title":@"昵称"}]];
    [infoList addObject:[UserInfoCellModel modelWithJson:@{@"descript":[NSString stringWithFormat:@"%@",[UserInfo shareInstance].userModel.sex.toConversionSex],@"title":@"性别"}]];
    [infoList addObject:[UserInfoCellModel modelWithJson:@{@"descript":[NSString stringWithFormat:@"%@",[UserInfo shareInstance].userModel.birthday],@"title":@"生日"}]];
    [infoList addObject:[UserInfoCellModel modelWithJson:@{@"descript":[NSString stringWithFormat:@"%@",[UserInfo shareInstance].userModel.adress],@"title":@"现居地"}]];
    [infoList addObject:[UserInfoCellModel modelWithJson:@{@"descript":[NSString stringWithFormat:@"%@",[UserInfo shareInstance].userModel.phone.phoneNumberReplace],@"title":@"手机号"}]];
    [infoList addObject:[UserInfoCellModel modelWithJson:@{@"descript":@"修改密码",@"title":@"登录密码"}]];
    [self.tableView.viewModel setList:infoList type:0];
}
- (void)updateUserInfoWithKey:(NSString *)key value:(NSString *)value{
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    self.params[key] = value;
    [self requestWithUrl:FanUrlUserInfoUpdate loading:NO];
}
#pragma makr -- 选照片
- (void)initActionSheet{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取 消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册上传", nil];
    actionSheet.actionSheetStyle  = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //拍照
    if (buttonIndex == 0){
        [self takingPicktures];
    }
    //从相册上传
    if (buttonIndex == 1){
        [self chooseAnAlbumPhotos];
    }
}
//拍照
- (void)takingPicktures{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法使用相机"
                                                        message:@"请在iPhone的“设置-隐私-相机”中允许访问相机。"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        //确认当前设备是否支持采用接口，是否有相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            //创建和初始化UIImagePickerController对象
            UIImagePickerController *camerarVC = [[UIImagePickerController alloc]init];
            //设置源类型
            [camerarVC setSourceType:UIImagePickerControllerSourceTypeCamera];
            [camerarVC.navigationBar setBarStyle:UIBarStyleBlack];
            //设置委托
            [camerarVC setDelegate:self];
            //是否允许编辑
            [camerarVC setAllowsEditing:YES];
            //对象展示
            [self presentViewController:camerarVC animated:YES completion:nil];
        }
    }
}
//选择照片流
- (void)chooseAnAlbumPhotos{
    //确认当前设备是否支持采用接口，是否有摄像头
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        if (@available(ios 11.0,*)) {//iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
        }
        //创建和初始化UIImagePickerController对象
        UIImagePickerController *imgPickerVC = [[UIImagePickerController alloc]init];
        //设置源类型
        [imgPickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        //设置顶部navigationBar样式
        [imgPickerVC.navigationBar setBarStyle:UIBarStyleBlack];
        //设置委托
        [imgPickerVC setDelegate:self];
        //是否允许编辑
        [imgPickerVC setAllowsEditing:YES];
        //对象展示
        [self presentViewController:imgPickerVC animated:YES completion:nil];
    }
}
//选择照片后呼叫该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:NO completion:^{
        if (@available(ios 11.0,*)) {//iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }];    //获得选择的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *dataImg = UIImageJPEGRepresentation(image, 0);
    if (dataImg) {
        NSString *img_str = [dataImg base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [UserInfo shareInstance].userModel.photo_str = img_str;
        [UserInfo saveUserInfo];
        //上传图片
        [self updateUserInfoWithKey:@"photo" value:img_str];
    }else{
        [FanAlert alertErrorWithMessage:@"获取照片失败"];
    }
    
}

- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_CONTENT_HEIGHT) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        __weak UserInfoController *weakSelf = self;
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_cell_click) {
                FanModel *model = obj;
                if (model.row == 0) {
                    //拍照
                    [weakSelf initActionSheet];
                }else if(model.row == 1){
                    //昵称
                    [[UIApplication sharedApplication].keyWindow addSubview:weakSelf.input_View];
                }else if(model.row == 2){
                    //性别
                    weakSelf.pickerView = [[FanMinePickerView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_CONTENT_HEIGHT)];
                    weakSelf.pickerView.type = PickerViewType_Sex;
                    [weakSelf.pickerView.pickerView selectRow:[weakSelf.pickerView.dataSoureArray indexOfObject:[UserInfo shareInstance].userModel.sex.length > 0 ? [UserInfo shareInstance].userModel.sex.toConversionSex : @"保密"] inComponent:0 animated:NO];
                    [weakSelf.pickerView pickViewShow];
                    weakSelf.pickerView.customActionBlock = ^(id obj, cat_action_type idx) {
                        [weakSelf updateUserInfoWithKey:@"sex" value:obj];
                        [UserInfo shareInstance].userModel.sex = obj;
                        [UserInfo saveUserInfo];
                    };
                }else if(model.row == 3){
                    //生日
                    weakSelf.datePicker = [[FanDatePicker alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT)];
                    [weakSelf.datePicker pickViewShow];
                    weakSelf.datePicker.customActionBlock = ^(id obj, cat_action_type idx) {
                        [weakSelf updateUserInfoWithKey:@"birthday" value:obj];
                        [UserInfo shareInstance].userModel.birthday = obj;
                        [UserInfo saveUserInfo];
                    };
                }else if(model.row == 4){
                    //现居地
                    weakSelf.pickerView = [[FanMinePickerView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT)];
                    weakSelf.pickerView.type = PickerViewType_City;
                    [weakSelf.pickerView pickerView:weakSelf.pickerView.pickerView didSelectRow:0 inComponent:0];
                    [weakSelf.pickerView pickViewShow];
                    weakSelf.pickerView.customActionBlock = ^(id obj, cat_action_type idx) {
                        [weakSelf updateUserInfoWithKey:@"adress" value:obj];
                        [UserInfo shareInstance].userModel.adress = obj;
                        [UserInfo saveUserInfo];
                    };
                }else if(model.row == 5){
                    //手机号
                    [FanAlert alertMessage:@"您已绑定手机号" type:AlertMessageTypeNomal];
                }else if(model.row == 6){
                    //修改密码
                    [weakSelf pushViewControllerWithUrl:@"PassWordController?type=resetpwd" transferData:nil hander:nil];
                }
            }
        };
    }return _tableView;
}
- (FanUserInfoInputView *)input_View{
    if (!_input_View) {
        _input_View = [[FanUserInfoInputView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT)];
        __weak UserInfoController *weakSelf = self;
        _input_View.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_action_click) {
                [weakSelf updateUserInfoWithKey:@"name" value:obj];
                [UserInfo shareInstance].userModel.name = obj;
                [UserInfo saveUserInfo];
            }
        };
    }
    return _input_View;
}
- (void)keyboardResignFirstResponder{
    [UIView animateWithDuration:0.25f animations:^{
        self.input_View.maskView.alpha = 0;
        [self.input_View endEditing:YES];
    } completion:^(BOOL finished) {
        [self.input_View.maskView removeFromSuperview];
        [self.input_View removeFromSuperview];
        self.input_View = nil;
    }];
}
@end

#import "MineModel.h"
#define PickerViewHeight 200
#define HeaderViewHeight 40

@interface FanMinePickerView ()
@property (nonatomic ,strong) MineUserInfoCityModel *currentinfoModel;
@end

@implementation FanMinePickerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSoureArray = [NSMutableArray array];
    }
    return self;
}
- (void)pickViewShow {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self displayPickerView];
}

- (void)displayPickerView {
    [self addSubview:self.maskView];
    [self addSubview:self.subPickerView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.subPickerView.frame = CGRectMake(0, FAN_SCREEN_HEIGHT - (PickerViewHeight + HeaderViewHeight), FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT);
    }];
}

- (void)hideMyPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.subPickerView.frame = CGRectMake(0, FAN_SCREEN_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
        [self.pickerView removeFromSuperview];
        self.subPickerView = nil;
        self.pickerView = nil;
        self.maskView = nil;
    }];
}
- (void)tapGes{
    [self hideMyPicker];
}

- (void)setType:(PickerViewType)type{
    _type = type;
    switch (type) {
        case PickerViewType_Sex:{
            NSArray *sexArr = @[@"保密",@"男",@"女"];
            [self.dataSoureArray addObjectsFromArray:sexArr];
        }
            break;
        case PickerViewType_City:{
            NSArray *citys = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"cities" ofType:@"plist"]];
            MineUserInfoCityModel *infoModel = [MineUserInfoCityModel modelWithJson:@{@"citys":citys}];
            [self.dataSoureArray addObjectsFromArray:infoModel.mutbleCitys];
        }
            break;
        default:
            break;
    }
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 44, HeaderViewHeight)];
        [_cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:COLOR_PATTERN_STRING(@"_595959_color") forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelButton.tag = 10010;
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(FAN_SCREEN_WIDTH-15-44, 0, 44, HeaderViewHeight)];
        [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _confirmButton.tag = 10086;
        [_confirmButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}


- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, HeaderViewHeight)];
        [_headerView addSubview:self.cancelButton];
        [_headerView addSubview:self.confirmButton];
        _headerView.backgroundColor = COLOR_PATTERN_STRING(@"_base_background_color");
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _headerView.height, FAN_SCREEN_WIDTH, FAN_LINE_HEIGHT)];
        line.backgroundColor = COLOR_PATTERN_STRING(@"_line_color");
        [_headerView addSubview:line];
    }
    return _headerView;
}
- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes)];
        [_maskView addGestureRecognizer:ges];
    }
    return _maskView;
}
- (UIView *)subPickerView {
    if (!_subPickerView) {
        _subPickerView = [[UIView alloc]initWithFrame:CGRectMake(0, FAN_SCREEN_HEIGHT, FAN_SCREEN_WIDTH, PickerViewHeight + HeaderViewHeight)];
        _subPickerView.backgroundColor = COLOR_PATTERN_STRING(@"_base_background_color");
        [_subPickerView addSubview:self.pickerView];
        [_subPickerView addSubview:self.headerView];
    }
    return _subPickerView;
}
- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, HeaderViewHeight, FAN_SCREEN_WIDTH, PickerViewHeight)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

#pragma mark - UIPickerViewDataSource UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.type == PickerViewType_City) {
        return 2;
    }else
        return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (self.type) {
        case PickerViewType_Sex:{
            return self.dataSoureArray.count;
        }
            break;
        case PickerViewType_City:{
            if (component == 0) {
                return self.dataSoureArray.count;
            }else{
                NSInteger seleProIndx = [pickerView selectedRowInComponent:0];
                MineUserInfoCityModel *model = self.dataSoureArray[seleProIndx];
                self.currentinfoModel = model;
                return model.citys.count;
            }
        }
            break;
        default:
            break;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (self.type) {
        case PickerViewType_Sex:{
            return self.dataSoureArray[row];
        }
            break;
        case PickerViewType_City:{
            if (component == 0) {
                MineUserInfoCityModel *model = self.dataSoureArray[row];
                return model.name;
            }else{
                return self.currentinfoModel.citys[row];
            }
        }
            break;
        default:
            break;
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:FanRegularFont(20)];
        pickerLabel.textColor = COLOR_PATTERN_STRING(@"_333333_color");
    }
    // Fill the label text here
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    return pickerLabel;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    switch (self.type) {
        case PickerViewType_Sex:{
            if ([self.dataSoureArray[row] isEqualToString:@"保密"]) {
                self.select_text = @"0";
            }else if ([self.dataSoureArray[row] isEqualToString:@"男"]){
                self.select_text = @"1";
            }else
                self.select_text = @"2";
        }
            break;
        case PickerViewType_City:{
            if (component == 0) {
                [pickerView reloadComponent:1];
            }
            NSInteger selectedProvince = [pickerView selectedRowInComponent:0];
            NSInteger selectedCity = [pickerView selectedRowInComponent:1];
            MineUserInfoCityModel *model = self.dataSoureArray[selectedProvince];
            self.select_text = [NSString stringWithFormat:@"%@-%@",model.name,self.currentinfoModel.citys[selectedCity]];
        }
            break;
        default:
            break;
    }
    
}

- (void)buttonClick:(UIButton *)sender {
    [self hideMyPicker];
    if (sender.tag == 10010) {
        return;
    }else{
        if (self.customActionBlock) {
            self.customActionBlock(self.select_text,cat_pickerView_confirm_click);
        }
    }
}


@end




#define PickerViewHeight 216
#define HeaderViewHeight 40
#define TimeInterval 0.25

@interface FanDatePicker ()



@end

@implementation FanDatePicker

- (void)pickViewShow {
    NSDateFormatter*dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    _time = [dateFormat stringFromDate:[NSDate date]];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self displayPickerView];
}

- (void)displayPickerView {
    [self addSubview:self.maskView];
    [self addSubview:self.subPickerView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.subPickerView.frame = CGRectMake(0, FAN_SCREEN_HEIGHT - (PickerViewHeight + HeaderViewHeight), FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT);
    }];
}

- (void)hideMyPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.subPickerView.frame = CGRectMake(0, FAN_SCREEN_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
        [self.datePicker removeFromSuperview];
        self.subPickerView = nil;
        self.datePicker = nil;
        self.maskView = nil;
    }];
}
- (void)tapGes{
    [self hideMyPicker];
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 0, 44, HeaderViewHeight)];
        [_cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelButton.tag = 10010;
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]initWithFrame:CGRectMake(FAN_SCREEN_WIDTH-15-44, 0, 44, HeaderViewHeight)];
        [_confirmButton setTitle:@"完成" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:16];
        _confirmButton.tag = 10086;
        [_confirmButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _confirmButton;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, HeaderViewHeight)];
        [_headerView addSubview:self.cancelButton];
        [_headerView addSubview:self.confirmButton];
        _headerView.backgroundColor = COLOR_PATTERN_STRING(@"_base_background_color");
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, _headerView.height, FAN_SCREEN_WIDTH, FAN_LINE_HEIGHT)];
        line.backgroundColor = COLOR_PATTERN_STRING(@"_line_color");
        [_headerView addSubview:line];
    }
    return _headerView;
}

- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, HeaderViewHeight, FAN_SCREEN_WIDTH, PickerViewHeight)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.backgroundColor = COLOR_PATTERN_STRING(@"_base_background_color");
        [_datePicker setValue:COLOR_PATTERN_STRING(@"_333333_color") forKey:@"textColor"];//KVO修改datePicker字体颜色
        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes)];
        [_maskView addGestureRecognizer:ges];
    }
    return _maskView;
}
- (UIView *)subPickerView {
    if (!_subPickerView) {
        _subPickerView = [[UIView alloc]initWithFrame:CGRectMake(0, FAN_SCREEN_HEIGHT, FAN_SCREEN_WIDTH, PickerViewHeight + HeaderViewHeight)];
        _subPickerView.backgroundColor = COLOR_PATTERN_STRING(@"_base_background_color");
        [_subPickerView addSubview:self.datePicker];
        [_subPickerView addSubview:self.headerView];
    }
    return _subPickerView;
}
-(void)dateChange:(UIDatePicker*)picker;{
    NSDateFormatter*dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    _time = [dateFormat stringFromDate:[picker date]];
}

- (void)buttonClick:(UIButton *)sender {
    [self hideMyPicker];
    if (sender.tag == 10010) {
        return;
    }else{
        if (self.customActionBlock) {
            self.customActionBlock(self.time,cat_datePicker_confirm_click);
        }
    }
}


@end

#import "FanTextField.h"

@interface FanUserInfoInputView ()
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic ,strong) UIView *backView;
@property (nonatomic,strong) FanTextField *nickField;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIButton *confirmBtn;
@end
@implementation FanUserInfoInputView
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)initView{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [self addSubview:self.maskView];
    [self addSubview:self.backView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChangedFirstBank:) name:UITextFieldTextDidChangeNotification object:self.nickField];
}
/**
 *  键盘show
 *
 *  @param aNotification NSNotification
 */
- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[aNotification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
        self.backView.top = FAN_SCREEN_HEIGHT - keyboardRect.size.height - _backView.height;
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  键盘hide
 *
 *  @param aNotification NSNotification
 */
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView animateWithDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:[aNotification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue] animations:^{
        self.backView.top = FAN_SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
    }];
}
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, FAN_SCREEN_HEIGHT- 60, FAN_SCREEN_WIDTH, 60)];
        _backView.backgroundColor =  COLOR_PATTERN_STRING(@"_base_background_color");
        [_backView addSubview:self.nickField];
        [self.nickField becomeFirstResponder];
        [_backView addSubview:self.label];
        [_backView addSubview:self.confirmBtn];
        
    }
    return _backView;
}
- (FanTextField *)nickField{
    if (!_nickField) {
        _nickField = [[FanTextField alloc] initWithFrame:CGRectMake(20, 0, 220, _backView.height)];
    }
    return _nickField;
}

- (UILabel *)label{
    if (!_label) {
        _label = initLabel(nil, CGRectMake(_nickField.right, 0, 50, _backView.height), NSTextAlignmentCenter, @"0/10", FanRegularFont(15), COLOR_PATTERN_STRING(@"_212121_color"));
    }
    return _label;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = initButton(nil, CGRectMake(FAN_SCREEN_WIDTH - 60, 0, 50, _backView.height), nil, 123456, @"确定", COLOR_PATTERN_STRING(@"_212121_color"), FanRegularFont(15), self, @selector(confirmBtnClick));
    }
    return _confirmBtn;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

- (void)tapGes{
    [UIView animateWithDuration:0.25f animations:^{
        self.maskView.alpha = 0;
        [self.nickField resignFirstResponder];
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)confirmBtnClick{
    if ([_nickField.text toFilterSpace].length > 0 ) {
        [self  tapGes];
        if (self.customActionBlock) {
            self.customActionBlock(_nickField.text,cat_action_click);
        }
    }else
        [FanAlert alertErrorWithMessage:@"昵称不能为空"];
}
#pragma mark - 用于限制中文的字数和统计字数
- (void)textFiledEditChangedFirstBank:(NSNotification *)obj{
    NSString *toBeString = _nickField.text;
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_nickField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [_nickField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 10) {
                _nickField.text = [toBeString substringToIndex:10];
                self.label.text = [NSString stringWithFormat:@"%d/10",10];
            }else{
                self.label.text = [NSString stringWithFormat:@"%lu/10",(unsigned long)toBeString.length];
            }
            
        }else{
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
        }
    }else{
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if (toBeString.length > 10) {
            _nickField.text = [toBeString substringToIndex:10];
            self.label.text = [NSString stringWithFormat:@"%d/10",10];
        }else{
            self.label.text = [NSString stringWithFormat:@"%lu/10",(unsigned long)toBeString.length];
        }
    }
    
}

@end


@interface UserAccountImgCell()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) FanImageView *accountImg;

@end
@implementation UserAccountImgCell
- (void)initView{
    self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.FanSeparatorStyle =  FanTableViewCellSeparatorStyle15_15;
    self.titleLb.frame =  CGRectMake(15, 17, 100, 20);
    self.accountImg.frame =  CGRectMake(self.width - 70, self.height/2 - 20, 40, 40);
}
- (void)cellModel:(id)cellModel{
    [self.titleLb setText:[UserInfo shareInstance].userModel.name];
    if([[UserInfo shareInstance].userModel.photo_str isNotBlank]){
        UIImage *image = [UIImage imageWithData:[[NSData alloc] initWithBase64EncodedString:[UserInfo shareInstance].userModel.photo_str options:NSDataBase64DecodingIgnoreUnknownCharacters]];
        if (image) {
            [self.accountImg setImage:image];
            return;
        }
    }
    [self.accountImg setImageWithUrl:[UserInfo shareInstance].userModel.photo];
}
- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanRegularFont(15);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}
- (FanImageView *)accountImg{
    if (!_accountImg) {
        _accountImg = [FanImageView new];
        _accountImg.layer.cornerRadius = 20;
        _accountImg.layer.masksToBounds = YES;
        _accountImg. image = IMAGE_WITH_NAME(@"default_accoumt");
        _accountImg.placeholderImage = IMAGE_WITH_NAME(@"default_accoumt");
        [self addSubview:_accountImg];
    }return _accountImg;
}
@end

@interface UserInfoCell()
@property (nonatomic ,strong) UILabel *titleLb;
@property (nonatomic ,strong) UILabel *descriptLb;

@end
@implementation UserInfoCell


- (void)initView{
    self.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.FanSeparatorStyle =  FanTableViewCellSeparatorStyle15_15;
    self.titleLb.frame =  CGRectMake(15, 17, 100, 20);
    self.descriptLb.frame =  CGRectMake(self.width/2, 17, self.width/2 - 30, 20);
}
- (void)cellModel:(id)cellModel{
    UserInfoCellModel *model = cellModel;
    [self.titleLb setText:model.title];
    [self.descriptLb setText:model.descript];
    if ([model.title isEqualToString:@"登录密码"]) {
        [self.descriptLb setTextColor:COLOR_PATTERN_STRING(@"_red_color")];
    }else{
        _descriptLb.textColor = COLOR_PATTERN_STRING(@"_595959_color");
    }
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = FanRegularFont(15);
        _titleLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        [self addSubview:_titleLb];
    }return _titleLb;
}
- (UILabel *)descriptLb{
    if (!_descriptLb) {
        _descriptLb = [UILabel new];
        _descriptLb.font = FanRegularFont(13);
        _descriptLb.textColor = COLOR_PATTERN_STRING(@"_595959_color");
        _descriptLb.textAlignment = NSTextAlignmentRight;
        [self addSubview:_descriptLb];
    }return _descriptLb;
}
@end



@implementation UserAccountImgCellModel

- (CGFloat)cellHeight{
    return 54;
}
- (NSString *)fanClassName{
    return @"UserAccountImgCell";
}
@end



@implementation UserInfoCellModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    UserInfoCellModel *model = [UserInfoCellModel new];
    model.title = DICTION_OBJECT(json, @"title");
    model.descript = DICTION_OBJECT(json, @"descript");
    model.cellHeight = 54;
    model.fanClassName = @"UserInfoCell";
    return model;
}

@end
