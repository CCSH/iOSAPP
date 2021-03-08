//
//  UIButton+SHExtension.h
//  SHExtensionExample
//
//  Created by CCSH on 2020/11/17.
//  Copyright © 2020 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SHButtonImageDirection_top,
    SHButtonImageDirection_left,
    SHButtonImageDirection_right,
    SHButtonImageDirection_bottom,
} SHButtonImageDirection;

@interface UIButton (SHExtension)

- (void)imageDirection:(SHButtonImageDirection)direction space:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
