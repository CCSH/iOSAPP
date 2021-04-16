//
//  SHRouting.m
//  iOSAPP
//
//  Created by CCSH on 2020/11/24.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHRouting.h"

@implementation SHRouting

#pragma mark 获取路由页面
+ (UIViewController *)routingWithUrl:(NSString *)url
                                type:(SHRoutingType)type
                               block:(CallBack)block{
    NSURL *temp = [NSURL URLWithString:url];
    
    //获取scheme
    NSString *scheme = temp.scheme;
    NSString *host = temp.host;
    
    UIViewController *vc;
    
    if ([scheme isEqualToString:kScheme]) {
        //找到界面数据
        vc = [NSClassFromString([self getVCWithName:host]) new];
        
        if (vc) {
            //获取参数
            NSDictionary *param = [SHTool getUrlParam:temp.query];
            //设置参数
            if ([vc isKindOfClass:[SHBaseViewController class]]) {
                SHBaseViewController *temp = (SHBaseViewController *)vc;
                temp.callBack = block;
                temp.param = param;
            }
        }
    }
    
    //不存在保护
    if (!vc) {
        //未找到页面 返回一个错误页面提示
        vc = [self getErrorVC];
    }
    
    UIViewController *root = [self getCurrentVC];

    switch (type) {
        case SHRoutingType_root:
        {
            UIWindow *window = [UIApplication sharedApplication].delegate.window;
            window.rootViewController = vc;
        }
            break;
        case SHRoutingType_nav:
        {
            [root.navigationController pushViewController:vc animated:YES];
        }
            break;
        case SHRoutingType_modal:
        {
            SHBaseNavViewController *nav = [[SHBaseNavViewController alloc]initWithRootViewController:vc];
            [root presentViewController:nav animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    return vc;
}

#pragma mark 获取最上方控制器
+ (UIViewController *)getCurrentVC{
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *rootVC = window.rootViewController;
    UIViewController *activeVC = nil;
    
    while (true) {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            activeVC = [(UINavigationController *)rootVC visibleViewController];
        } else if ([rootVC isKindOfClass:[UITabBarController class]]) {
            activeVC = [(UITabBarController *)rootVC selectedViewController];
        } else if (rootVC.presentedViewController) {
            activeVC = rootVC.presentedViewController;
        } else if (rootVC.childViewControllers.count > 0) {
            activeVC = [rootVC.childViewControllers lastObject];
        } else {
            break;
        }
        rootVC = activeVC;
    }
    return activeVC;
}

#pragma mark 路由url生成
+ (NSString *)getUrlWithName:(NSString *)name
                       param:(NSDictionary *)param{
    NSString *url =[NSString stringWithFormat:@"%@://",kScheme];
    url = [NSString stringWithFormat:@"%@%@",url,name];
    //参数处理
    NSMutableArray *temp = [NSMutableArray new];
    [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [temp addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
    }];
    //有参数
    if (temp.count) {
        url = [NSString stringWithFormat:@"%@?%@",url,[temp componentsJoinedByString:@"&"]];
    }
    return url;
}

#pragma mark 获取name对应的vc
+ (NSString *)getVCWithName:(NSString *)name{
    name = name.lowercaseString;
    if ([name isEqualToString:@"login"]) {
        return @"LoginViewController";
    }else if ([name isEqualToString:@"welcome"]){
        return @"WelcomeViewController";
    }else if ([name isEqualToString:@"main"]){
        return @"MainTabBarController";
    }else if ([name isEqualToString:@"web"]){
        return @"SHWebViewController";
    }
    return @"";
}

#pragma mark 错误界面
+ (UIViewController *)getErrorVC{
    SHBaseViewController *vc = [NSClassFromString([self getVCWithName:@"web"]) new];
    vc.param = @{@"url":@"http://qzonestyle.gtimg.cn/qzone/hybrid/app/404"};
    return vc;
}

@end
