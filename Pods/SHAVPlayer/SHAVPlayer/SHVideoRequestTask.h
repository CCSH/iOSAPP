//
//  SHVideoRequestTask.h
//  SHAVPlayer
//
//  Created by CSH on 2019/2/22.
//  Copyright © 2019 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//缓存默认路径
#define kSHTempPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"SHAVPlayer_temp"]

NS_ASSUME_NONNULL_BEGIN

@protocol SHVideoRequestTaskDelegate <NSObject>

@optional
//接收数据
- (void)didReceiveVideoData;
//缓存完成
- (void)didFinishLoadingWithPath:(NSString *)path;
//下载错误
- (void)didFailLoadingWithErrorCode:(NSInteger)errorCode;

@end

/**
 下载管理
 */
@interface SHVideoRequestTask : NSObject

//请求属性
@property (nonatomic, strong, readonly) NSURL *url;
@property (nonatomic, readonly) NSUInteger offset;

@property (nonatomic, readonly) NSUInteger videoLength;
@property (nonatomic, readonly) NSUInteger downLoadingOffset;

//代理
@property (nonatomic, weak) id <SHVideoRequestTaskDelegate> delegate;
//缓存路径(有默认)
@property (nonatomic, copy) NSString *tempPath;

- (void)setUrl:(NSURL *)url offset:(NSUInteger)offset;

//取消请求
- (void)cancelTask;

@end

NS_ASSUME_NONNULL_END
