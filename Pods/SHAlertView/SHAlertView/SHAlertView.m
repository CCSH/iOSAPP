//
//  SHAlertView.m
//  SHAlertViewExmpale
//
//  Created by CSH on 2018/8/24.
//  Copyright © 2018年 CSH. All rights reserved.
// 

#import "SHAlertView.h"

@interface SHAlertView ()

//主体
@property (nonatomic, strong) UIView *mainView;

//标题
@property (nonatomic, strong) UILabel *titleLab;
//内容
@property (nonatomic, strong) SHClickTextView *messageText;
//取消
@property (nonatomic, strong) UIButton *cancelBtn;
//确认
@property (nonatomic, strong) UIButton *surelBtn;

@end;

@implementation SHAlertView

#pragma mark - 懒加载
//主体
- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [[UIView alloc]init];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _mainView.layer.cornerRadius = 4;
        _mainView.userInteractionEnabled = YES;
        [self addSubview:_mainView];
    }
    return _mainView;
}

//标题
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc]init];
        _titleLab.frame = CGRectMake(15, 0, kAlertContentWidth - 2*15, 0);
        _titleLab.font = [UIFont systemFontOfSize:20];
        _titleLab.numberOfLines = 0;
        _titleLab.textColor = [UIColor blackColor];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self.mainView addSubview:_titleLab];
    }
    return _titleLab;
}

//内容
- (SHClickTextView *)messageText{
    if (!_messageText) {
        _messageText = [[SHClickTextView alloc]init];
        _messageText.userInteractionEnabled = YES;
        _messageText.frame = CGRectMake(15, 0, kAlertContentWidth - 2*15, 0);
        _messageText.font = [UIFont systemFontOfSize:16];
        _messageText.textColor = [UIColor lightGrayColor];
        [self.mainView addSubview:_messageText];
    }
    return _messageText;
}

//取消
- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, 0, kAlertContentWidth, 48);
        _cancelBtn.backgroundColor = [UIColor whiteColor];
        _cancelBtn.tag = 1;
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelBtn setTitleColor:[UIColor darkGrayColor] forState:0];
        [_cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:_cancelBtn];
    }
    return _cancelBtn;
}

//确认
- (UIButton *)surelBtn{
    if (!_surelBtn) {
        _surelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _surelBtn.frame = CGRectMake(0, 0, kAlertContentWidth, 48);
        _surelBtn.backgroundColor = [UIColor whiteColor];
        _surelBtn.tag = 2;
        _surelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_surelBtn setTitleColor:[UIColor orangeColor] forState:0];
        [_surelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:_surelBtn];
    }
    return _surelBtn;
}

#pragma mark - 私有方法
#pragma mark 配置UI
- (void)configUI{
    
    self.frame = CGRectMake(0, 0, kSHWidth, kSHWidth);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
}

#pragma mark 点击方法
- (void)btnAction:(UIButton *)btn{
    switch (btn.tag) {
        case 1://取消
        {
            if (self.cancelAction) {
                self.cancelAction();
            }
        }
            break;
        case 2://确认
        {
            if (self.sureAction) {
                self.sureAction();
            }
        }
            break;
        default:
            break;
    }
    
    [self hideView];
}

#pragma mark - 添加组件
#pragma mark 添加标题
- (CGFloat)addTitle:(id)title viewY:(CGFloat)viewY{
    
    if ([title length]) {
        
        NSAttributedString *titleAtt;
        
        if ([title isKindOfClass:[NSString class]]) {//字符串
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = 4;
            style.alignment = NSTextAlignmentCenter;
            
            NSDictionary *config = @{NSFontAttributeName:self.titleLab.font,
                                     NSForegroundColorAttributeName:self.titleLab.textColor,
                                     NSParagraphStyleAttributeName:style};
            titleAtt = [[NSAttributedString alloc] initWithString:title attributes:config];
            
        }else if ([titleAtt isKindOfClass:[NSAttributedString class]]){//富文本
            
            titleAtt = title;
        }
        
        self.titleLab.attributedText = titleAtt;
        
        CGSize size = [titleAtt boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.titleLab.frame), CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        CGRect frame = self.titleLab.frame;
        frame.size.height = ceil(size.height);
        frame.origin.y = viewY;
        self.titleLab.frame = frame;
        
        viewY = CGRectGetMaxY(self.titleLab.frame) + 15;
    }
    return viewY;
}

