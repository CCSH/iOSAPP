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
    SHPopViewAnimation_top,//滑动、上
    SHPopViewAnimation_bottom,//滑动、下
    SHPopViewAnimation_left,//滑动、左
    SHPopViewAnimation_right,//滑动、右
    SHPopViewAnimation_rotationX,//旋转、X轴方向
    SHPopViewAnimation_rotationY,//旋转、Y轴方向
    SHPopViewAnimation_rotationZ,//旋转、中心点方向
    SHPopViewAnimation_spring_top,//弹簧、上
    SHPopViewAnimation_spring_bottom,//弹簧、下
    SHPopViewAnimation_spring_left,//弹簧、左
    SHPopViewAnimation_spring_right,//弹簧、右
} SHPopViewAnimation;

@interface SHPopView : UIView

#pragma mark - 必选参数
//内容视图
@property (nonatomic, strong) UIView *contentView;

#pragma mark - 可选参数
//显示动画
@property (nonatomic, assign) SHPopViewAnimation showAnimation;
//消失动画(消失动画不包含弹簧，没写，太丑)
@property (nonatomic, assign) SHPopViewAnimation hideAnimation;
//动画时长(默认 0.25，弹簧动画下如果为负数则使用弹簧默认动画时间)
@property (nonatomic, assign) CGFloat duration;
//是否抖动
@property (nonatomic, assign) BOOL isJitter;
//内容是否显示中
@property (nonatomic, assign, readonly) BOOL isShowing;
//点击背景消失
@property (nonatomic, assign) BOOL isClickDisappear;
//蒙板颜色
@property (nonatomic, strong) UIColor *maskColor;

#pragma mark 弹簧动画的可选参数有默认
//初始速度
@property (nonatomic, assign) CGFloat initialVelocity;
//阻尼(阻尼越大、停止越快)
@property (nonatomic, assign) CGFloat damping;
//刚度(刚度越大、运动越快)
@property (nonatomic, assign) CGFloat stiffness;
//质量(质量越大、惯性越大)
@property (nonatomic, assign) CGFloat mass;

#pragma mark 显示
- (void)show;
- (void)showInView:(UIView *_Nullable)view;

#pragma mark 隐藏
- (void)hide;

@end

NS_ASSUME_NONNULL_END
