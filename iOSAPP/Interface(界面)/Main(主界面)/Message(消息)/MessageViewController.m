//
//  MessageViewController.m
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorTable_3;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showHub];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet< UITouch * > *)touches withEvent:(UIEvent *)event
{
    //支持旋转
    AppDelegate *app = kAppDelegate;

    if (app.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        app.interfaceOrientation = UIInterfaceOrientationPortrait;
    }
    else
    {
        app.interfaceOrientation = UIInterfaceOrientationLandscapeRight;
    }
}

@end
