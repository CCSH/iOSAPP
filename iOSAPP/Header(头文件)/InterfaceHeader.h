//
// InterfaceHeader.h
// CoolTalk
//
// Created by CSH on 16/7/5.
// Copyright © 2016年 CSH. All rights reserved.
//

#ifndef InterfaceHeader_h
#define InterfaceHeader_h

//网络请求接口

//定义请求信息
static NSString *request_time = @"请求超时，请检查网络";
static NSString *request_error = @"网络异常，请检查网络";
static NSString *error_domain = @"ccsh_domain";
//请求code
//自定义code
static NSInteger ccsh_code = -1;
//超时
static NSInteger time_code = -1001;
//成功
static NSInteger success_code = 200;

#pragma mark - 三方
#define kBuglyID @"fc42b13a1b"

#pragma mark - 主机地址
#pragma mark 主机地址
#if kEnvironment_test
    //测试环境
    #define kUrl @"https://gg.gg/ccsh-blog/test/"
#elif kEnvironment_pre
    //预发环境
    #define kUrl @"https://gg.gg/ccsh-blog/pre/"
#else
    //生产环境
    #define kUrl @"https://gg.gg/ccsh-blog/pro/"
#endif

#pragma mark - 接口
#define kHostUrl @""kUrl"api/"

#pragma mark 新闻列表
#define kNewsList @"user/newsList"



#endif /* InterfaceHeader_h */









