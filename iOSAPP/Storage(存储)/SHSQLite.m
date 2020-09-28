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
static NSString *const UPDATE_SQL = @"UPDATE %@ SET ";
static NSString *const INSERT_SQL = @"INSERT INTO %@ ";
static NSString *const SELECT_SQL = @"SELECT * FROM %@ WHERE ";
static NSString *const DELETE_SQL = @"DELETE FROM %@ WHERE ";

//数据库表
static NSString *const loginInfo = @"login_info";
static NSString *const loginInfoKey = @"user_id TEXT,user_info TEXT";

#pragma mark - 实例化
+ (FMDatabaseQueue *)shareQueue
{
    static FMDatabaseQueue *queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

      NSString *path = [NSString stringWithFormat:@"%@/iOSAPP_db.db", kSHDBPath];
      //获取本地的数据库文件，没有则创建
      queue = [FMDatabaseQueue databaseQueueWithPath:path];

      //表集合
      NSDictionary *table = @{loginInfo : loginInfoKey};

      [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {

        [table enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *_Nonnull stop) {
          //sql语句创建表
          NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(id INTEGER PRIMARY KEY,%@)", key, obj];
          [db executeUpdate:sql];
        }];
      }];
    });

    return queue;
}

//增加、修改
+ (BOOL)addLoginInfoWithModel:(NSDictionary *)model
{
    __block BOOL result;
    [[self shareQueue] inDatabase:^(FMDatabase *_Nonnull db) {

      NSString *sql = [NSString stringWithFormat:SELECT_SQL, loginInfo];
      sql = [NSString stringWithFormat:@"%@ user_id = ?;", sql];
      FMResultSet *set = [db executeQuery:sql, model[@"user_id"]];

      if (![set next])
      {
          //增加操作
          sql = [NSString stringWithFormat:INSERT_SQL, loginInfo];
          sql = [NSString stringWithFormat:@"%@ (user_id, user_info) VALUES (?, ?);", sql];
          result = [db executeUpdate:sql, model[@"user_id"], model[@"user_info"]];
      }
      else
      {
          //修改操作
          sql = [NSString stringWithFormat:UPDATE_SQL, loginInfo];
          sql = [NSString stringWithFormat:@"%@ user_info = ? WHERE user_id = ?;", sql];
          result = [db executeUpdate:sql, model[@"user_info"], model[@"user_id"]];
      }
      [set close];
    }];

    return result;
}

//获取
+ (NSDictionary *)getLoginInfoWithUid:(NSString *)uid
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];

    [[self shareQueue] inDatabase:^(FMDatabase *_Nonnull db) {

      NSString *sql = [NSString stringWithFormat:SELECT_SQL, loginInfo];
      sql = [NSString stringWithFormat:@"%@ user_id = ?;", sql];

      FMResultSet *set = [db executeQuery:sql, uid];
      if ([set next])
      {
          dic[@"user_id"] = [set stringForColumn:@"user_id"];
          dic[@"user_info"] = [set stringForColumn:@"user_info"];
      }
      [set close];
    }];

    return dic;
}

//删除
+ (BOOL)deleteLoginInfoWithUid:(NSString *)uid
{
    __block BOOL result;
    [[self shareQueue] inDatabase:^(FMDatabase *_Nonnull db) {
      NSString *sql = [NSString stringWithFormat:DELETE_SQL, loginInfo];
      sql = [NSString stringWithFormat:@"%@ user_id = ?;", sql];
      result = [db executeUpdate:sql, uid];
    }];

    return result;
}

@end
