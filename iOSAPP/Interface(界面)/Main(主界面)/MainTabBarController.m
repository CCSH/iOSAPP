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
#import "SHBaseViewController.h"
#import "SHTabBar.h"

@interface MainTabBarController () < UITabBarControllerDelegate >

@property (nonatomic, strong) SHTabBar *shTabBar;

@end

@implementation MainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : kColorText_2}
                                                forState:UIControlStateNormal];

    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : kColorMain} forState:UIControlStateSelected];

    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : kFont(12)} forState:UIControlStateNormal];

    //tabbar
    self.shTabBar = [[SHTabBar alloc] init];
    [self setValue:self.shTabBar forKey:@"tabBar"];

    self.delegate = self;

    //添加子控制器
    OneViewController *oneVC = [[OneViewController alloc] init];
    [self addOneChlildVC:oneVC title:@"第一个" img:@"image" selectedImg:@"image"];

    TwoViewController *telView = [[TwoViewController alloc] init];
    [self addOneChlildVC:telView title:@"第二个" img:@"image" selectedImg:@"image"];

    [self addOneChlildVC:nil title:nil img:nil selectedImg:nil];

    ThreeViewController *addressView = [[ThreeViewController alloc] init];
    [self addOneChlildVC:addressView title:@"第三个" img:@"image" selectedImg:@"image"];

    FourViewController *settingView = [[FourViewController alloc] init];
    [self addOneChlildVC:settingView title:@"第四个" img:@"image" selectedImg:@"image"];

    //设置展示
    self.selectedIndex = 0;
}

/**
 *  添加一个子控制器
 *
 *  @param childVC         子控制器对象
 *  @param title             标题
 *  @param img         图标
 *  @param selectedImg 选中的图标
 */
- (void)addOneChlildVC:(UIViewController *)childVC
                 title:(NSString *)title
                   img:(NSString *)img
           selectedImg:(NSString *)selectedImg
{
    if (!childVC)
    {
        childVC = [[SHBaseViewController alloc] init];
    }

    childVC.title = title;

    //设置点击图片
    childVC.tabBarItem.image = [[UIImage imageNamed:img] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImg] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    // 添加为tabbar控制器的子控制器
    SHBaseNavViewController *nav = [[SHBaseNavViewController alloc] initWithRootViewController:childVC];
    nav.view.tag = 1 + self.viewControllers.count;
    [self addChildViewController:nav];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController.view.tag == 3)
    {
        [self.shTabBar didSelectItem:2];
        return NO;
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self.shTabBar didSelectItem:self.selectedIndex];
}

@end
