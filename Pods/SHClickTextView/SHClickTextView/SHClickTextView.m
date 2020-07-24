//
//  SHClickTextView.m
//  SHClickTextView
//
//  Created by CSH on 2018/6/12.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHClickTextView.h"

@interface SHClickTextView ()<UITextViewDelegate>

@end

@implementation SHClickTextView

static NSString *mark = @"link";

#pragma mark - 实例化
- (instancetype)init {
    self = [super init];
    if (self) {
        //初始化
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setup];
}

#pragma mark - 初始化
- (void)setup{
    
    self.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.editable = NO;
    self.scrollEnabled = NO;
    self.delegate = self;
    self.dataDetectorTypes = UIDataDetectorTypeAll;
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset{
    
    CGFloat padding = self.textContainer.lineFragmentPadding;
    
    [super setTextContainerInset:UIEdgeInsetsMake(textContainerInset.top,textContainerInset.left - padding, textContainerInset.bottom,textContainerInset.right - padding)];
}

#pragma mark - SET
- (void)setLinkAtts:(NSDictionary *)linkAtts{
    _linkAtts = linkAtts;
    self.linkTextAttributes = linkAtts;
}

- (void)setLinkArr:(NSArray<SHClickTextModel *> *)linkArr{
    _linkArr = linkArr;
    //添加链接
    [linkArr enumerateObjectsUsingBlock:^(SHClickTextModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self addClickWithModel:obj idx:idx];
    }];
}

#pragma mark - 添加点击
- (void)addClickWithModel:(SHClickTextModel *)model idx:(NSInteger)idx{
    
    //拿到字符串
    NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    //添加属性
    if (atrString.length && model.range.length) {

        NSString *value = [NSString stringWithFormat:@"%@:%ld",mark,(long)idx];
        //添加点击
        [atrString addAttribute:NSLinkAttributeName value:value range:model.range];
        self.attributedText = atrString;
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    
    if ([self didSelectLinkWithUrl:URL]) {
        return NO;
    }
    return NO;
}

#pragma mark - 点击判断
- (BOOL)didSelectLinkWithUrl:(NSURL *)URL{
    
    if ([URL.scheme isEqualToString:mark]) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __weak typeof(self) weakSelf = self;
            if (self.clickTextBlock) {
                NSInteger idx = [URL.resourceSpecifier integerValue];
                self.clickTextBlock(weakSelf.linkArr[idx], self);
            }
        });
        
        return YES;
    }
    return NO;
}

#pragma mark 拦截系统弹框
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if ([UIMenuController sharedMenuController]){
        
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end


/**
 文字局部点击Model
 */
@implementation SHClickTextModel

@end
