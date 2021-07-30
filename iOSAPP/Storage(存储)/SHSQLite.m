//
//  SHSQLite.m
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHSQLite.h"

@implementation SHSQLite

//Sql语句
static NSString *const update_sql = @"UPDATE %@ SET ";
static NSString *const insert_sql = @"INSERT INTO %@ ";
static NSString *const select_sql = @"SELECT * FROM %@ WHERE ";
static NSString *const delete_sql = @"DELETE FROM %@ WHERE ";
static NSString *const create_table = @"CREATE TABLE IF NOT EXISTS `%@` (id INTEGER PRIMARY KEY, %@)";

//数据库表
//登录信息表
static NSString *const loginTable = @"login";
static NSString *const loginTable_info = @"info";

#pragma mark - 实例化

+ (void)initialize
{
    if (self == [self class]) {
        
        FMDatabaseQueue *queue = [self writeQueue];
        //表集合
        NSDictionary *table = @{loginTable : [NSString stringWithFormat:@"%@",[self getText:loginTable_info]]};
        
        [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            [table enumerateKeysAndObjectsUsingBlock:^(NSString *table, NSString *key, BOOL *_Nonnull stop) {
                //sql语句创建表
                NSString *sql = [NSString stringWithFormat:create_table, table, key];
                SHLog(@"数据库表创建：%@ %i", table, [db executeUpdate:sql]);
            }];
        }];
    }
}

#pragma mark 写入队列
+ (FMDatabaseQueue *)writeQueue
{
    static FMDatabaseQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *path = [NSString stringWithFormat:@"%@/iOSAPP_db.db", kSHDBPath];
        //获取本地的数据库文件，没有则创建
        queue = [FMDatabaseQueue databaseQueueWithPath:path];
    });
    
    return queue;
}

#pragma mark 读取队列
+ (FMDatabaseQueue *)readQueue
{
    static FMDatabaseQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *path = [NSString stringWithFormat:@"%@/iOSAPP_db.db", kSHDBPath];
        //获取本地的数据库文件，没有则创建
        queue = [FMDatabaseQueue databaseQueueWithPath:path];
    });
    
    return queue;
}

#pragma mark - loginTable
#pragma mark 增加、修改
+ (BOOL)addLoginInfoWithModel:(IUserModel *)model
{
    __block BOOL result;
    //删除之前的
    [self deleteLoginInfo];
    [[self writeQueue] inDatabase:^(FMDatabase *_Nonnull db) {

        //添加
        NSString *sql = [NSString stringWithFormat:insert_sql, loginTable];
        sql = [NSString stringWithFormat:@"%@ (%@) VALUES (?);",sql, loginTable_info];
        result = [db executeUpdate:sql, model.mj_JSONString];
    }];
    
    return result;
}

#pragma mark 获取
+ (IUserModel *)getLoginInfo
{
    __block IUserModel *model = [[IUserModel alloc]init];
    
    [[self readQueue] inDatabase:^(FMDatabase *_Nonnull db) {
        
        NSString *sql = [NSString stringWithFormat:select_sql, loginTable];
        sql = [NSString stringWithFormat:@"%@ 1=1", sql];
        FMResultSet *set = [db executeQuery:sql];
        if ([set next])
        {
            model = [IUserModel mj_objectWithKeyValues:[set stringForColumn:loginTable_info]];
        }
        [set close];
    }];
    
    return model;
}

#pragma mark 删除
+ (BOOL)deleteLoginInfo
{
    __block BOOL result;
    [[self writeQueue] inDatabase:^(FMDatabase *_Nonnull db) {
        NSString *sql = [NSString stringWithFormat:delete_sql, loginTable];
        sql = [NSString stringWithFormat:@"%@ 1=1", sql];
        result = [db executeUpdate:sql];
    }];
    
    return result;
}

#pragma mark - 获取key属性
+ (NSString *)getText:(NSString *)key{
    return [NSString stringWithFormat:@"%@ text",key];
}

@end
