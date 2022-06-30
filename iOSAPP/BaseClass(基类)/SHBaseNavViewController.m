//
//  SHBaseNavViewController.m
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHBaseNavViewController.h"

@interface SHBaseNavViewController () <UINavigationControllerDelegate>

@end

@implementation SHBaseNavViewController

+ (void)initialize
{
    if (self == [self class]) {
        UINavigationBar *navBar = [UINavigationBar appearance];
        
        //主题颜色(图标、文字颜色)
        navBar.tintColor = [UIColor whiteColor];
        //半透明(关闭后 导航栏布局起始点为导航栏下方)
        navBar.translucent = NO;
        
        //背景颜色
        [self navBGColor:kColorMain];
        //背景图片
//        [self navBGImage:[UIImage imageNamed:@"tabbar_min"]];
        //标题
        [self navTitle:@{NSFontAttributeName:kFontBold(18),
                         NSForegroundColorAttributeName:[UIColor whiteColor]}];
        //iteam文字
        [self navItemText:@{NSFontAttributeName:kFont(14),
                            NSForegroundColorAttributeName:[UIColor redColor]}];
        //返回图片
        [self navBackImage:[UIImage imageNamed:@"left"]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

#pragma mark - 导航栏设置
#pragma mark 获取样式
+ (UINavigationBarAppearance *)getBar API_AVAILABLE(ios(13.0)){
    UINavigationBar *navBar = [UINavigationBar appearance];
    return navBar.scrollEdgeAppearance ? : [UINavigationBarAppearance new];
}

#pragma mark 标题
+ (void)navTitle:(NSDictionary<NSAttributedStringKey,id> *)obj{
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.titleTextAttributes = obj;
    if (IOS(13)) {
        UINavigationBarAppearance *appearance = [self getBar];
        appearance.titleTextAttributes = obj;
        
        navBar.scrollEdgeAppearance = appearance;
        navBar.standardAppearance = appearance;
    }
}

#pragma mark 背景颜色
+ (void)navBGColor:(UIColor *)obj{
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    navBar.barTintColor = obj;
    //背景颜色(44高度的颜色 最下方, 界面模态跳转不是全屏时用得到)
//    navBar.backgroundColor = obj;
    //分割线
    navBar.shadowColor = [UIColor clearColor];

    if (IOS(13)) {
        UINavigationBarAppearance *appearance = [self getBar];
        appearance.backgroundColor = obj;
        appearance.shadowColor = navBar.shadowColor;
        //关闭模糊效果
        appearance.backgroundEffect = nil;

        navBar.scrollEdgeAppearance = appearance;
        navBar.standardAppearance = appearance;
    }
}

#pragma mark 背景图片
+ (void)navBGImage:(UIImage *)obj{
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    [navBar setBackgroundImage:obj forBarMetrics:UIBarMetricsDefault];
    
    //分割线
    navBar.shadowColor = [UIColor clearColor];

    if (IOS(13)) {
        UINavigationBarAppearance *appearance = [self getBar];
        appearance.backgroundImage = obj;
        appearance.shadowColor = navBar.shadowColor;

        navBar.scrollEdgeAppearance = appearance;
        navBar.standardAppearance = appearance;
    }
}

#pragma mark 返回图片
+ (void)navBackImage:(UIImage *)obj{
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.backIndicatorImage = obj;
    
    if (IOS(13)) {
        UINavigationBarAppearance *appearance = [self getBar];
        [appearance setBackIndicatorImage:obj transitionMaskImage:obj];
        
        navBar.scrollEdgeAppearance = appearance;
        navBar.standardAppearance = appearance;
    }
}

#pragma mark iteam文字
+ (void)navItemText:(NSDictionary<NSAttributedStringKey,id> *)obj{
    
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    [barItem setTitleTextAttributes:obj forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:obj forState:UIControlStateSelected];
    if (IOS(13)) {
        UINavigationBar *navBar = [UINavigationBar appearance];
        UINavigationBarAppearance *appearance = [self getBar];
        UIBarButtonItemAppearance *button = appearance.buttonAppearance;
        UIBarButtonItemStateAppearance *state = button.normal;
        UIBarButtonItemStateAppearance *state2 = button.highlighted;
        
        state.titleTextAttributes = obj;
        state2.titleTextAttributes = obj;

        appearance.buttonAppearance = button;

        navBar.scrollEdgeAppearance = appearance;
        navBar.standardAppearance = appearance;
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:nil
                                                                                       style:UIBarButtonItemStylePlain
                                                                                      target:self
                                                                                      action:nil];
    [super pushViewController:viewController animated:animated];
}

@end
