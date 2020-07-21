//
//  SHToast.m
//  SHToast
//
//  Created by CSH on 2017/8/16.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "SHToast.h"

@interface SHToast ()

//内容
@property (nonatomic, strong) UIButton *contentView;
//回调
@property (nonatomic, copy) void(^block)(void);

@end

@implementation SHToast

#pragma mark - 私有方法
#pragma mark 屏幕旋转通知方法
- (void)deviceOrientationDidChanged:(NSNotification *)not{
    [self dismiss];
}

#pragma mark 消失
- (void)dismiss{
    
    [self.contentView removeFromSuperview];
}

#pragma mark - 懒加载
- (UIButton *)contentView{
    if (!_contentView) {
        _contentView = [UIButton buttonWithType:UIButtonTypeCustom];
        _contentView.titleLabel.numberOfLines = 0;
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:_contentView];
    }
    return _contentView;
}

#pragma mark - 获取内容Size
- (CGSize)getTextSizeWithText:(id)text font:(UIFont *)font maxSize:(CGSize)maxSize{
    
    CGSize size;
    //内容
    if ([text isKindOfClass:[NSString class]]) {//字符串
        
        NSString *str = (NSString *)text;
        size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
        size = CGSizeMake(ceil(size.width), ceil(size.height));
        
    }else if ([text isKindOfClass:[NSAttributedString class]]){//富文本
        
        NSAttributedString *att = (NSAttributedString *)text;
        size = [att boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        size =  CGSizeMake(ceil(size.width), ceil(size.height));
        
    }else{//其他
        size = CGSizeZero;
    }
    
    return size;
}

#pragma mark - Toast
#pragma mark 实例化
- (id)initWithText:(id)text{
    
    if (self = [super init]) {
        
        //内容视图
        self.contentView.backgroundColor = kSHToastRGB;
        self.contentView.titleLabel.font = kSHToastTextFont;
        [self.contentView setTitleColor:kSHToastTextRGB forState:0];
        [self.contentView addTarget:self action:@selector(hideAnimation) forControlEvents:UIControlEventTouchDown];
        
        [self.contentView setTitleEdgeInsets:UIEdgeInsetsMake(kSHToastTextUDMargin, kSHToastTextLRMargin, kSHToastTextUDMargin, kSHToastTextLRMargin)];
        
        //size
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2*kSHToastMargin - 2*kSHToastTextLRMargin, CGFLOAT_MAX);
        CGSize textSize = [self getTextSizeWithText:text font:kSHToastTextFont maxSize:maxSize];
        self.contentView.frame = CGRectMake(0, 0, textSize.width + 2*kSHToastTextLRMargin, textSize.height + 2*kSHToastTextUDMargin);
        
        //圆角 需要控制最大圆角
        self.contentView.layer.cornerRadius = self.contentView.frame.size.height/2;
        
        //内容
        if ([text isKindOfClass:[NSString class]]) {//字符串
            
            NSString *str = (NSString *)text;
            [self.contentView setTitle:str forState:0];
        }else if ([text isKindOfClass:[NSAttributedString class]]){//富文本
            
            NSAttributedString *att = (NSAttributedString *)text;
            [self.contentView setAttributedTitle:att forState:0];
        }
        
        //添加旋转通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    }
    return self;
}

#pragma mark 显示方法
#pragma mark 中间位置显示
+ (void)showWithText:(id)text{
    
    [SHToast showWithText:text duration:kSHToastTime];
}

+ (void)showWithText:(id)text duration:(CGFloat)duration{
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [SHToast showWithText:text offset:window.center.y duration:duration];
}

#pragma mark 自定义位置显示
+ (void)showWithText:(id)text offset:(CGFloat)offset{
    [SHToast showWithText:text offset:offset duration:kSHToastTime];
}

+ (void)showWithText:(id)text offset:(CGFloat)offset duration:(CGFloat)duration{
    if (!text) {
        return;
    }
    SHToast *toast = [[SHToast alloc] initWithText:text];
    [toast showToastWithDuration:duration offset:offset];
}

#pragma mark 显示
- (void)showToastWithDuration:(CGFloat)duration offset:(CGFloat)offset{
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.contentView.center = CGPointMake(window.center.x,offset);
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

#pragma mark 显示动画
- (void)showAnimation{
    
    self.contentView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentView.alpha = 1;
    }];
}

#pragma mark 隐藏动画
- (void)hideAnimation{
    
    self.contentView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.contentView.alpha = 0;
    }completion:^(BOOL finished) {
        [self dismiss];
    }];
}

