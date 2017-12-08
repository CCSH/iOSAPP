//
//  SHNetworkRequest.m
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHNetworkRequest.h"
#import "SHBaseHttp.h"

@implementation SHNetworkRequest

#pragma mark - 登录
+ (void)getLoginAppWithName:(NSString *)name password:(NSString *)password result:(void (^)(IServerBaseModel *model,NSError *error))result{
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",@"https://www.baidu.com",@"login"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:name forKey:@"name"];
    [dic setObject:password forKey:@"password"];
    
    [SHBaseHttp getWithUrl:url param:dic retryNum:0 timeOut:0 progress:nil success:^(id responseObj) {

        IServerBaseModel *model = [[IServerBaseModel alloc]init];
        
        NSLog(@"详单查询接口 --- %@",model.result);
        if (result) {
            result(model,nil);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"详单查询接口 --- %@",[error description]);
        if (result) {
            result(nil,error);
        }
    }];
}

@end
