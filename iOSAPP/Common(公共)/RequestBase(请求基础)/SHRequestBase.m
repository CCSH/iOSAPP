

//
//  SHRequestBase.m
//  SHNetworkRequest
//
//  Created by CSH on 2019/5/31.
//  Copyright © 2019 CSH. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "SHRequestBase.h"

@implementation SHRequestBase

//请求队列
static NSMutableDictionary *netQueueDic;
//默认超时
static NSInteger timeOut = 10;
//日志
static bool isLog = YES;

#pragma mark - 实例化请求对象
+ (AFHTTPSessionManager *)manager:(SHRequestBase *)model {
    static AFHTTPSessionManager *mgr;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [AFHTTPSessionManager manager];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"multipart/form-data",
                                                         @"text/javascript",
                                                         @"text/json",
                                                         @"text/html",
                                                         @"text/plain",
                                                         nil];
        mgr.securityPolicy.allowInvalidCertificates = YES;
        mgr.securityPolicy.validatesDomainName = NO;
        mgr.requestSerializer.timeoutInterval = timeOut;
        
        //网络监听
        [self startMonitoring:mgr];
        //设置缓存
        [self defaultCacheSize:mgr];
        
        //请求队列
        netQueueDic = [[NSMutableDictionary alloc] init];
    });
    //加上默认的
    NSMutableDictionary *header = [SHRequestBase defaultHeader];
    [header addEntriesFromDictionary:model.headers];
    model.headers = header;
    
    //序列化
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return mgr;
}

#pragma mark 网络监听
+ (void)startMonitoring:(AFHTTPSessionManager *)mgr {
    //网络监听
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                mgr.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
            } break;
            default: {
                mgr.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
            } break;
        }
    }];
    
    //开始监听
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

#pragma mark 设置缓存大小
+ (void)defaultCacheSize:(AFHTTPSessionManager *)mgr {
    //设置缓存
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                      diskCapacity:50 * 1024 * 1024
                                                          diskPath:nil];
    [NSURLCache setSharedURLCache:cache];
    
    //缓存处理
    [mgr setDataTaskWillCacheResponseBlock:^NSCachedURLResponse *_Nonnull(NSURLSession *_Nonnull session, NSURLSessionDataTask *_Nonnull dataTask, NSCachedURLResponse *_Nonnull proposedResponse) {
        //可以进行修改
        //响应信息
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)proposedResponse.response;
        //请求头
        NSDictionary *headers = response.allHeaderFields;
        NSMutableDictionary *headers2 = headers.mutableCopy;
        [headers2 setObject:@"max-age=100" forKey:@"Cache-Control"];
        
        NSHTTPURLResponse *response2 = [[NSHTTPURLResponse alloc] initWithURL:response.URL
                                                                   statusCode:response.statusCode
                                                                  HTTPVersion:@"HTTP/1.1"
                                                                 headerFields:headers2];
        
        NSCachedURLResponse *proposedResponse2 = [[NSCachedURLResponse alloc] initWithResponse:response2
                                                                                          data:proposedResponse.data
                                                                                      userInfo:proposedResponse.userInfo
                                                                                 storagePolicy:proposedResponse.storagePolicy];
        
        return proposedResponse2;
    }];
}

#pragma mark - 请求方法
#pragma mark GET
- (void)requestGet {
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager:self];
    
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
        if (self.retry > 0) {
            //重新请求
            self.retry--;
            [self requestGet];
        } else {
            [self handleFailure:error];
        }
    }];
    [self handleTag:task];
}

#pragma mark POST
- (void)requestPost {
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager:self];
    
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
        if (self.retry > 0) {
            //重新请求
            self.retry--;
            [self requestPost];
        } else {
            [self handleFailure:error];
        }
    }];
    
    [self handleTag:task];
}

