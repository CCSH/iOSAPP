//
//  SHLabelPageView.h
//  SHLabelPageView
//
//  Created by CSH on 2018/7/10.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//标签页类型
typedef enum : NSUInteger {
    SHLabelPageType_more,   //多页(横屏滚动)
    SHLabelPageType_one,    //一页(标签居中)
} SHLabelPageType;

/**
 标签页
 */
@interface SHLabelPageView : UIView

#pragma mark - 必须设置
//数组(NSString、NSAttributedString)
@property (nonatomic, strong) NSArray *pageList;

#pragma mark - 选择设置
//回调(标签点击回调)
@property (nonatomic, copy) void(^pageViewBlock)(NSInteger index);

//类型
@property (nonatomic, assign) SHLabelPageType type;
//当前位置(默认是0)
@property (nonatomic, assign) NSInteger index;

//偏移量(设置滑动中的效果)
@property (nonatomic, assign) CGFloat contentOffsetX;

//方向 (如果是 UICollectionViewScrollDirectionVertical 的 则 type 为 SHLabelPageType_more)
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

#pragma mark 竖直配置(购物类APP分类形式)
//标签高度(默认40)
@property (nonatomic, assign) CGFloat labelH;

#pragma mark 标签布局设置(更改设置需要调用 reloadView)

//标签开始的距离(如果是 SHLabelPageType_one 的话就是居中 此属性失效)
@property (nonatomic, assign) CGFloat start;
//标签间间隔
@property (nonatomic, assign) CGFloat space;

//标签宽度(可以不设置自适应)
@property (nonatomic, assign) CGFloat labelW;

//标签字体大小(默认是加粗16)
@property (nonatomic, strong) UIFont *fontSize;
//标签未选中字体大小(默认是16)
@property (nonatomic, strong) UIFont *unFontSize;
//标签选中颜色(默认是黑色)
@property (nonatomic, strong) UIColor *checkColor;
//标签未选中颜色(默认是黑色 0.3)
@property (nonatomic, strong) UIColor *uncheckColor;

#pragma mark 选中线
//选中线 Y
@property (nonatomic, assign) CGFloat currentLineY;
//选中线图片
@property (nonatomic, strong) UIImage *currentImg;
//选中线 size(默认 height: 4, width: 自适应)
@property (nonatomic, assign) CGSize currentLineSize;
//选中线 自适应后多出间隙(未设置宽度 currentLineSize.width 时需要多余的间隙 如果设置了宽度则 此属性失效)
@property (nonatomic, assign) CGFloat currentLineMargin;

//选中线 弧度(默认 2)
@property (nonatomic, assign) CGFloat currentLineRadius;
//选中线 color(默认 redColor)
@property (nonatomic, strong) UIColor *currentLineColor;

#pragma mark - 其他功能定制
#pragma mark 标记
//key   标记位置
//value frame
@property (nonatomic, strong) NSDictionary *tagConfig;
//标记颜色（默认红色）
@property (nonatomic, strong) UIColor *tagColor;

#pragma mark 刷新
- (void)reloadView;

@end
