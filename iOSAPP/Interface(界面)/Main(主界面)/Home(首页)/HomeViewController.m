//
//  HomeViewController.m
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "HomeViewController.h"
#import <Speech/Speech.h>

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
    
    [self makeMaskView:view withImage:[UIImage imageNamed:@"tabbar_min"]];

}

#pragma mark 剪切视图
- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image {
    
    dispatch_async(dispatch_get_main_queue(), ^{

        CALayer *maskLayer = [CALayer layer];
        maskLayer.frame = view.bounds;

        [maskLayer setContents:(id)image.CGImage];
        [maskLayer setContentsScale:image.scale];

        view.layer.mask = maskLayer;
    });
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
