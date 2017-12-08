//
//  SHNetworkRequest.h
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHNetworkRequest : NSObject


#pragma mark 登录
+ (void)getLoginAppWithName:(NSString *)name password:(NSString *)password result:(void (^)(IServerBaseModel *model,NSError *error))result;

@end
