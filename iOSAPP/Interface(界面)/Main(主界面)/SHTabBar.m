//
//  SHTabbar.m
//  FengRuiNong
//
//  Created by CSH on 2020/9/11.
//  Copyright © 2020 Xiaodong Jiang. All rights reserved.
//

#import "SHTabBar.h"

@interface SHTabBar () < UITabBarDelegate >

@property (nonatomic, strong) UIView *minView;

@end

@implementation SHTabBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
      if (!obj.tag)
      {
          obj.tag = idx;
      }
    }];

    // 0是背景横条
    self.minView = (UIView *)[self viewWithTag:3];

    self.minView.height = 80;
    self.minView.y = 49 - self.minView.height;

    [self.minView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = self.minView.bounds;
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.backgroundColor = [UIColor orangeColor];
    [self.minView addSubview:img];
}

#pragma mark - 超出响应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil)
    {
        // 转换坐标系
        CGPoint newPoint = [self.minView convertPoint:point fromView:self];
        // 判断触摸点是否在视图上
        if (CGRectContainsPoint(self.minView.bounds, newPoint) && !self.isHidden)
        {
            return self.minView;
        }
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark  - tabbar点击
- (void)didSelectItem:(NSInteger)index
{
    if (index == 2)
    {
        [SHToast showWithText:@"点击了中间！！！"];
    }
}

@end
