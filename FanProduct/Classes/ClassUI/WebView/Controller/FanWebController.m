//
//  FanWebController.m
//  FanProduct
//
//  Created by 99epay on 2019/6/24.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanWebController.h"

@interface FanWebController ()

@end

@implementation FanWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.leftImage = @"nav_back";
    self.navTitle = DICTION_OBJECT(self.urlParams, @"title");
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
