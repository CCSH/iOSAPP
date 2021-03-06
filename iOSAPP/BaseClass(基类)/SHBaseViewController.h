//
//  SHBaseViewController.h
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//回调
typedef void(^CallBack)();

@interface SHBaseViewController : UIViewController

// 路由设置
//参数
@property (nonatomic, strong) id param;
//回调
@property (nonatomic, copy) CallBack callBack;

// 其他参数
//当前windows
@property (nonatomic, strong) UIWindow *window;
//导航背景透明
@property (nonatomic, assign) CGFloat navBarBGAlpha;
//导航栏透明
@property (nonatomic, assign) CGFloat navBarAlpha;
//导航栏隐藏
@property (nonatomic, assign) BOOL isNavHide;
//状态栏隐藏
@property (nonatomic, assign) BOOL isStatusBarHide;
//状态栏颜色
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

#pragma mark 关闭自动布局
- (void)closeAutomatically;

#pragma mark 返回
- (void)backAction;

#pragma mark 获取堆栈中的某个控制器
- (UIViewController *_Nullable)getStackVCWithClassName:(NSString *_Nonnull)className;

#pragma mark 获取堆栈中的指定位置的控制器
- (UIViewController *_Nullable)getStackVCWithAt:(int)at;

#pragma mark 删除某个控制器
- (BOOL)removeVCToStackWithClassName:(NSString *_Nonnull)className;

#pragma mark 删除某个位置的控制器
- (void)removeVCToStackWithAt:(int)at;

#pragma mark 替换某个控制器到堆栈中
- (BOOL)replaceVCToStackVC:(UIViewController *_Nonnull)vc at:(int)at;

#pragma mark 显示加载框
- (void)showHub;
- (void)showHubWithView:(UIView *_Nullable)view;

#pragma mark 隐藏加载框
- (void)hideHub;
- (void)hideHubWithView:(UIView *_Nullable)view;


@end

NS_ASSUME_NONNULL_END
