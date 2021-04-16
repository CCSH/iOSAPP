//
//  AppDelegate+SHExtension.h
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 csh. All rights reserved.
//

#import "AppDelegate.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (SHExtension)<UNUserNotificationCenterDelegate>

typedef enum : NSUInteger
{
    RootVCType_home,   //首页
    RootVCType_wecome, //欢迎页
    RootVCType_login,  //登录
} RootVCType;



#pragma mark - 配置
- (void)configApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)configVC:(RootVCType)type;

#pragma mark 界面旋转
- (void)handleRotation;

#pragma mark 处理粘贴板
- (void)handleCopy;

#pragma mark 处理通知
- (void)handleNotificationRequest:(UNNotificationRequest *)request;

#pragma mark 处理点击通知
- (void)handleClickNotification:(NSString *)userInfo;


@end

NS_ASSUME_NONNULL_END
