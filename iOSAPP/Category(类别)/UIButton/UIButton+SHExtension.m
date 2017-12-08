//
//  UIButton+SHExtension.m
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "UIButton+SHExtension.h"

@implementation UIButton (SHExtension)


+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector title:(NSString *)title{
    
    return [UIButton buttonWithFrame:frame target:target selector:selector title:title image:nil imageSelected:nil];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector image:(NSString *)image{
    
    return [UIButton buttonWithFrame:frame target:target selector:selector title:nil image:image imageSelected:image];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector image:(NSString *)image imageSelected:(NSString *)imageSelected{
    
    return [UIButton buttonWithFrame:frame target:target selector:selector title:nil image:image imageSelected:imageSelected];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target selector:(SEL)selector title:(NSString *)title image:(NSString *)image imageSelected:(NSString *)imageSelected{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    if (image) {
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    if (imageSelected) {
        [button setImage:[UIImage imageNamed:imageSelected] forState:UIControlStateSelected];
    }
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}



@end
