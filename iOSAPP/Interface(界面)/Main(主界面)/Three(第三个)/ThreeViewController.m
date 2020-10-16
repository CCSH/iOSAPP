//
//  ThreeViewController.m
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "ThreeViewController.h"

@interface ThreeViewController ()

@end

@implementation ThreeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorTable_3;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet< UITouch * > *)touches withEvent:(UIEvent *)event
{
    NSLog(@"旋转");

    //支持旋转
    AppDelegate *app = kAppDelegate;

    if (app.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        app.interfaceOrientation = UIInterfaceOrientationPortrait;
    }
    else
    {
        app.interfaceOrientation = UIInterfaceOrientationLandscapeRight;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].statusBarHidden = NO;
        });
    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

@end
