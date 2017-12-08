//
//  UIImage+SHExtension.h
//  iOSAPP
//
//  Created by CSH on 2017/9/19.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SHExtension)

//获取指定大小的图片
- (UIImage *)imageWithSize:(CGSize)size;
//通过颜色获取一张图片
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
