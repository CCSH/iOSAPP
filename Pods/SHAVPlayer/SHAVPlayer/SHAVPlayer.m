//
//  SHAVPlayer.m
//  SHAVPlayer
//
//  Created by CSH on 2019/1/3.
//  Copyright © 2019 CSH. All rights reserved.
//

#import "SHAVPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "SHLoaderURLConnection.h"

@interface SHAVPlayer ()<SHLoaderURLConnectionDelegate>

//播放器对象
@property (nonatomic, strong) AVPlayer *player;
//播放器管理器
@property (nonatomic, strong) AVPlayerItem *playerItem;
//播放器播放层
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
//当前时间
@property (nonatomic, assign) NSInteger currentTime;

//播放监听
@property (nonatomic, assign) id timeObserver;
//是否有监听
@property (nonatomic, assign) BOOL hasKVO;

//锁屏信息
@property (nonatomic, strong) NSMutableDictionary *lockInfo;

//边下边播
@property (nonatomic, strong) SHLoaderURLConnection *resouerLoader;

@end

@implementation SHAVPlayer

#pragma mark - 懒加载
- (AVPlayerLayer *)playerLayer{
    if (!_playerLayer) {
        _playerLayer = [[AVPlayerLayer alloc]init];
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        _playerLayer.frame = self.bounds;
        [self.layer addSublayer:_playerLayer];
    }
    return _playerLayer;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {//播放状态
        
        //获取对象
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        AVPlayerStatus status = [change[NSKeyValueChangeNewKey] intValue];
        
        switch (status) {
            case AVPlayerStatusReadyToPlay://准备播放
            {
                //获取资源总时长
                CMTime duration = playerItem.asset.duration;
                //转换成秒
                NSInteger totalTime = CMTimeGetSeconds(duration);
                
                if (totalTime > 0) {
                    
                    self.totalTime = totalTime;
                    
                    //回调
                    if ([self.delegate respondsToSelector:@selector(shAVPlayStatusChange:message:)]) {
                        
                        [self.delegate shAVPlayStatusChange:SHAVPlayStatus_readyToPlay
                                                    message:[NSString stringWithFormat:@"%ld",(long)totalTime]];
                    }
                }
                //监听播放进度
                [self addPlayProgress];
                //自动播放
                if (self.isAutomatic) {
                    [self play];
                }
            }
                break;
            case AVPlayerItemStatusFailed://播放错误
            case AVPlayerItemStatusUnknown://未知错误
            {
                //回调
                if ([self.delegate respondsToSelector:@selector(shAVPlayStatusChange:message:)]) {
                    
                    [self.delegate shAVPlayStatusChange:SHAVPlayStatus_failure
                                                message:[self.playerItem.error description]];
                }
            }
                break;
            default:
                break;
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {//缓存进度
        
        //获取对象
        AVPlayerItem *playerItem = (AVPlayerItem *)object;
        NSArray *loadedTimeRanges = playerItem.loadedTimeRanges;
        //获取缓冲区域
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        NSInteger statrtTime = CMTimeGetSeconds(timeRange.start);
        NSInteger durationTime = CMTimeGetSeconds(timeRange.duration);
        //获取缓存时间
        NSInteger cacheTime =  statrtTime + durationTime;
        
        //回调
        if ([self.delegate respondsToSelector:@selector(shAVPlayWithCacheTime:)]) {
            
            [self.delegate shAVPlayWithCacheTime:cacheTime];
        }
    }else if ([keyPath isEqualToString:@"frame"]){//视图frame
        
        self.playerLayer.frame = self.bounds;
    }else if ([keyPath isEqualToString:@"rate"]){//播放器状态
        
        //回调
        if ([self.delegate respondsToSelector:@selector(shAVPlayStatusChange:message:)]) {
            
            if (self.player.rate > 0 && !self.player.error) {
                [self.delegate shAVPlayStatusChange:SHAVPlayStatus_play
                                            message:@"播放"];
            }else{
                [self.delegate shAVPlayStatusChange:SHAVPlayStatus_pause
                                            message:@"暂停"];
            }
        }
        
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){//缓存不可用
        
        //回调
        if ([self.delegate respondsToSelector:@selector(shAVPlayStatusChange:message:)]) {
            
            [self.delegate shAVPlayStatusChange:SHAVPlayStatus_loading
                                        message:@"缓存不可用"];
        }
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){//缓存可以用
        
        //回调
        if ([self.delegate respondsToSelector:@selector(shAVPlayStatusChange:message:)]) {
            
            [self.delegate shAVPlayStatusChange:SHAVPlayStatus_canPlay
                                        message:@"缓存可以用"];
        }
    }
}

#pragma mark 监听播放进度
- (void)addPlayProgress{
    
    __weak typeof(self) weakSelf = self;
    //监听当前播放进度
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        
        //计算当前在第几秒
        NSInteger currentTime = CMTimeGetSeconds(time);
        
        //避免重复调用
        if (currentTime == weakSelf.currentTime) {
            return ;
        }
        weakSelf.currentTime = currentTime;
        
        if (weakSelf.isBackPlay) {//后台播放
            
            // 设置歌曲的总时长
            [weakSelf.lockInfo setObject:@(weakSelf.totalTime)
                                  forKey:MPMediaItemPropertyPlaybackDuration];
            // 设置当前时间
            [weakSelf.lockInfo setObject:@(currentTime)
                                  forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
            
            // 音乐信息赋值给获取锁屏中心的nowPlayingInfo属性
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:weakSelf.lockInfo];
        }
        
        //回调
        if ([weakSelf.delegate respondsToSelector:@selector(shAVPlayWithCurrentTime:)]) {
            
            [weakSelf.delegate shAVPlayWithCurrentTime:currentTime];
        }
    }];
}

