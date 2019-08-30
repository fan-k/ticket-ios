//
//  SetController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/12.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "SetController.h"
#import "AppDelegate+Push.h"

@interface SetController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) FanTableView *tableView;
@property (nonatomic ,strong) NSArray *lists;
@property (nonatomic ,strong) UIView *footView;

@end

@implementation SetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"设置";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushStaus) name:UIApplicationDidBecomeActiveNotification object:nil];
    [self pushStaus];
    // Do any additional setup after loading the view.
}
- (void)pushStaus{
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 ) {
        FanSetSwitchCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"switch" forIndexPath:indexPath];
        switchCell.data  = self.lists[indexPath.row];
        if (indexPath.row == 0) {
            if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
                switchCell.pushSwitch = NO;
                //注销推送
                [[UIApplication sharedApplication] unregisterForRemoteNotifications];
            }else{
                switchCell.pushSwitch = YES;
                [[AppDelegate appDelegate] initPUSH];
            }
        }
        
        return switchCell;
    }else{
        NSString *title = self.lists[indexPath.row];
        if ([title isNotBlank]) {
            FanSetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.data =  self.lists[indexPath.row];
            return cell;
        }else{
            FanNilCell *nilCell = [tableView dequeueReusableCellWithIdentifier:@"nilCell" forIndexPath:indexPath];
            return nilCell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.lists[indexPath.row];
    if ([title isEqualToString:@"清理缓存"]) {
        __weak SetController *weakself = self;
        [FanAlert showAlertControllerWithTitle:@"温馨提示" message:@"是否清理缓存数据？" _cancletitle_:@"取消" _confirmtitle_:@"确定" handler1:nil handler2:^(UIAlertAction * _Nonnull action) {
            [FanCache clearCache:DEF_CachesDir];
            [FanAlert showLoadingWithCompletion:^{
                [weakself.tableView reloadData];
            }];
        }];
    }else if ([title isEqualToString:@"关于我们"]){
        [self pushViewControllerWithUrl:@"AboutController" transferData:nil hander:nil];
    }else if ([title isEqualToString:@"意见反馈"]){
        [self pushViewControllerWithUrl:@"FeedbackController" transferData:nil hander:nil];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = self.lists[indexPath.row];
    if ([title isNotBlank]) {
        return 56;
    }else
        return 8;
    
}

- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT) style:UITableViewStylePlain];
        [_tableView registerClass:[FanSetSwitchCell class] forCellReuseIdentifier:@"switch"];
        [_tableView registerClass:[FanSetCell class] forCellReuseIdentifier:@"cell"];
        [_tableView registerClass:[FanNilCell class] forCellReuseIdentifier:@"nilCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if ([UserInfo shareInstance].isLogin) {
            _tableView.tableFooterView = self.footView;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSArray *)lists{
    if (!_lists) {
        _lists = @[@"开启推送",@"清理缓存",@"意见反馈",@"",@"关于我们",@"版本号"];
    }
    return _lists;
}

- (UIView *)footView{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, 120)];
        _footView.backgroundColor = [UIColor clearColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(15, 50, FAN_SCREEN_WIDTH - 30, 50);
        [button setTitle:@"退出登录" forState:UIControlStateNormal];
        [button setTitleColor:COLOR_PATTERN_STRING(@"_red_color") forState:UIControlStateNormal];
        [button setBackgroundColor:COLOR_PATTERN_STRING(@"_whiter_color")];
        [button.titleLabel setFont: FanFont(17)];
        button.layer.cornerRadius = 3;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(buttonMethod) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:button];
    }
    return _footView;
}
- (void)buttonMethod{
    //退出登录
    __weak SetController *weakSelf = self;
    [FanAlert showLoadingWithCompletion:^{
        weakSelf.tableView.tableFooterView = nil;//隐藏footer
        [UserInfo logout];
        [UserInfo clearUserInfo];
        [weakSelf leftNavBtnClick];
    }];
    
}

@end


@interface FanSetSwitchCell ()
@property (nonatomic ,strong) UISwitch *swithButton;
@property (nonatomic ,strong) UILabel *mainTitleLab;
@end

@implementation FanSetSwitchCell

