

//
//  SHServerRequest.m
//  SHNetworkRequest
//
//  Created by CSH on 2019/5/31.
//  Copyright © 2019 CSH. All rights reserved.
//

#import "SHServerRequest.h"
#import "SHRequestBase.h"

@implementation SHServerRequest

#pragma mark - 缓存路径
#pragma mark 可清理的缓存
+ (NSString *)getRequstCacheClean{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *path = [DocumentPatch stringByAppendingPathComponent:@"request_cache_clean"];
    
    if(![fileManager fileExistsAtPath:path]){
        //不存在则创建
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

#pragma mark 不可清理的缓存
+ (NSString *)getRequstCache{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *path = [DocumentPatch stringByAppendingPathComponent:@"request_cache"];
    
    if(![fileManager fileExistsAtPath:path]){
        //不存在则创建
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

#pragma mark 缓存不清理白名单
+ (NSArray *)getCacheList{
    return @[];
}

#pragma mark 缓存大小
+ (CGFloat)getRequstCacheSize{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    CGFloat filesize = 0.0;
    NSString *path = [self getRequstCacheClean];
    if ([fileManager fileExistsAtPath:path]) {
        //获取文件的属性
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = size/1024.0;
    }
    return filesize;
}

#pragma mark 清理缓存
+ (void)cleanRequstCache{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    [fileManager removeItemAtPath:[self getRequstCacheClean] error:nil];
}

#pragma mark - 私有方法
#pragma mark 公共参数
+ (NSMutableDictionary *)getParameter{
    return [NSMutableDictionary dictionaryWithDictionary:@{}];
}

#pragma mark 处理参数
+ (NSMutableDictionary *)handleParameter:(NSDictionary *)dic
{
    NSMutableDictionary *para = [[NSMutableDictionary alloc] initWithDictionary:dic];
    if (!para[@"user_id"]) {
        NSString *uid = [SHToolHelper getUserId];
        if (uid.length) {
            para[@"user_id"] = uid;
        }
    }
    return para;
}

#pragma mark 请求统一
+ (SHRequestBaseModel *)handleModel{
    SHRequestBaseModel *model = [SHRequestBaseModel new];
    model.code = success_code;
    model.msg = @"成功";
    return model;
}

#pragma mark 请求超时
+ (BOOL)requestTimeOut:(NSInteger)code{
    if (code == -1001) {
        return YES;
    }
    return NO;
}

#pragma mark 请求写入沙盒
+ (void)saveSandboxData:(SHRequestBase *)request model:(SHRequestBaseModel *)model{
    
    if (model.code == success_code) {
        NSError *error;
        NSData *data = model.mj_JSONData;
        NSString *path = [self getPath:request];
        [data writeToFile:path options:NSDataWritingAtomic error:&error];
        if (error) {
            SHLog(@"写入失败:%@",request.url);
        }
    }
}

#pragma mark 获取缓存数据
+ (SHRequestBaseModel *)getCacheData:(SHRequestBase *)request{
    
    //没网络 获取缓存中成功的数据
    NSString *path = [self getPath:request];
    NSData *data = [NSData dataWithContentsOfFile:path];
    SHRequestBaseModel *model = [SHRequestBaseModel mj_objectWithKeyValues:data];
    model.msg = @"沙盒";
    if (!model) {
        //使用本地默认数据
        model = [self getDefaultData:request];
        model.msg = @"默认";
    }
    return model;
}

#pragma mark 获取默认数据
+ (SHRequestBaseModel *)getDefaultData:(SHRequestBase *)request{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:[self getCacheName:request] ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:path];
    SHRequestBaseModel *model = [SHRequestBaseModel mj_objectWithKeyValues:data];
    return model;
}

#pragma mark 获取文件路径
+ (NSString *)getPath:(SHRequestBase *)request{
    
    NSString *path = [self getRequstCacheClean];
    for (NSString *url in [self getCacheList]) {
        if ([request.url containsString:url]) {
            path = [self getRequstCache];
            break;
        }
    }
    return [NSString stringWithFormat:@"%@/%@",path,[self getCacheName:request]];
}

#pragma mark 获取文件名
+ (NSString *)getCacheName:(SHRequestBase *)request{
    NSString *name = [NSString stringWithFormat:@"%@%@",request.url,[request.param mj_JSONString]].md5;
    return [NSString stringWithFormat:@"request_%@",name];
}

#pragma mark 处理请求
+ (void)handleDataWithModel:(SHRequestBaseModel *)model
                      error:(NSError *)error
                      block:(RequestBlock)block
{
    if (error)
    {
        if ([self requestTimeOut:error.code])
        {
            //网络请求超时
            [SHToast showWithText:request_error_timeout];
        }else{
            //网络错误
            [SHToast showWithText:request_error];
        }
    }
    else if (model.code != success_code)
    {
        //服务器错误(统一状态码)
        error = [NSError errorWithDomain:error_domain code:500 userInfo:nil];
        if (model.msg.length) {
            //服务器错误
            [SHToast showWithText:model.msg];
        }
    }
    
    if (block)
    {
        block(model, error);
    }
}


#pragma mark - 网络请求
#pragma mark 新闻列表
+ (void)requestNewsListWithPid:(NSString *)pid
                        result:(RequestBlock)result
{
    //网址
    NSString *url = [NSString stringWithFormat:@"%@%@", kHostUrl, kNewsList];

    //数据处理
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (pid)
    {
        param[@"pid"] = pid;
    }
    //处理参数
    param = [self handleParameter:param];
    
    //请求
    SHRequestBase *request = [SHRequestBase new];
    request.url = url;
    request.param = param;
    @weakify(self);
    @weakify(request);
    request.success = ^(id  _Nonnull responseObj) {
        @strongify(self);
        @strongify(request);
        //处理数据
        SHRequestBaseModel *model = [SHRequestBaseModel mj_objectWithKeyValues:responseObj];
        [self handleDataWithModel:model error:nil block:result];
        
        if (!pid) {
            //写入沙盒
            [self saveSandboxData:request model:model];
        }
    };
    request.failure = ^(NSError * _Nonnull error) {
        @strongify(self);
        @strongify(request);
        //用个缓存
        SHRequestBaseModel *model;
        if (!pid) {
            model = [self getCacheData:request];;
        }
        if (model) {
            [self handleDataWithModel:model error:nil block:result];
        }else{
            [self handleDataWithModel:nil error:error block:result];
        }
    };
    [request requestGet];
}

@end
