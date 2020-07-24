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
#define StatusBarH (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
//导航栏H
#define NavBarH 44.0
//状态栏 + 导航栏
#define NavAndStatusH (StatusBarH + NavBarH)
//全面屏判断
#define IsFullScreen (StatusBarH != 20)
//底部安全H
#define SafeBottomH (IsFullScreen ? 34 : 0)
//tabbarH
#define TabBarH (49.0)
//Tabbar安全H
#define TabBarSafeH (TabBarH + SafeBottomH)
//内容安全H
#define ContentAreaH (kSHHeight - NavAndStatusH)
#define ContentSafeAreaH (ContentAreaH - SafeBottomH)

//界面宽高
#define kSHViewWidth (self.view.frame.size.width)
#define kSHViewHeight (self.view.frame.size.height)

//是否为V以上系统
#define IOS(V) [[[UIDevice currentDevice] systemVersion] floatValue] >= V

//RGB颜色
#define kRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//系统delegate
#define SHAppDelegate (AppDelegate *)[UIApplication sharedApplication].delegate

//描边
#define kSHViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setCornerRadius:(Radius)];\
[View.layer setBorderColor:[Color CGColor]]

//清除模型中的所有数据
#define kSHClearModelData(Model) \
\
Model *_model##Model = [[Model alloc] init];\
u_int count##Model;\
objc_property_t *properties##Model = class_copyPropertyList([Model class], &count##Model);\
for (int i = 0; i< count##Model; i++){\
[_model##Model setValue:nil forKey:[NSString stringWithFormat:@"%s",property_getName(properties##Model[i])]];\
}\
free(properties##Model);\

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

