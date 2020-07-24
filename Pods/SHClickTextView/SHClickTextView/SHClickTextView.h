//
//  SHClickTextView.h
//  SHClickTextView
//
//  Created by CSH on 2018/6/12.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SHClickTextView,SHClickTextModel;
//文字局部点击回调
typedef void (^SHClickTextBlock)(SHClickTextModel *model,SHClickTextView *textView);

/**
 文字局部点击视图
 */
@interface SHClickTextView : UITextView

//链接属性(颜色，字体大小等)
@property (nonatomic, copy) NSDictionary *linkAtts;
//链接属性(需要提前设置attributedText)
@property (nonatomic, copy) NSArray <SHClickTextModel *>*linkArr;
//回调
@property (nonatomic, copy) SHClickTextBlock clickTextBlock;

//如果UITextViewDelegate在其他地方实现 请在
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
//中执行此方法（返回YES则是我的链接 NO则不是）
- (BOOL)didSelectLinkWithUrl:(NSURL *)URL;

@end

/**
 文字局部点击Model
 */
@interface SHClickTextModel : NSObject

//参数
@property (nonatomic, copy) id parameter;
//范围
@property (nonatomic, assign) NSRange range;

@end


