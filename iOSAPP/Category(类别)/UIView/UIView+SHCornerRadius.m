//
//  UIView+SHCornerRadius.m
//  XIB圆角
//
//  Created by CSH on 16/7/14.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "UIView+SHCornerRadius.h"

@implementation UIView (SHCornerRadius)

#pragma mark - 设置边框宽度
- (void)setBorderWidth:(CGFloat)borderWidth {
    
    if (borderWidth < 0) return;
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth{
    return self.borderWidth;
}

#pragma mark - 设置边框颜色
- (void)setBorderColor:(UIColor *)borderColor {
    
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor{
    return self.borderColor;
}

#pragma mark - 设置圆角
- (void)setCornerRadius:(CGFloat)cornerRadius {
    
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (CGFloat)cornerRadius{
    return self.cornerRadius;
}

@end
