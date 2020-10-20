

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

    return para;
}

#pragma mark - 处理请求
+ (void)handleDataWithModel:(SHRequestBaseModel *)model error:(NSError *)error block:(RequestBlock)block
{
    if (error)
    {
        //网络错误
        [SHToast showWithText:request_error];
        if (error.code == -1001)
        {
            //网络请求超时
        }
    }
    else if (![model.result isEqualToString:success_code])
    {
        //服务器错误
        error = [NSError errorWithDomain:error_domain code:0 userInfo:nil];
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
    [SHRequestBase postWithUrl:url
        param:param
        tag:@"1"
        retry:0
        progress:nil
        success:^(id responseObj) {
          //处理数据
          SHRequestBaseModel *model = [SHRequestBaseModel yy_modelWithJSON:responseObj];
          [self handleDataWithModel:model error:nil block:result];
        }
        failure:^(NSError *error) {
          //处理数据
          [self handleDataWithModel:nil error:error block:result];
        }];
}

@end
