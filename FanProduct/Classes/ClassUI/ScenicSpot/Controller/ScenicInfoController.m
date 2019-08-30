
//
//  ScenicInfoController.m
//  FanProduct
//
//  Created by 99epay on 2019/7/3.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "ScenicInfoController.h"
#import "ScenicModel.h"

@interface ScenicInfoController ()
@property (nonatomic ,strong) ScenicModel *scenicModel;
@end

@implementation ScenicInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scenicModel = self.transferData;
    self.leftImage = @"nav_back";
    self.navTitle = self.scenicModel.title;
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
