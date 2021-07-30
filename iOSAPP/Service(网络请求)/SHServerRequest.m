

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

#pragma mark - 处理参数
+ (NSMutableDictionary *)handleParameterWithDic:(NSDictionary *)dic
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

#pragma mark - 处理请求
+ (void)handleDataWithModel:(SHRequestBaseModel *)model error:(NSError *)error block:(RequestBlock)block
{
    if (error)
    {
        //网络错误
        [SHToast showWithText:request_error];
        if (error.code == time_out_code)
        {
            //网络请求超时
            [SHToast showWithText:@"请求超时"];
        }
    }
    else if (model.code != success_code)
    {
        //服务器错误
        error = [NSError errorWithDomain:error_domain code:model.code userInfo:nil];
        if (model.msg.length) {
            [SHToast showWithText:model.msg];
        }
    }

    if (block)
    {
        block(model, error);
    }
}

#pragma mark - 网络请求
+ (void)requestLoginWithMobile:(NSString *)mobile
                      password:(NSString *)password
                        result:(RequestBlock)result
{
    //网址
    NSString *url = [NSString stringWithFormat:@"%@%@", kHostUrl, kLogin];

    //数据处理
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (mobile)
    {
        param[@"mobile"] = mobile;
    }
    if (password)
    {
        param[@"password"] = password;
    }
    //处理参数
    param = [self handleParameterWithDic:param];
    
    //请求
    SHRequestBase *request = [SHRequestBase new];
    request.url = url;
    request.param = param;
    @weakify(self);
    request.success = ^(id  _Nonnull responseObj) {
        //处理数据
        SHRequestBaseModel *model = [SHRequestBaseModel mj_objectWithKeyValues:responseObj];
        [weak_self handleDataWithModel:model error:nil block:result];
    };
    request.failure = ^(NSError * _Nonnull error) {
        //处理数据
        [weak_self handleDataWithModel:nil error:error block:result];
    };
    [request requestGet];
}

@end