#pragma mark 添加内容
- (CGFloat)addMessage:(id)message viewY:(CGFloat)viewY{
    
    if ([message length]) {
        
        NSAttributedString *messageAtt;
        
        if ([message isKindOfClass:[NSString class]]) {//字符串
            
            NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
            style.lineSpacing = 4;
            style.alignment = NSTextAlignmentCenter;
            
            NSDictionary *config = @{NSFontAttributeName:self.messageText.font,
                                     NSForegroundColorAttributeName:self.messageText.textColor,
                                     NSParagraphStyleAttributeName:style};
            messageAtt = [[NSAttributedString alloc] initWithString:message attributes:config];
            
        }else if ([message isKindOfClass:[NSAttributedString class]]){//富文本
            
            messageAtt = messageAtt;
        }
        
        self.messageText.attributedText = messageAtt;
        
        CGSize size = [messageAtt boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.messageText.frame), CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        CGRect frame = self.messageText.frame;
        frame.size.height = ceil(size.height);
        frame.origin.y = viewY;
        self.messageText.frame = frame;
        
        viewY = CGRectGetMaxY(self.messageText.frame) + 15;
    }
    return viewY;
}

#pragma mark 添加自定义视图
- (CGFloat)addView:(UIView *)view viewY:(CGFloat)viewY{
    
    if (view) {
        view.frame = CGRectMake(CGRectGetMinX(view.frame), viewY + CGRectGetMinY(view.frame), CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
        [self.mainView addSubview:view];
        viewY = CGRectGetMaxY(view.frame);
    }
    return viewY;
}

#pragma mark 添加图标
- (CGFloat)addIcon:(UIImage *)icon viewY:(CGFloat)viewY{
    
    if (icon) {
        //icon size
        CGSize size = CGSizeMake(kAlertContentWidth/3, kAlertContentWidth/3*icon.size.height/icon.size.width);
        //添加图片
        NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
        // 标记图片
        attchImage.image = icon;
        // 设置图片大小
        attchImage.bounds = CGRectMake(0, 0, size.width, size.height);
        
        NSMutableAttributedString *iconAtt = [[NSMutableAttributedString alloc] init];
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        [iconAtt appendAttributedString:[NSAttributedString attributedStringWithAttachment:attchImage]];
        [iconAtt addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, iconAtt.length)];
        
        self.titleLab.userInteractionEnabled = NO;
        self.titleLab.attributedText = iconAtt;
        
        self.titleLab.frame = CGRectMake(0, -size.height/2, kAlertContentWidth, size.height);
        
        viewY = CGRectGetHeight(self.titleLab.frame)/2 + 15;
    }
    
    return viewY;
}

#pragma mark 添加插画
- (CGFloat)addImage:(UIImage *)image viewY:(CGFloat)viewY{
    
    if (image) {
        
        self.messageText.backgroundColor = [UIColor clearColor];
        
        CGFloat image_h = (image.size.height*kAlertContentWidth)/image.size.width;
        //添加图片
        NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
        // 标记图片
        attchImage.image = image;
        // 设置图片大小
        attchImage.bounds = CGRectMake(0, 0, kAlertContentWidth, image_h);
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        
        NSMutableAttributedString *messageAtt = [[NSMutableAttributedString alloc] init];
        [messageAtt appendAttributedString:[NSAttributedString attributedStringWithAttachment:attchImage]];
        [messageAtt addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, messageAtt.length)];
        
        self.messageText.userInteractionEnabled = NO;
        self.messageText.attributedText = messageAtt;
        
        self.messageText.frame = CGRectMake(0, 0, kAlertContentWidth, image_h);
        
        viewY = CGRectGetMaxY(self.messageText.frame);
    }
    return viewY;
}

