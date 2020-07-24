//
//  SHVideoRequestTask.m
//  SHAVPlayer
//
//  Created by CSH on 2019/2/22.
//  Copyright © 2019 CSH. All rights reserved.
//

#import "SHVideoRequestTask.h"

@interface SHVideoRequestTask ()

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableArray *taskArr;
@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, assign) BOOL once;

@end

@implementation SHVideoRequestTask

- (instancetype)init{
    
    self = [super init];
    if (self) {
        self.taskArr = [NSMutableArray array];
        
        _tempPath = kSHTempPath;
    }
    return self;
}

- (void)setTempPath:(NSString *)tempPath{
    _tempPath = tempPath;
    
    //存在缓存文件则删除
    if ([[NSFileManager defaultManager] fileExistsAtPath:tempPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
    }
    
    //创建新的
    [[NSFileManager defaultManager] createFileAtPath:tempPath contents:nil attributes:nil];
}

- (void)setUrl:(NSURL *)url offset:(NSUInteger)offset{
    
    _url = url;
    _offset = offset;
    _downLoadingOffset = 0;
    
    NSURLComponents *actualURLComponents = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    actualURLComponents.scheme = @"http";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[actualURLComponents URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    if (offset > 0 && self.videoLength > 0) {
        [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)offset, (unsigned long)self.videoLength - 1] forHTTPHeaderField:@"Range"];
    }
    
    [self continueLoading];
}

#pragma mark -  NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    
    NSDictionary *dic = (NSDictionary *)[httpResponse allHeaderFields] ;
    
    NSString *content = [dic valueForKey:@"Content-Range"];
    NSArray *array = [content componentsSeparatedByString:@"/"];
    NSString *length = array.lastObject;
    
    NSUInteger videoLength;
    
    if ([length integerValue] == 0) {
        videoLength = (NSUInteger)httpResponse.expectedContentLength;
    } else {
        videoLength = [length integerValue];
    }
    
    _videoLength = videoLength;
    
    [self.taskArr addObject:connection];
    
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.tempPath];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [self.fileHandle seekToEndOfFile];
    
    [self.fileHandle writeData:data];
    
    _downLoadingOffset += data.length;
    
    
    if ([self.delegate respondsToSelector:@selector(didReceiveVideoData)]) {
        [self.delegate didReceiveVideoData];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{

    if (self.taskArr.count < 2) {
        
        if ([self.delegate respondsToSelector:@selector(didFinishLoadingWithPath:)]) {
            [self.delegate didFinishLoadingWithPath:self.tempPath];
        }
    }
}

//网络中断：-1005
//无网络连接：-1009
//请求超时：-1001
//服务器内部错误：-1004
//找不到服务器：-1003
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (error.code == -1001 && !self.once) {      //网络超时，重连一次
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.once = YES;
            [self continueLoading];
        });
    }
    if ([self.delegate respondsToSelector:@selector(didFailLoadingWithErrorCode:)]) {
        [self.delegate didFailLoadingWithErrorCode:error.code];
    }
}

#pragma mark 开始连接
- (void)continueLoading{
    
    NSURLComponents *actualURLComponents = [[NSURLComponents alloc] initWithURL:_url resolvingAgainstBaseURL:NO];
    actualURLComponents.scheme = @"http";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[actualURLComponents URL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
    
    [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld",(unsigned long)_downLoadingOffset, (unsigned long)self.videoLength - 1] forHTTPHeaderField:@"Range"];
    
    
    [self cancelTask];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [self.connection setDelegateQueue:[NSOperationQueue mainQueue]];
    [self.connection start];
}

- (void)cancelTask{
    
    [self.connection cancel];
}

@end
