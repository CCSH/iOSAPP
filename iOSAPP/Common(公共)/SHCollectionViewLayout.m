//
//  SHCollectionViewLayout.m
//  FengRuiNong
//
//  Created by CCSH on 2021/2/25.
//  Copyright © 2021 Xiaodong Jiang. All rights reserved.
//

#import "SHCollectionViewLayout.h"

@interface SHCollectionViewLayout ()

//存放所有cell 的布局属性
@property (nonatomic, strong) NSMutableArray *attrsArray;
//缩放所有列的高度
@property (nonatomic, strong) NSMutableArray *columnHeights;

@end

@implementation SHCollectionViewLayout

#pragma mark - <懒加载>
- (NSMutableArray *)attrsArray{
    if (!_attrsArray) {
        _attrsArray = [NSMutableArray array];
    }
    return _attrsArray;
}

- (NSMutableArray *)columnHeights{
    if (!_columnHeights) {
        _columnHeights = [NSMutableArray array];
    }
    return _columnHeights;
}
#pragma mark - <准备布局>
//准备布局（布局前自动执行）
- (void) prepareLayout{
    //重写此方法一定要记得super
    [super prepareLayout];
    
    //初始化
    [self.columnHeights removeAllObjects];
    [self.attrsArray removeAllObjects];
    //首先为第一行的cell附高度
    for (NSInteger i = 0; i < self.columnCount; i ++) {
        //数组里只能存放对象
        [self.columnHeights addObject:@(self.defaultEdgeInsets.top)];
    }
    //下面开始创建每一个cell的布局属性 并且添加到存储cell布局属性的数组中
    //cell总个数 因为这里只要一个section
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i ++) {
        // 创建位置 即indexPath
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        //获取indexPath对应的cell布局属性
        UICollectionViewLayoutAttributes * attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        //把获取到的布局属性添加到数组中
        [self.attrsArray addObject:attributes];
    }
    //准备布局的工作到这里就结束了
}
//返回所有cell布局属性 及整体cell 的排布
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.attrsArray;
}
//返回cell 的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    //创建布局属性
    UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //获取collectionView 的宽
    CGFloat collectionViewWidth = self.collectionView.frame.size.width;
    //下面的一部分是获取cell的frame（布局属性）
    CGFloat width = 0;
    CGFloat height = 0;
    CGFloat X;
    CGFloat Y;
    //获取width
    width = (collectionViewWidth - self.defaultEdgeInsets.left - self.defaultEdgeInsets.right - (self.columnCount - 1) * self.columnMagin) / self.columnCount;
    //获取size
    if ([self.delegate respondsToSelector:@selector(layout:itemWidth:atIndexPath:)]){
        CGSize size = [self.delegate layout:self itemWidth:width atIndexPath:indexPath];
        width = size.width?:width;
        height = size.height;
    }
   
    //获取X （瀑布流的实现重点就在cell的X，Y值获取）
    //设置一个列数的中间变量
    NSInteger tempColumn = 0;
    //设置高度小的中间变量 在这里我们把第0列的高度给他，这样可以减少循环次数，提高效率
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i ++) {
        if (minColumnHeight > [self.columnHeights[i] doubleValue]) {
            minColumnHeight = [self.columnHeights[i] doubleValue];
            tempColumn = i;
        }
    }
    X = self.defaultEdgeInsets.left + (width + self.columnMagin) * tempColumn;
    //获取Y
    Y = minColumnHeight;
    if (Y != self.defaultEdgeInsets.top) {
        Y += self.rowMagin;
    }
    //设置cell的frame
    attributes.frame = CGRectMake(X, Y, width, height);
    //更新高度最矮的那列的高度
    self.columnHeights[tempColumn] = @(CGRectGetMaxY(attributes.frame));
    
    return attributes;
}
//返回collegeView的Content的大小
- (CGSize)collectionViewContentSize{
    //虽说返回的是大小，但是我们这里主要的是height
    CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {

        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        
        if (maxColumnHeight < columnHeight) {
            maxColumnHeight = columnHeight;
        }
    }
    return CGSizeMake(0, maxColumnHeight + self.defaultEdgeInsets.bottom);
}

@end
