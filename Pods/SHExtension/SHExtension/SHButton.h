//
//  UIButton+SHExtension.h
//  SHExtension
//
//  Created by CSH on 2018/9/19.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BtnBlock)(UIButton *btn);

@interface SHButton : UIButton

//扩大button点击区域(4边扩大相同值)
@property (nonatomic, assign) CGFloat enlargedEdge;

//扩大button点击区域(上左下右)
- (void)setEnlargedEdgeWithEdgeInsets:(UIEdgeInsets)edgeInsets;

#pragma mark - 添加点击
- (void)addClickBlock:(BtnBlock)block;

#pragma mark - 添加事件
- (void)addAction:(UIControlEvents)events block:(BtnBlock)block;

@end

NS_ASSUME_NONNULL_END
