//
//  NSString+SHExtension.m
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "NSString+SHExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CallKit/CallKit.h>

@implementation NSString (Extension)

#define D_MINUTE    60
#define D_HOUR      3600
#define D_DAY       86400
#define D_WEEK      604800
#define D_MONTH     2592000
#define D_YEAR      31556926

#define TIME_Formatter @"yyyy-MM-dd HH:mm:ss"

#pragma mark - 属性
#pragma mark 获取拼音
- (NSString *)pinyin{

    if (!self.length) {
        
        return self;
    }
    
    //系统
    NSMutableString *pinyin = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)pinyin, NULL, kCFStringTransformToLatin, false);
    NSString *str = [[pinyin stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]] lowercaseString];
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (void)setPinyin:(NSString *)pinyin{

}

#pragma mark 获取MD5加密
- (NSString *)md5{
    
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (NSInteger i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x", result[i]];
    }
    
    return ret;
}

- (void)setMd5:(NSString *)md5{
    
}

#pragma mark 获取文件名字
- (NSString *)fileName{
    if (!self.length) {
        return self;
    }
    
    return [[self.lastPathComponent componentsSeparatedByString:@"."] firstObject];
}

- (void)setFileName:(NSString *)fileName{
    
}

#pragma mark 获取字符串长度(中文：2 其他：1）
- (NSInteger)textLenght{
    
    //判断长度
    NSInteger asciiLength = 0;
    
    for (NSUInteger i = 0; i < self.length; i++) {
        
        unichar uc = [self characterAtIndex: i];
        
        asciiLength += isascii(uc) ? 1 : 2;
    }
    return asciiLength;
}

- (void)setTextLenght:(NSInteger)textLenght{

}

#pragma mark 是否为邮箱
- (BOOL)isEmail{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

- (void)setIsEmail:(BOOL)isEmail{
    
}

#pragma mark 是否包含特殊字符
- (BOOL)isSpecial{
    
    NSString *str = [[[NSMutableString alloc]initWithString:self] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (str.length) {
        //判断是否包含特殊字符
        NSRange urgentRange = [self rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$€"]];
        
        return (urgentRange.location != NSNotFound);
    }else{
        return YES;
    }
}

- (void)setIsSpecial:(BOOL)isSpecial{
    
}

#pragma mark 是否首字母开头
- (BOOL)isFirstLetter{
    
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    return [regextestA evaluateWithObject:[self substringToIndex:1]];
}

- (void)setIsFirstLetter:(BOOL)isFirstLetter{
    
}

#pragma mark - 获取日期（毫秒）
- (NSString *)date{
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:[self longLongValue]/1000.0];
    NSDateFormatter *dateformat = [[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:TIME_Formatter];
    
    return [dateformat stringFromDate:date];
}

- (void)setDate:(NSString *)date{
    
}

#pragma mark 国际化内容
- (NSString *)localizable{
    
    NSString *language = kSHUserDefGet(kAppLanguage);
    
    NSString *str = @"";
    
    if (language.length){//APP如果有设置
        
        if ([language hasPrefix:@"es"]){//西班牙
            
            str = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"es" ofType:@"lproj"]] localizedStringForKey:(self) value:@"" table:nil];
        }else if ([language hasPrefix:@"zh"]){//中文
            
            str = [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"zh-Hans" ofType:@"lproj"]] localizedStringForKey:(self) value:@"" table:nil];
        }
    }else{
        
        str = NSLocalizedString(self, nil);
    }
    
    if (str.length) {

        return str;
    }else{
        
        return self;
    }
}

- (void)setLocalizable:(NSString *)localizable{
    
}

#pragma mark base64编码
- (NSString *)base64{
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (void)setBase64:(NSString *)base64{
    
}

#pragma mark base64解码
- (NSString *)decoded64{
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)setDecoded64:(NSString *)decoded64{
    
}

#pragma mark - 方法
#pragma mark 获取系统语言
+ (NSString*)getAppLanguage {
    
    //如果APP有设置用APP
    NSString *language = kSHUserDefGet(kAppLanguage);
    
    if (language.length){
        return language;
    }
    
    //如果APP没有用系统
    NSArray *languages = kSHUserDefGet(@"AppleLanguages");
    language = [languages objectAtIndex:0];
    
    return language;
}

#pragma mark 获取毫秒值
+ (uint64_t)getTimeMS{
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    return [[NSNumber numberWithUnsignedLong:recordTime] unsignedLongLongValue];
}

#pragma mark 格式化电话号码(00 -> +)
- (NSString *)formatPhone{
    if (self.length) {
        if ([self hasPrefix:@"00"]) {
            return [NSString stringWithFormat:@"+%@",[self substringFromIndex:2]];
        }
    }
    return self;
}

- (void)setFormatPhone:(NSString *)formatPhone{
    
}

@end

