//
//  AppDelegate.h
//  iOSAPP
//
//  Created by CSH on 2017/9/13.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IUserModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//是否旋转
@property (nonatomic, assign) UIInterfaceOrientation interfaceOrientation;
//通知处理
@property (nonatomic, copy) NSString *notInfo;
//登录用户
@property (nonatomic, strong) IUserModel *userInfo;

@end

