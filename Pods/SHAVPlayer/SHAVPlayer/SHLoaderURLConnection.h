//
//  SHLoaderURLConnection.h
//  SHAVPlayer
//
//  Created by CSH on 2019/2/22.
//  Copyright © 2019 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SHVideoRequestTask.h"

@protocol SHLoaderURLConnectionDelegate <NSObject>

@optional
//下载完成
- (void)shLoaderDidFinishLoadingWithPath:(NSString *)path;
//播放错误
- (void)shLoaderDidFailLoadingWithErrorCode:(NSInteger)errorCode;

@end

@interface SHLoaderURLConnection : NSURLConnection <AVAssetResourceLoaderDelegate>

//下载任务
@property (nonatomic, strong) SHVideoRequestTask *task;
//代理
@property (nonatomic, weak) id<SHLoaderURLConnectionDelegate> delegate;

//处理url
+ (NSURL *)getSchemeVideoURL:(NSURL *)url;

@end
