//
//  SHToast.h
//  SHToast
//
//  Created by CSH on 2017/8/16.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SHToast : UIView

#pragma mark - Toast (text 可以是 NSString、NSAttributedString)
//中间位置显示
+ (void)showWithText:(id)text;
+ (void)showWithText:(id)text duration:(CGFloat)duration;

//自定义位置显示
+ (void)showWithText:(id)text offset:(CGFloat)offset;
+ (void)showWithText:(id)text offset:(CGFloat)offset duration:(CGFloat)duration;

#pragma mark - Push (title、content 可以是 NSString、NSAttributedString)
+ (void)showPushWithContent:(id)content title:(id)title image:(UIImage *)image block:(void(^)(void))block;
+ (void)showPushWithContent:(id)content title:(id)title image:(UIImage *)image duration:(CGFloat)duration block:(void(^) (void))block;

@end

// toast样式
@interface SHToastStyle : NSObject

//弹框内部间隔(默认 上左下右 10)
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
//弹框整体间隔(默认 10)
@property (nonatomic, assign) CGFloat margin;
//默认显示时间(默认 2)
@property (nonatomic, assign) CGFloat time;
//背景颜色(默认 黑色 0.7)
@property (nonatomic, strong) UIColor *color;
//字体颜色(默认 白色)
@property (nonatomic, strong) UIColor *textColor;
//字体大小(默认 14)
@property (nonatomic, strong) UIFont *font;
//圆角(默认 5 针对toast形式)
@property (nonatomic, assign) CGFloat cornerRadius;

//推送图片大小(默认 50)
@property (nonatomic, assign) CGSize imageSize;
//推送内容颜色(默认 白色)
@property (nonatomic, strong) UIColor *contentColor;
//推送内容字体(默认 12)
@property (nonatomic, strong) UIFont *contentFont;

+ (instancetype)share;

@end
