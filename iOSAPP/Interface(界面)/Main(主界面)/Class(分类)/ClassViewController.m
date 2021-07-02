
//
//  ClassViewController.m
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "ClassViewController.h"

@interface ClassViewController ()<UIScrollViewDelegate>

@end

@implementation ClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIScrollView *scroll = [[UIScrollView alloc]init];
    scroll.frame = CGRectMake(0, -kNavAndStatusH, kSHWidth, kSHHeight);
    scroll.delegate = self;
    scroll.backgroundColor = kColorStatus_warning;
    [self.view addSubview:scroll];
    scroll.contentSize = CGSizeMake(kSHWidth, 1000);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarBGAlpha = 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    self.navBarBGAlpha = offsetY / 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
