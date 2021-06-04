//
//  UIButton+SHExtension.m
//  SHExtensionExample
//
//  Created by CCSH on 2020/11/17.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "UIButton+SHExtension.h"
#import <objc/runtime.h>

@implementation UIButton (SHExtension)


- (void)imageDirection:(SHButtonImageDirection)direction space:(CGFloat)space {
    CGFloat imageWidth, imageHeight, textWidth, textHeight, x, y;
    imageWidth = self.currentImage.size.width;
    imageHeight = self.currentImage.size.height;
    [self.titleLabel sizeToFit];
    textWidth = self.titleLabel.frame.size.width;
    textHeight = self.titleLabel.frame.size.height;
    space = space / 2;
    switch (direction) {
        case SHButtonImageDirection_top: {
            x = textHeight / 2 + space;
            y = textWidth / 2;
            self.imageEdgeInsets = [self setUIEdgeInsets:CGPointMake(-x, y)];
            x = imageHeight / 2 + space;
            y = imageWidth / 2;
            self.titleEdgeInsets = [self setUIEdgeInsets:CGPointMake(x, -y)];
            ;
        } break;
        case SHButtonImageDirection_bottom: {
            x = textHeight / 2 + space;
            y = textWidth / 2;
            self.imageEdgeInsets = [self setUIEdgeInsets:CGPointMake(x, y)];
            x = imageHeight / 2 + space;
            y = imageWidth / 2;
            self.titleEdgeInsets = [self setUIEdgeInsets:CGPointMake(-x, -y)];
        } break;
        case SHButtonImageDirection_left: {
            self.imageEdgeInsets = [self setUIEdgeInsets:CGPointMake(0, -space)];
            self.titleEdgeInsets = [self setUIEdgeInsets:CGPointMake(0, space)];
        } break;
        case SHButtonImageDirection_right: {
            self.imageEdgeInsets = [self setUIEdgeInsets:CGPointMake(0, space + textWidth)];
            self.titleEdgeInsets = [self setUIEdgeInsets:CGPointMake(0, -(space + imageWidth))];
        } break;
        default:
            break;
    }
}

- (UIEdgeInsets)setUIEdgeInsets:(CGPoint)point {
    return UIEdgeInsetsMake(point.x, point.y, -point.x, -point.y);
}



@end
