//
//  AppDelegate+SHExtension.m
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 csh. All rights reserved.
//

#import "AppDelegate+SHExtension.h"
#import "WelcomeViewController.h"
#import "MainTabBarController.h"
#import "LoginViewController.h"

@interface AppDelegate (SHExtension)

@end

@implementation AppDelegate (SHExtension)

#pragma mark - 配置
- (void)config
{
    //配置其他
    [self configOther];
    //配置界面逻辑
    [self configInterface];
    //配置通知
    [self configNotification];
}

#pragma mark 配置其他
- (void)configOther
{
    //三方配置
}

#pragma mark 配置界面逻辑
- (void)configInterface
{
    //当前版本号
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    //判断版本号(为空或者不为当前版本)
    if (kSHUserDefGet(kAppVersion) == nil || ![kSHUserDefGet(kAppVersion) isEqualToString:currentVersion])
    {
        SHLog(@"出现启动图");
        //保存版本号
        [kSHUserDef setValue:currentVersion forKey:kAppVersion];
        [kSHUserDef synchronize];
        //进入欢迎页
        [self configVC:RootVCType_wecome];
    }
    else
    {
        SHLog(@"不出现启动图");

        //判断是否登录过
        if ([SHSQLite getLoginInfoWithUid:@"1"][@"user_id"])
        {
            //进入主界面
            [self configVC:RootVCType_home];
        }
        else
        {
            //进入登录界面
            [self configVC:RootVCType_login];
        }
    }
}

#define mark 配置根视图
- (void)configVC:(RootVCType)type
{
    switch (type)
    {
        case RootVCType_home:
        {
            MainTabBarController *vc = [[MainTabBarController alloc] init];
            self.window.rootViewController = vc;
        }
        break;
        case RootVCType_wecome:
        {
            WelcomeViewController *vc = [[WelcomeViewController alloc] init];
            SHBaseNavViewController *nav = [[SHBaseNavViewController alloc] initWithRootViewController:vc];
            self.window.rootViewController = nav;
        }
        break;
        case RootVCType_login:
        {
            LoginViewController *vc = [[LoginViewController alloc] init];
            SHBaseNavViewController *nav = [[SHBaseNavViewController alloc] initWithRootViewController:vc];
            self.window.rootViewController = nav;
        }
        break;

        default:
            break;
    }
}

#pragma mark 配置通知
- (void)configNotification
{
    UIApplication *application = [UIApplication sharedApplication];

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //必须写代理，不然无法监听通知的接收与点击事件
    center.delegate = self;

    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError *_Nullable error) {
                            if (!error && granted)
                            {
                                //用户点击允许
                                SHLog(@"注册成功");

                                //注册远端消息通知
                                [application registerForRemoteNotifications];
                            }
                            else
                            {
                                //用户点击不允许
                                SHLog(@"注册失败");
                            }
                          }];
}

@end
