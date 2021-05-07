//
//  HomeViewController.m
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "HomeViewController.h"
#import <Speech/Speech.h>
#import "ClassViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColorTable_1;
    
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(100, 100, 100, 100);
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isNavHide = YES;
//    self.isStatusBarHide = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    param[@"url"] = @"https://github.com/CCSH";
    
    [SHRouting routingWithUrl:[SHRouting getUrlWithName:@"web" param:param]
                                                type:SHRoutingType_nav
                                               block:nil];
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
