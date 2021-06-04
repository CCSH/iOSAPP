//
//  SHTool.m
//  SHExtensionExample
//
//  Created by CSH on 2019/8/6.
//  Copyright © 2019 CSH. All rights reserved.
//

#import "SHTool.h"

@implementation SHTool

#pragma mark - 当前时间处理
#pragma mark 获取当前时间戳
+ (NSString *)getTimeMs{
    NSDate *date = [NSDate date];
    UInt64 recordTime = [date timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%llu", recordTime];
}

#pragma mark 获取当前格式时间
+ (NSString *)getTimeWithformat:(NSString *)format{
    return [self getTimeWithformat:format GMT:-1];
}

+ (NSString *)getTimeWithformat:(NSString *)format GMT:(NSInteger)GMT{
    return [self getTimeWithDate:[NSDate date] format:format GMT:GMT];
}

#pragma mark 获取当前时区
+ (NSInteger)getCurrentGMT{
    return [[NSTimeZone localTimeZone] secondsFromGMT];
}

#pragma mark - 时间格式化
#pragma mark 获取指定格式时间
+ (NSString *)getTimeWithTime:(NSString *)time currentFormat:(NSString *)currentFormat format:(NSString *)format{
    if (!time.length) {
        return @"";
    }
    
    NSDate *date = [self getDateWithTime:time format:currentFormat];
    
    return [self getTimeWithDate:date format:format];
}

#pragma mark - 时间处理
#pragma mark 获取时间戳
+ (NSString *)getMsWithTime:(NSString *)time format:(NSString *)format{
    return [self getMsWithTime:time format:format GMT:-1];
}

+ (NSString *)getMsWithTime:(NSString *)time format:(NSString *)format GMT:(NSInteger)GMT{
    if (!time.length) {
        return @"";
    }
    
    NSDate *date = [self getDateWithTime:time format:format GMT:GMT];
    
    return [self getMsWithDate:date];
}

+ (NSString *)getMsWithDate:(NSDate *)date{
    
    UInt64 recordTime = [date timeIntervalSince1970] * 1000;
    
    return [NSString stringWithFormat:@"%llu", recordTime];
}

#pragma mark 获取time
+ (NSString *)getTimeWithMs:(NSString *)ms format:(NSString *)format{
    return [self getTimeWithMs:ms format:format GMT:-1];
}

+ (NSString *)getTimeWithMs:(NSString *)ms format:(NSString *)format GMT:(NSInteger)GMT{
    ms = [self handleMs:ms];
    if (!ms.length) {
        return @"";
    }
    
    NSDate *date = [self getDateWithMs:ms];
    
    return [self getTimeWithDate:date format:format GMT:GMT];
}

+ (NSString *)getTimeWithDate:(NSDate *)date format:(NSString *)format{
    
    return [self getTimeWithDate:date format:format GMT:-1];
}

+ (NSString *)getTimeWithDate:(NSDate *)date format:(NSString *)format GMT:(NSInteger)GMT{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (GMT != -1) {
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:GMT]];
    }
    
    return [formatter stringFromDate:date];
}

#pragma mark 获取date
+ (NSDate *)getDateWithMs:(NSString *)ms{
    ms = [self handleMs:ms];
    if (!ms.length) {
        return nil;
    }
    return [NSDate dateWithTimeIntervalSince1970:[ms longLongValue]/1000];
}

+ (NSDate *)getDateWithTime:(NSString *)time format:(NSString *)format{
    return [self getDateWithTime:time format:format GMT:-1];
}

+ (NSDate *)getDateWithTime:(NSString *)time format:(NSString *)format GMT:(NSInteger)GMT{
    if (!time.length) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    if (GMT != -1) {
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:GMT]];
    }
    
    return [formatter dateFromString:time];
}

#pragma mark 获取即时时间
+ (NSString *)getInstantTimeWithMs:(NSString *)ms{
    ms = [self handleMs:ms];
    if (!ms.length) {
        return @"";
    }
    //转时间
    NSDate *date = [self getDateWithMs:ms];
    
    return [self getInstantTimeWithDate:date];
}

+ (NSString *)getInstantTimeWithDate:(NSDate *)date{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    //当前
    NSDateComponents *currentComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    
    //今天
    NSDateComponents *todayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    //昨天
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1];
    NSDate *yesterday = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:[NSDate date] options:0];
    NSDateComponents *yesterdayComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:yesterday];
    
    if (currentComponents.year == todayComponents.year && currentComponents.month == todayComponents.month && currentComponents.day == todayComponents.day) { //今天
        
        //获取当前时时间戳差
        NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:date];
        
        if (time < 60) { //1分钟内
            
            return @"刚刚";
        } else if (time < 60 * 60) { //1小时内
            
            return [NSString stringWithFormat:@"%.0f分钟前", time / 60];
        } else if (time < 60 * 60 * 24) { //1天内
            
            return [NSString stringWithFormat:@"%.0f小时前", time / 60 / 60];
        }
    } else if (currentComponents.year == yesterdayComponents.year && currentComponents.month == yesterdayComponents.month && currentComponents.day == yesterdayComponents.day) { //昨天
        
        format.dateFormat = sh_fomat_10;
        return [NSString stringWithFormat:@"昨天 %@", [format stringFromDate:date]];
    } else if (currentComponents.year == todayComponents.year) { //今年
        
        format.dateFormat = sh_fomat_9;
        return [format stringFromDate:date];
    }
    
    //其他
    format.dateFormat = sh_fomat_4;
    return [format stringFromDate:date];
}

