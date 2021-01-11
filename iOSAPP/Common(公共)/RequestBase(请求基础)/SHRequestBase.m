

//
//  SHRequestBase.m
//  SHNetworkRequest
//
//  Created by CSH on 2019/5/31.
//  Copyright © 2019 CSH. All rights reserved.
//

#import "SHRequestBase.h"
#import "AFHTTPSessionManager.h"

@implementation SHRequestBase

//请求队列
static NSMutableDictionary *netQueueDic;
//默认超时
static NSInteger timeOut = 10;
//日志
static bool isLog = YES;

#pragma mark - 实例化请求对象
+ (AFHTTPSessionManager *)manager
{
    static AFHTTPSessionManager *mgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [AFHTTPSessionManager manager];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/html",
                                                         @"text/plain",
                                                         @"multipart/form-data",
                                                         nil];
        mgr.securityPolicy.allowInvalidCertificates = YES;
        mgr.securityPolicy.validatesDomainName = NO;
        mgr.requestSerializer.timeoutInterval = timeOut;
        
        mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [mgr.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //网络监听
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status)
            {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    //只加载网络
                    mgr.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    //只加载网络
                    mgr.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringCacheData;
                    break;
                default:
                    //只加载本地
                    mgr.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
                    break;
            }
        }];
        
        //开始监听
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        //请求队列
        netQueueDic = [[NSMutableDictionary alloc] init];
    });
    
    return mgr;
}

#pragma mark - 请求方法

#pragma mark GET
- (void)requestGet{
    
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager];
    
    // 开始请求
    NSURLSessionDataTask *task = [mgr GET:self.url
                               parameters:self.param
                                  headers:self.headers
                                 progress:self.progress
                                  success:^(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject) {
        //处理
        [self handleSuccess:responseObject];
        
    }
                                  failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error) {
        if (self.retry > 0)
        {
            //重新请求
            self.retry--;
            [self requestGet];
        }
        else
        {
            [self handleFailure:error];
        }
    }];
    
    [self handleTag:task];
}

#pragma mark POST
- (void)requestPost{
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager];
    
    // 开始请求
    NSURLSessionDataTask *task = [mgr POST:self.url
                                parameters:self.param
                                   headers:self.headers
                                  progress:self.progress
                                   success:^(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject) {
        //处理
        [self handleSuccess:responseObject];
        
    }
                                   failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error) {
        if (self.retry > 0)
        {
            //重新请求
            self.retry--;
            [self requestGet];
        }
        else
        {
            [self handleFailure:error];
        }
    }];
    
    [self handleTag:task];
}

#pragma mark FORM
- (void)requestFormWithFormParam:(id)formParam{
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager];
    
    // 开始请求
    NSURLSessionDataTask *task = [mgr POST:self.url
                                parameters:self.param
                                   headers:self.headers
                 constructingBodyWithBlock:^(id< AFMultipartFormData > _Nullable formData) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:formParam options:NSJSONWritingPrettyPrinted error:&error];
        
        if (!error)
        {
            [formData appendPartWithFormData:data name:@"items"];
        }
        else
        {
            [self handleFailure:error];
        }
    }
                                  progress:self.progress
                                   success:^(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject) {
        [self handleSuccess:responseObject];
    }
                                   failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error) {
        
        if (self.retry > 0)
        {
            //重新请求
            self.retry--;
            [self requestFormWithFormParam:formParam];
            
        }
        else
        {
            [self handleFailure:error];
        }
    }];
    [self handleTag:task];
}

#pragma mark 文件上传(单个)
- (void)requestUploadFileWithName:(NSString *_Nullable)name
                             data:(NSData *)data{
    name = name ?: @"file.jpg";
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager];
    
    // 开始请求
    NSURLSessionDataTask *task = [mgr POST:self.url
                                parameters:self.param
                                   headers:self.headers
                 constructingBodyWithBlock:^(id< AFMultipartFormData > _Nullable formData) {
        if (data)
        {
            NSArray *temp = [name componentsSeparatedByString:@"."];
            if (temp.count != 2)
            {
                temp = @[ name, @"jpg" ];
            }
            [formData appendPartWithFileData:data name:temp[0] fileName:[NSString stringWithFormat:@"file.%@", temp[1]] mimeType:@"application/octet-stream"];
        }
    }
                                  progress:self.progress
                                   success:^(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject) {
        [self handleSuccess:responseObject];
    }
                                   failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error) {
        
        if (self.retry > 0)
        {
            //重新请求
            self.retry--;
            [self requestUploadFileWithName:name data:data];
            
        }
        else
        {
            [self handleFailure:error];
        }
    }];
    [self handleTag:task];
}

