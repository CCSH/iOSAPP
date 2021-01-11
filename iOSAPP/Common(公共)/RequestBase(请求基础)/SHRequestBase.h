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

// 必填
//地址
@property (nonatomic, copy) NSString *url;

// 选填
//进度
@property (nonatomic, copy) void(^progress)(NSProgress *progress);
//成功
@property (nonatomic, copy) void (^success)(id responseObj);
//失败
@property (nonatomic, copy) void (^failure)(NSError *error);

//公共参数
//参数
@property (nonatomic, copy) id param;
//请求头
@property (nonatomic, copy) NSDictionary <NSString *, NSString *> *headers;
//请求标记
@property (nonatomic, copy) NSString *tag;
//重试次数
@property (nonatomic, assign) NSInteger retry;

#pragma mark GET
- (void)requestGet;

#pragma mark POST
- (void)requestPost;

#pragma mark FORM
- (void)requestFormWithFormParam:(id)formParam;

#pragma mark 文件上传(单个)
- (void)requestUploadFileWithName:(NSString *_Nullable)name
                             data:(NSData *)data;

#pragma mark 文件上传(多个 一次)
- (void)requestUploadFilesWithName:(NSString *_Nullable)name
                             datas:(NSArray< NSData * > *)datas;

#pragma mark 文件上传(多个 多次)
- (void)requestUploadFilesManyWithName:(NSString *_Nullable)name
                                 datas:(NSArray< NSData * > *)datas;

#pragma mark 文件下载
- (void)requestDownLoadFlieWithFlie:(NSString *)file;

#pragma mark 获取请求队列
- (NSDictionary *)getRequestQueue;

#pragma mark 取消所有网络请求
- (void)cancelAllOperations;

#pragma mark 取消某个网络请求
- (void)cancelOperationsWithTag:(NSString *)tag;

@end

NS_ASSUME_NONNULL_END
