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
        
        //主题颜色(图标，字体颜色)
        navBar.tintColor = [UIColor whiteColor];
        //半透明(关闭后 导航栏布局起始点为导航栏下方)
        navBar.translucent = NO;
        
        //标题
        [self navTitle:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        //item
        [self navItem:@{NSFontAttributeName:kFont(14)}];
        //背景
        [self navBGColor:kColorMain];
        //返回图片
        [self navBackImage:[UIImage imageNamed:@"nav_back"]];
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
    if (IOS(15)) {
        UINavigationBarAppearance *bar = [self getBar];
        bar.titleTextAttributes = obj;
        
        navBar.scrollEdgeAppearance = bar;
        navBar.standardAppearance = bar;
    }
}

#pragma mark 背景颜色
+ (void)navBGColor:(UIColor *)obj{
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    navBar.barTintColor = obj;
    //背景图片(比barTintColor大)
    [navBar setBackgroundImage:[UIImage getImageWithColor:obj] forBarMetrics:UIBarMetricsDefault];
    //背景颜色(44高度的颜色 最下方, 界面模态跳转不是全屏时用得到)
//    navBar.backgroundColor = color;
    //分割线
    navBar.shadowColor = [UIColor clearColor];
    
    if (IOS(15)) {
        UINavigationBarAppearance *bar = [self getBar];
        bar.backgroundColor = obj;
        bar.shadowColor = navBar.shadowColor;
        //关闭模糊效果
        bar.backgroundEffect = nil;
        
        navBar.scrollEdgeAppearance = bar;
        navBar.standardAppearance = bar;
    }
}

#pragma mark 返回图片
+ (void)navBackImage:(UIImage *)obj{
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.backIndicatorImage = obj;
    navBar.backIndicatorTransitionMaskImage = obj;
    
    if (IOS(15)) {
        UINavigationBarAppearance *bar = [self getBar];
        [bar setBackIndicatorImage:obj transitionMaskImage:obj];
        
        navBar.scrollEdgeAppearance = bar;
        navBar.standardAppearance = bar;
    }
}

#pragma mark item
+ (void)navItem:(NSDictionary<NSAttributedStringKey,id> *)obj{
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:obj
                                                forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:obj
                                                forState:UIControlStateSelected];
    if (IOS(15)) {
        UINavigationBar *navBar = [UINavigationBar appearance];
        UINavigationBarAppearance *bar = [self getBar];
        UIBarButtonItemAppearance *button = bar.buttonAppearance;
        UIBarButtonItemStateAppearance *state = button.normal;
        UIBarButtonItemStateAppearance *state2 = button.highlighted;
        
        state.titleTextAttributes = obj;
        state2.titleTextAttributes = obj;

        bar.buttonAppearance = button;

        navBar.scrollEdgeAppearance = bar;
        navBar.standardAppearance = bar;
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
