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
    navBar.shadowImage = [UIImage new];
    
    //标题处理
    NSMutableDictionary *att = [NSMutableDictionary dictionary];
    //标题颜色
    att[NSForegroundColorAttributeName] = [UIColor whiteColor];
    //标题字体
    att[NSFontAttributeName] = kBoldFont(15);
    navBar.titleTextAttributes = att;
    
    //按钮处理
    att = [NSMutableDictionary dictionary];
    att[NSForegroundColorAttributeName] = [UIColor whiteColor];
    att[NSFontAttributeName] = kFont(14);
    [[UIBarButtonItem appearance] setTitleTextAttributes:att forState:UIControlStateNormal];
    
    // 系统返回按钮
    UIImage *image = [UIImage imageNamed:@"nav_back"];
    navBar.backIndicatorImage = image;
    navBar.backIndicatorTransitionMaskImage = image;

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
