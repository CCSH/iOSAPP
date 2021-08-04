//
//  SHBaseViewController.m
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHBaseViewController.h"
#import <IQKeyboardManager.h>

@interface SHBaseViewController ()

@end

@implementation SHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kColor245;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.isOpenKeyboard = YES;
    [self closeAutomatically];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //根据需求进行管理
    if (self.isNavHide) {
        self.isNavHide = NO;
    }
    if (self.isStatusBarHide) {
        self.isStatusBarHide = NO;
    }
    if (self.navBarAlpha < 1) {
        self.navBarAlpha = 1;
    }
    if (self.navBarBGAlpha < 1) {
        self.navBarBGAlpha = 1;
    }
    if (self.statusBarStyle != UIStatusBarStyleDefault) {
        self.statusBarStyle = UIStatusBarStyleDefault;
    }
    if (!self.isOpenKeyboard) {
        self.isOpenKeyboard = YES;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.window endEditing:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDecelerating || scrollView.isDragging || scrollView.isTracking) {
        [self.window endEditing:YES];
    }
}

#pragma mark - 属性
#pragma mark 属性
- (void)setNavBarAlpha:(CGFloat)navBarAlpha {
    _navBarAlpha = navBarAlpha;
    //整体透明
    self.navigationController.navigationBar.alpha = navBarAlpha;
}

- (void)setNavBarBGAlpha:(CGFloat)navBarBGAlpha {
    _navBarBGAlpha = navBarBGAlpha;
    
    UIView *bgView = self.navigationController.navigationBar.subviews.firstObject;
    //颜色透明
    bgView.alpha = navBarBGAlpha;
}

- (void)setIsNavHide:(BOOL)isNavHide {
    _isNavHide = isNavHide;
    [self.navigationController setNavigationBarHidden:isNavHide animated:NO];
}

- (void)setIsStatusBarHide:(BOOL)isStatusBarHide {
    _isStatusBarHide = isStatusBarHide;
    [UIApplication sharedApplication].statusBarHidden = isStatusBarHide;
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    [UIApplication sharedApplication].statusBarStyle = statusBarStyle;
}

- (void)setIsOpenKeyboard:(BOOL)isOpenKeyboard {
    _isOpenKeyboard = isOpenKeyboard;
    [IQKeyboardManager sharedManager].enable = isOpenKeyboard;
}

#pragma mark - 方法
#pragma mark 关闭自动布局
- (void)closeAutomatically {
    if (IOS(11)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark 返回
- (void)backAction {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark 获取堆栈中的某个控制器
- (UIViewController *)getStackVCWithClassName:(NSString *)className {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    __block UIViewController *vc = nil;
    [vcs enumerateObjectsUsingBlock:^(UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([NSStringFromClass([obj class]) isEqualToString:className]) {
            vc = obj;
            *stop = YES;
        }
    }];
    
    return vc;
}

#pragma mark 获取堆栈中的指定位置的控制器
- (UIViewController *)getStackVCWithAt:(int)at {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    if (vcs.count) {
        NSUInteger index = at;
        
        if (at < 0) {
            index = vcs.count + at;
        }
        return vcs[index];
    }
    
    return nil;
}

#pragma mark 删除某个控制器
- (BOOL)removeVCToStackWithClassName:(NSString *_Nonnull)className {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    __block NSInteger index = -1;
    [vcs enumerateObjectsUsingBlock:^(UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if ([NSStringFromClass([obj class]) isEqualToString:className]) {
            index = idx;
            *stop = YES;
        }
    }];
    if (index >= 0) {
        [vcs removeObjectAtIndex:index];
        [self.navigationController setViewControllers:vcs animated:false];
        return YES;
    }
    return NO;
    ;
}

#pragma mark 删除某个位置的控制器
- (void)removeVCToStackWithAt:(int)at {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    NSUInteger index = at;
    
    if (at < 0) {
        index = vcs.count + at;
    }
    [vcs removeObjectAtIndex:index];
    [self.navigationController setViewControllers:vcs animated:false];
}

#pragma mark 替换某个控制器到堆栈中
- (BOOL)replaceVCToStackVC:(UIViewController *)vc at:(int)at {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    
    if (vcs.count > abs(at)) {
        NSUInteger index = at;
        if (at < 0) {
            index = vcs.count + at;
        }
        if (vc) {
            vcs[index] = vc;
        } else {
            [vcs removeObjectAtIndex:index];
        }
        
        [self.navigationController setViewControllers:vcs animated:false];
        
        return true;
    }
    
    return false;
}

#pragma mark 显示加载框
- (void)showHub {
    [self showHubWithView:nil];
}

- (void)showHubWithView:(UIView *_Nullable)view {
    if (!view) {
        view = self.view;
    }
    
    [self hideHubWithView:view];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeCustomView;
        
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        hud.customView = [self hubView];
    });
}

#pragma mark 隐藏加载框
- (void)hideHub {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)hideHubWithView:(UIView *_Nullable)view {
    if (!view) {
        view = self.view;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];
    });
}

- (UIImageView *)hubView {
    UIImageView *hubView = [[UIImageView alloc] init];
    hubView.image = [UIImage imageNamed:@"loading"];
    hubView.size = CGSizeMake(20, 20);
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [hubView.layer addAnimation:rotationAnimation forKey:@"hubView"];
    
    return hubView;
}

#pragma mark 模态跳转
- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (IOS(13)) {
        if (viewControllerToPresent.modalPresentationStyle == UIModalPresentationPageSheet) {
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        }
    }
    
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

#pragma mark 懒加载
- (UIWindow *)window {
    if (!_window) {
        _window = [[[UIApplication sharedApplication] delegate] window];
    }
    return _window;
}

@end