#pragma mark FORM
- (void)requestFormWithFormParam:(id)formParam {
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager:self];
    
    // 开始请求
    NSURLSessionDataTask *task = [mgr POST:self.url
                                parameters:self.param
                                   headers:self.headers
                 constructingBodyWithBlock:^(id<AFMultipartFormData> _Nullable formData) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:formParam options:NSJSONWritingPrettyPrinted error:&error];
        
        if (!error) {
            [formData appendPartWithFormData:data name:@"items"];
        } else {
            [self handleFailure:error];
        }
    }
                                  progress:self.progress
                                   success:^(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject) {
        [self handleSuccess:responseObject];
    }
                                   failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error) {
        if (self.retry > 0) {
            //重新请求
            self.retry--;
            [self requestFormWithFormParam:formParam];
            
        } else {
            [self handleFailure:error];
        }
    }];
    [self handleTag:task];
}

#pragma mark 文件上传(单个)
- (void)requestUploadFileWithName:(NSString *_Nullable)name
                             data:(NSData *)data {
    [self requestUploadFileWithName:name datas:@[ data ]];
}

#pragma mark 文件上传(多个 一次)
- (void)requestUploadFileWithName:(NSString *_Nullable)name
                            datas:(NSArray<NSData *> *)datas {
    NSArray *temp = [SHRequestBase handleUpLoad:name];
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager:self];
    
    // 开始请求
    NSURLSessionDataTask *task = [mgr POST:self.url
                                parameters:self.param
                                   headers:self.headers
                 constructingBodyWithBlock:^(id<AFMultipartFormData> _Nullable formData) {
        [datas enumerateObjectsUsingBlock:^(NSData *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [formData appendPartWithFileData:obj name:temp[0] fileName:[NSString stringWithFormat:@"file.%@", temp[1]] mimeType:@"application/octet-stream"];
        }];
    }
                                  progress:self.progress
                                   success:^(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject) {
        [self handleSuccess:responseObject];
    }
                                   failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error) {
        if (self.retry > 0) {
            //重新请求
            self.retry--;
            [self requestUploadFileWithName:name datas:datas];
            
        } else {
            [self handleFailure:error];
        }
    }];
    [self handleTag:task];
}

#pragma mark 文件上传(多个 多次)
- (void)requestUploadFilesManyWithName:(NSString *_Nullable)name
                                 datas:(NSArray<NSData *> *)datas {
    NSArray *temp = [SHRequestBase handleUpLoad:name];
    
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager:self];
    
    __block NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    dispatch_group_t group = dispatch_group_create();
    
    //循环
    [datas enumerateObjectsUsingBlock:^(NSData *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        dispatch_group_enter(group);
        // 开始请求
        [mgr POST:self.url
       parameters:self.param
          headers:self.headers
constructingBodyWithBlock:^(id<AFMultipartFormData> _Nullable formData) {
            [formData appendPartWithFileData:obj name:temp[0] fileName:[NSString stringWithFormat:@"file.%@", temp[1]] mimeType:@"application/octet-stream"];
        }
         progress:self.progress
          success:^(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject) {
            dispatch_group_leave(group);
            //存起来
            [arr addObject:responseObject];
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
- (void)requestDownLoadFlieWithFlie:(NSString *)file {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager:self];
    
    //开始请求
    NSURLSessionDownloadTask *task = [mgr downloadTaskWithRequest:request
                                                         progress:self.progress
                                                      destination:^NSURL *_Nullable(NSURL *_Nullable targetPath, NSURLResponse *_Nullable response) {
        return [NSURL fileURLWithPath:file];
    }
                                                completionHandler:^(NSURLResponse *_Nullable response, NSURL *_Nullable filePath, NSError *_Nullable error) {
        if (error) {
            if (self.retry > 0) {
                //重新请求
                self.retry--;
                [self requestDownLoadFlieWithFlie:file];
                
            } else {
                [self handleFailure:error];
            }
        } else {
            [self handleSuccess:filePath];
        }
    }];
    //启动
    [task resume];
    [self handleTag:task];
}

#pragma mark 原生GET
- (void)requestNativeGet {
    [SHRequestBase manager:self];
    
    NSString *url = [NSString stringWithFormat:@"%@%@", self.url, [self setUrlPara:self.param]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] init];
    req.URL = [NSURL URLWithString:url];
    
    req.allHTTPHeaderFields = [SHRequestBase defaultHeader];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:req
                                                                 completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (self.retry > 0) {
                    //重新请求
                    self.retry--;
                    [self requestNativeGet];
                    
                } else {
                    [self handleFailure:error];
                }
            } else {
                [self handleSuccess:data];
            }
        });
    }];
    
    //启动
    [task resume];
    [self handleTag:task];
}

