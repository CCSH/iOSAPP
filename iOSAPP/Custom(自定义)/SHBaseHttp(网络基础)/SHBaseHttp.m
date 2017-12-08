//
//  SHBaseHttp.m
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHBaseHttp.h"
#import <AFNetworking/AFNetworking.h>

#define TimeOut 30

@interface SHBaseHttp ()<NSURLSessionDelegate>

@end

@implementation SHBaseHttp

//请求队列
static NSMutableArray <NSURLSessionDataTask *>*operationQueueArr;

#pragma mark - 实例化请求对象
+ (AFHTTPSessionManager *)getAFHTTPSessionManager{

    
    static AFHTTPSessionManager *mgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 1.获得请求管理者
        mgr = [AFHTTPSessionManager manager];
        // 2.添加参数
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/xml",@"text/html",@"application/octet-stream", nil];
        
        // 3.支持HTTPS
        mgr.securityPolicy.allowInvalidCertificates = YES;
        mgr.securityPolicy.validatesDomainName = NO;
        
        // 4.设置格式
        mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
        mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        // 6.设置队列
        operationQueueArr = [[NSMutableArray alloc]init];
    });
    
    // 7.设置超时
    mgr.requestSerializer.timeoutInterval = TimeOut;
    
    return mgr;
}

#pragma mark - GET
+ (void)getWithUrl:(NSString *)url param:(id)param retryNum:(NSInteger)retryNum timeOut:(NSInteger)timeOut progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    // 发送GET请求
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AFHTTPSessionManager *mgr = [SHBaseHttp getAFHTTPSessionManager];
        
        //如果有超时设置超时
        if (timeOut) {
            mgr.requestSerializer.timeoutInterval = timeOut;
        }
        
        NSURLSessionDataTask *task = [mgr GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //移除队列
            [operationQueueArr removeObject:task];
            
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //移除队列
            [operationQueueArr removeObject:task];
            
            if (retryNum > 0) {
                //重新请求
                [self getWithUrl:url param:param retryNum:retryNum-1 timeOut:timeOut progress:progress success:success failure:failure];
            }else{
                if (failure) {
                    failure(error);
                }
            }
        }];
        //添加队列
        [operationQueueArr addObject:task];
    });
}

#pragma mark - POST
+ (void)postWithUrl:(NSString *)url param:(id)param retryNum:(NSInteger)retryNum timeOut:(NSInteger)timeOut progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    // 发送POST请求
    dispatch_async(dispatch_get_main_queue(), ^{
        
        AFHTTPSessionManager *mgr = [SHBaseHttp getAFHTTPSessionManager];
        
        //如果有超时设置超时
        if (timeOut) {
            mgr.requestSerializer.timeoutInterval = timeOut;
        }
        
        NSURLSessionDataTask *task = [mgr POST:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            if (progress) {
                progress(downloadProgress);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //移除队列
            [operationQueueArr removeObject:task];
            
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //移除队列
            [operationQueueArr removeObject:task];
            
            if (retryNum > 0) {
                //重新请求
                [self postWithUrl:url param:param retryNum:retryNum-1 timeOut:timeOut progress:progress success:success failure:failure];
            }else{
                if (failure) {
                    failure(error);
                }
            }
        }];
        //添加队列
        [operationQueueArr addObject:task];
    });
}

#pragma mark - 文件上传
+ (void)postUploadFileWithUrl:(NSString *)url param:(id)param file:(id)file fileType:(NSString *)fileType retryNum:(NSInteger)retryNum progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    // 发送文件上传
    NSURLSessionDataTask *task = [[SHBaseHttp getAFHTTPSessionManager] POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *data;
        
        if ([file isKindOfClass:[NSData class]]) {
            data = file;
        }else if ([file isKindOfClass:[NSString class]]){
            data = [NSData dataWithContentsOfFile:file];
        }

        if (data) {
             [formData appendPartWithFileData:data name:@"file" fileName:@"" mimeType:fileType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"文件上传进度：%f",uploadProgress.fractionCompleted);
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //移除队列
        [operationQueueArr removeObject:task];
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //移除队列
        [operationQueueArr removeObject:task];
        
        if (retryNum > 0) {
            //重新请求
            [self postUploadFileWithUrl:url param:param file:file fileType:fileType retryNum:retryNum-1 progress:progress success:success failure:failure];
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
    //添加队列
    [operationQueueArr addObject:task];
}

+ (void)postDataWithUrl:(NSString *)url param:(NSData *)param retryNum:(NSInteger)retryNum success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure{

    [[SHBaseHttp new] postDataWithUrl:url param:param retryNum:retryNum success:success failure:failure];
}

- (void)postDataWithUrl:(NSString *)url param:(NSData *)param retryNum:(NSInteger)retryNum success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure{
    
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultConfiguration.timeoutIntervalForRequest = TimeOut;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    NSMutableURLRequest *requset = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [requset setHTTPMethod:@"POST"];
    [requset setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:requset fromData:param completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (failure) {
                    failure(error);
                }
                
            }else{
                if (success) {
                    success(data);
                }
            }
        });
    }];
    //开始
    [task resume];
    
    //添加队列
    [operationQueueArr addObject:task];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
    NSURLCredential *card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
    completionHandler(NSURLSessionAuthChallengeUseCredential,card);
}

#pragma mark - 文件下载
+ (void)downLoadFlieWithUrl:(NSString *)url flie:(NSString *)file retryNum:(NSInteger)retryNum progress:(void (^)(NSProgress *))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    //1.创建会话管理者
    NSURL *fileUrl = [NSURL URLWithString:url];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
    
    //2.下载文件
    NSURLSessionDownloadTask *task = [[SHBaseHttp getAFHTTPSessionManager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"\n网址:%@\n文件下载进度：%f",url,downloadProgress.fractionCompleted);
        if (progress) {
            progress(downloadProgress);
        }
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return [NSURL fileURLWithPath:file];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            if (retryNum > 0) {
                //重新请求
                [self downLoadFlieWithUrl:url flie:file retryNum:retryNum-1 progress:progress success:success failure:failure];
            }else{
                if (failure) {
                    failure(error);
                }
            }
        }else{
            if (success) {
                success([filePath path]);
            }
        }
    }];
    
    //3.执行Task
    [task resume];
}

#pragma mark - 取消所有网络请求
+ (void)cancelAllOperations{
    
    while (operationQueueArr.count) {
        
        NSURLSessionDataTask *task = operationQueueArr[0];
        //取消请求
        [task cancel];
        //移除队列
        [operationQueueArr removeObject:task];
    }
}

@end
