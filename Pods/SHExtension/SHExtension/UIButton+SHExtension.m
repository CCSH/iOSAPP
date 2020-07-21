//
//  UIButton+SHExtension.m
//  SHExtension
//
//  Created by CSH on 2018/9/19.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "UIButton+SHExtension.h"
#import "objc/runtime.h"

static char topEdgeKey;
static char leftEdgeKey;
static char bottomEdgeKey;
static char rightEdgeKey;

@implementation UIButton (SHExtension)

- (void)setEnlargedEdge:(CGFloat)enlargedEdge{
    
    [self setEnlargedEdgeWithEdgeInsets:UIEdgeInsetsMake(enlargedEdge, enlargedEdge, enlargedEdge, enlargedEdge)];
}

- (void)setEnlargedEdgeWithEdgeInsets:(UIEdgeInsets)edgeInsets{
    
    objc_setAssociatedObject(self, &topEdgeKey, [NSNumber numberWithFloat:edgeInsets.top], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &leftEdgeKey, [NSNumber numberWithFloat:edgeInsets.left], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bottomEdgeKey, [NSNumber numberWithFloat:edgeInsets.bottom], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &rightEdgeKey, [NSNumber numberWithFloat:edgeInsets.right], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)enlargedEdge{
    
    return [(NSNumber *)objc_getAssociatedObject(self, &topEdgeKey) floatValue];
}

- (CGRect)enlargedRect{
    
    NSNumber *topEdge = objc_getAssociatedObject(self, &topEdgeKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftEdgeKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomEdgeKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightEdgeKey);
    
    if(topEdge && leftEdge && bottomEdge && rightEdge){
        
        CGRect enlargedRect = CGRectMake(self.bounds.origin.x-leftEdge.floatValue, self.bounds.origin.y - topEdge.floatValue, self.bounds.size.width+ leftEdge.floatValue +rightEdge.floatValue, self.bounds.size.height+topEdge.floatValue+bottomEdge.floatValue);
        return enlargedRect;
    }
    
    return self.bounds;
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    if( !self.alpha || !self.userInteractionEnabled || self.hidden){
        return nil;
    }
    
    CGRect enlargedRect = [self enlargedRect];
    return CGRectContainsPoint(enlargedRect, point) ? self: nil;
}

@end
