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
    RootVCType_home,   //首页
    RootVCType_wecome, //欢迎页
    RootVCType_login,  //登录
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
#define RoutingName_goodDetail @"goodDetail"
#define RoutingName_orderConfirm @"orderConfirm"
#define RoutingName_addressList @"addressList"
#define RoutingName_goodsSearch @"goodsSearch"
#define RoutingName_specifications @"specifications"
#define RoutingName_addressAdd @"addressAdd"
#define RoutingName_addressRegionSelect @"addressRegionSelect"
#define RoutingName_publish @"publish"
#define RoutingName_center @"center"
#define RoutingName_orderList @"orderList"
#define RoutingName_order @"order"

#pragma mark - 订单
#define OrderType_pay @"WAITPAY"
#define OrderType_send @"WAITSEND"
#define OrderType_receivce @"WAITRECEIVE"
#define OrderType_cancel @"CANCEL_REFUND"

#endif /* EnumHeader_h */