#pragma mark 播放完成
- (void)playFinished {
    
    //回调
    if ([self.delegate respondsToSelector:@selector(shAVPlayStatusChange:message:)]) {
        
        [self.delegate shAVPlayStatusChange:SHAVPlayStatus_end
                                    message:@"播放完成"];
    }
}

#pragma mark 中断处理
- (void)handleInterreption{
    
    [self pause];
}

#pragma mark 进入后台
- (void)enterBackground{
    
    if (self.isBackPlay) {
        self.playerLayer.player = nil;
    }else{
        [self pause];
    }
}

#pragma mark 进入前台
- (void)enterForeground{
    
    if (self.isBackPlay && !self.playerLayer.player) {
        
        self.playerLayer.player = self.player;
    }
}

#pragma mark - 其他方法
#pragma mark 配置信息
- (void)configInfo{
    
    self.hasKVO = YES;
    
    //监听frame
    [self addObserver:self
           forKeyPath:@"frame"
              options:NSKeyValueObservingOptionNew
              context:nil];
    //监听播放状态
    [self.player addObserver:self
                  forKeyPath:@"rate"
                     options:NSKeyValueObservingOptionNew
                     context:nil];
    
    //监听status属性
    [self.playerItem addObserver:self
                      forKeyPath:@"status"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    //监听loadedTimeRanges属性
    [self.playerItem addObserver:self
                      forKeyPath:@"loadedTimeRanges"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    //监听播放的区域缓存是否为空
    [self.playerItem addObserver:self
                      forKeyPath:@"playbackBufferEmpty"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    //缓存可以播放的时候调用
    [self.playerItem addObserver:self
                      forKeyPath:@"playbackLikelyToKeepUp"
                         options:NSKeyValueObservingOptionNew
                         context:nil];
    
    //播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playFinished)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
    //中断通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleInterreption)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:[AVAudioSession sharedInstance]];
    //进入后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    //进入前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(enterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    //设置锁屏播放
    [[AVAudioSession sharedInstance] setActive:YES
                                         error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                     withOptions:AVAudioSessionCategoryOptionAllowBluetooth
                                           error:nil];
    
    if (self.isBackPlay) {//支持后台播放
        
        //设置锁屏信息
        [self configLockInfo];
    }
}

#pragma mark 清除信息
- (void)clearInfo{
    
    if (self.hasKVO) {//避免多次移除报错
        
        self.hasKVO = NO;
        
        [self pause];
        //取消请求
        [self.resouerLoader.task cancelTask];
        
        if (self.timeObserver) {
            [self.player removeTimeObserver:self.timeObserver];
            self.timeObserver = nil;
        }
        
        if (self.playerItem) {
            
            [self.playerItem removeObserver:self
                                 forKeyPath:@"status"];
            [self.playerItem removeObserver:self
                                 forKeyPath:@"loadedTimeRanges"];
            [self.playerItem removeObserver:self
                                 forKeyPath:@"playbackBufferEmpty"];
            [self.playerItem removeObserver:self
                                 forKeyPath:@"playbackLikelyToKeepUp"];
        }
        
        [self removeObserver:self
                  forKeyPath:@"frame"];
        [self.player removeObserver:self
                         forKeyPath:@"rate"];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] removeObserver:self.playerItem];
        [[NSNotificationCenter defaultCenter] removeObserver:[AVAudioSession sharedInstance]];
        
        //移除锁屏控制
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
        
        MPRemoteCommandCenter *rcc = [MPRemoteCommandCenter sharedCommandCenter];
        [rcc.playCommand removeTarget:self];
        [rcc.pauseCommand removeTarget:self];
        [rcc.togglePlayPauseCommand removeTarget:self];
        
        [[AVAudioSession sharedInstance] setActive:NO
                                             error:nil];
    }
}

#pragma mark 设置锁屏信息
- (void)configLockInfo{
    
    //锁屏信息
    self.lockInfo = [NSMutableDictionary dictionary];
    // 1、设置标题
    if (self.title) {
        [self.lockInfo setObject:self.title forKey:MPMediaItemPropertyTitle];
    }
    // 2、设置歌曲名
    if (self.name) {
        [self.lockInfo setObject:self.name forKey:MPMediaItemPropertyAlbumTitle];
    }
    // 3、设置艺术家
    if (self.artist) {
        [self.lockInfo setObject:self.artist forKey:MPMediaItemPropertyArtist];
    }
    // 4、设置封面的图片
    if (self.coverImage) {
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:self.coverImage];
        [self.lockInfo setObject:artwork forKey:MPMediaItemPropertyArtwork];
    }
    
    //接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    MPRemoteCommandCenter *rcc = [MPRemoteCommandCenter sharedCommandCenter];
    
    //界面控制
    [rcc.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self play];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    [rcc.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        [self pause];
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    //播放与暂停(耳机线控)
    [rcc.togglePlayPauseCommand setEnabled:YES];
    [rcc.togglePlayPauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        if (self.player.rate) {
            [self pause];
        }else{
            [self play];
        }
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    //拖拽进度
    if (@available(iOS 9.1, *)) {
        
        [rcc.changePlaybackPositionCommand setEnabled:YES];
        [rcc.changePlaybackPositionCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
            
            //跳转时间
            MPChangePlaybackPositionCommandEvent *playEvent = (MPChangePlaybackPositionCommandEvent *)event;
            //进行跳转
            [self seekToTime:playEvent.positionTime block:nil];
            
            return MPRemoteCommandHandlerStatusSuccess;
        }];
    } else {
        // Fallback on earlier versions
    }
    
    //上一首
    [rcc.previousTrackCommand setEnabled:YES];
    [rcc.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
    
    //下一首
    [rcc.nextTrackCommand setEnabled:YES];
    [rcc.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent * _Nonnull event) {
        
        return MPRemoteCommandHandlerStatusSuccess;
    }];
}

#pragma mark - 公共方法
#pragma mark 准备播放
- (void)preparePlay{
    
    //清除信息
    [self clearInfo];
    
    //初始化
    AVURLAsset *asset;
    if (self.isDownLoad) {//是否开启边下边播
        
        self.resouerLoader = [[SHLoaderURLConnection alloc] init];
        self.resouerLoader.delegate = self;
        
        asset = [AVURLAsset URLAssetWithURL:[SHLoaderURLConnection getSchemeVideoURL:self.url] options:nil];
        [asset.resourceLoader setDelegate:self.resouerLoader queue:dispatch_get_main_queue()];
    }else{//在线播放
        
        asset = [AVURLAsset URLAssetWithURL:self.url options:nil];
    }
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    if (!self.player) {
        self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    } else {
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    }
    
    self.playerLayer.player = self.player;
    
    if (!self.url.absoluteString.length) {
        return;
    }
    
    //配置信息
    [self configInfo];
}

#pragma mark 开始播放
- (void)play{
    //如果在停止播放状态就播放
    if (self.player.rate == 0) {
        [self.player play];
    }
}

#pragma mark 暂停播放
- (void)pause{
    //如果在播放状态就停止
    if (self.player.rate == 1) {
        [self.player pause];
    }
}

#pragma mark 停止播放
- (void)stop{
    //暂停
    [self pause];
    //到0
    [self seekToTime:0 block:nil];
}

#pragma mark 跳转多少秒
- (void)seekToTime:(NSTimeInterval)time block:(void (^)(BOOL))block{
    
    //向下取整
    time =  (int)time;
    
    time = MAX(0, time);
    time = MIN(time, self.totalTime);
    
    //设置时间
    CMTime changedTime = CMTimeMakeWithSeconds(time, 1);
    [self.player seekToTime:changedTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:block];
}

#pragma mark 处理时间
+ (NSString *)dealTime:(NSTimeInterval)time{
    
    if (isnan(time)) {
        return @"00:00";
    }
    
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    
    if (time/3600 >= 1) {
        formatter.allowedUnits = kCFCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    } else {
        formatter.allowedUnits = NSCalendarUnitMinute | NSCalendarUnitSecond;
    }
    
    NSString *dealTime = [formatter stringFromTimeInterval:time];
    
    if (dealTime.length == 7  || dealTime.length == 4) {
        dealTime = [NSString stringWithFormat:@"0%@",dealTime];
    }
    
    return dealTime;
}

#pragma mark - 边下边播 -
#pragma mark - SHLoaderURLConnectionDelegate
- (void)shLoaderDidFinishLoadingWithPath:(NSString *)path{
    
    //回调
    if ([self.delegate respondsToSelector:@selector(shAVPlayStatusChange:message:)]) {
        
        [self.delegate shAVPlayStatusChange:SHAVPlayStatus_downEnd message:path];
    }
}

#pragma mark 错误信息
- (void)shLoaderDidFailLoadingWithErrorCode:(NSInteger)errorCode{
    
    NSString *str = @"";
    switch (errorCode) {
        case -1001:
            str = @"请求超时";
            break;
        case -1003:
        case -1004:
            str = @"服务器错误";
            break;
        case -1005:
            str = @"网络中断";
            break;
        case -1009:
            str = @"无网络连接";
            break;
        default:
            str = [NSString stringWithFormat:@"%@", @"(_errorCode)"];
            break;
    }
    
    //回调
    if ([self.delegate respondsToSelector:@selector(shAVPlayStatusChange:message:)]) {
        [self.delegate shAVPlayStatusChange:SHAVPlayStatus_failure message:str];
    }
}

@end
