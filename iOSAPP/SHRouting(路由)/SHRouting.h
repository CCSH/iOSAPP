//
//  SHRouting.h
//  iOSAPP
//
//  Created by CCSH on 2020/11/24.
//  Copyright © 2020 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SHRoutingType_none,//不处理
    SHRoutingType_root,//跟视图
    SHRoutingType_nav,//导航调转
    SHRoutingType_modal,//模态跳转
} SHRoutingType;

NS_ASSUME_NONNULL_BEGIN

/// 路由管理
@interface SHRouting : NSObject

#pragma mark 获取路由页面
+ (UIViewController *)routingWithUrl:(NSString *)url
                                type:(SHRoutingType)type
                               block:(CallBack _Nullable)block;

#pragma mark 路由url生成
+ (NSString *)getUrlWithName:(NSString *)name
                       param:(NSDictionary *_Nullable)param;

@end

NS_ASSUME_NONNULL_END
