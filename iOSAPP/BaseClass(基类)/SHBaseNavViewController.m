//
//  SHBaseNavViewController.m
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHBaseNavViewController.h"

@interface SHBaseNavViewController ()

@end

@implementation SHBaseNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
