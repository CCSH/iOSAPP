//
//  SHCollectionViewLayout.h
//  FengRuiNong
//
//  Created by CCSH on 2021/2/25.
//  Copyright © 2021 Xiaodong Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SHCollectionViewLayout;

NS_ASSUME_NONNULL_BEGIN

@protocol SHCollectionViewLayoutDelegate <NSObject>

@required
//计算item高度的代理方法，将item的高度与indexPath传递给外界
- (CGSize)layout:(SHCollectionViewLayout *)layout itemWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath;

@end

@interface SHCollectionViewLayout : UICollectionViewLayout

//瀑布流的列数
@property (nonatomic, assign) NSInteger columnCount;
//瀑布流的内边距
@property (nonatomic, assign) UIEdgeInsets defaultEdgeInsets;;
//cell的列间距
@property (nonatomic, assign) NSInteger columnMagin;
//cell的行间距
@property (nonatomic, assign) NSInteger rowMagin;

@property (nonatomic, weak) id<SHCollectionViewLayoutDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
