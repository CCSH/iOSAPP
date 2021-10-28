//
//  SHTabbar.m
//  FengRuiNong
//
//  Created by CSH on 2020/9/11.
//  Copyright © 2020 Xiaodong Jiang. All rights reserved.
//

#import "SHTabBar.h"

@interface SHTabBar () <UITabBarDelegate>

@property (nonatomic, strong) UIView *minView;

@end

@implementation SHTabBar

+ (void)initialize {
    if (self == [self class]) {
        [self tabBGColor:[UIColor whiteColor]];
        [self tabItem:@{NSFontAttributeName : kFont(12)}
               select:@{NSFontAttributeName : kFont(12),
                        NSForegroundColorAttributeName : kColorMain}];
    }
}

#pragma mark - tabbar设置
#pragma mark 获取样式
+ (UITabBarAppearance *)getBar API_AVAILABLE(ios(15.0)){
    return [UITabBar appearance].scrollEdgeAppearance ? : [UITabBarAppearance new];
}

#pragma mark 背景颜色
+ (void)tabBGColor:(UIColor *)obj{
    UITabBar *tabbar = [UITabBar appearance];
    UIImage *img = [UIImage getImageWithColor:obj];
    
    tabbar.backgroundImage = img;
    tabbar.shadowColor = [UIColor clearColor];
    
    if (IOS(15)) {
        UITabBarAppearance *bar = [self getBar];
        bar.backgroundColor = obj;
        bar.shadowColor = tabbar.shadowColor;
        //关闭模糊效果
        bar.backgroundEffect = nil;
        
        tabbar.scrollEdgeAppearance = bar;
        tabbar.standardAppearance = bar;
    }
}

#pragma mark item
+ (void)tabItem:(NSDictionary<NSAttributedStringKey,id> *)obj select:(NSDictionary<NSAttributedStringKey,id> *)obj2{
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    [tabBarItem setTitleTextAttributes:obj forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:obj2 forState:UIControlStateSelected];
    
    [UITabBar appearance].tintColor = obj2[NSForegroundColorAttributeName];
    if (IOS(10)) {
        [UITabBar appearance].unselectedItemTintColor = obj[NSForegroundColorAttributeName];
    }
    
    if (IOS(15)) {
        UITabBar *tabbar = [UITabBar appearance];
        UITabBarAppearance *bar = [self getBar];
        UITabBarItemAppearance *button = bar.stackedLayoutAppearance;
        UITabBarItemStateAppearance *state = button.normal;
        UITabBarItemStateAppearance *state2 = button.selected;
        
        state.titleTextAttributes = obj;
        state2.titleTextAttributes = obj2;
        
        bar.stackedLayoutAppearance = button;
        
        tabbar.scrollEdgeAppearance = bar;
        tabbar.standardAppearance = bar;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
      if (!obj.tag) {
          obj.tag = idx;
      }
    }];
//    self.height = kTabBarH;
//    self.y += (49 - kTabBarH);
//
    // 0是背景横条
    self.minView = (UIView *)[self viewWithTag:3];
    [self.minView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    UIImageView *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(0, 0, 50, 50);
    img.image = [UIImage imageNamed:self.dataArr[0]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.centerX = self.minView.width / 2;
    [self.minView addSubview:img];

    self.minView.height = kTabBarH + img.height / 2;
    self.minView.y = kTabBarH - self.minView.height;
}

#pragma mark - 超出响应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        // 转换坐标系
        CGPoint newPoint = [self.minView convertPoint:point fromView:self];
        // 判断触摸点是否在视图上
        if (CGRectContainsPoint(self.minView.bounds, newPoint) && !self.isHidden) {
            return self.minView;
        }
    }
    return [super hitTest:point withEvent:event];
}

#pragma mark - tabbar点击
- (void)didSelectItem:(NSInteger)index {
    if (index == 2) {
        [SHToast showWithText:@"点击了中间！！！"];
    }
}

@end
