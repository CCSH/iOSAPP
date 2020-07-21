//
//  SHFileHelper.h
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  文件操作工具类
 */
@interface SHFileHelper : NSObject

/**
 *  获取文件夹（没有的话创建）
 **/
+ (NSString *)getCreateFilePath:(NSString *)path;

@end
