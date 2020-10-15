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
@property (nonatomic, assign) BOOL isNavTransparent;

//导航栏隐藏
@property (nonatomic, assign) BOOL isNavHide;

#pragma mark - 返回
- (void)backAction;

#pragma mark - 获取堆栈中的某个控制器
- (UIViewController *)getStackVCWithPageVC:(Class)pageVC;

#pragma mark - 获取堆栈中的指定位置的控制器
- (UIViewController *)getStackVCWithIndex:(int)index;

#pragma mark - 替换某个控制器到堆栈中
- (BOOL)replaceVCToStackVC:(UIViewController *)vc at:(int)at;

@end

NS_ASSUME_NONNULL_END
