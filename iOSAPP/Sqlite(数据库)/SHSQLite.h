//
//  SHSQLite.h
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHSQLite : NSObject

//增加、修改
+ (BOOL)addLoginInfoWithModel:(NSDictionary *)model;
//获取
+ (NSDictionary *)getLoginInfoWithUid:(NSString *)uid;
//删除
+ (BOOL)deleteLoginInfoWithUid:(NSString *)uid;

@end