+ (NSString *)getInstantTimeWithTime:(NSString *)time format:(NSString *)format{
    return [self getInstantTimeWithTime:time format:format GMT:-1];
}

+ (NSString *)getInstantTimeWithTime:(NSString *)time format:(NSString *)format GMT:(NSInteger)GMT{
    NSDate *date = [self getDateWithTime:time format:format GMT:GMT];
    return [self getInstantTimeWithDate:date];
}

#pragma mark - 时间其他方法
#pragma mark 比较两个日期大小
+ (NSInteger)compareStartDate:(NSString *)startDate endDate:(NSString *)endDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:sh_fomat_1];
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] init];
    date1 = [formatter dateFromString:startDate];
    date2 = [formatter dateFromString:endDate];
    NSComparisonResult result = [date1 compare:date2];
    switch (result) {
        case NSOrderedAscending: //date1 < date2
            return -1;
            break;
        case NSOrderedSame: //date1 == date2
            return 0;
            break;
        case NSOrderedDescending: //date1 > date2
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

#pragma mark 处理时间戳
+ (NSString *)handleMs:(NSString *)str{
    if (str.length == 10) {
        return [NSString stringWithFormat:@"%@000", str];
    }
    if (str.length != 13) {
        return @"";
    }
    return str;
}


#pragma mark - 计算方法
#pragma mark 计算富文本的size
+ (CGSize)getSizeWithAtt:(NSAttributedString *)att
                 maxSize:(CGSize)maxSize {
    if (att.length == 0) {
        return CGSizeZero;
    }
    
    CGSize size = [att boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    if (att.length && !size.width && !size.height) {
        size = maxSize;
    }
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

#pragma mark 计算字符串的size
+ (CGSize)getSizeWithStr:(NSString *)str
                    font:(UIFont *)font
                 maxSize:(CGSize)maxSize {
    if (str.length == 0) {
        return CGSizeZero;
    }
    
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : font} context:nil].size;
    if (str.length && !size.width && !size.height) {
        size = maxSize;
    }
    return CGSizeMake(ceil(size.width), ceil(size.height));
}

#pragma mark 是否超过规定高度
+ (BOOL)isLineWithAtt:(NSAttributedString *)att lineH:(CGFloat)lineH maxW:(CGFloat)maxW {
    CGFloat attH = [self getSizeWithAtt:att maxSize:CGSizeMake(maxW, CGFLOAT_MAX)].height;
    
    return (attH > ceil(lineH));
}

#pragma mark 获取真实行间距
+ (CGFloat)lineSpaceWithLine:(CGFloat)line font:(UIFont *)font {
    return line - (font.lineHeight - font.pointSize);
}

#pragma mark 获取属性字符串真实行间距
+ (CGFloat)lineSpaceWithLineWithAtt:(NSAttributedString *)att line:(CGFloat)line font:(UIFont *)font maxW:(CGFloat)maxW {
    if ([self isLineWithAtt:att lineH:font.lineHeight maxW:maxW]) {
        return [self lineSpaceWithLine:line font:font];
    }
    //只有一行行间距为0
    return 0;
}

#pragma mark - 其他方法
#pragma mark 处理个数
+ (NSString *)handleCount:(NSString *)count {
    long num = count.longLongValue;
    if (num >= 1000 && num < 10000) {
        return [NSString stringWithFormat:@"%.1fK", [count doubleValue] / 1000];
    } else if (num >= 10000) {
        return [NSString stringWithFormat:@"%.1fW", [count doubleValue] / 10000];
    }
    return [NSString stringWithFormat:@"%ld",num];
}

#pragma mark 处理金额
+ (NSString *)handleMoneyWithStr:(NSString *)str {

    NSNumber *number = @(str.floatValue);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.positivePrefix = @"";
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    
    return [formatter stringFromNumber:number];
}

#pragma mark 处理价格(小数点后两位)
+ (NSString *)handlePriceWithStr:(NSString *)str {
    return [NSString stringWithFormat:@"%.2f", str.floatValue];
}

#pragma mark 处理视频时间
+ (NSString *)handleVideoTime:(NSString *)time {
    NSTimeInterval interval = time.integerValue;
    
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
    formatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
    
    if (interval / (60 * 60) >= 1) {
        //超过一小时
        formatter.allowedUnits = kCFCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    } else {
        formatter.allowedUnits = NSCalendarUnitMinute | NSCalendarUnitSecond;
    }
    
    NSString *dealTime = [formatter stringFromTimeInterval:interval];
    
    if (dealTime.length == 7 || dealTime.length == 4) {
        //补0
        dealTime = [NSString stringWithFormat:@"0%@", dealTime];
    }
    
    return dealTime;
}

#pragma mark 获取一个渐变色的视图
+ (UIView *)getGradientViewWithSize:(CGSize)size colorArr:(NSArray *)colorArr {
    return [self getGradientViewWithSize:size startPoint:CGPointMake(0.5, 0) endPoint:CGPointMake(0.5, 1) colorArr:colorArr];
}

+ (UIView *)getGradientViewWithSize:(CGSize)size startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colorArr:(NSArray *)colorArr {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, size.width, size.height);
    //  CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = colorArr;
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    
    // 设置渐变位置
    CGFloat loc = 1.0 / (colorArr.count - 1);
    NSMutableArray *location = [[NSMutableArray alloc] init];
    [location addObject:@0];
    NSInteger index = 1;
    
    while (index != colorArr.count) {
        [location addObject:[NSNumber numberWithFloat:index * loc]];
        index++;
    }
    
    //设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = location;
    
    [view.layer addSublayer:gradientLayer];
    
    return view;
}

