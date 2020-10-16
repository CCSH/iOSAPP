//
//  SHBaseViewController.m
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHBaseViewController.h"

@interface SHBaseViewController ()

@end

@implementation SHBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kRGB(245, 245, 245, 1);
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //根据需求进行管理
    if (self.isNavHide) {
        self.isNavHide = NO;
    }
    if (self.isNavTransparent) {
        self.isNavTransparent = NO;
    }
    if (self.isStatusBarHide) {
        self.isStatusBarHide = NO;
    }
}

#pragma mark - 属性
- (void)setIsNavTransparent:(BOOL)isNavTransparent{
    _isNavTransparent = isNavTransparent;
    if (isNavTransparent) {
          [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
          [self.navigationController.navigationBar setShadowImage:[UIImage new]];
          self.navigationController.navigationBar.translucent = YES;
    }else{
          [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
          [self.navigationController.navigationBar setShadowImage:nil];
          self.navigationController.navigationBar.translucent = NO;
    }
}

- (void)setIsNavHide:(BOOL)isNavHide{
    _isNavHide = isNavHide;
    [self.navigationController setNavigationBarHidden:isNavHide animated:NO];
}

- (void)setIsStatusBarHide:(BOOL)isStatusBarHide{
    _isStatusBarHide = isStatusBarHide;
    [UIApplication sharedApplication].statusBarHidden = isStatusBarHide;
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle{
    _statusBarStyle = statusBarStyle;
    [UIApplication sharedApplication].statusBarStyle = statusBarStyle;
}

#pragma mark - 方法
#pragma mark 关闭自动布局
- (void)automaticallyWithScroll:(UIScrollView *)scroll{
    if (@available(iOS 11.0, *)) {
        if (scroll) {
            scroll.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark 返回
- (void)backAction
{
    if (self.navigationController.viewControllers.count > 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark 获取堆栈中的某个控制器
- (UIViewController *)getStackVCWithPageVC:(Class)pageVC
{
    NSArray< UIViewController * > *vcs = self.navigationController.viewControllers;

    __block UIViewController *vc = nil;
    [vcs enumerateObjectsUsingBlock:^(UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
      if ([obj isKindOfClass:pageVC])
      {
          vc = obj;
          *stop = YES;
      }
    }];

    return vc;
}

#pragma mark 获取堆栈中的指定位置的控制器
- (UIViewController *)getStackVCWithIndex:(int)index
{
    NSArray< UIViewController * > *vcs = self.navigationController.viewControllers;

    if (vcs.count)
    {
        if (vcs.count > abs(index))
        {
            return vcs[index];
        }
        else
        {
            return vcs[vcs.count + index];
        }
    }

    return nil;
}

#pragma mark 替换某个控制器到堆栈中
- (BOOL)replaceVCToStackVC:(UIViewController *)vc at:(int)at
{
    NSMutableArray< UIViewController * > *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];

    if (vcs.count > abs(at))
    {
        if (at > 0)
        {
            vcs[at] = vc;
        }
        else
        {
            vcs[vcs.count + at] = vc;
        }
        [self.navigationController setViewControllers:vcs animated:false];

        return true;
    }

    return false;
}

#pragma mark 模态跳转
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if (IOS(13))
    {
        if (viewControllerToPresent.modalPresentationStyle == UIModalPresentationPageSheet)
        {
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        }
    }

    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

#pragma mark 懒加载
- (UIWindow *)window
{
    if (!_window)
    {
        _window = [[[UIApplication sharedApplication] delegate] window];
    }
    return _window;
}

@end
