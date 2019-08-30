//
//  OrderTouristController.m
//  FanProduct
//
//  Created by 99epay on 2019/7/11.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "OrderTouristController.h"
#import "TouristModel.h"
@interface OrderTouristController ()
@property (nonatomic ,strong) FanTableView *tableView;
@property (nonatomic ,strong) NSMutableArray *touristList;
@end

@implementation OrderTouristController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    [self setNavTitle:@"选择游客信息"];
    self.rightTxt = @"完成";
    [self initListinfo];
    // Do any additional setup after loading the view.
}
- (void)rightNavBtnCilck{
     __block TouristModel  *model;
    [self.touristList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[TouristModel class]]) {
            TouristModel *dd = obj;
            if (dd.selected) {
                model = dd;
                *stop = YES;
            }
        }
    }];
    if (model) {
        if (self.customActionBlock) {
            self.customActionBlock(model, cat_chance_touristinfo);
        }
    }
    [self leftNavBtnClick];
}
- (void)initListinfo{
    self.params[@"token"] = [UserInfo shareInstance].userModel.token;
    [self requestWithUrl:FanUrlTouristInfoGet loading:YES];
}
- (void)deleteTourist:(NSString *)o_id{
    __block TouristModel *deleteModel ;
    [self.touristList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[TouristModel class]]) {
            TouristModel *touristModel = obj;
            if ([touristModel.o_id isEqualToString:o_id]) {
                *stop = YES;
                deleteModel = obj;
            }
        }
    }];
    if (deleteModel) {
        [self.touristList removeObject:deleteModel];
        [self.tableView.viewModel setList:self.touristList type:0];
    }
}
- (void)handelFailureRequest:(FanRequestItem *)item{
    [self.tableView.viewModel setList:self.touristList type:0];
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    NSArray *arr = DICTION_OBJECT(item.responseObject, @"data");
    if (isValidArray(arr)) {
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:obj];
            NSString *UUtourist_info = DICTION_OBJECT(self.urlParams, @"UUtourist_info");
            dict[@"UUtourist_info"] = UUtourist_info;
            TouristModel *model = [TouristModel modelWithJson:dict];
            if (model) {
                if (idx == 0) {
                    model.selected = YES;//默认选中第一个
                }
                [self.touristList addObject:model];
            }
        }];
    }
    [self.tableView.viewModel setList:self.touristList type:0];
}
- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT - FAN_TABBAR_HEIGHT) style:UITableViewStylePlain];
        [self.view addSubview:_tableView];
        __weak OrderTouristController *weakSelf =  self;
        _tableView.customActionBlock = ^(id obj, cat_action_type idx) {
             if(idx == cat_action_cell_click){
               //若是选中游客信息 需判断当前景点门票是否需要身份证信息，若需要 则判断选中的游客信息是否包含身份证信息，不包含的情况下 ，在cell上做提示，
                 if ([obj isKindOfClass:[TouristAddModel class]]) {
                     [weakSelf pushViewControllerWithUrl:[NSString stringWithFormat:@"OrderTouristEidtController?UUtourist_info=%@",DICTION_OBJECT(weakSelf.urlParams, @"UUtourist_info")] transferData:nil hander:^(id obj, int idx) {
                         [weakSelf.touristList insertObject:obj atIndex:1];
                         [weakSelf.tableView reloadData];
                     }];
                 }else{
                     TouristModel *model = obj;
                     //切换
                     [weakSelf.tableView.viewModel.contentList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                         if ([obj isKindOfClass:[TouristModel class]]) {
                             TouristModel *touristModel = obj;
                             if (touristModel.selected) {
                                 touristModel.selected = NO;
                                 *stop = YES;
                             }
                         }
                     }];
                     model.selected = YES;
                     [weakSelf.tableView reloadData];
                 }
             }else if (idx == cat_action_click){
                 TouristModel *model = obj;
                 [weakSelf pushViewControllerWithUrl:[NSString stringWithFormat:@"OrderTouristEidtController?name=%@&phone=%@&card=%@&id=%@&UUtourist_info=%@",model.name,model.phone,model.card,model.o_id,model.UUtourist_info] transferData:nil hander:^(id obj, int idx) {
                     if ([obj isKindOfClass:[TouristModel class]]) {
                         TouristModel *editModel = obj;
                         model.name = editModel.name;
                         model.phone = editModel.phone;
                         if (editModel.card) {
                             model.card = editModel.card;
                         }
                         [weakSelf.tableView reloadData];
                     }else{
                         //删除  传的id
                         
                         [weakSelf deleteTourist:obj];
                     }
                    
                 }];
             }
        };
    }return _tableView;
}
- (NSMutableArray *)touristList{
    if (!_touristList) {
        _touristList = @[].mutableCopy;
        [_touristList addObject:[TouristAddModel new]];
    }return _touristList;
}
@end
#import "FanTextField.h"
@interface OrderTouristEidtController ()
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) FanTextField *titleField;
@property (nonatomic ,strong) FanTextField *cardField;
@property (nonatomic ,strong) FanTextField *phoneField;
@property (nonatomic ,strong) UIButton *submitButton;
@end
@implementation OrderTouristEidtController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    if ([DICTION_OBJECT(self.urlParams, @"name") isNotBlank]) {
        self.rightTxt = @"删除";
    }
    self.navTitle = [DICTION_OBJECT(self.urlParams, @"name") isNotBlank] ? @"编辑游客信息":@"新增游客信息";
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.submitButton];
    
    // Do any additional setup after loading the view.
}
- (void)rightNavBtnCilck{
    [FanAlert showAlertControllerWithTitle:@"温馨提示" message:@"是否删除该游客信息" _cancletitle_:@"确定" _confirmtitle_:@"取消" handler1:^(UIAlertAction * _Nonnull action) {
        self.params[@"id"] = DICTION_OBJECT(self.urlParams, @"id");
        self.params[@"token"] = [UserInfo shareInstance].userModel.token;
        [self requestWithUrl:FanUrlTouristInfoDelete loading:YES];
    } handler2:nil];
}
- (void)changeButtonStatus{
    NSString *UUtourist_info = DICTION_OBJECT(self.urlParams, @"UUtourist_info");
    if ([self.titleField.text isNotBlank] && [self.phoneField.text isNotBlank] && UUtourist_info.integerValue < 1) {
        [self.submitButton setBackgroundColor:COLOR_PATTERN_STRING(@"_yellow_color")];
        self.submitButton.userInteractionEnabled = YES;
    }else if ([self.titleField.text isNotBlank] && [self.phoneField.text isNotBlank] && [self.cardField.text isNotBlank] && UUtourist_info.integerValue > 0) {
        [self.submitButton setBackgroundColor:COLOR_PATTERN_STRING(@"_yellow_color")];
        self.submitButton.userInteractionEnabled = YES;
    }else{
        [self.submitButton setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        self.submitButton.userInteractionEnabled = YES;
    }
}
- (void)submitButtonMethod{
    if ([self.urlParams.allKeys containsObject:@"name"]) {
        //编辑
        self.params[@"id"] = DICTION_OBJECT(self.urlParams, @"id");
        self.params[@"token"] = [UserInfo shareInstance].userModel.token;
        self.params[@"name"] = self.titleField.text;
        self.params[@"phone"] = self.phoneField.text;
        NSString *UUtourist_info = DICTION_OBJECT(self.urlParams, @"UUtourist_info");
        if (UUtourist_info.integerValue > 0) {
             self.params[@"card"] = self.cardField.text;
        }
        [self requestWithUrl:FanUrlTouristInfoOption loading:YES];
        
    }else{
        //新增
        self.params[@"token"] = [UserInfo shareInstance].userModel.token;
        self.params[@"name"] = self.titleField.text;
        self.params[@"phone"] = self.phoneField.text;
        NSString *UUtourist_info = DICTION_OBJECT(self.urlParams, @"UUtourist_info");
        if (UUtourist_info.integerValue > 0) {
            self.params[@"card"] = self.cardField.text;
        }
        [self requestWithUrl:FanUrlTouristInfoPost loading:YES];
    }
    
}

- (void)handelFailureRequest:(FanRequestItem *)item{
    [FanAlert alertErrorWithItem:item];
}
- (void)handelSuccessRequest:(FanRequestItem *)item{
    if ([item.url isEqualToString:FanUrlTouristInfoDelete]) {
        //删除成功
        [FanAlert alertMessage:@"删除成功" type:AlertMessageTypeNomal];
        if (self.customActionBlock) {
            self.customActionBlock(DICTION_OBJECT(self.urlParams, @"id"), cat_action_click);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self leftNavBtnClick];
        });
    }else if ([item.url isEqualToString:FanUrlTouristInfoOption]){
        [FanAlert alertMessage:@"编辑成功" type:AlertMessageTypeNomal];
        if (self.customActionBlock) {
            TouristModel *editModel = [TouristModel new];
            editModel.name = DICTION_OBJECT(item.params, @"name");
            editModel.phone = DICTION_OBJECT(item.params, @"phone");
            if ([item.params.allKeys containsObject:@"card"]) {
                editModel.card = DICTION_OBJECT(item.params, @"card");
            }
            self.customActionBlock(editModel, cat_action_click);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self leftNavBtnClick];
        });
    }else if ([item.url isEqualToString:FanUrlTouristInfoPost]){
        [FanAlert alertMessage:@"新增成功" type:AlertMessageTypeNomal];
        if (self.customActionBlock) {
            TouristModel *editModel = [TouristModel new];
            editModel.name = DICTION_OBJECT(item.params, @"name");
            editModel.phone = DICTION_OBJECT(item.params, @"phone");
            if ([item.params.allKeys containsObject:@"card"]) {
                editModel.card = DICTION_OBJECT(item.params, @"card");
            }
            self.customActionBlock(editModel, cat_action_click);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self leftNavBtnClick];
        });
    }
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        NSString *UUtourist_info = DICTION_OBJECT(self.urlParams, @"UUtourist_info");
        _bgView.frame = CGRectMake(15, FAN_NAV_HEIGHT + 15, self.view.width - 30,UUtourist_info.integerValue > 0 ? 150 : 100);
        _bgView.layer.cornerRadius = 5;
        _bgView.backgroundColor = COLOR_PATTERN_STRING(@"_whiter_color");
        [_bgView addSubview:self.titleField];
        [_bgView addSubview:self.phoneField];
        if (UUtourist_info.integerValue > 0) {
            [_bgView addSubview:self.cardField];
        }
    }return _bgView;
}
- (FanTextField *)titleField{
    if (!_titleField) {
        _titleField = [[FanTextField alloc] initWithFrame:CGRectMake(10, 0, self.bgView.width - 20, 50)];
        _titleField.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _titleField.font = FanMediumFont(16);
        _titleField.text = DICTION_OBJECT(self.urlParams, @"name");
        _titleField.fan_placeholder_font = FanMediumFont(16);
        _titleField.placeholdercolor = COLOR_PATTERN_STRING(@"_bfbfbf_color");
        _titleField.leftViewWidth = 80;
        _titleField.leftLbTxt = @"真实姓名";
        _titleField.lineViewNomalColor = @"_line_color";
        _titleField.fan_placeholder = @"与证件保持一致";
        __weak OrderTouristEidtController *weakSelf = self;
        _titleField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_textfield_content_changed_nil || idx == cat_textfield_content_changed_unnil) {
                [weakSelf changeButtonStatus];
            }
        };
    }return _titleField;
}

