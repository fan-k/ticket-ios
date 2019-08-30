//
//  FoundClassController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/10.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FoundClassController.h"
#import "HomeModel.h"
@interface FoundClassController (){
    UIButton *_currentButton;
}

@end

@implementation FoundClassController

- (void)leftNavBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"景区主题";
    self.leftImage = @"nav_back";
    NSArray *arr = self.transferData;
    
    CGFloat _cellHeight = FAN_NAV_HEIGHT + 20;
    CGFloat width = FAN_SCREEN_WIDTH; //内容区域宽度
    CGFloat specal = 10;//间隔宽度
    CGFloat left = 15;
    CGFloat buttonWidth = (FAN_SCREEN_WIDTH - 75 )/4;
    for (int i = 0;  i < arr.count;i ++) {
        HomeSectionHeaderModel *model = arr[i];
        if (width - left >=buttonWidth) {
            [self initButtonWithX:left Y:_cellHeight name:model.title idx:i width:buttonWidth];
            left += buttonWidth + specal;
        }else{
            left = 15;
            _cellHeight += 50;//间隔为10 内容高度为33
            [self initButtonWithX:left Y:_cellHeight name:model.title idx:i width:buttonWidth];
            left += buttonWidth + specal;
        }
    }
    // Do any additional setup after loading the view.
}
- (void)initButtonWithX:(CGFloat)x Y:(CGFloat)Y name:(NSString *)name idx:(NSUInteger)idx width:(CGFloat)width{
    UIButton *button  = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, Y, width, 35);
    [button setBackgroundColor:[UIColor lightGrayColor]];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button setTitle:name forState:0];
    button.titleLabel.font = FanFont(15);
    button.tag = 108 + idx;
    [button setTitleColor:[UIColor whiteColor] forState:0];
    [button addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    if (idx == [DICTION_OBJECT(self.transferData, @"index") integerValue]) {
        [button setBackgroundColor:COLOR_PATTERN_STRING(@"_yellow_color")];
    }
}
- (void)buttonClickMethod:(UIButton *)button{
    [_currentButton setBackgroundColor:[UIColor lightGrayColor]];
    [button setBackgroundColor:COLOR_PATTERN_STRING(@"_yellow_color")];
    _currentButton = button;
    if (self.customActionBlock) {
        self.customActionBlock([NSString stringWithFormat:@"%ld",button.tag - 108], cat_found_class_add);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
