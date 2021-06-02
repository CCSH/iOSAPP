
//
//  ClassViewController.m
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "ClassViewController.h"
#import "HomeViewController.h"

@interface ClassViewController ()<UIScrollViewDelegate>

@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorStatus_warning;
    
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.frame = CGRectMake(0, 0, kSHWidth, kNavContentSafeAreaH - kTabBarH);
    scroll.delegate = self;
    [self.view addSubview:scroll];
    scroll.contentSize = CGSizeMake(kSHWidth, 10000);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarAlpha = 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    self.navBarAlpha = offsetY / 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
