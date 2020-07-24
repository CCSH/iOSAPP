//
//  SHAlertView.h
//  SHAlertViewExmpale
//
//  Created by CSH on 2018/8/24.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHClickTextView.h"

#define kSHWidth  [UIScreen mainScreen].bounds.size.width
#define kSHHeight  [UIScreen mainScreen].bounds.size.height
//弹框宽
#define kAlertContentWidth MIN(kSHWidth*0.75, 300)

typedef void(^AlertSureAction) (void);
typedef void(^AlertCancelAction) (void);
typedef void(^AlertTextAction) (NSString *parameter);

/**
 悬浮框
 */
@interface SHAlertView : UIView

//回调
//取消回调
@property (nonatomic, copy) AlertCancelAction cancelAction;
//确认回调
@property (nonatomic, copy) AlertSureAction sureAction;
//文本回调
@property (nonatomic, copy) AlertTextAction textAction;

//是否用默认动画(淡入淡出)
@property (nonatomic, assign) BOOL isAnimation;

/**
 初始化(标准)

 @param title 标题 (可以是 NSString、NSAttributedString)
 @param message 内容 (可以是 NSString、NSAttributedString)
 @param cancelTitle 取消名称
 @param sureTitle 确认名称
 */
- (instancetype)initWithTitle:(id)title
                      message:(id)message
                  cancelTitle:(NSString *)cancelTitle
                    sureTitle:(NSString *)sureTitle;
/**
 初始化(富文本)

 @param title 标题 (可以是 NSString、NSAttributedString)
 @param messageAtt 内容(富文本)
 @param parameArr 属性集合(SHClickTextModel)
 @param cancelTitle 取消名称
 @param sureTitle 确认名称
 */
- (instancetype)initWithTitle:(id)title
                   messageAtt:(NSAttributedString *)messageAtt
                    parameArr:(NSArray <SHClickTextModel *>*)parameArr
                  cancelTitle:(NSString *)cancelTitle
                    sureTitle:(NSString *)sureTitle;


/**
 初始化(插画)

 @param image 插画
 @param cancelTitle 取消名称
 @param sureTitle 确认名称
 */
- (instancetype)initWithImage:(UIImage *)image
                  cancelTitle:(NSString *)cancelTitle
                    sureTitle:(NSString *)sureTitle;


/**
 初始化(图标)

 @param icon 图标
 @param message 内容(可以是 NSString、NSAttributedString)
 @param cancelTitle 取消名称
 @param sureTitle 确认名称
 */
- (instancetype)initWithIcon:(UIImage *)icon
                      message:(id)message
                  cancelTitle:(NSString *)cancelTitle
                    sureTitle:(NSString *)sureTitle;

/**
 初始化(图标、自定义视图)
 
 @param view 自定义视图
 @param cancelTitle 取消名称
 @param sureTitle 确认名称
 */
- (instancetype)initWithIcon:(UIImage *)icon
                        view:(UIView *)view
                 cancelTitle:(NSString *)cancelTitle
                   sureTitle:(NSString *)sureTitle;

/**
 初始化(自定义视图)

 @param view 自定义视图
 @param cancelTitle 取消名称
 @param sureTitle 确认名称
 */
- (instancetype)initWithView:(UIView *)view
                 cancelTitle:(NSString *)cancelTitle
                   sureTitle:(NSString *)sureTitle;


/**
 显示在window上
 */
- (void)show;

/**
 显示在指定的View上

 @param inView 指定View
 */
- (void)showInView:(UIView *)inView;

@end
