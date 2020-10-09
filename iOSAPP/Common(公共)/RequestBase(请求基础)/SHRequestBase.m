

//
//  SHRequestBase.m
//  SHNetworkRequest
//
//  Created by CSH on 2019/5/31.
//  Copyright © 2019 CSH. All rights reserved.
//

#import "SHRequestBase.h"
#import "AFNetworking.h"

@implementation SHRequestBase

//请求队列
static NSMutableDictionary *netQueueDic;
//默认超时
static NSInteger timeOut = 10;

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

      //入参格式
      mgr.responseSerializer = [AFJSONResponseSerializer serializer];
      //回参格式
      mgr.requestSerializer = [AFHTTPRequestSerializer serializer];

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

#pragma mark GET
+ (void)getWithUrl:(NSString *)url
             param:(id)param
               tag:(NSString *)tag
             retry:(NSInteger)retry
          progress:(void (^__nullable)(NSProgress *_Nullable))progress
           success:(void (^__nullable)(id _Nullable))success
           failure:(void (^__nullable)(NSError *_Nullable))failure
{
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager];

    // 开始请求
    NSURLSessionDataTask *task = [mgr GET:url
        parameters:param
        progress:progress
        success:^(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject) {
          //移除队列
          [self cancelOperationsWithTag:tag];

          if (success)
          {
              success(responseObject);
          }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error) {
          //移除队列
          [self cancelOperationsWithTag:tag];

          if (retry > 0)
          {
              //重新请求
              [self getWithUrl:url
                         param:param
                           tag:tag
                         retry:(retry - 1)
                      progress:progress
                       success:success
                       failure:failure];
          }
          else
          {
              if (failure)
              {
                  failure(error);
              }
          }
        }];
    if (tag.length)
    {
        //添加队列
        netQueueDic[tag] = task;
    }
}

#pragma mark POST
+ (void)postWithUrl:(NSString *)url
              param:(id)param
                tag:(NSString *__nullable)tag
              retry:(NSInteger)retry
           progress:(void (^__nullable)(NSProgress *progress))progress
            success:(void (^__nullable)(id responseObj))success
            failure:(void (^__nullable)(NSError *error))failure
{
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager];

    // 开始请求
    NSURLSessionDataTask *task = [mgr POST:url
        parameters:param
        progress:nil
        success:^(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject) {
          //移除队列
          [self cancelOperationsWithTag:tag];

          if (success)
          {
              success(responseObject);
          }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error) {
          //移除队列
          [self cancelOperationsWithTag:tag];

          if (retry > 0)
          {
              //重新请求
              [self postWithUrl:url
                          param:param
                            tag:tag
                          retry:(retry - 1)
                       progress:progress
                        success:success
                        failure:failure];
          }
          else
          {
              if (failure)
              {
                  failure(error);
              }
          }
        }];

    if (tag.length)
    {
        //添加队列
        netQueueDic[tag] = task;
    }
}
#pragma mark FORM
+ (void)formWithUrl:(NSString *)url
                     param:(id)param
                 formParam:(id)formParam
                       tag:(NSString *__nullable)tag
                     retry:(NSInteger)retry
                  progress:(void (^__nullable)(NSProgress *progress))progress
                   success:(void (^__nullable)(id responseObj))success
                   failure:(void (^__nullable)(NSError *error))failure
{
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager];

    // 开始请求
    NSURLSessionDataTask *task = [mgr POST:url
        parameters:param
        constructingBodyWithBlock:^(id< AFMultipartFormData > _Nullable formData) {
          NSError *error = nil;
          NSData *data = [NSJSONSerialization dataWithJSONObject:formParam options:NSJSONWritingPrettyPrinted error:&error];

          if (!error)
          {
              [formData appendPartWithFormData:data name:@"items"];
          }
          else
          {
              if (failure)
              {
                  failure(error);
              }
          }
        }
        progress:progress
        success:^(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject) {
          //移除队列
          [self cancelOperationsWithTag:tag];

          if (success)
          {
              success(responseObject);
          }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error) {
          //移除队列
          [self cancelOperationsWithTag:tag];

          if (retry > 0)
          {
              //重新请求
              [self formWithUrl:url
                          param:param
                      formParam:formParam
                            tag:tag
                          retry:(retry - 1)
                       progress:progress
                        success:success
                        failure:failure];
          }
          else
          {
              if (failure)
              {
                  failure(error);
              }
          }
        }];
    if (tag.length)
    {
        //添加队列
        netQueueDic[tag] = task;
    }
}

