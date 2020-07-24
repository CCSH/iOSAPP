//
//  SHActionSheetView.h
//  iOSAPP
//
//  Created by CSH on 16/8/16.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHActionSheetView;

//回调
typedef void (^SHSelectBlock)(SHActionSheetView *sheetView, NSInteger buttonIndex);


/**
 Model
 */
@interface SHActionSheetModel : NSObject
//标题头
@property (nonatomic, copy) NSString *title;
//取消按钮 默认 取消
@property (nonatomic, copy) NSString *cancel;
//特殊按钮
@property (nonatomic, copy) NSArray *specialArr;
//其他按钮
@property (nonatomic, copy) NSArray *messageArr;



@end

typedef enum : NSUInteger {
    SHActionSheetStyle_custom, //默认
    SHActionSheetStyle_system, //系统
} SHActionSheetStyle;

#define kRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

/**
 列表弹框
 */
@interface SHActionSheetView : UIView

//参数
@property (nonatomic, strong) SHActionSheetModel *model;
//回调
@property (nonatomic, copy) SHSelectBlock block;

//最多内容个数 默认8
@property (nonatomic, assign) NSInteger maxNum;
//风格
@property (nonatomic, assign) SHActionSheetStyle style;

//定制样式配置
//内容高度 默认 57
@property (nonatomic, assign) CGFloat contentH;
//头部高度 默认 57
@property (nonatomic, assign) CGFloat headH;
//取消上方分割高度 默认 10
@property (nonatomic, assign) CGFloat separatorH;

//标题字体 默认 13
@property (nonatomic, strong) UIFont *titleFont;
//内容字体 默认 18
@property (nonatomic, strong) UIFont *contentFont;
//取消字体 默认 18 中粗体
@property (nonatomic, strong) UIFont *cancelFont;

//蒙版颜色 默认 [UIColor colorWithWhite:0 alpha:0.4]
@property (nonatomic, strong) UIColor *maskColor;
//列表颜色 默认
@property (nonatomic, strong) UIColor *listColor;
//头部字体颜色 默认 blackColor
@property (nonatomic, strong) UIColor *headTextColor;
//特殊按钮字体颜色 默认 redColor
@property (nonatomic, strong) UIColor *specialTextColor;
//内容按钮字体颜色 默认 kRGB(54, 90, 247, 1)
@property (nonatomic, strong) UIColor *contentTextColor;
//分割线颜色 默认 lightGrayColor
@property (nonatomic, strong) UIColor *separatorColor;
//取消分割线颜色 默认 clearColor
@property (nonatomic, strong) UIColor *cancelSeparatorColor;

/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)dismiss;

@end


