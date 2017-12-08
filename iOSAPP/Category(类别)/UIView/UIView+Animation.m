//
//  UIView+SHExtensionAnimation.m
//  LazyWeather
//
//  Created by KevinSH on 15/12/6.
//  Copyright © 2015年 SHXiaoMing. All rights reserved.
//

#import "UIView+Animation.h"
#import <objc/runtime.h>

#define BottomRect CGRectMake(self.frame.origin.x, kSHWidth, self.frame.size.width, self.frame.size.height)
#define AnimationTime 0.25

@implementation UIView (Animation)

#pragma mark - 底部出现动画
- (void)showFromBottom {
    CGRect rect = self.frame;
    self.frame = BottomRect;
    [self executeAnimationWithFrame:rect];
}

#pragma mark - 底部消失动画
- (void)dismissToBottom{
    [self executeAnimationWithFrame:BottomRect];
}

#pragma mark - 背景浮现动画
- (void)emerge {
    self.alpha = 0.0;
    [self executeAnimationWithAlpha:AnimationTime];
}

#pragma mark - 背景淡去动画
- (void)fake {
    [self executeAnimationWithAlpha:0.f];
}

#pragma mark - 执行动画
- (void)executeAnimationWithAlpha:(CGFloat)alpha{
    [UIView animateWithDuration:AnimationTime animations:^{
        self.alpha = alpha;
    }];
}

- (void)executeAnimationWithFrame:(CGRect)rect{
     [UIView animateWithDuration:AnimationTime animations:^{
         self.frame = rect;
     }];
}

#pragma mark - 按钮震动动画
- (void)startSelectedAnimation {
    CAKeyframeAnimation * ani = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    ani.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.0)],
                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)],
                   [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    ani.removedOnCompletion = YES;
    ani.fillMode = kCAFillModeForwards;
    ani.duration = 0.4;
    [self.layer addAnimation:ani forKey:@"transformAni"];
}

@end