- (void)setData:(NSString *)data{
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle15_0;
    self.mainTitleLab.text = data;
    [self.contentView addSubview:self.swithButton];
}
- (void)setPushSwitch:(BOOL)pushSwitch{
    _pushSwitch = pushSwitch;
    _swithButton.on = pushSwitch;
}
- (void)switchMethod{
   
    __weak FanSetSwitchCell *weakSelf = self;
        if (!_pushSwitch) {
            //未打开系统推送开关 不可以打开开关
            [FanAlert showAlertControllerWithTitle:@"温馨提示" message:@"请在iPhone的“设置-通知”中设置打开允许推送开关" _cancletitle_:@"取消" _confirmtitle_:@"去设置" handler1:nil handler2:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            _swithButton.on = NO;
            
        }else{
            [FanAlert showAlertControllerWithTitle:@"温馨提示" message:@"如需关闭消息推送，请在iphone的“设置”-“通知”中更改。" _cancletitle_:@"取消" _confirmtitle_:@"去设置" handler1:^(UIAlertAction * _Nonnull action) {
                weakSelf.swithButton.on = YES;
            } handler2:^(UIAlertAction * _Nonnull action) {
                weakSelf.swithButton.on = NO;
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if([[UIApplication sharedApplication] canOpenURL:url]) {
                    NSURL *url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
        }
    
}
- (UISwitch *)swithButton{
    if (!_swithButton) {
        _swithButton = [[UISwitch alloc] initWithFrame:CGRectMake(FAN_SCREEN_WIDTH - 70, 15, 50, 30)];
        [_swithButton addTarget:self action:@selector(switchMethod) forControlEvents:UIControlEventTouchUpInside];
    }
    return _swithButton;
}
- (UILabel *)mainTitleLab{
    if (!_mainTitleLab){
        _mainTitleLab = [[UILabel alloc]init];
        _mainTitleLab.frame = CGRectMake(24, 18, 100, 20);
        _mainTitleLab.textColor  = COLOR_PATTERN_STRING(@"_333333_color");
        _mainTitleLab.font = FanRegularFont(15);
        [self.contentView addSubview:_mainTitleLab];
    }
    return _mainTitleLab;
}

@end


@interface FanSetCell ()
@property (nonatomic ,strong) UILabel *mainTitleLab;
@property (nonatomic ,strong) UILabel *sizeLb;
@property (nonatomic ,strong) UILabel *redLb;
@end

@implementation FanSetCell

- (void)setData:(NSString *)data{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.FanSeparatorStyle = FanTableViewCellSeparatorStyle15_0;
    self.mainTitleLab.text = data;
    if ([data isEqualToString:@"清理缓存"]) {
        CGFloat size  = [FanCache getFolderSizeWithPath:DEF_CachesDir];
        self.sizeLb.text = [NSString stringWithFormat:@"%.2fM",size];
        [self.redLb setHidden:YES];
    }else if ([data isEqualToString:@"版本号"]) {
        [self.redLb setHidden:NO];
        self.sizeLb.text = [NSString stringWithFormat:@"v%@",FAN_APP_VERSION];
        
        if ([[FanConfig shareInstance].version floatValue] > FAN_KEY_APP_VERSION) {
            _redLb.backgroundColor = COLOR_PATTERN_STRING(@"_red_color");
        }else
            _redLb.backgroundColor = [UIColor clearColor];
    }
}
- (UILabel *)sizeLb{
    if (!_sizeLb) {
        _sizeLb = [[UILabel alloc] initWithFrame:CGRectMake(FAN_SCREEN_WIDTH - 30 - 200, 20, 200, 18)];
        _sizeLb.textAlignment = NSTextAlignmentRight;
        _sizeLb.font = FanRegularFont(15);
        _sizeLb.textColor = COLOR_PATTERN_STRING(@"_333333_color");
        [self.contentView addSubview:_sizeLb];
    }
    return _sizeLb;
}
- (UILabel *)redLb{
    if (!_redLb) {
        _redLb = [[UILabel alloc] initWithFrame:CGRectMake(FAN_SCREEN_WIDTH - 30 - 8, 24, 8, 8)];
        _redLb.layer.cornerRadius = 4;
        _redLb.layer.masksToBounds = YES;
        [self.contentView addSubview:_redLb];
    }
    return _redLb;
}
    - (UILabel *)mainTitleLab{
        if (!_mainTitleLab){
            _mainTitleLab = [[UILabel alloc]init];
            _mainTitleLab.frame = CGRectMake(24, 18, 100, 20);
            _mainTitleLab.textColor  = COLOR_PATTERN_STRING(@"_333333_color");
            _mainTitleLab.font = FanRegularFont(15);
            [self.contentView addSubview:_mainTitleLab];
        }
        return _mainTitleLab;
    }
@end
