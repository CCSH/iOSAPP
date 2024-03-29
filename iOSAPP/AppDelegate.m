
//
//  AppDelegate.m
//  iOSAPP
//
//  Created by CSH on 2017/9/13.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //配置界面
    [self configApplication:application didFinishLaunchingWithOptions:launchOptions];

    return YES;
}

#pragma mark - 程序将要进入后台
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    SHLog(@"程序将要进入后台");
}

#pragma mark - 程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    SHLog(@"程序进入后台");
}

#pragma mark - 程序将要进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    SHLog(@"程序将要进入前台");
}

#pragma mark - 程序进入前台
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    SHLog(@"程序进入前台");
    [UIApplication sharedApplication].applicationIconBadgeNumber++;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    //处理粘贴板
    [self handleCopy];
}

#pragma mark 程序远程推送获取Token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (IOS(13)) {
        if (![deviceToken isKindOfClass:[NSData class]])
        {
            return;
        }
        const unsigned *tokenBytes = [deviceToken bytes];
        token = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                 ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                 ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                 ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    }
    
    SHLog(@"远程推送证书Token：%@", token);
}

#pragma mark - iOS10 收到通知（本地和远端）UNUserNotificationCenterDelegate
#pragma mark App处于前台接收通知时(下面这个代理方法，只会是app处于前台或者前台状态下才会走，后台模式下是不会走这里的)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(nonnull UNNotification *)notification withCompletionHandler:(nonnull void (^)(UNNotificationPresentationOptions))completionHandler
{
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    
    //处理通知
    [self handleNotificationRequest:request];
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
}

#pragma mark App通知的点击事件 (下面这个代理方法，只会是用户点击消息才会触发，如果使用户长按（3DTouch）、Action等并不会触发。 前后台点击都会走此方法)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(nonnull void (^)(void))completionHandler
{
    //收到推送的请求
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    //点击通知
    [self handleClickNotification:userInfo[@"payload"]];
    
    completionHandler(); // 系统要求执行这个方法
}

#pragma mark - 处理外部唤起
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary< UIApplicationOpenURLOptionsKey, id > *)options
{
    [self handleOpenURL:url];
    return YES;
}

- (void)setInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            break;
        default:
            interfaceOrientation = UIInterfaceOrientationPortrait;
            break;
    }
    
    if (_interfaceOrientation == interfaceOrientation) {
        return;
    }
    _interfaceOrientation = interfaceOrientation;
    [self handleRotation];
}

@end
