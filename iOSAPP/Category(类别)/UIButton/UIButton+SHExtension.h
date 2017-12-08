//
//  UIButton+SHExtension.h
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SHExtension)

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector title:(NSString *)title;

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector image:(NSString*)image;

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector image:(NSString*)image imageSelected:(NSString *)imageSelected;

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector title:(NSString *)title image:(NSString*)image imageSelected:(NSString *)imageSelected;

@end
