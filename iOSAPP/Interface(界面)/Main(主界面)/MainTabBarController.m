//
//  MainTabBarController.m
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "ClassViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"
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
    
    //tabbar
    self.shTabBar = [[SHTabBar alloc] init];
    [self setValue:self.shTabBar forKey:@"tabBar"];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : kFont(12)}
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : kColorMain}
                                             forState:UIControlStateSelected];
    [[UITabBar appearance] setUnselectedItemTintColor:kColorText_5];
  
    UIImage *img = [UIImage getImageWithColor:[UIColor clearColor]];
    [[UITabBar appearance] setBackgroundImage:img];
    [[UITabBar appearance] setShadowImage:img];
    
    self.delegate = self;
    
    //添加子控制器
    HomeViewController *oneVC = [[HomeViewController alloc] init];
    [self addOneChlildVC:oneVC title:@"首页" img:@"tabbar_home"];
    
    ClassViewController *telView = [[ClassViewController alloc] init];
    [self addOneChlildVC:telView title:@"分类" img:@"tabbar_class"];
    
    [self addOneChlildVC:nil title:nil img:nil];
    
    MessageViewController *addressView = [[MessageViewController alloc] init];
    [self addOneChlildVC:addressView title:@"消息" img:@"tabbar_message"];
    
    MineViewController *settingView = [[MineViewController alloc] init];
    [self addOneChlildVC:settingView title:@"我的" img:@"tabbar_me"];
    
    self.shTabBar.dataArr = @[@"tabbar_min"];
    
    //设置展示
    self.selectedIndex = 0;
}

//添加一个子控制器
- (void)addOneChlildVC:(UIViewController *)childVC
                 title:(NSString *)title
                   img:(NSString *)img
{
    if (!childVC)
    {
        childVC = [[SHBaseViewController alloc] init];
    }
    
    childVC.title = title;
    
    //设置点击图片
    UIImage *image = [UIImage imageNamed:img];
    childVC.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVC.tabBarItem.selectedImage = [[image imageWithColor:kColorMain] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 添加为tabbar控制器的子控制器
    SHBaseNavViewController *nav = [[SHBaseNavViewController alloc] initWithRootViewController:childVC];
    nav.view.tag = self.viewControllers.count;
    [self addChildViewController:nav];
}

#pragma mark - UITabBarControllerDelegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController.view.tag == 2)
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