#pragma mark 添加链接点击
- (CGFloat)addClickMessageAtt:(NSAttributedString *)messageAtt parameArr:(NSArray <SHClickTextModel *>*)parameArr viewY:(CGFloat)viewY{
    
    if (messageAtt.length) {
        
        self.messageText.attributedText = messageAtt;
        self.messageText.linkArr = parameArr;
        __weak typeof(self) weakSelf = self;
        self.messageText.clickTextBlock = ^(SHClickTextModel *model, SHClickTextView *textView) {
            if (weakSelf.textAction) {
                weakSelf.textAction(model.parameter);
            }
        };
        
        CGSize size = [messageAtt boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.messageText.frame), CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        CGRect frame = self.messageText.frame;
        frame.size.height = ceil(size.height);
        frame.origin.y = viewY;
        self.messageText.frame = frame;
        
        viewY = CGRectGetMaxY(self.messageText.frame) + 15;
    }
    return viewY;
}

#pragma mark 添加分割线
- (CGFloat)addLineWithViewY:(CGFloat)viewY{
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, viewY, kAlertContentWidth,0.5);
    line.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    [self.mainView.layer addSublayer:line];
    
    viewY += CGRectGetHeight(line.frame) + 1;
    
    return viewY;
}

#pragma mark 添加取消确定
- (void)addCancel:(NSString *)cancel sure:(NSString *)sure viewY:(CGFloat)viewY{
    
    //取消
    if (cancel.length) {
        [self.cancelBtn setTitle:cancel forState:0];
        
        CGRect frame = self.cancelBtn.frame;
        frame.origin.y = viewY;
        self.cancelBtn.frame = frame;
    }
    
    //确认
    if (sure.length) {
        [self.surelBtn setTitle:sure forState:0];
        CGRect frame = self.surelBtn.frame;
        frame.origin.y = viewY;
        self.surelBtn.frame = frame;
    }
    
    //同时存在
    if (cancel.length && sure.length) {
        //分割线
        CALayer *verLine = [CALayer layer];
        verLine.frame = CGRectMake((kAlertContentWidth - 0.5)/2, viewY, 0.5, 48);
        verLine.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
        [self.mainView.layer addSublayer:verLine];
        
        CGRect frame = self.cancelBtn.frame;
        frame.size.width = kAlertContentWidth/2;
        
        self.cancelBtn.frame = frame;
        frame.origin.x = kAlertContentWidth/2;
        self.surelBtn.frame = frame;
    }
    
    if (cancel.length || sure.length) {
        viewY += 48;
    }
    
    CGRect frame = CGRectMake(0, 0, kAlertContentWidth, viewY);
    self.mainView.frame = frame;
    self.mainView.center = self.center;
}

#pragma mark - 公开方法
#pragma mark 初始化(标准)
- (instancetype)initWithTitle:(id)title
                      message:(id)message
                  cancelTitle:(NSString *)cancelTitle
                    sureTitle:(NSString *)sureTitle{
    
    if (self = [super init]) {
    
        //配置UI
        [self configUI];
        
        //标题不存在，内容存在
        if (![title length] && [message length]) {
            title = message;
            message = nil;
        }
        
        CGFloat view_y = 15;
        
        //标题
        view_y = [self addTitle:title viewY:view_y];
        
        //内容
        view_y = [self addMessage:message viewY:view_y];
        
        //分割线
        if ([message length] || [title length]) {
            
            view_y = [self addLineWithViewY:view_y];
        }else{
            
            view_y = 0;
        }
        
        //取消确定
        [self addCancel:cancelTitle sure:sureTitle viewY:view_y];
    }
    return self;
}

