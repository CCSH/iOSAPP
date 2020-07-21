//
//  SHFileHelper.m
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SHFileHelper.h"

@implementation SHFileHelper

/**
 *  获取文件夹（没有的话创建）
 **/
+ (NSString *)getCreateFilePath:(NSString *)path {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}


@end
