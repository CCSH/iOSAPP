//
//  SHBaseViewController.h
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIViewController+SHExtension.h>

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
//开启键盘监听
@property (nonatomic, assign) BOOL isOpenKeyboard;
//请求中
@property (nonatomic, assign) BOOL isRequesting;

#pragma mark 显示加载框
- (void)showHub;
- (void)showHubWithView:(UIView *_Nullable)view;

#pragma mark 隐藏加载框
- (void)hideHub;
- (void)hideHubWithView:(UIView *_Nullable)view;

@end

NS_ASSUME_NONNULL_END
