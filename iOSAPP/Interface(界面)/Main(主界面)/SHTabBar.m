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
    [self.minView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(0, 0, 50, 50);
    img.image = [UIImage imageNamed:self.dataArr[0]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.centerX = self.minView.width/2;
    [self.minView addSubview:img];

    self.minView.height = kTabBarH + img.height/2;
    self.minView.y = kTabBarH - self.minView.height;
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

#pragma mark - tabbar点击
- (void)didSelectItem:(NSInteger)index
{
    if (index == 2)
    {
        [SHToast showWithText:@"点击了中间！！！"];
    }
}

@end
