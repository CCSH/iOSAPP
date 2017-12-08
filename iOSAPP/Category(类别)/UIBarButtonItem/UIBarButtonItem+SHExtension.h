//
//  UIBarButtonItem+SHExtension.h
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

//图片
+ (UIBarButtonItem *)itemWithImage:(NSString *)image higlightedImage:(NSString *)higlightedImage target:(id)target action:(SEL)action;

//文字
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title normalColor:(UIColor *)normal  selectorColor:(UIColor *)selector target:(id)target action:(SEL)action;

//返回文字
+ (UIBarButtonItem *)backItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
