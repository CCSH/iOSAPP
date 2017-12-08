//
//  SHBaseHttp.h
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络基础POST、GET
 */

@interface SHBaseHttp : NSObject

/**
 GET请求

 @param url 网址
 @param param 参数
 @param retryNum 重试次数
 @param timeOut 超时
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)getWithUrl:(NSString *)url param:(id)param retryNum:(NSInteger)retryNum timeOut:(NSInteger)timeOut progress:(void (^)(NSProgress *progress))progress success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 POST请求


 @param url 网址
 @param param 参数
 @param retryNum 重试次数
 @param timeOut 超时
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)postWithUrl:(NSString *)url param:(id)param retryNum:(NSInteger)retryNum timeOut:(NSInteger)timeOut progress:(void (^)(NSProgress *progress))progress success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 POST文件上传
 
 @param url 网址
 @param param 参数
 @param file 文件路径或者data
 @param fileType 文件类型
 @param retryNum 重试次数
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)postUploadFileWithUrl:(NSString *)url param:(id)param file:(id)file fileType:(NSString *)fileType retryNum:(NSInteger)retryNum progress:(void (^)(NSProgress *progress))progress success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 POST码流上传

 @param url 网址
 @param param 码流
 @param retryNum 重试次数
 @param success 成功
 @param failure 失败
 */
+ (void)postDataWithUrl:(NSString *)url param:(NSData *)param retryNum:(NSInteger)retryNum success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

/**
 文件下载

 @param url 网址
 @param file 文件下载路径
 @param retryNum 重试次数
 @param progress 进度
 @param success 成功
 @param failure 失败
 */
+ (void)downLoadFlieWithUrl:(NSString *)url flie:(NSString *)file retryNum:(NSInteger)retryNum progress:(void (^)(NSProgress *progress))progress success:(void (^)(id responseObj))success failure:(void (^)(NSError *error))failure;

//取消所有网络请求
+ (void)cancelAllOperations;

@end
