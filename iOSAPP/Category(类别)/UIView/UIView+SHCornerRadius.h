//
//  UIView+SHCornerRadius.h
//  XIB圆角
//
//  Created by CSH on 16/7/14.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  为storyboard与xib添加描边属性
 */

IB_DESIGNABLE //动态刷新

@interface UIView (SHCornerRadius)

// 注意: 加上IBInspectable就可以可视化显示相关的属性
/** 可视化设置圆角 */
@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;
/** 可视化设置边框宽度 */
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;
/** 可视化设置边框颜色 */
@property (nonatomic, strong)IBInspectable UIColor *borderColor;


@end
