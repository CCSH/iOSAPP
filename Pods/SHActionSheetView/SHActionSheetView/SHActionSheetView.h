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
//标题头(NSString, NSAttributedString)
@property (nonatomic, copy) id title;
//取消按钮(NSString, NSAttributedString)
@property (nonatomic, copy) id cancel;
//特殊按钮(NSString, NSAttributedString)
@property (nonatomic, copy) NSArray *specialArr;
//其他按钮(NSString, NSAttributedString)
@property (nonatomic, copy) NSArray *messageArr;

@end

typedef enum : NSUInteger {
    SHActionSheetStyle_custom, //自定义
    SHActionSheetStyle_system, //系统
} SHActionSheetStyle;

/**
 列表弹框
 */
@interface SHActionSheetView : UIView

//参数
@property (nonatomic, strong) SHActionSheetModel *model;
//回调
@property (nonatomic, copy) SHSelectBlock block;
//风格
@property (nonatomic, assign) SHActionSheetStyle style;
//点击背景消失
@property (nonatomic, assign) BOOL isClickDisappear;

//最多内容个数 默认8
@property (nonatomic, assign) NSInteger maxNum;

// 定制样式配置
//头部高度 默认 50
@property (nonatomic, assign) CGFloat headH;
//内容高度 默认 50
@property (nonatomic, assign) CGFloat contentH;
//取消上方分割高度 默认 3
@property (nonatomic, assign) CGFloat separatorH;

//标题字体 默认 16
@property (nonatomic, strong) UIFont *titleFont;
//内容字体 默认 16
@property (nonatomic, strong) UIFont *contentFont;
//取消字体 默认 18 中粗体
@property (nonatomic, strong) UIFont *cancelFont;

//蒙版颜色 默认 [[UIColor blackColor] colorWithAlphaComponent:0.3]
@property (nonatomic, strong) UIColor *maskColor;
//列表颜色 默认 whiteColor
@property (nonatomic, strong) UIColor *listColor;
//头部字体颜色 默认 blackColor
@property (nonatomic, strong) UIColor *headTextColor;
//特殊字体颜色 默认 redColor
@property (nonatomic, strong) UIColor *specialTextColor;
//内容字体颜色 默认 grayColor
@property (nonatomic, strong) UIColor *contentTextColor;
//分割线颜色 默认 [UIColor colorWithWhite:0.7 alpha:1]
@property (nonatomic, strong) UIColor *separatorColor;
//取消分割线颜色 默认 clearColor
@property (nonatomic, strong) UIColor *cancelSeparatorColor;
//取消字体颜色 默认 lightGrayColor
@property (nonatomic, strong) UIColor *cancelTextColor;

/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)dismiss;

@end


