//
//  UIButton+SHExtension.h
//  SHExtension
//
//  Created by CSH on 2018/9/19.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (SHExtension)

//扩大button点击区域(4边扩大相同值)
@property (nonatomic, assign) CGFloat enlargedEdge;

//扩大button点击区域(上左下右)
- (void)setEnlargedEdgeWithEdgeInsets:(UIEdgeInsets)edgeInsets;

@end

NS_ASSUME_NONNULL_END
