//
//  SHSQLite.m
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHSQLite.h"

@implementation SHSQLite

#pragma mark - 实例化
+ (FMDatabaseQueue *)shareQueue{
    
    static FMDatabaseQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //获取本地的数据库文件，没有则创建
        queue = [FMDatabaseQueue databaseQueueWithPath:[NSString stringWithFormat:@"%@/iOSAPP_db.db",kSHDBPath]];
        
        [queue inTransaction:^(FMDatabase *db,BOOL *rollback) {
            
            
        }];
    });

    //使用
//    [[self shareQueue] inTransaction:^(FMDatabase *db,BOOL *rollback) {
//
//    }];
    return queue;
}


@end
