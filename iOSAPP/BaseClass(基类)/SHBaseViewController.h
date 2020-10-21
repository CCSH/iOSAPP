//
//  SHBaseViewController.h
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHBaseViewController : UIViewController

@property (nonatomic, strong) UIWindow *window;

//导航栏透明
@property (nonatomic, assign) CGFloat navBarAlpha;

//导航栏隐藏
@property (nonatomic, assign) BOOL isNavHide;

//状态栏隐藏
@property (nonatomic, assign) BOOL isStatusBarHide;

//状态栏颜色
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

#pragma mark 关闭自动布局
- (void)automaticallyWithScroll:(UIScrollView *)scroll;

#pragma mark 返回
- (void)backAction;

#pragma mark 获取堆栈中的某个控制器
- (UIViewController *)getStackVCWithPageVC:(Class)pageVC;

#pragma mark 获取堆栈中的指定位置的控制器
- (UIViewController *)getStackVCWithIndex:(int)index;

#pragma mark 替换某个控制器到堆栈中
- (BOOL)replaceVCToStackVC:(UIViewController *)vc at:(int)at;

#pragma mark 显示加载框
- (void)showHub;
- (void)showHubWithView:(UIView *_Nullable)view;
#pragma mark 隐藏加载框
- (void)hideHub;
- (void)hideHubWithView:(UIView *_Nullable)view;

@end

NS_ASSUME_NONNULL_END
