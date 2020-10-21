//
//  SHRequestBase.h
//  SHNetworkRequest
//
//  Created by CSH on 2019/5/31.
//  Copyright © 2019 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 网络请求基础
 */
@interface SHRequestBase : NSObject

#pragma mark GET
+ (void)getWithUrl:(NSString *)url
             param:(id)param
               tag:(NSString *_Nullable)tag
             retry:(NSInteger)retry
          progress:(void (^_Nullable)(NSProgress *progress))progress
           success:(void (^_Nullable)(id responseObj))success
           failure:(void (^_Nullable)(NSError *error))failure;

#pragma mark POST

+ (void)postWithUrl:(NSString *)url
              param:(id)param
                tag:(NSString *_Nullable)tag
              retry:(NSInteger)retry
           progress:(void (^_Nullable)(NSProgress *progress))progress
            success:(void (^_Nullable)(id responseObj))success
            failure:(void (^_Nullable)(NSError *error))failure;

#pragma mark FORM
+ (void)formWithUrl:(NSString *)url
              param:(id)param
          formParam:(id)formParam
                tag:(NSString *_Nullable)tag
              retry:(NSInteger)retry
           progress:(void (^_Nullable)(NSProgress *progress))progress
            success:(void (^_Nullable)(id responseObj))success
            failure:(void (^_Nullable)(NSError *error))failure;

#pragma mark POST文件上传
+ (void)uploadFileWithUrl:(NSString *)url
                    param:(id)param
                     name:(NSString *_Nullable)name
                     data:(NSData *)data
                      tag:(NSString *_Nullable)tag
                    retry:(NSInteger)retry
                 progress:(void (^_Nullable)(NSProgress *progress))progress
                  success:(void (^_Nullable)(id responseObj))success
                  failure:(void (^_Nullable)(NSError *error))failure;

#pragma mark POST文件上传(批量 一次)
+ (void)uploadFilesWithUrl:(NSString *)url
                     param:(id)param
                      name:(NSString *_Nullable)name
                     datas:(NSArray< NSData * > *)datas
                       tag:(NSString *_Nullable)tag
                     retry:(NSInteger)retry
                  progress:(void (^_Nullable)(NSProgress *progress))progress
                   success:(void (^_Nullable)(id responseObj))success
                   failure:(void (^_Nullable)(NSError *error))failure;

#pragma mark POST文件上传(批量 多次)
+ (void)uploadFilesManyWithUrl:(NSString *)url
                         param:(id)param
                          name:(NSString *_Nullable)name
                         datas:(NSArray< NSData * > *)datas
                      progress:(void (^_Nullable)(NSProgress *progress))progress
                       success:(void (^_Nullable)(id responseObj))success
                       failure:(void (^_Nullable)(NSError *error))failure;

#pragma mark 文件下载
+ (void)downLoadFlieWithUrl:(NSURL *)url
                       flie:(NSString *)file
                        tag:(NSString *_Nullable)tag
                      retry:(NSInteger)retry
                   progress:(void (^_Nullable)(NSProgress *progress))progress
                    success:(void (^_Nullable)(id responseObj))success
                    failure:(void (^_Nullable)(NSError *error))failure;

#pragma mark 获取请求队列
+ (NSDictionary *)getRequestQueue;

#pragma mark 取消所有网络请求
+ (void)cancelAllOperations;

#pragma mark 取消某个网络请求
+ (void)cancelOperationsWithTag:(NSString *_Nullable)tag;

@end

NS_ASSUME_NONNULL_END
