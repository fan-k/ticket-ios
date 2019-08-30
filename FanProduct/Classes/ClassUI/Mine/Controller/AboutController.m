//
//  AboutController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/13.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "AboutController.h"

@interface AboutController ()
@property (nonatomic ,strong) FanTableView *tableView;


@end

@implementation AboutController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = @"关于我们";
    NSArray *arr  =  @[
                       [FanNomalModel modelWithJson:@{@"title":@"特别声明"}],
                       [FanNomalModel modelWithJson:@{@"title":@"给我反馈"}],
                       [FanNomalModel modelWithJson:@{@"title":@"给我评分"}],
                       [FanNomalModel modelWithJson:@{@"title":@"隐私政策"}],
                       ];

    [self.tableView.viewModel setList:arr type:0];
}
- (UIView *)tableHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, 49 + 83 + 70)];
    view.backgroundColor = COLOR_PATTERN_STRING(@"_base_background_color");
    FanImageView *icon = [[FanImageView alloc] initWithFrame:CGRectMake(FAN_SCREEN_WIDTH/2 - 40,49, 83, 83)];
    icon.image = IMAGE_WITH_NAME(@"set_logo");
    icon.layer.cornerRadius = 10;
    [view addSubview:icon];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, icon.bottom + 5, view.width, 20)];
    name.textAlignment = NSTextAlignmentCenter;
    name.textColor = COLOR_PATTERN_STRING(@"_212121_color");
    name.font = FanRegularFont(16);
    name.text = @"票儿网";
    [view addSubview:name];
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(0, name.bottom, view.width, 20)];
    version.textAlignment = NSTextAlignmentCenter;
    version.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
    version.font = FanRegularFont(16);
    version.text = [NSString stringWithFormat:@"版本号：%@",FAN_APP_VERSION];
    [view addSubview:version];
    return view;
}
- (UIView *)tableFooterView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, FAN_SCREEN_WIDTH, 150)];
    view.backgroundColor = COLOR_PATTERN_STRING(@"_base_background_color");

    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, view.width, 20)];
    name.textAlignment = NSTextAlignmentCenter;
    name.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
    name.font = FanRegularFont(16);
    name.text = @"spay365.com 版本所有";
    [view addSubview:name];
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(0, name.bottom, view.width, 20)];
    version.textAlignment = NSTextAlignmentCenter;
    version.textColor = COLOR_PATTERN_STRING(@"_9a9a9a_color");
    version.font = FanRegularFont(16);
    version.text = @"© 上海品付信息科技有限公司";
    [view addSubview:version];
    return view;
}
- (FanTableView *)tableView{
    if (!_tableView) {
        _tableView = [[FanTableView alloc] initWithFrame:CGRectMake(0, FAN_NAV_HEIGHT, FAN_SCREEN_WIDTH, FAN_SCREEN_HEIGHT - FAN_NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.tableFooterView = [self tableFooterView];
        _tableView.tableHeaderView = [self tableHeaderView];
        [self.view addSubview:_tableView];
    }return _tableView;
}
@end
