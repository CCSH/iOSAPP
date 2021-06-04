//
//  SHPopView.h
//  Exmpale
//
//  Created by CCSH on 2021/3/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SHPopViewAnimation_fade,//淡入淡出
    SHPopViewAnimation_none,//无动画
    SHPopViewAnimation_scale,//缩放
    SHPopViewAnimation_top,//滑动、上侧
    SHPopViewAnimation_bottom,//滑动、下侧
    SHPopViewAnimation_left,//滑动、左侧
    SHPopViewAnimation_right,//滑动、右侧
    SHPopViewAnimation_rotationX,//旋转、X轴方向
    SHPopViewAnimation_rotationY,//旋转、Y轴方向
    SHPopViewAnimation_rotationZ,//旋转、中心点方向
} SHPopViewAnimation;

@interface SHPopView : UIView

//内容视图
@property (nonatomic, strong) UIView *contentView;
//显示动画
@property (nonatomic, assign) SHPopViewAnimation showAnimation;
//消失动画
@property (nonatomic, assign) SHPopViewAnimation hideAnimation;
//动画时长(默认 0.25)
@property (nonatomic, assign) CGFloat duration;
//是否抖动
@property (nonatomic, assign) BOOL isJitter;
//内容是否显示中
@property (nonatomic, assign, readonly) BOOL isShowing;
//点击背景消失
@property (nonatomic, assign) BOOL isClickDisappear;

#pragma mark 显示
- (void)show;
- (void)showInView:(UIView *_Nullable)view;

#pragma mark 隐藏
- (void)hide;

@end

NS_ASSUME_NONNULL_END