#pragma mark 文件上传(多个 一次)
- (void)requestUploadFilesWithName:(NSString *_Nullable)name
                             datas:(NSArray< NSData * > *)datas{
    name = name ?: @"file.jpg";
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager];
    
    // 开始请求
    NSURLSessionDataTask *task = [mgr POST:self.url
                                parameters:self.param
                                   headers:self.headers
                 constructingBodyWithBlock:^(id< AFMultipartFormData > _Nullable formData) {
        [datas enumerateObjectsUsingBlock:^(NSData *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSArray *temp = [name componentsSeparatedByString:@"."];
            if (temp.count != 2)
            {
                temp = @[ name, @"jpg" ];
            }
            [formData appendPartWithFileData:obj name:temp[0] fileName:[NSString stringWithFormat:@"file.%@", temp[1]] mimeType:@"application/octet-stream"];
        }];
    }
                                  progress:self.progress
                                   success:^(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject) {
        [self handleSuccess:responseObject];
    }
                                   failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error) {
        
        if (self.retry > 0)
        {
            //重新请求
            self.retry--;
            [self requestUploadFilesWithName:name datas:datas];
            
        }
        else
        {
            [self handleFailure:error];
        }
    }];
    [self handleTag:task];
}

#pragma mark 文件上传(多个 多次)
- (void)requestUploadFilesManyWithName:(NSString *_Nullable)name
                                 datas:(NSArray< NSData * > *)datas{
    name = name ?: @"file.jpg";
    
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager];
    __block NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    
    dispatch_group_t group = dispatch_group_create();
    
    //循环
    [datas enumerateObjectsUsingBlock:^(NSData *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        dispatch_group_enter(group);
        // 开始请求
        [mgr POST:self.url
       parameters:self.param
          headers:self.headers
constructingBodyWithBlock:^(id< AFMultipartFormData > _Nullable formData) {
            NSArray *temp = [name componentsSeparatedByString:@"."];
            if (temp.count != 2)
            {
                temp = @[ name, @"jpg" ];
            }
            [formData appendPartWithFileData:obj name:temp[0] fileName:[NSString stringWithFormat:@"file.%@", temp[1]] mimeType:@"application/octet-stream"];
        }
         progress:self.progress
          success:^(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject) {
            dispatch_group_leave(group);
            //存起来
            [temp setValue:responseObject forKey:[NSString stringWithFormat:@"%lu", (unsigned long)idx]];
        }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error) {
            *stop = YES;
            dispatch_group_leave(group);
            [self handleFailure:error];
        }];
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        [self handleSuccess:temp];
    });
}

#pragma mark 文件下载
- (void)requestDownLoadFlieWithFlie:(NSString *)file{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager];
    
    //开始请求
    NSURLSessionDownloadTask *task = [mgr downloadTaskWithRequest:request
                                                         progress:self.progress
                                                      destination:^NSURL *_Nullable(NSURL *_Nullable targetPath, NSURLResponse *_Nullable response) {
        return [NSURL fileURLWithPath:file];
    }
                                                completionHandler:^(NSURLResponse *_Nullable response, NSURL *_Nullable filePath, NSError *_Nullable error) {
        
        if (error)
        {
            if (self.retry > 0)
            {
                //重新请求
                self.retry--;
                [self requestDownLoadFlieWithFlie:file];
                
            }
            else
            {
                [self handleFailure:error];
            }
        }
        else
        {
            [self handleSuccess:filePath];
        }
    }];
    //启动
    [task resume];
    [self handleTag:task];
}

#pragma mark 获取请求队列
- (NSDictionary *)getRequestQueue{
    return netQueueDic;
}

#pragma mark 取消所有网络请求
- (void)cancelAllOperations{
    NSDictionary *temp = [NSDictionary dictionaryWithDictionary:netQueueDic];
    
    [temp enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        //取消网络请求
        [self cancelOperationsWithTag:key];
    }];
}

#pragma mark 取消某个网络请求
- (void)cancelOperationsWithTag:(NSString *)tag{
    if (tag)
    {
        //取消请求
        NSURLSessionTask *task = netQueueDic[tag];
        if (task)
        {
            [task cancel];
            //移除队列
            [netQueueDic removeObjectForKey:tag];
        }
    }
}

#pragma mark - 私有方法
#pragma mark 处理成功
- (void)handleSuccess:(id)responseObject{
    //移除队列
    [self cancelOperationsWithTag:self.tag];
    //打印
    if (isLog) {
        SHLog(@"地址：%@\n入参：%@\n回参：%@", self.url, self.param, responseObject);
    }
    //回调
    if (self.success) {
        self.success(responseObject);
    }
}

#pragma mark 处理失败
- (void)handleFailure:(NSError *)error{
    //移除队列
    [self cancelOperationsWithTag:self.tag];
    //打印
    if (isLog) {
        SHLog(@"地址：%@\n入参：%@\n回参：%@", self.url, self.param, error.description);
    }
    //回调
    if (self.success) {
        self.failure(error);
    }
}

#pragma mark 处理tag
- (void)handleTag:(NSURLSessionTask *)task{
    if (self.tag.length)
    {
        //添加队列
        netQueueDic[self.tag] = task;
    }
}

@end
