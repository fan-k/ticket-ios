//
//  FanController.m
//  Baletu
//
//  Created by fangkangpeng on 2018/12/17.
//  Copyright © 2018 Fan. All rights reserved.
//

#import "FanController.h"

@interface FanController ()

@end

@implementation FanController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = COLOR_PATTERN_STRING(@"_base_background_color");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
