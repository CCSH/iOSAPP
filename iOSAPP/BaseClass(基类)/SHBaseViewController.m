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
    // Do any additional setup after loading the view.=
}

#pragma mark - 获取堆栈中的某个控制器
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

#pragma mark - 获取堆栈中的指定位置的控制器
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

#pragma mark - 替换某个控制器到堆栈中
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

#pragma mark 蓝加载
- (UIWindow *)window
{
    if (!_window)
    {
        _window = [[[UIApplication sharedApplication] delegate] window];
    }
    return _window;
}
@end