#pragma mark 原生POST
- (void)requestNativePOST {
    [SHRequestBase manager:self];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] init];
    req.URL = [NSURL URLWithString:self.url];
    req.HTTPBody = [self.param mj_JSONData];
    req.HTTPMethod = @"POST";
    req.allHTTPHeaderFields = self.headers;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:req
                                                                 completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (self.retry > 0) {
                    //重新请求
                    self.retry--;
                    [self requestNativeGet];
                } else {
                    [self handleFailure:error];
                }
            } else {
                [self handleSuccess:data];
            }
        });
    }];
    
    //启动
    [task resume];
    [self handleTag:task];
}

#pragma mark - 公共方法
#pragma mark 获取请求队列
- (NSDictionary *)getRequestQueue {
    return netQueueDic;
}

#pragma mark 取消所有网络请求
- (void)cancelAllOperations {
    NSDictionary *temp = [NSDictionary dictionaryWithDictionary:netQueueDic];
    
    [temp enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
        //取消网络请求
        [self cancelOperationsWithTag:key];
    }];
}

#pragma mark 取消某个网络请求
- (void)cancelOperationsWithTag:(NSString *)tag {
    if (tag) {
        //取消请求
        NSURLSessionTask *task = netQueueDic[tag];
        if (task) {
            [task cancel];
            //移除队列
            [netQueueDic removeObjectForKey:tag];
        }
    }
}

#pragma mark - 私有方法
#pragma mark 处理成功
- (void)handleSuccess:(id)responseObject {
    //移除队列
    [self cancelOperationsWithTag:self.tag];
    
    responseObject = [responseObject mj_JSONObject];
    
    //打印
    if (isLog) {
        SHLog(@"地址：%@\n入参：%@\n回参：%@", self.url, [self.param mj_JSONString], responseObject);
    }
    //回调
    if (self.success) {
        self.success(responseObject);
    }
}

#pragma mark 处理失败
- (void)handleFailure:(NSError *)error {
    //移除队列
    [self cancelOperationsWithTag:self.tag];
    //打印
    if (isLog) {
        SHLog(@"地址：%@\n入参：%@\n回参：%@", self.url, [self.param mj_JSONString], error.description);
    }
    //回调
    if (self.failure) {
        self.failure(error);
    }
}

#pragma mark 处理tag
- (void)handleTag:(NSURLSessionTask *)task {
    if (self.tag.length) {
        //添加队列
        netQueueDic[self.tag] = task;
    }
}

#pragma mark 设置Url参数
- (NSString *)setUrlPara:(NSDictionary *)para {
    if (!para.count) {
        return @"";
    }
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    [para enumerateKeysAndObjectsUsingBlock:^(NSString *_Nonnull key, NSString *_Nonnull obj, BOOL *_Nonnull stop) {
        [temp addObject:[NSString stringWithFormat:@"%@=%@", key, obj]];
    }];
    
    return [NSString stringWithFormat:@"?%@", [temp componentsJoinedByString:@"&"]];
}

#pragma mark 默认请求头
+ (NSMutableDictionary *)defaultHeader {
    NSMutableDictionary *header = [NSMutableDictionary dictionary];
    header[@"Content-Type"] = @"application/json";
    
    return header;
}

#pragma mark 处理文件上传
+ (NSArray *)handleUpLoad:(NSString *)name {
    name = name ?: @"file.jpg";
    NSArray *temp = [name componentsSeparatedByString:@"."];
    if (temp.count != 2) {
        temp = @[ name, @"jpg" ];
    }
    return temp;
}

@end
