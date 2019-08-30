//
//  FanRootController.m
//  FanProduct
//
//  Created by 樊康鹏 on 2019/2/18.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanRootController.h"
#import "HomeController.h"
#import "FoundController.h"
#import "OrderController.h"
#import "MineController.h"





FanRootController * MainRootViewController(){
    static FanRootController *root  = nil;
    if (!root) {
        root = (FanRootController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    }
    return root;
}

UINavigationController *MainRootSelectNavController(){
    FanRootController *root  = MainRootViewController();
    return (UINavigationController*)MainRootViewController().viewControllers[root.selectedIndex];
}

UIViewController *MainRootSelectTopViewController(){
    return [MainRootSelectNavController() topViewController];
}
UIViewController *MainRootSelectFirstViewController(){
    return [MainRootSelectNavController().viewControllers firstObject];
}


@interface FanRootController ()

@property (nonatomic ,strong) HomeController *homeVc;

@property (nonatomic ,strong) FoundController *foundVc;

@property (nonatomic ,strong) OrderController *orderVc;

@property (nonatomic ,strong) MineController *mineVc;

@property (nonatomic ,assign) NSInteger index;

@end

@implementation FanRootController

- (void)managerhandleOpenUrl:(NSURL *)url{
    
}
- (void)managerPushData:(NSDictionary *)push active:(BOOL)active{
    
}

#pragma mark -- KRootController
+ (instancetype)initializeShare{
    static FanRootController *rootVc ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        rootVc = [[self alloc] init];
    });
    return rootVc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTabbarViewControllers];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //setShadowImage  必须和 setBackgroundImage 同时使用 否则设置分割线颜色不生效
    //    [self.tabBar setShadowImage:[UIImage imageWithColor:COLOR_PATTERN_STRING(@"nav_line_color") size:CGSizeMake(screenWidth, LINE_HEIGTH)]];
    
    //    [self.tabBar setBackgroundImage:[UIImage imageWithColor:COLOR_PATTERN_STRING(@"nav_bg_color") size:CGSizeMake(screenWidth, LINE_HEIGTH)]];
    //半透 高斯模糊效果
    //    self.tabBar.translucent = YES;
    //    self.tabBar.itemSpacing = 0.3;
    // Do any additional setup after loading the view.
}

- (void)initTabbarViewControllers{
    self.homeVc = [[HomeController alloc]init];
    [self setTabBarItem:self.homeVc.tabBarItem
              withTitle:@"首页"
        withNormalImage:@"tabbar_icon_home_unselected"
      withSelectedImage:@"tabbar_icon_home_selected"
   withNormalTitleColor:COLOR_PATTERN_STRING(@"_666666_color")
      withSelectedColor:COLOR_PATTERN_STRING(@"_363636_color")
          withTitleFont:12];
    UINavigationController *homeNav = [[UINavigationController alloc]initWithRootViewController:self.homeVc];
    
    self.foundVc = [[FoundController alloc]init];
    [self setTabBarItem:self.foundVc.tabBarItem
              withTitle:@"发现"
        withNormalImage:@"tabbar_icon_found_unselected"
      withSelectedImage:@"tabbar_icon_found_selected"
   withNormalTitleColor:COLOR_PATTERN_STRING(@"_666666_color")
      withSelectedColor:COLOR_PATTERN_STRING(@"_363636_color")
          withTitleFont:12];
    UINavigationController *foundNav = [[UINavigationController alloc]initWithRootViewController:self.foundVc];
    
    self.orderVc = [[OrderController alloc]init];
    
    [self setTabBarItem:self.orderVc.tabBarItem
              withTitle:@"订单"
        withNormalImage:@"tabbar_icon_order_unselected"
      withSelectedImage:@"tabbar_icon_order_selected"
   withNormalTitleColor:COLOR_PATTERN_STRING(@"_666666_color")
      withSelectedColor:COLOR_PATTERN_STRING(@"_363636_color")
          withTitleFont:12];
    UINavigationController *orderNav = [[UINavigationController alloc]initWithRootViewController:self.orderVc];
    
     self.mineVc = [[MineController alloc]init];
    [self setTabBarItem:self.mineVc.tabBarItem
              withTitle:@"我的"
        withNormalImage:@"tabbar_icon_mine_unselected"
      withSelectedImage:@"tabbar_icon_mine_selected"
   withNormalTitleColor:COLOR_PATTERN_STRING(@"_666666_color")
      withSelectedColor:COLOR_PATTERN_STRING(@"_363636_color")
          withTitleFont:12];
    UINavigationController *mineNav = [[UINavigationController alloc]initWithRootViewController:self.mineVc];
   
    self.viewControllers = @[homeNav,foundNav,orderNav,mineNav];
}


/**
 设置TabBar样式<可灵活修改字体大小、颜色>
 
 @param tabBarItem    具体Item
 @param title         title
 @param normalImage   正常图片
 @param selectedImage 选中图片
 @param normalColor   正常字体颜色
 @param selectedColor 选中字体颜色
 @param titleFont     字体大小
 */
-(void)setTabBarItem:(UITabBarItem *)tabBarItem
           withTitle:(NSString *)title
     withNormalImage:(NSString *)normalImage
   withSelectedImage:(NSString *)selectedImage
withNormalTitleColor:(UIColor *)normalColor
   withSelectedColor:(UIColor *)selectedColor
       withTitleFont:(CGFloat)titleFont;
{
    tabBarItem = [tabBarItem initWithTitle:title image:[[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    /*正常情况*/
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:normalColor,NSFontAttributeName:FanFont(titleFont)} forState:UIControlStateNormal];
    /*选中情况*/
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectedColor,NSFontAttributeName:FanFont(titleFont)} forState:UIControlStateSelected];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSUInteger selectedIndex = [tabBar.items indexOfObject:item];
    if (self.index != selectedIndex) {
        [self animationWithIndex:selectedIndex];
    }
}
- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    if (self.viewControllers.count > self.selectedIndex) {
        UINavigationController *lastNav = self.viewControllers[self.selectedIndex];
        [lastNav popToRootViewControllerAnimated:NO];
    }
    [super setSelectedIndex:selectedIndex];
}
// 动画
- (void)animationWithIndex:(NSInteger)index {
    NSMutableArray * tabbarbuttonArray = [NSMutableArray array];
    for (UIView *tabBarButton in self.tabBar.subviews) {
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabbarbuttonArray addObject:tabBarButton];
        }
    }
    //需要实现的帧动画,这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.values = @[@1.0,@1.1,@0.9,@1.02,@1.0];
    animation.duration = 0.5f;
    animation.calculationMode = kCAAnimationCubic;
    UIView *button = tabbarbuttonArray[index];
    UIView *img = nil;
    for (UIView *barView in button.subviews) {
        if ([barView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            img = barView;
        }
    }
    if (img) {
        [img.layer addAnimation:animation forKey:nil];
    }
    self.index = index;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