#pragma mark 初始化(富文本)
- (instancetype)initWithTitle:(id)title
                   messageAtt:(NSAttributedString *)messageAtt
                    parameArr:(NSArray <SHClickTextModel *>*)parameArr
                  cancelTitle:(NSString *)cancelTitle
                    sureTitle:(NSString *)sureTitle{
    
    if (self = [super init]) {
        
        //配置UI
        [self configUI];
        
        CGFloat view_y = 15;
        
        //标题
        view_y = [self addTitle:title viewY:view_y];
        
        //链接点击
        view_y = [self addClickMessageAtt:messageAtt parameArr:parameArr viewY:view_y];
        
        //分割线
        if (messageAtt.length || [title length]) {
            
            view_y = [self addLineWithViewY:view_y];
        }else{
            
            view_y = 0;
        }
        
        //取消确定
        [self addCancel:cancelTitle sure:sureTitle viewY:view_y];
    }
    return self;
}


#pragma mark 初始化(插画)
- (instancetype)initWithImage:(UIImage *)image
                  cancelTitle:(NSString *)cancelTitle
                    sureTitle:(NSString *)sureTitle{
    
    if (self = [super init]) {
        
        //配置UI
        [self configUI];
        
        CGFloat view_y = 15;
        
        //插画
        view_y = [self addImage:image viewY:view_y];
        
        //分割线
        if (image) {
            view_y = [self addLineWithViewY:view_y];
        }else{
            view_y = 0;
        }
        
        //取消确定
        [self addCancel:cancelTitle sure:sureTitle viewY:view_y];
    }
    return self;
}

#pragma mark 初始化(图标)
- (instancetype)initWithIcon:(UIImage *)icon
                     message:(id)message
                 cancelTitle:(NSString *)cancelTitle
                   sureTitle:(NSString *)sureTitle{
    
    if (self = [super init]) {
        
        //配置UI
        [self configUI];
        
        CGFloat view_y = 15;
        
        //图标
        view_y = [self addIcon:icon viewY:view_y];
        
        //内容
        view_y = [self addMessage:message viewY:view_y];
        
        //分割线
        if ((icon || [message length])) {
            
            view_y = [self addLineWithViewY:view_y];
        }else{
            view_y = 0;
        }
        
        //取消确定
        [self addCancel:cancelTitle sure:sureTitle viewY:view_y];
    }
    return self;
    
}

#pragma mark 初始化(图标、自定义视图)
- (instancetype)initWithIcon:(UIImage *)icon
                        view:(UIView *)view
                 cancelTitle:(NSString *)cancelTitle
                   sureTitle:(NSString *)sureTitle{
    
    if (self = [super init]) {
        
        //配置UI
        [self configUI];
        
        CGFloat view_y = 0;
        
        //图标
        view_y = [self addIcon:icon viewY:view_y];
        
        //自定义视图
        view_y = [self addView:view viewY:view_y];
        
        //分割线
        if (view || icon) {
            view_y = [self addLineWithViewY:view_y];
        }else{
            view_y = 0;
        }
        
        //取消确定
        [self addCancel:cancelTitle sure:sureTitle viewY:view_y];
    }
    return self;
}

#pragma mark 初始化(自定义视图)
- (instancetype)initWithView:(UIView *)view
                 cancelTitle:(NSString *)cancelTitle
                   sureTitle:(NSString *)sureTitle{
    
    if (self = [super init]) {
        
        //配置UI
        [self configUI];
        
        CGFloat view_y = 0;
        //自定义视图
        view_y = [self addView:view viewY:view_y];
        
        //分割线
        if (view) {
            view_y = [self addLineWithViewY:view_y];
        }else{
            view_y = 0;
        }
        
        //取消确定
        [self addCancel:cancelTitle sure:sureTitle viewY:view_y];
    }
    return self;
}

#pragma mark -
#pragma mark 显示在window上
- (void)show{
    [self showInView:[UIApplication sharedApplication].delegate.window];
}

#pragma mark 显示在指定的View上
- (void)showInView:(UIView *)inView{
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth(inView.frame), CGRectGetHeight(inView.frame));
    [inView addSubview:self];
    
    if (self.isAnimation) {
        self.mainView.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.mainView.alpha = 1;
        }];
    }

}

#pragma mark 隐藏
- (void)hideView{
    
    if (self.isAnimation) {
        [UIView animateWithDuration:0.2 animations:^{
            self.mainView = 0;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        [self removeFromSuperview];
    }
}

@end
