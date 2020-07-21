//
//  MainTabBarController.m
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "MainTabBarController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "SHBaseNavViewController.h"

@interface MainTabBarController () < UITabBarControllerDelegate >

@end

@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //设置底部背景
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSHWidth, 49)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.opaque = YES;

    //设置底部标题颜色
    UIColor *titleNormalColor = [UIColor lightGrayColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleNormalColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];

    //设置底部标题点击颜色
    UIColor *titleSelectedColor = kRGB(18, 137, 255, 1);
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleSelectedColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];

    //添加子控制器
    OneViewController *oneVC = [[OneViewController alloc] init];
    [self addOneChlildVC:oneVC title:@"第一个" imageName:@"image" selectedImageName:@"image"];

    TwoViewController *telView = [[TwoViewController alloc] init];
    [self addOneChlildVC:telView title:@"第二个" imageName:@"image" selectedImageName:@"image"];

    ThreeViewController *addressView = [[ThreeViewController alloc] init];
    [self addOneChlildVC:addressView title:@"第三个" imageName:@"image" selectedImageName:@"image"];

    FourViewController *settingView = [[FourViewController alloc] init];
    [self addOneChlildVC:settingView title:@"第四个" imageName:@"image" selectedImageName:@"image"];

    //设置展示
    self.selectedIndex = 1;
    
        self.tabBarController.delegate = self;
}

/**
 *  添加一个子控制器
 *
 *  @param childVC         子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addOneChlildVC:(UIViewController *)childVC title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    childVC.title = title;

    //设置点击图片
    childVC.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    // 添加为tabbar控制器的子控制器
    SHBaseNavViewController *nav = [[SHBaseNavViewController alloc] initWithRootViewController:childVC];
    [self addChildViewController:nav];
//    self.tabBarController.navigationController.navigationBarHidden = YES;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController
{
    return YES;
}

#pragma mark - VC界面周期
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.selectedViewController beginAppearanceTransition:YES animated:animated];
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    [self.selectedViewController endAppearanceTransition];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [self.selectedViewController beginAppearanceTransition:NO animated:animated];
//}
//
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    [self.selectedViewController endAppearanceTransition];
//}

@end
