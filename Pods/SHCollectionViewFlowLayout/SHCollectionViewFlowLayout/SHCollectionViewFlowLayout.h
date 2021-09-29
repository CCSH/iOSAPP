//
//  SHCollectionViewFlowLayout.h
//  iOSAPP
//
//  Created by CCSH on 2021/9/28.
//  Copyright © 2021 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SHLayoutAlignment_left,
    SHLayoutAlignment_center,
    SHLayoutAlignment_right,
} SHLayoutAlignment;

@interface SHCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) SHLayoutAlignment alignment;

@end

NS_ASSUME_NONNULL_END
