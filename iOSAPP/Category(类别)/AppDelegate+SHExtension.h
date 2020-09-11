//
//  AppDelegate+SHExtension.h
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 csh. All rights reserved.
//

#import "AppDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (SHExtension)

typedef enum : NSUInteger
{
    RootVCType_home,   //首页
    RootVCType_wecome, //欢迎页
    RootVCType_login,  //登录
} RootVCType;

#pragma mark - 配置
- (void)config;

- (void)configVC:(RootVCType)type;

@end

NS_ASSUME_NONNULL_END
