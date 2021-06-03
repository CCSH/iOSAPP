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
    return [self routingWithUrl:url param:nil type:type block:block];
}

+ (UIViewController *)routingWithUrl:(NSString *)url
                               param:(id)param
                                type:(SHRoutingType)type
                               block:(CallBack _Nullable)block{
    NSURL *routing = [NSURL URLWithString:url];
    
    //获取scheme
    NSString *scheme = routing.scheme;
    NSString *host = routing.host;
    
    UIViewController *vc;
    
    //符合自定义的路由规则
    if ([scheme isEqualToString:kScheme]) {
        //找到界面数据
        vc = [NSClassFromString([self getVCWithName:host]) new];
        //设置内容
        if ([vc isKindOfClass:[SHBaseViewController class]]) {
            SHBaseViewController *temp = (SHBaseViewController *)vc;
            //设置回调
            temp.callBack = block;
            //设置参数
            if (param) {
                temp.param = param;
            }else{
                temp.param = [self getUrlParam:routing.query];
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

#pragma mark 获取url的参数
+ (NSDictionary *)getUrlParam:(NSString *)str{
    //获取参数
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSArray *query = [str componentsSeparatedByString:@"&"];
    for (NSString *obj in query) {
        NSArray *temp = [obj componentsSeparatedByString:@"="];
        [param setValue:temp[1] forKey:temp[0]];
    }
    return param;
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
+ (NSString *)getUrlWithName:(NSString *)name{
    return [self getUrlWithName:name param:nil];
}

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

    if ([name isEqualToString:RoutingName_login]) {
        return @"LoginViewController";
    }else if ([name isEqualToString:RoutingName_welcome]){
        return @"WelcomeViewController";
    }else if ([name isEqualToString:RoutingName_main]){
        return @"MainTabBarController";
    }else if ([name isEqualToString:RoutingName_web]){
        return @"SHWebViewController";
    }else if ([name isEqualToString:RoutingName_search]){
        return @"ShopSearchViewController";
    }else if ([name isEqualToString:RoutingName_goodDetail]){
        return @"GoodsDetailViewController";
    }else if ([name isEqualToString:RoutingName_orderConfirm]){
        return @"OrderConfirmViewController";
    }else if ([name isEqualToString:RoutingName_addressList]){
        return @"AddressListViewController";
    }else if ([name isEqualToString:RoutingName_goodsSearch]){
        return @"GoodsSearchViewController";
    }else if ([name isEqualToString:RoutingName_specifications]){
        return @"CommoditySpecificationsViewController";
    }else if ([name isEqualToString:RoutingName_addressAdd]){
        return @"AddressAddViewController";
    }else if ([name isEqualToString:RoutingName_addressRegionSelect]){
        return @"AddressRegionSelectViewController";
    }else if ([name isEqualToString:RoutingName_publish]){
        return @"PublishViewController";
    }else if ([name isEqualToString:RoutingName_center]){
        return @"PersonalCenterViewController";
    }else if ([name isEqualToString:RoutingName_orderList]){
        return @"OrderListViewController";
    }else if ([name isEqualToString:RoutingName_order]){
        return @"OrderViewController";
    }
    return @"";
}

#pragma mark 错误界面
+ (UIViewController *)getErrorVC{
    SHBaseViewController *vc = [NSClassFromString([self getVCWithName:RoutingName_web]) new];
    vc.param = @{@"url":@"http://qzonestyle.gtimg.cn/qzone/hybrid/app/404"};
    return vc;
}

@end
