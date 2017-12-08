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

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置底部背景
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSHWidth, 49)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.opaque = YES;
    
    //设置底部标题颜色
    UIColor *titleNormalColor = [UIColor lightGrayColor];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleNormalColor,NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    //设置底部标题点击颜色
    UIColor *titleSelectedColor = kRGB(18, 137, 255, 1);
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleSelectedColor, NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
    //添加子控制器
    OneViewController *oneVC = [[OneViewController alloc]init];
    [self addOneChlildVc:oneVC title:@"第一个" imageName:@"image" selectedImageName:@"image"];
    
    TwoViewController *telView = [[TwoViewController alloc]init];
    [self addOneChlildVc:telView title:@"第二个" imageName:@"image" selectedImageName:@"image"];
    
    ThreeViewController *addressView = [[ThreeViewController alloc]init];
    [self addOneChlildVc:addressView title:@"第三个" imageName:@"image" selectedImageName:@"image"];
    
    FourViewController *settingView = [[FourViewController alloc]init];
    [self addOneChlildVc:settingView title:@"第四个" imageName:@"image" selectedImageName:@"image"];
    
    //设置展示
    self.selectedIndex = 0;
}

/**
 *  添加一个子控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param imageName         图标
 *  @param selectedImageName 选中的图标
 */
- (void)addOneChlildVc:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName {

    childVc.title = title;
    
    //设置点击图片
    if (IOS(7)) {
        
        childVc.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        
        childVc.tabBarItem.image = [UIImage imageNamed:imageName];
        childVc.tabBarItem.selectedImage =[UIImage imageNamed:selectedImageName];
    }
    
    // 添加为tabbar控制器的子控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

#pragma mark - VC界面周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.selectedViewController beginAppearanceTransition:YES animated: animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.selectedViewController endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.selectedViewController endAppearanceTransition];
}

@end
