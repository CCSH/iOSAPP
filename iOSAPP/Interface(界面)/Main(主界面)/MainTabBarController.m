//
//  MainTabBarController.m
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "ClassViewController.h"
#import "HomeViewController.h"
#import "MainTabBarController.h"
#import "MessageViewController.h"
#import "MineViewController.h"
#import "SHBaseNavViewController.h"
#import "SHBaseViewController.h"
#import "SHTabBar.h"

@interface MainTabBarController () <UITabBarControllerDelegate>

@property (nonatomic, strong) SHTabBar *shTabBar;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    // tabbar
    self.shTabBar = [[SHTabBar alloc] init];
    [self setValue:self.shTabBar forKey:@"tabBar"];

    self.delegate = self;

    //添加子控制器
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    [self addOneChlildVC:homeVC title:@"首页" img:nil];

    ClassViewController *classVC = [[ClassViewController alloc] init];
    [self addOneChlildVC:classVC title:@"分类" img:nil];

    [self addOneChlildVC:nil title:nil img:nil];

    MessageViewController *messageVC = [[MessageViewController alloc] init];
    [self addOneChlildVC:messageVC title:@"消息" img:nil];

    MineViewController *mineVC = [[MineViewController alloc] init];
    [self addOneChlildVC:mineVC title:@"我的" img:nil];

    self.shTabBar.dataArr = @[ @"tabbar_min" ];

    //设置展示
    self.selectedIndex = 0;
}

//添加一个子控制器
- (void)addOneChlildVC:(UIViewController *)childVC
                 title:(NSString *)title
                   img:(NSString *)img {
    if (!childVC) {
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
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (viewController.view.tag == 2) {
        [self.shTabBar didSelectItem:2];
        return NO;
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    [self.shTabBar didSelectItem:self.selectedIndex];
}

@end
