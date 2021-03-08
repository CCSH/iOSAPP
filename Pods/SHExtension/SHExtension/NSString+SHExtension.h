//
//  NSString+SHExtension.h
//  SHExtension
//
//  Created by CSH on 2018/9/19.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SHExtension)

//获取拼音
@property (nonatomic, copy, readonly) NSString *pinyin;
//获取文件名字
@property (nonatomic, copy, readonly) NSString *fileName;
//获取字符串长度(中文：2 其他：1）
@property (nonatomic, assign, readonly) NSInteger textLength;

//是否为邮箱
@property (nonatomic, assign, readonly) BOOL isEmail;
//是否首字母开头
@property (nonatomic, assign, readonly) BOOL isFirstLetter;
//是否包含系统表情
@property (nonatomic, assign, readonly) BOOL isEmoji;

//获取MD5加密
@property (nonatomic, copy, readonly) NSString *md5;
//64编码
@property (nonatomic, copy, readonly) NSString *base64;
//64解码
@property (nonatomic, copy, readonly) NSString *decoded64;

@end

NS_ASSUME_NONNULL_END
