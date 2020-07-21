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
+ (void)getRequestWithUrl:(NSString *)url
                    param:(id)param
                      tag:(NSString *)tag
                    retry:(NSInteger)retry
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id responseObj))success
                  failure:(void (^)(NSError *error))failure;

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
+ (void)postRequestWithUrl:(NSString *)url
                     param:(id)param
                       tag:(NSString *)tag
                     retry:(NSInteger)retry
                  progress:(void (^)(NSProgress *progress))progress
                   success:(void (^)(id responseObj))success
                   failure:(void (^)(NSError *error))failure;

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
+ (void)formRequestWithUrl:(NSString *)url
                     param:(id)param
                 formParam:(id)formParam
                       tag:(NSString *)tag
                     retry:(NSInteger)retry
                  progress:(void (^)(NSProgress *progress))progress
                   success:(void (^)(id responseObj))success
                   failure:(void (^)(NSError *error))failure;

/**
 POST文件上传

 @param url 地址
 @param param 参数
 @param fileType 文件类型
 @param file 文件绝对路径
 @param tag 请求标记
 @param retry 重试次数
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)uploadFileWithUrl:(NSString *)url
                    param:(id)param
                 fileType:(NSString *)fileType
                     file:(NSString *)file
                      tag:(NSString *)tag
                    retry:(NSInteger)retry
                 progress:(void (^)(NSProgress *progress))progress
                  success:(void (^)(id responseObj))success
                  failure:(void (^)(NSError *error))failure;

/**
 POST文件上传(批量)
 
 @param url 地址
 @param param 参数
 @param fileType 文件类型
 @param files 文件路径集合(文件绝对路径)
 @param tag 请求标记
 @param retry 重试次数
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)uploadFilesWithUrl:(NSString *)url
                     param:(id)param
                  fileType:(NSString *)fileType
                     files:(NSArray<NSString *> *)files
                       tag:(NSString *)tag
                     retry:(NSInteger)retry
                  progress:(void (^)(NSProgress *progress))progress
                   success:(void (^)(id responseObj))success
                   failure:(void (^)(NSError *error))failure;

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
                        tag:(NSString *)tag
                      retry:(NSInteger)retry
                   progress:(void (^)(NSProgress *))progress
                    success:(void (^)(id))success
                    failure:(void (^)(NSError *))failure;

//获取请求队列
+ (NSDictionary *)getRequestQueue;

//取消所有网络请求
+ (void)cancelAllOperations;

//取消某个网络请求
+ (void)cancelOperationsWithTag:(NSString *)tag;

@end

NS_ASSUME_NONNULL_END