#pragma mark 格式化TextField字符串
+ (void)handleTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string rule:(NSArray *)rule {
    NSString *text = textField.text;
    
    if (string.length == 0) {
        //删除空格则多删除一位
        NSString *temp = [text substringWithRange:range];
        if ([temp isEqualToString:@" "]) {
            range = NSMakeRange(range.location - 1, range.length + 1);
        }
    }
    
    //去除空格
    NSString *str = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    text = [text stringByReplacingCharactersInRange:range withString:str];
    
    NSInteger count = [SHTool appearCountWithStr:[text substringWithRange:NSMakeRange(0, range.location)] target:@" "];
    
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    textField.text = [self handleStrWithText:text rule:rule];
    
    //记录光标位置
    if (string.length) {
        if ((textField.text.length >= range.location + str.length)) {
            NSString *temp = [textField.text substringWithRange:NSMakeRange(0, range.location + str.length)];
            
            count = [self appearCountWithStr:temp target:@" "] - count;
            range = NSMakeRange(range.location + count, 0);
        }
        
        range = NSMakeRange(range.location + str.length, 0);
    }
    
    //保护删除最后一位
    if (range.location > textField.text.length) {
        range = NSMakeRange(textField.text.length, 0);
    }
    
    //设置光标位置
    UITextPosition *position = [textField positionFromPosition:textField.beginningOfDocument offset:range.location];
    UITextRange *textRange = [textField textRangeFromPosition:position toPosition:position];
    
    textField.selectedTextRange = textRange;
}

#pragma mark 格式化字符串
+ (NSString *)handleStrWithText:(NSString *)text rule:(NSArray *)rule {
    __block NSString *tempStr = @"";
    __block NSInteger tempIndex = 0;
    
    [rule enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *_Nonnull stop) {
        NSRange range = NSMakeRange(tempIndex, obj.intValue);
        tempIndex = range.location + range.length;
        NSInteger start = tempIndex - obj.intValue;
        
        if (text.length <= tempIndex) {
            //拼接剩余
            tempStr = [tempStr stringByAppendingString:[text substringWithRange:NSMakeRange(start, text.length - start)]];
            *stop = YES;
        } else {
            //插入字符
            NSString *temp = [text substringWithRange:range];
            temp = [temp stringByAppendingString:@" "];
            tempStr = [tempStr stringByAppendingString:temp];
            
            if (idx == rule.count - 1) { //最后一位
                start = tempIndex;
                //拼接剩余
                tempStr = [tempStr stringByAppendingString:[text substringWithRange:NSMakeRange(start, text.length - start)]];
            }
        }
    }];
    
    return tempStr;
}

#pragma mark 获取某个字符在字符串中出现的次数
+ (NSInteger)appearCountWithStr:(NSString *)str target:(NSString *)target {
    NSArray *temp = [str componentsSeparatedByString:target];
    
    return temp.count - 1;
}

#pragma mark 获取最上方控制器
+ (UIViewController *)getCurrentVC {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *rootVC = window.rootViewController;
    UIViewController *activeVC = nil;
    
    while (true) {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            activeVC = [(UINavigationController *)rootVC visibleViewController];
        } else if ([rootVC isKindOfClass:[UITabBarController class]]) {
            activeVC = [(UITabBarController *)rootVC selectedViewController];
        } else if (rootVC.presentedViewController) {
            activeVC = rootVC.presentedViewController;
        } else if (rootVC.childViewControllers.count > 0) {
            activeVC = [rootVC.childViewControllers lastObject];
        } else {
            break;
        }
        rootVC = activeVC;
    }
    return activeVC;
}

#pragma mark 获取url的参数
+ (NSDictionary *)getUrlParam:(NSString *)str{
    //获取参数
    NSMutableDictionary *param = [NSMutableDictionary new];
    NSArray *query = [str componentsSeparatedByString:@"&"];
    for (NSString *obj in query) {
        NSArray *temp = [obj componentsSeparatedByString:@"="];
        [param setValue:temp[1] forKey:temp[0]];
    }
    return param;
}

@end
