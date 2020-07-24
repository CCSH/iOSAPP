//
//  SHAVPlayer.h
//  SHAVPlayer
//
//  Created by CSH on 2019/1/3.
//  Copyright © 2019 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SHAVPlayStatus_readyToPlay,  //准备播放 (资源加载完成,可以使用)
    SHAVPlayStatus_canPlay,      //可以播放 (缓存可用)
    SHAVPlayStatus_loading,      //加载中   (缓存不可用)
    SHAVPlayStatus_failure,      //失败
    SHAVPlayStatus_play,         //播放
    SHAVPlayStatus_pause,        //暂停
    SHAVPlayStatus_end,          //播放完成
    SHAVPlayStatus_downEnd,      //下载完成
} SHAVPlayStatus;

/**
 视频播放代理
 */
@protocol SHAVPlayerDelegate <NSObject>

@optional

//资源当前时长(S)
- (void)shAVPlayWithCurrentTime:(NSInteger)currentTime;
//资源缓存时长(S)
- (void)shAVPlayWithCacheTime:(NSInteger)cacheTime;

//播放状态改变
- (void)shAVPlayStatusChange:(SHAVPlayStatus)status message:(NSString *)message;

@end

@interface SHAVPlayer : UIView

//资源url
@property (nonatomic, copy) NSURL *url;
//代理
@property (nonatomic, weak) id<SHAVPlayerDelegate> delegate;
//是否自动播放
@property (nonatomic, assign) BOOL isAutomatic;
//是否开启边下边播
@property (nonatomic, assign) BOOL isDownLoad;
//是否后台播放(需要设置app 后台模式 background modes 支持)
@property (nonatomic, assign) BOOL isBackPlay;

//总时长(如果能获取到 内部有设置)
@property (nonatomic, assign) NSInteger totalTime;

//锁屏音频信息(可以不设置)
//标题
@property (nonatomic, copy) NSString *title;
//音乐名
@property (nonatomic, copy) NSString *name;
//作者
@property (nonatomic, copy) NSString *artist;
//封面图片
@property (nonatomic, copy) UIImage *coverImage;

//准备播放
- (void)preparePlay;
//开始播放
- (void)play;
//暂停播放
- (void)pause;
//停止播放
- (void)stop;

//跳转多少秒
- (void)seekToTime:(NSTimeInterval)time block:(void (^)(BOOL finish))block;

//清除信息
- (void)clearInfo;

//处理时间
+ (NSString *)dealTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
