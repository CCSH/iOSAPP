



//
//  WMZDropMenuBtn.m
//  WMZDropDownMenu
//
//  Created by wmz on 2019/11/20.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZDropMenuBtn.h"

@implementation WMZDropMenuBtn

- (void)setUpParam:(WMZDropMenuParam*)param withDic:(id)dic{
    self.tj_acceptEventInterval = 0.3;
    self.param = param;
    BOOL dictionary = [dic isKindOfClass:[NSDictionary class]];
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    if ([dic isKindOfClass:[NSString class]]) {
        [self setTitle:dic forState:UIControlStateNormal];
    }else if([dic isKindOfClass:[NSDictionary class]]){
        [self setTitle:dic[@"name"] forState:UIControlStateNormal];
    }
    CGFloat font = 14.0;
    if (dictionary&&dic[@"font"]) {font = [dic[@"font"]floatValue];}
    if (dictionary&&dic[@"fontObject"]&&[dic[@"fontObject"] isKindOfClass:[UIFont class]]) {
        self.titleLabel.font = dic[@"fontObject"];
    }else{
        self.titleLabel.font = [UIFont systemFontOfSize:font];
    }
    UIColor *normalColor = self.param.wCollectionViewCellTitleColor;
    if (dictionary&&dic[@"normalColor"]) {normalColor = dic[@"normalColor"];}
    UIColor *selectColor = self.param.wCollectionViewCellSelectTitleColor;
    if (dictionary&&dic[@"selectColor"]) {selectColor = dic[@"selectColor"];}
    if (dictionary&&dic[@"reSelectImage"]) {self.reSelectImage = dic[@"reSelectImage"];}
    if (dictionary&&dic[@"selectTitle"]) {self.selectTitle = dic[@"selectTitle"];}
    if (dictionary&&dic[@"reSelectTitle"]) {self.reSelectTitle = dic[@"reSelectTitle"];}
    NSString *seletImage = nil;
    if (dictionary&&dic[@"selectImage"]) {
        seletImage = dic[@"selectImage"];
    }else{
        if (dictionary) {
            if (!dic[@"hideDefatltImage"]||
                (dic[@"hideDefatltImage"]&&![dic[@"hideDefatltImage"] boolValue])) {
                 seletImage = @"menu_xiangshang";
            }
        }
    }
    NSString *normalImage = nil;
    if (dictionary&&dic[@"normalImage"]) {
        normalImage = dic[@"normalImage"];
    }else{
        if (dictionary) {
            if (!dic[@"hideDefatltImage"]||
                (dic[@"hideDefatltImage"]&&![dic[@"hideDefatltImage"] boolValue])) {
                normalImage = @"menu_xiangxia";
            }
        }
    }
    if ((dictionary&&dic[@"normalImage"])&&(dictionary&&!dic[@"selectImage"])) {
        seletImage = dic[@"normalImage"];
    }
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    self.normalImage = normalImage;
    self.selectImage = seletImage;
    self.normalColor = normalColor;
    self.selectColor = selectColor;
    [self setImage:normalImage?[UIImage bundleImage:normalImage]:nil forState:UIControlStateNormal];
    [self setImage:seletImage?[UIImage bundleImage:seletImage]:nil forState:UIControlStateSelected];
    [self setTitleColor:normalColor forState:UIControlStateSelected];
    self.normalTitle = [self titleForState:UIControlStateNormal];
    if (self.selectTitle) {
        [self setTitle:self.selectTitle forState:UIControlStateSelected];
    }
}

- (MenuBtnPosition)position{
    if (!_position) {
        _position = MenuBtnPositionRight;
    }
    return _position;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
    [WMZDropMenuTool TagSetImagePosition:self.position spacing:self.param.wMenuTitleSpace button:self];
}
@end

static char lineViewKey;
@implementation WMZDropMenuBtn (WMZLine)

- (void)showLine:(NSDictionary*)config
{
    if (self.line == nil||[[self subviews] indexOfObject:self.line]==NSNotFound) {
        CGRect frame = CGRectMake((self.frame.size.width - 30)/2, self.frame.size.height-5, 30, 3);
        self.line = [[UIView alloc] initWithFrame:frame];
        self.line.backgroundColor = [UIColor menuColorGradientChangeWithSize:self.line.frame.size direction:MenuGradientChangeDirectionLevel startColor:MenuColor(0xf92921) endColor:MenuColor(0xffc1bd)];
        [self addSubview:self.line];
        [self bringSubviewToFront:self.line];
    }
}

- (void)hidenLine
{
    if (self.line) {
        [self.line removeFromSuperview];
    }
}

#pragma mark - GetterAndSetter
- (UIView *)line
{
    return objc_getAssociatedObject(self, &lineViewKey);
}

- (void)setLine:(UIView *)line
{
    objc_setAssociatedObject(self, &lineViewKey, line, OBJC_ASSOCIATION_RETAIN);
}


@end

#import <objc/runtime.h>
@implementation WMZDropMenuBtn (Time)
static const char *UIButton_acceptEventInterval = "UIButton_TJ_acceptEventInterval";
static const char *UIButton_acceptEventTime     = "UIButton_TJ_acceptEventTime";
- (NSTimeInterval )tj_acceptEventInterval{
    return [objc_getAssociatedObject(self, UIButton_acceptEventInterval) doubleValue];
}
-(void)setTj_acceptEventInterval:(NSTimeInterval)tj_acceptEventInterval{
    objc_setAssociatedObject(self, UIButton_acceptEventInterval, @(tj_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval )tj_acceptEventTime{
    return [objc_getAssociatedObject(self, UIButton_acceptEventTime) doubleValue];
}
- (void)setTj_acceptEventTime:(NSTimeInterval)tj_acceptEventTime{
    objc_setAssociatedObject(self, UIButton_acceptEventTime, @(tj_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
+ (void)load{
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    Method myMethod = class_getInstanceMethod(self, @selector(tj_sendAction:to:forEvent:));
    SEL mySEL = @selector(tj_sendAction:to:forEvent:);
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    if (didAddMethod) {
        class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, myMethod);
    }
}
- (void)tj_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    //判断时间差
    if (NSDate.date.timeIntervalSince1970 - self.tj_acceptEventTime < self.tj_acceptEventInterval) {
        return;
    }
    //记录时间
    if (self.tj_acceptEventInterval > 0) {
        self.tj_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    //执行点击事件
    [self tj_sendAction:action to:target forEvent:event];
}
@end