#pragma mark POST文件上传
+ (void)uploadFileWithUrl:(NSString *)url
                    param:(id)param
                 fileType:(NSString *)fileType
                     data:(NSData *)data
                      tag:(NSString *__nullable)tag
                    retry:(NSInteger)retry
                 progress:(void (^__nullable)(NSProgress *progress))progress
                  success:(void (^__nullable)(id responseObj))success
                  failure:(void (^__nullable)(NSError *error))failure;
{
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager];

    // 开始请求
    NSURLSessionDataTask *task = [mgr POST:url
        parameters:param
        constructingBodyWithBlock:^(id< AFMultipartFormData > _Nullable formData) {
          if (data)
          {
              [formData appendPartWithFileData:data name:@"filename" fileName:@"filename" mimeType:fileType];
          }
        }
        progress:progress
        success:^(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject) {
          //移除队列
          [netQueueDic removeObjectForKey:tag];

          if (success)
          {
              success(responseObject);
          }
        }
        failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error) {
          //移除队列
          [netQueueDic removeObjectForKey:tag];

          if (retry > 0)
          {
              //重新请求
              [self uploadFileWithUrl:url param:param fileType:fileType data:data tag:tag retry:(retry - 1) progress:progress success:success failure:failure];
          }
          else
          {
              if (failure)
              {
                  failure(error);
              }
          }
        }];
    if (tag.length)
    {
        //添加队列
        netQueueDic[tag] = task;
    }
}

#pragma mark POST文件批量上传
+ (void)uploadFilesWithUrl:(NSString *)url
                     param:(id)param
                  fileType:(NSString *)fileType
                     datas:(NSArray< NSData * > *)datas
                  progress:(void (^__nullable)(NSProgress *_Nullable))progress
                   success:(void (^__nullable)(id _Nullable))success
                   failure:(void (^__nullable)(NSError *_Nullable))failure
{
    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager];
    __block NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];

    dispatch_group_t group = dispatch_group_create();

    //循环
    [datas enumerateObjectsUsingBlock:^(NSData *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
      dispatch_group_enter(group);
      // 开始请求
      [mgr POST:url
          parameters:param
          constructingBodyWithBlock:^(id< AFMultipartFormData > _Nullable formData) {
            if (obj)
            {
                [formData appendPartWithFileData:obj name:@"filename" fileName:@"filename" mimeType:fileType];
            }
          }
          progress:progress
          success:^(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject) {
            dispatch_group_leave(group);
            //存起来
            [temp setValue:responseObject forKey:[NSString stringWithFormat:@"%lu", (unsigned long)idx]];
          }
          failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error) {
            *stop = YES;
            dispatch_group_leave(group);
            if (failure)
            {
                failure(error);
            }
          }];
    }];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
      if (success)
      {
          success(temp);
      }
    });
}

#pragma mark 文件下载
+ (void)downLoadFlieWithUrl:(NSURL *)url
                       flie:(NSString *)file
                        tag:(NSString *__nullable)tag
                      retry:(NSInteger)retry
                   progress:(void (^__nullable)(NSProgress *progress))progress
                    success:(void (^__nullable)(id responseObj))success
                    failure:(void (^__nullable)(NSError *error))failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    // 获取对象
    AFHTTPSessionManager *mgr = [SHRequestBase manager];

    //开始请求
    NSURLSessionDownloadTask *task = [mgr downloadTaskWithRequest:request
        progress:progress
        destination:^NSURL *_Nullable(NSURL *_Nullable targetPath, NSURLResponse *_Nullable response) {
          return [NSURL fileURLWithPath:file];
        }
        completionHandler:^(NSURLResponse *_Nullable response, NSURL *_Nullable filePath, NSError *_Nullable error) {
          //移除队列
          [self cancelOperationsWithTag:tag];

          if (error)
          {
              if (retry > 0)
              {
                  //重新请求
                  [self downLoadFlieWithUrl:url flie:file tag:tag retry:(retry - 1) progress:progress success:success failure:failure];
              }
              else
              {
                  if (failure)
                  {
                      failure(error);
                  }
              }
          }
          else
          {
              if (success)
              {
                  success([filePath path]);
              }
          }
        }];
    //启动
    [task resume];
    if (tag.length)
    {
        //添加队列
        netQueueDic[tag] = task;
    }
}

#pragma mark 获取请求队列
+ (NSDictionary *)getRequestQueue
{
    return netQueueDic;
}

#pragma mark 取消所有网络请求
+ (void)cancelAllOperations
{
    NSDictionary *temp = [NSDictionary dictionaryWithDictionary:netQueueDic];

    [temp enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
      //取消网络请求
      [self cancelOperationsWithTag:key];
    }];
}

#pragma mark 取消某个网络请求
+ (void)cancelOperationsWithTag:(NSString *__nullable)tag
{
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

@end
