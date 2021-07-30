//
//  SHSQLite.h
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IUserModel.h"

@interface SHSQLite : NSObject

#pragma mark - loginTable
#pragma mark 增加、修改
+ (BOOL)addLoginInfoWithModel:(IUserModel *)model;
#pragma mark 获取
+ (IUserModel *)getLoginInfo;
#pragma mark 删除
+ (BOOL)deleteLoginInfo;

@end
