//
//  WelcomeViewController.m
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

#pragma mark - 配置
- (void)configUI{
    SHScrollView *scroll = [[SHScrollView alloc]init];
    scroll.frame = self.view.bounds;
    scroll.contentArr = @[@"欢迎页1",@"欢迎页2",@"欢迎页3"];
    scroll.textAlignment = NSTextAlignmentCenter;
    scroll.timeInterval = -1;
    scroll.endRollingBlock = ^(BOOL isClick, NSInteger currentIndex) {
        if (isClick && currentIndex == scroll.contentArr.count - 1) {
            [kAppDelegate configVC:RootVCType_ad];
        }
    };
    [scroll reloadView];
    [self.view addSubview:scroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
