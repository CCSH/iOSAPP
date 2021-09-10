//
//  EnumHeader.h
//  iOSAPP
//
//  Created by CCSH on 2021/3/18.
//  Copyright © 2016年 CSH. All rights reserved.
//

#ifndef EnumHeader_h
#define EnumHeader_h

//结构体头文件

//跟视图类型
typedef enum : NSUInteger
{
    RootVCType_main,   //首页
    RootVCType_wecome, //欢迎页
    RootVCType_ad,     //广告
} RootVCType;

//路由跳转类型
typedef enum : NSUInteger {
    SHRoutingType_none,//不处理
    SHRoutingType_root,//跟视图
    SHRoutingType_nav,//导航调转
    SHRoutingType_modal,//模态跳转
} SHRoutingType;

#pragma mark - 路由
#pragma mark 内容
#define RoutingName_web @"web"
#define RoutingName_welcome @"welcome"
#define RoutingName_search @"search"
#define RoutingName_main @"main"
#define RoutingName_login @"login"
#define RoutingName_ad @"ad"
#define RoutingName_register @"register"
#define RoutingName_home @"home"
#define RoutingName_mine @"mine"
#define RoutingName_order @"order"

#endif /* EnumHeader_h */
