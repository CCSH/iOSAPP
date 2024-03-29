//
//  AppDelegate+SHExtension.m
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 csh. All rights reserved.
//

#import "AppDelegate+SHExtension.h"
#import "MainTabBarController.h"
#import <MOBFoundation/MobSDK+Privacy.h>
#import <MobLinkPro/IMLSDKRestoreDelegate.h>
#import <MobLinkPro/MLSDKScene.h>
#import <MobLinkPro/MobLink.h>

@interface AppDelegate (SHExtension) <
IMLSDKRestoreDelegate,
UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate (SHExtension)

#pragma mark - 配置
- (void)configApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [UIApplication sharedApplication].statusBarHidden = NO;
    //配置其他
    [self configOther];
    //配置界面逻辑
    [self configInterface];
    //配置通知
    [self configNotification];
}

#pragma mark 配置其他
- (void)configOther {
    //    //bugly配置
    //    BuglyConfig * config = [[BuglyConfig alloc] init];
    //    //卡顿监听
    //    config.blockMonitorEnable = YES;
    //    config.blockMonitorTimeout = 0.5;
    //
    //    [Bugly startWithAppId:kBuglyID config:config];
    //协议
    [MobSDK uploadPrivacyPermissionStatus:YES onResult:nil];
    //设置MobLink代理
    [MobLink setDelegate:self];
    
    if (IOS(15)) {
        [UITableView appearance].sectionHeaderTopPadding = 0;
    }
    
    //配置登录信息
    self.userInfo = [SHSQLite getLoginInfo];
}

#pragma mark 配置界面逻辑
- (void)configInterface {
    //当前版本号
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    //判断版本号(为空或者不为当前版本)
    if (kSHUserDefGet(kAppVersion) == nil || ![kSHUserDefGet(kAppVersion) isEqualToString:currentVersion]) {
        SHLog(@"出现欢迎页");
        //保存版本号
        [kSHUserDef setValue:currentVersion forKey:kAppVersion];
        [kSHUserDef synchronize];
        
        //进入欢迎页
        [self configVC:RootVCType_wecome];
    } else {
        SHLog(@"不出现欢迎页");
        //进入主界面
        [self configVC:RootVCType_ad];
    }
}

#define mark 配置根视图
- (void)configVC:(RootVCType)type {
    switch (type) {
        case RootVCType_main: {
            [SHRouting routingWithUrl:[SHRouting getUrlWithName:RoutingName_main]
                                 type:SHRoutingType_root
                                block:nil];
            //界面加载完毕、处理通知点击
            [self handleClickNotification:self.notInfo];
        } break;
        case RootVCType_wecome: {
            [SHRouting routingWithUrl:[SHRouting getUrlWithName:RoutingName_welcome]
                                 type:SHRoutingType_root
                                block:nil];
        } break;
        case RootVCType_ad: {
            [SHRouting routingWithUrl:[SHRouting getUrlWithName:RoutingName_ad]
                                 type:SHRoutingType_root
                                block:nil];
        } break;
        default:
            break;
    }
}

#pragma mark 配置通知
- (void)configNotification {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //必须写代理，不然无法监听通知的接收与点击事件
    center.delegate = self;
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
                          completionHandler:^(BOOL granted, NSError *_Nullable error) {
        if (!error && granted) {
            //用户点击允许
            SHLog(@"注册成功");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //注册远端消息通知
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            });
        } else {
            //用户点击不允许
            SHLog(@"注册失败");
        }
    }];
}

#pragma mark 界面旋转
- (void)handleRotation {
    //强制转换
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        UIInterfaceOrientation val = kAppDelegate.interfaceOrientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return UIInterfaceOrientationMaskLandscape;
            break;
        default:
            return UIInterfaceOrientationMaskPortrait;
            break;
    }
}

#pragma mark 处理粘贴板
- (void)handleCopy {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    
    if (IOS(14)) {
        [board detectPatternsForPatterns:[NSSet setWithObjects:UIPasteboardDetectionPatternProbableWebURL, UIPasteboardDetectionPatternNumber, UIPasteboardDetectionPatternProbableWebSearch, nil]
                       completionHandler:^(NSSet<UIPasteboardDetectionPattern> *_Nullable set, NSError *_Nullable error) {
            //判断类型是否可用
            BOOL hasNumber = NO, hasURL = NO;
            for (NSString *type in set) {
                if ([type isEqualToString:UIPasteboardDetectionPatternProbableWebURL]) {
                    hasURL = YES;
                } else if ([type isEqualToString:UIPasteboardDetectionPatternNumber]) {
                    hasNumber = YES;
                }
            }
            
            if (hasNumber && hasURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SHLog(@"符合标准===%@", board.string);
                });
            }
        }];
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark 处理通知
- (void)handleNotificationRequest:(UNNotificationRequest *)request {
    //收到推送的内容
    UNNotificationContent *content = request.content;
    //    //收到用户的基本信息
    //    NSDictionary *userInfo = content.userInfo;
    //
    //    //收到推送消息的角标
    //    NSNumber *badge = content.badge;
    //
    //    //收到推送消息body
    //    NSString *body = content.body;
    //
    //    //推送消息的声音
    //    UNNotificationSound *sound = content.sound;
    //
    //    // 推送消息的副标题
    //    NSString *subtitle = content.subtitle;
    //
    //    // 推送消息的标题
    //    NSString *title = content.title;
    
    if ([request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        SHLog(@"远程通知 = %@", content.userInfo);
    } else {
        // 判断为本地通知
        SHLog(@"本地通知 = {\n消息Body:%@\n标题:%@\n副标题:%@\n消息个数:%@\n声音：%@\n传值：%@}", content.body, content.title, content.subtitle, content.badge, content.sound, content.userInfo);
    }
}

#pragma mark 处理点击通知
- (void)handleClickNotification:(NSString *)userInfo {
    if (!userInfo.length) {
        return;
    }
    
    //处理逻辑
    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        //默认界面加载完毕
        self.notInfo = nil;
        SHLog(@"点击了通知 = %@", userInfo);
        
        NSDictionary *info = userInfo.mj_JSONObject;
        if (!info) {
            return;
        }
        //处理通知内容
        
    } else {
        //界面没加载完存起来
        self.notInfo = userInfo;
    }
}

#pragma mark 处理外部链接唤起
- (void)handleOpenURL:(NSURL *)url {
    if (!url) {
        return;
    }
    SHLog(@"内容 --- %@\n主机 --- %@\n参数 --- %@", url.absoluteString, url.host, url.query);
}

#pragma mark IMLSDKRestoreDelegate
- (void)IMLSDKWillRestoreScene:(MLSDKScene *)scene Restore:(void (^)(BOOL, RestoreStyle))restoreHandler {
    [self handleOpenURL:[NSURL URLWithString:scene.path]];
    restoreHandler(YES, MLDefault);
}

- (void)IMLSDKCompleteRestore:(MLSDKScene *)scene {
    NSLog(@"Complete Restore -Path:%@", scene.path);
}

- (void)IMLSDKNotFoundScene:(MLSDKScene *)scene {
    NSLog(@"Not Found Scene - Path :%@", scene.path);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"没有找到路径"
                                                        message:[NSString stringWithFormat:@"Path:%@", scene.path]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
