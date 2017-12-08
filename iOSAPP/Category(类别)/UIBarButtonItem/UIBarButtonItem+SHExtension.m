//
//  UIBarButtonItem+SHExtension.m
//  iOSAPP
//
//  Created by CSH on 16/7/5.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "UIBarButtonItem+SHExtension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithImage:(NSString *)image higlightedImage:(NSString *)higlightedImage target:(id)target action:(SEL)action {
    // 1.初始化按钮
    UIButton *button =  [[UIButton alloc] init];
    // 2.设置图片
    [button setBackgroundImage:[[UIImage imageNamed:image] imageWithSize:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    if (!higlightedImage.length) {
        higlightedImage = image;
    }
    [button setBackgroundImage:[[UIImage imageNamed:higlightedImage] imageWithSize:CGSizeMake(20, 20)] forState:UIControlStateHighlighted];
    // 3.设置大小
    CGSize size = button.currentBackgroundImage.size;
    button.size = size;
    // 4.监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 5.返回创建好的item
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title normalColor:(UIColor *)normal selectorColor:(UIColor *)selector target:(id)target action:(SEL)action{
    // 1.初始化按钮
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    // 2.设置文字
    [button setTitle:title forState:UIControlStateNormal];
    
    if (normal) {
        [button setTitleColor:normal forState:UIControlStateNormal];
    }else{
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if (selector) {
        [button setTitleColor:selector forState:UIControlStateHighlighted];
    }else{
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    
    // 3.设置大小
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    button.titleLabel.font=[UIFont systemFontOfSize:16];
    CGSize size = [button.currentTitle sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];
    button.size = CGSizeMake(size.width, size.height);
    // 4.监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    // 5.返回创建好的item
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)backItemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    return [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
}

@end
