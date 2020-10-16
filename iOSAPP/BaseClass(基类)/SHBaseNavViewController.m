//
//  SHBaseNavViewController.m
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHBaseNavViewController.h"

@interface SHBaseNavViewController () < UINavigationControllerDelegate >

@end

@implementation SHBaseNavViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //主题颜色
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //标题颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UINavigationBar appearance].tintColor,
                                                           NSFontAttributeName : kFont(15)}];
    //item 文字颜色 (图标颜色按照主题颜色)
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName :[UINavigationBar appearance].tintColor,
                                                           NSFontAttributeName : kFont(14)}
                                                forState:UIControlStateNormal];
    //背景颜色
    [[UINavigationBar appearance] setBarTintColor:kColorStatus_primary];

    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }

    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
        initWithTitle:nil
                style:UIBarButtonItemStylePlain
               target:self
               action:nil];
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([[viewController class] conformsToProtocol:@protocol(HideNav)])
    {
        [viewController.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

@end
