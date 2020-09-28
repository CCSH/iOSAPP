//
//  SHToast.h
//  SHToast
//
//  Created by CSH on 2017/8/16.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SHToast : NSObject

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


@interface SHToastStyle : NSObject

//弹框内部间隔
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
//弹框整体间隔
@property (nonatomic, assign) CGFloat margin;
//默认显示时间
@property (nonatomic, assign) CGFloat time;
//背景颜色
@property (nonatomic, strong) UIColor *color;
//字体颜色
@property (nonatomic, strong) UIColor *textColor;
//字体大小
@property (nonatomic, strong) UIFont *font;

+ (instancetype)shareSHToastStyle;

@end

@interface SHPushStyle : NSObject

//推送弹框内部间隔
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
//默认显示时间
@property (nonatomic, assign) CGFloat time;
//推送图片大小
@property (nonatomic, assign) CGSize imageSize;
//推送背景颜色
@property (nonatomic, strong) UIColor *color;
//推送标题颜色
@property (nonatomic, strong) UIColor *titleColor;
//推送标题字体
@property (nonatomic, strong) UIFont *titleFont;
//推送内容颜色
@property (nonatomic, strong) UIColor *contentColor;
//推送内容字体
@property (nonatomic, strong) UIFont *contentFont;

+ (instancetype)shareSHPushStyle;

@end
