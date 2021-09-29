//
//  SHCollectionViewFlowLayout.m
//  iOSAPP
//
//  Created by CCSH on 2021/9/28.
//  Copyright © 2021 CSH. All rights reserved.
//

#import "SHCollectionViewFlowLayout.h"

@interface SHCollectionViewFlowLayout () {
    //在居中对齐的时候需要知道这行所有cell的宽度总和
    CGFloat _sumWidth;
}

@end

@implementation SHCollectionViewFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributes_t = [super layoutAttributesForElementsInRect:rect];
    NSArray *layoutAttributes = [[NSArray alloc] initWithArray:layoutAttributes_t copyItems:YES];

    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < layoutAttributes.count; index++) {
        //当前cell 位置信息
        UICollectionViewLayoutAttributes *currentArr = layoutAttributes[index];
        //上一个cell 位置信息
        UICollectionViewLayoutAttributes *upArr = (index == 0) ? nil : layoutAttributes[index - 1];
        //下一个cell 位置信息
        UICollectionViewLayoutAttributes *nextArr = (index + 1) == layoutAttributes.count ? nil : layoutAttributes[index + 1];

        [temp addObject:currentArr];
        
        _sumWidth += currentArr.frame.size.width;

        CGFloat upY = (upArr) ? CGRectGetMaxY(upArr.frame) : 0;
        CGFloat currentY = CGRectGetMaxY(currentArr.frame);
        CGFloat nextY = (nextArr) ? CGRectGetMaxY(nextArr.frame) : 0;
        
        //如果当前cell是单独一行
        if (currentY != upY && currentY != nextY) {
            if ([currentArr.representedElementKind isEqualToString:UICollectionElementKindSectionHeader] ||
                [currentArr.representedElementKind isEqualToString:UICollectionElementKindSectionFooter]) {
                [temp removeAllObjects];
                _sumWidth = 0.0;
            } else {
                [self handleCellFrame:temp];
            }
        } else if (currentY != nextY) {
            //如果下一个cell在本行，这开始调整Frame位置
            [self handleCellFrame:temp];
        }
    }
    return layoutAttributes;
}

//调整属于同一行的cell的位置frame
- (void)handleCellFrame:(NSMutableArray *)temp {
    __block CGFloat width = 0.0;
    switch (self.alignment) {
        case SHLayoutAlignment_right: {
            width = self.collectionView.frame.size.width - self.sectionInset.right;
            [temp enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UICollectionViewLayoutAttributes *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGRect frame = obj.frame;
                frame.origin.x = width - frame.size.width;
                obj.frame = frame;
                width = width - frame.size.width - self.minimumInteritemSpacing;
            }];
        } break;
        case SHLayoutAlignment_center: {
            width = (self.collectionView.frame.size.width - _sumWidth - ((temp.count - 1) * self.minimumInteritemSpacing)) / 2;
            [temp enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGRect frame = obj.frame;
                frame.origin.x = width;
                obj.frame = frame;
                width += frame.size.width + self.minimumInteritemSpacing;
            }];
        } break;
        default: {
            width = self.sectionInset.left;
            [temp enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGRect frame = obj.frame;
                frame.origin.x = width;
                obj.frame = frame;
                width += frame.size.width + self.minimumInteritemSpacing;
            }];
        } break;
    }
    _sumWidth = 0.0;
    [temp removeAllObjects];
}

@end
