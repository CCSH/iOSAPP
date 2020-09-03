//
//  MacroHeader.h
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#ifndef MacroHeader_h
#define MacroHeader_h


#endif /* MacroHeader_h */
//宏定义

//设备物理WH
#define kSHWidth ([UIScreen mainScreen].bounds.size.width)
#define kSHHeight ([UIScreen mainScreen].bounds.size.height)
//状态栏H
#define kStatusBarH (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
//导航栏H
#define kNavBarH 44.0
//状态栏 + 导航栏
#define kNavAndStatusH (kStatusBarH + kNavBarH)
//全面屏判断
#define kIsFullScreen (kStatusBarH != 20)
//底部安全H
#define kSafeBottomH (kIsFullScreen ? 34 : 0)
//tabbarH
#define kTabBarH (49.0)
//Tabbar安全H
#define kTabBarSafeH (kTabBarH + kSafeBottomH)
//内容安全H
#define kContentAreaH (kkSHHeight - kNavAndStatusH)
#define kContentSafeAreaH (kContentAreaH - kSafeBottomH)

//界面宽高
#define kSHViewWidth (self.view.frame.size.width)
#define kSHViewHeight (self.view.frame.size.height)

//字体
#define kFont(A) [UIFont systemFontOfSize:A]

//是否为V以上系统
#define IOS(V) [[[UIDevice currentDevice] systemVersion] floatValue] >= V

//RGB颜色
#define kRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//系统delegate
#define kSHAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

//引用
#define weakify(obj) @autoreleasepool{} __weak typeof(obj) weak_##obj = obj;
#define strongify(obj) @autoreleasepool{} __strong typeof(obj) strong_##obj = weak_##obj;

//描边
#define kSHViewStroke(V, R, W, C)\
\
[V.layer setMasksToBounds:YES];\
[V.layer setBorderWidth:(W)];\
[V.layer setCornerRadius:(R)];\
[V.layer setBorderColor:[C CGColor]];

//控制日志输出
#ifdef DEBUG
#   define SHLog(log, ...) NSLog((@"\n%s\n[Line %d]\n"  log), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define SHLog(...)
#endif

//计算耗时
#define TICK        CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define TOCKFor(A)  SHLog(@"耗时计算-%@: %f",(A),CFAbsoluteTimeGetCurrent() - start);
#define TOCK        SHLog(@"耗时计算: %f",CFAbsoluteTimeGetCurrent() - start);

#pragma mark - 文件路径
//Document目录
#define DocumentPatch [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

//Caches目录
#define CachesPatch NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

//Temp目录
#define TempPatch NSTemporaryDirectory()

//数据库路径
#define kSHDBPath [SHFileHelper getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/DataBase",CachesPatch]]

#pragma mark - NSUserDefaults使用的键值

#define kSHUserDef [NSUserDefaults standardUserDefaults]
#define kSHUserDefGet(KEY) [[NSUserDefaults standardUserDefaults] objectForKey:(KEY)]

#pragma mark UserDefKey
//APP版本
#define kAppVersion         @"app_version"

#pragma mark 通知
//刷新界面
#define kNotReload @"not-reload"