#pragma mark - Push
#pragma mark 实例化
- (id)initPushWithTitle:(id)title content:(id)content image:(UIImage *)image{
    
    if (self = [super init]) {
        
        //内容视图
        self.contentView.backgroundColor = kSHPushRGB;
        [self.contentView addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
        self.contentView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        CGFloat view_top = [[UIApplication sharedApplication] statusBarFrame].size.height;
        [self.contentView setTitleEdgeInsets:UIEdgeInsetsMake(view_top, kSHPushTextLRMargin, kSHPushTextUDMargin, kSHPushTextLRMargin)];
        
        CGFloat view_x = kSHPushTextLRMargin;
        CGFloat view_y = view_top + kSHPushTextUDMargin;
        CGFloat min_h = view_top + 2*kSHPushTextUDMargin + 50;
        
        //图片
        if (image) {
            
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake(kSHPushTextLRMargin, view_y, 50, 50);
            imageView.image = image;
            imageView.backgroundColor = [UIColor lightGrayColor];
            [self.contentView addSubview:imageView];
            
            view_x += CGRectGetMaxX(imageView.frame);
        }
        
        CGFloat max_w = [UIScreen mainScreen].bounds.size.width - view_x - 2*kSHPushTextLRMargin;
        
        view_x += kSHPushTextLRMargin;
        
        //标题
        if ([title length]) {
            
            UILabel *titleLab = [[UILabel alloc]init];
            titleLab.numberOfLines = 0;
            titleLab.font = kSHPushTitleFont;
            titleLab.textColor = kSHPushTitleRGB;
            
            CGSize textSize = [self getTextSizeWithText:title font:kSHPushTitleFont maxSize:CGSizeMake(max_w, CGFLOAT_MAX)];
            titleLab.frame = CGRectMake(view_x, view_y, max_w, textSize.height);
            
            if ([title isKindOfClass:[NSString class]]) {
                
                titleLab.text = title;
            }else if ([title isKindOfClass:[NSAttributedString class]]){
                
                titleLab.attributedText = title;
            }
            
            [self.contentView addSubview:titleLab];
            
            view_y += CGRectGetHeight(titleLab.frame);
        }
        
        //内容
        if ([content length]) {
            
            if ([title length]) {
                view_y += kSHPushTextUDMargin;
            }
            
            UILabel *contentLab = [[UILabel alloc]init];
            contentLab.numberOfLines = 0;
            contentLab.font = kSHPushContentFont;
            contentLab.textColor = kSHPushContentRGB;
            
            CGSize textSize = [self getTextSizeWithText:content font:kSHPushContentFont maxSize:CGSizeMake(max_w, CGFLOAT_MAX)];
            contentLab.frame = CGRectMake(view_x, view_y, max_w, textSize.height);
            
            if ([content isKindOfClass:[NSString class]]) {
                
                contentLab.text = content;
            }else if ([content isKindOfClass:[NSAttributedString class]]){
                
                contentLab.attributedText = content;
            }
            
            [self.contentView addSubview:contentLab];
            
            view_y += CGRectGetHeight(contentLab.frame);
        }
        
        view_y += kSHPushTextUDMargin;
        
        if (image && view_y < min_h) {
            view_y = min_h;
        }
        
        self.contentView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, view_y);
        
        //添加旋转通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChanged:) name:UIDeviceOrientationDidChangeNotification object:[UIDevice currentDevice]];
    }
    return self;
}

#pragma mark 显示方法
+ (void)showPushWithTitle:(id)title content:(id)content image:(UIImage *)image block:(void (^)(void))block{
    
    [SHToast showPushWithTitle:title content:content image:image duration:kSHPushTime block:block];
}

+ (void)showPushWithTitle:(id)title content:(id)content image:(UIImage *)image duration:(CGFloat)duration block:(void (^)(void))block{
    
    if (![content length]) {
        return;
    }
    
    SHToast *toast = [[SHToast alloc]initPushWithTitle:title content:content image:image];
    toast.block = block;
    [toast showPushWithDuration:duration];
}

#pragma mark 显示
- (void)showPushWithDuration:(CGFloat)duration{
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = -self.contentView.frame.size.height;
    self.contentView.frame = frame;
    
    [self showPushAnimation];
    [self performSelector:@selector(hidePushAnimation) withObject:nil afterDelay:duration];
}

#pragma mark 点击
- (void)pushAction{
    
    //回调
    if (self.block) {
        self.block();
    }
    
    [self hidePushAnimation];
}

#pragma mark 显示动画
- (void)showPushAnimation{
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.windowLevel = UIWindowLevelAlert;
    
    __block CGRect frame = self.contentView.frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        frame.origin.y = 0;
        self.contentView.frame = frame;
    }];
}

#pragma mark 隐藏动画
- (void)hidePushAnimation{
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.windowLevel = UIWindowLevelNormal;
    
    __block CGRect frame = self.contentView.frame;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        frame.origin.y = -frame.size.height;
        self.contentView.frame = frame;
    }completion:^(BOOL finished) {
        
        [self dismiss];
    }];
}

@end

