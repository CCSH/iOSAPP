//
//  MacroHeader.h
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#ifndef MacroHeader_h
#define MacroHeader_h

//宏定义

//设备物理WH
#define kSHWidth ([UIScreen mainScreen].bounds.size.width)
#define kSHHeight ([UIScreen mainScreen].bounds.size.height)
//界面宽高
#define kSHViewWidth (self.view.frame.size.width)
#define kSHViewHeight (self.view.frame.size.height)
//状态栏H
#define kStatusBarH (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
//状态栏 + 导航栏
#define kNavAndStatusH (kStatusBarH + kNavBarH)
//全面屏判断
#define kIsFullScreen (kSafeBottomH > 0)
//导航栏H
#define kNavBarH (44.0)
//底部安全H
#define kSafeBottomH ([SHToolHelper getSafeBottomH])
//顶部安全H
#define kSafeTopH ([SHToolHelper getSafeTopH])
//tabbarH
#define kTabBarH (30.0)
//Tabbar安全H
#define kTabBarSafeH (kTabBarH + kSafeBottomH)
//无导航栏内容H
#define kContentAreaH (kSHHeight - kStatusBarH)
//无导航栏内容安全H
#define kContentSafeAreaH (kContentAreaH - kSafeBottomH)
//有导航栏内容H
#define kNavContentAreaH (kSHHeight - kNavAndStatusH)
//有导航栏内容安全H
#define kNavContentSafeAreaH (kNavContentAreaH - kSafeBottomH)

//适配X、Y轴
#define kAdapter_X(V) (V*kSHWidth/375.00)
#define kAdapter_Y(V) (V*kSHHeight/812.00)

//空插画高度
#define kEmptyH (260)
//默认间距
#define kSpaceW (15)
//组头部高度
#define kHeadH (40)

//字体
#define kFont(A) [UIFont systemFontOfSize:A]
#define kFontBold(A) [UIFont systemFontOfSize:A weight:UIFontWeightBold]
#define kFontMedium(A) [UIFont systemFontOfSize:A weight:UIFontWeightMedium]
#define kFontRegular(A) [UIFont systemFontOfSize:A weight:UIFontWeightRegular]
#define kFontHeavy(A) [UIFont systemFontOfSize:A weight:UIFontWeightHeavy]
#define kFontWidth(A) [UIFont fontWithName:@"Helvetica Neue" size:A]

//是否为V以上系统
#define IOS(V) @available(iOS V, *)

//RGB颜色
#define kRGBA(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define kRGB(R,G,B) kRGBA(R,G,B,1)

//系统delegate
#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

//引用
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

//控制日志输出
#ifdef DEBUG
#   define SHLog(log, ...) printf("%s \nline (%d) \n%s\n", __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:(log), ##__VA_ARGS__] UTF8String])
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
#define kSHDBPath [SHTool getCreateFilePath:[NSString stringWithFormat:@"%@/APPData/DataBase",CachesPatch]]

#pragma mark - NSUserDefaults使用的键值
#define kSHUserDef [NSUserDefaults standardUserDefaults]
#define kSHUserDefGet(KEY) [[NSUserDefaults standardUserDefaults] objectForKey:(KEY)]

#pragma mark UserDefKey
//APP版本
#define kAppVersion @"kAppVersion"

#pragma mark - 通知
#define kNotCenter [NSNotificationCenter defaultCenter]
//退出登录
#define kNotLoginOut @"kNotLoginOut"
//登录成功
#define kNotLoginSuccess @"kNotLoginSuccess"

#pragma mark - 路由
#pragma mark 链接
#define kScheme @"ccsh"

#pragma mark - 颜色
//主题色
#define kColorMain kColorStatus_primary
//背景色、分割线
#define kColor245 kRGB(245, 245, 245)
//状态颜色
#define kColorStatus_primary [UIColor colorWithHexString:@"#409eff"]
#define kColorStatus_success [UIColor colorWithHexString:@"#67c23a"]
#define kColorStatus_warning [UIColor colorWithHexString:@"#e6a23c"]
#define kColorStatus_danger [UIColor colorWithHexString:@"#f56c6c"]
#define kColorStatus_info [UIColor colorWithHexString:@"#909399"]
//文本颜色
#define kColorText_1 [UIColor colorWithHexString:@"#c0c4cc"]
#define kColorText_2 [UIColor colorWithHexString:@"#909399"]
#define kColorText_3 [UIColor colorWithHexString:@"#606266"]
#define kColorText_4 [UIColor colorWithHexString:@"#303133"]
#define kColorText_5 [UIColor colorWithHexString:@"#d8d8d8"]
//线颜色
#define kColorLine_1 [UIColor colorWithHexString:@"#f2f6fc"]
#define kColorLine_2 [UIColor colorWithHexString:@"#ebeef5"]
#define kColorLine_3 [UIColor colorWithHexString:@"#e4e7ed"]
#define kColorLine_4 [UIColor colorWithHexString:@"#dcdfe6"]
//基础颜色
#define kColorBasis_1 [UIColor colorWithHexString:@"#f5f7fa"]
#define kColorBasis_2 [UIColor colorWithHexString:@"#f0f2f5"]
#define kColorBasis_3 [UIColor colorWithHexString:@"#000000"]
//表单颜色
#define kColorTable_1 [UIColor colorWithHexString:@"#f0f9ea"]
#define kColorTable_2 [UIColor colorWithHexString:@"#ecf5ff"]
#define kColorTable_3 [UIColor colorWithHexString:@"#fef0f0"]
#define kColorTable_4 [UIColor colorWithHexString:@"#fdf5e6"]
//边框颜色
#define kColorBorder_1 [UIColor colorWithHexString:@"#a3d0fd"]
#define kColorBorder_2 [UIColor colorWithHexString:@"#fbc4c4"]
#define kColorBorder_3 [UIColor colorWithHexString:@"#c2e7b0"]
#define kColorBorder_4 [UIColor colorWithHexString:@"#d3d4d6"]
#define kColorBorder_5 [UIColor colorWithHexString:@"#f5dab1"]

#endif /* MacroHeader_h */