- (FanTextField *)phoneField{
    if (!_phoneField) {
        _phoneField = [[FanTextField alloc] initWithFrame:CGRectMake(10, 50, self.bgView.width - 20, 50)];
        _phoneField.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _phoneField.font = FanMediumFont(16);
        _phoneField.text = DICTION_OBJECT(self.urlParams, @"phone");
        _phoneField.fan_placeholder_font = FanMediumFont(16);
        _phoneField.placeholdercolor = COLOR_PATTERN_STRING(@"_bfbfbf_color");
        _phoneField.leftViewWidth = 80;
        _phoneField.leftLbTxt = @"手机号";
        _phoneField.style_count = YES;
        _phoneField.lineViewNomalColor = @"_line_color";
        _phoneField.fan_placeholder = @"接收确认信息";
        __weak OrderTouristEidtController *weakSelf = self;
        _phoneField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_textfield_content_changed_nil || idx == cat_textfield_content_changed_unnil) {
                [weakSelf changeButtonStatus];
            }
        };
    }return _phoneField;
}



- (FanTextField *)cardField{
    if (!_cardField) {
        _cardField = [[FanTextField alloc] initWithFrame:CGRectMake(10, 100, self.bgView.width - 20, 50)];
        _cardField.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        _cardField.font = FanMediumFont(16);
        _cardField.fan_placeholder_font = FanMediumFont(16);
        _cardField.placeholdercolor = COLOR_PATTERN_STRING(@"_bfbfbf_color");
        _cardField.leftViewWidth = 80;
        _cardField.style_count = YES;
        _cardField.leftLbTxt = @"身份证号";
        _cardField.text = DICTION_OBJECT(self.urlParams, @"card");
        _cardField.lineViewNomalColor = @"_line_color";
        _cardField.fan_placeholder = @"与证件保持一致";
        __weak OrderTouristEidtController *weakSelf = self;
        _cardField.customActionBlock = ^(id obj, cat_action_type idx) {
            if (idx == cat_textfield_content_changed_nil || idx == cat_textfield_content_changed_unnil) {
                [weakSelf changeButtonStatus];
            }
        };
    }return _cardField;
}

- (UIButton *)submitButton{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(15, self.bgView.bottom + 30, self.bgView.width, 44);
        _submitButton.layer.masksToBounds = YES;
        _submitButton.layer.cornerRadius = 22;
        [_submitButton setTitleColor:COLOR_PATTERN_STRING(@"_333333_color") forState:UIControlStateNormal];
        [_submitButton.titleLabel setFont:FanMediumFont(17)];
        [_submitButton setBackgroundColor:COLOR_PATTERN_STRING(@"_line_color")];
        _submitButton.userInteractionEnabled = NO;
        [_submitButton addTarget:self action:@selector(submitButtonMethod) forControlEvents:UIControlEventTouchUpInside];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    }return _submitButton;
}
@end
