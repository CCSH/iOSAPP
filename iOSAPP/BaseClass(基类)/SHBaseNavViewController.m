//
//  SHBaseNavViewController.m
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHBaseNavViewController.h"

@interface SHBaseNavViewController () <UINavigationControllerDelegate>

@end

@implementation SHBaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UINavigationBar *navBar = [UINavigationBar appearance];
    //主题颜色
    navBar.tintColor = [UIColor whiteColor];
    //44高度的颜色 最下方
//    navBar.backgroundColor = kColorMain;
    //背景颜色
//    navBar.barTintColor = kColorMain;
    //比barTintColor大 (设置了 导航栏布局为起始点为导航栏下方)
    [navBar setBackgroundImage:[UIImage getImageWithColor:kColorMain] forBarMetrics:UIBarMetricsDefault];
    //半透明(关闭后 存在导航栏布局为起始点为导航栏下方)
    navBar.translucent = NO;
    //分割线图片
//    navBar.shadowImage = [UIImage getImageWithColor:kColorMain];

    // 系统返回按钮
    UIImage *image = [UIImage imageNamed:@"nav_back"];
    navBar.backIndicatorImage = image;
    navBar.backIndicatorTransitionMaskImage = image;
    
    //标题颜色
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UINavigationBar appearance].tintColor,
                                     NSFontAttributeName : kBoldFont(15)}];
    //item 文字颜色 (图标颜色按照主题颜色)
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UINavigationBar appearance].tintColor,
                                                           NSFontAttributeName : kFont(14)}
                                                forState:UIControlStateNormal];

    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }

    if (viewController.navigationItem.backBarButtonItem) {
        viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil
                                                                                           style:UIBarButtonItemStylePlain
                                                                                          target:self
                                                                                          action:nil];
    }
    [super pushViewController:viewController animated:animated];
}

@end
