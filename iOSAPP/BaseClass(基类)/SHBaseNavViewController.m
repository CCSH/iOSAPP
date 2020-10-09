//
//  SHBaseNavViewController.m
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHBaseNavViewController.h"

@interface SHBaseNavViewController ()<UINavigationControllerDelegate>

@end

@implementation SHBaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[UINavigationBar appearance] setTintColor:kColorMain];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    self.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if ([[viewController class] conformsToProtocol:@protocol(HideNav)]) {
        [viewController.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
}

@end
