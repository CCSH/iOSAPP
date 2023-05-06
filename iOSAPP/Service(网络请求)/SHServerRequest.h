//
//  SHServerRequest.h
//  SHNetworkRequest
//
//  Created by CSH on 2019/5/31.
//  Copyright © 2019 CSH. All rights reserved.
//

#import "SHRequestBaseModel.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 请求接口
 */
@interface SHServerRequest : NSObject

#pragma mark - 缓存
#pragma mark 可清理的缓存
+ (NSString *)getRequstCacheClean;
#pragma mark 缓存大小
+ (CGFloat)getRequstCacheSize;
#pragma mark 清理缓存
+ (void)cleanRequstCache;
#pragma mark 不可清理的缓存
+ (NSString *)getRequstCache;

#pragma mark - 网络请求
#pragma mark 新闻列表
+ (void)requestListWithPid:(NSString *)pid
                    result:(RequestBlock)result;

@end

NS_ASSUME_NONNULL_END
