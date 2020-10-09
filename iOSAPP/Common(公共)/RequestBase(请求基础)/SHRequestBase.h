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

/**
 GET

 @param url 地址
 @param param 参数
 @param tag 请求标记
 @param retry 重试次数
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)getWithUrl:(NSString *)url
             param:(id)param
               tag:(NSString *__nullable)tag
             retry:(NSInteger)retry
          progress:(void (^__nullable)(NSProgress *progress))progress
           success:(void (^__nullable)(id responseObj))success
           failure:(void (^__nullable)(NSError *error))failure;

/**
 POST

 @param url 地址
 @param param 参数
 @param tag 请求标记
 @param retry 重试次数
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)postWithUrl:(NSString *)url
              param:(id)param
                tag:(NSString *__nullable)tag
              retry:(NSInteger)retry
           progress:(void (^__nullable)(NSProgress *progress))progress
            success:(void (^__nullable)(id responseObj))success
            failure:(void (^__nullable)(NSError *error))failure;

/**
 FORM

 @param url 地址
 @param param 参数
 @param formParam form表单参数
 @param tag 请求标记
 @param retry 重试次数
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)formWithUrl:(NSString *)url
              param:(id)param
          formParam:(id)formParam
                tag:(NSString *__nullable)tag
              retry:(NSInteger)retry
           progress:(void (^__nullable)(NSProgress *progress))progress
            success:(void (^__nullable)(id responseObj))success
            failure:(void (^__nullable)(NSError *error))failure;

/**
 POST文件上传

 @param url 地址
 @param param 参数
 @param fileType 文件类型
 @param data 文件
 @param tag 请求标记
 @param retry 重试次数
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)uploadFileWithUrl:(NSString *)url
                    param:(id)param
                 fileType:(NSString *)fileType
                     data:(NSData *)data
                      tag:(NSString *__nullable)tag
                    retry:(NSInteger)retry
                 progress:(void (^__nullable)(NSProgress *progress))progress
                  success:(void (^__nullable)(id responseObj))success
                  failure:(void (^__nullable)(NSError *error))failure;

/**
 POST文件上传(批量)
 
 @param url 地址
 @param param 参数
 @param fileType 文件类型
 @param datas 文件集合
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)uploadFilesWithUrl:(NSString *)url
                     param:(id)param
                  fileType:(NSString *)fileType
                     datas:(NSArray< NSData * > *)datas
                  progress:(void (^__nullable)(NSProgress *progress))progress
                   success:(void (^__nullable)(id responseObj))success
                   failure:(void (^__nullable)(NSError *error))failure;

/**
 文件下载

 @param url 地址
 @param file 文件保存地址
 @param tag 请求标记
 @param retry 重试次数
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)downLoadFlieWithUrl:(NSURL *)url
                       flie:(NSString *)file
                        tag:(NSString *__nullable)tag
                      retry:(NSInteger)retry
                   progress:(void (^__nullable)(NSProgress *progress))progress
                    success:(void (^__nullable)(id responseObj))success
                    failure:(void (^__nullable)(NSError *error))failure;

//获取请求队列
+ (NSDictionary *)getRequestQueue;

//取消所有网络请求
+ (void)cancelAllOperations;

//取消某个网络请求
+ (void)cancelOperationsWithTag:(NSString *__nullable)tag;

@end

NS_ASSUME_NONNULL_END
