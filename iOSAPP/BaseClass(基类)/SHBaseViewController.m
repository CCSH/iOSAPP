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
    self.isOpenKeyboard = YES;
    [self closeAutomatically];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //根据需求进行管理
    if (self.isNavHide) {
        self.isNavHide = NO;
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
    if (self.isStatusBarHide) {
        self.isStatusBarHide = NO;
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

- (UIStatusBarStyle)preferredStatusBarStyle{
    //View controller-based status bar appearance :YES
    return self.statusBarStyle;
}

- (BOOL)prefersStatusBarHidden{
    return self.isStatusBarHide;
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
    [[UIApplication sharedApplication] setStatusBarHidden:isStatusBarHide animated:NO];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle animated:NO];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setIsOpenKeyboard:(BOOL)isOpenKeyboard {
    _isOpenKeyboard = isOpenKeyboard;
    [IQKeyboardManager sharedManager].enable = isOpenKeyboard;
}

#pragma mark - 方法
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
