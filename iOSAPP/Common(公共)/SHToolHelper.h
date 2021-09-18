//
//  SHToolHelper.h
//  iOSAPP
//
//  Created by CCSH on 2021/5/12.
//  Copyright © 2021 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TZImagePickerController.h"
@class SHButton;

NS_ASSUME_NONNULL_BEGIN

@interface SHToolHelper : NSObject

#pragma mark 占位图
+ (UIImage *)placeholderImage;

#pragma mark 地图导航
+ (void)mapNavigationWithLon:(CGFloat)lon lat:(CGFloat)lat name:(NSString *)name;

#pragma mark 获取头部view
+ (UIView *)getHeadViewWithName:(NSString *)name;

#pragma mark 是否登录
+ (BOOL)isLogin;

#pragma mark 需要登录
+ (BOOL)needLogin;

#pragma mark 登录成功
+ (void)loginSuccess:(SHRequestBaseModel *)obj;

#pragma mark 退出登录
+ (void)loginOut;

#pragma mark 去登录
+ (void)gotoLogin;

#pragma mark 获取用户ID
+ (NSString *)getUserId;

#pragma mark 配置图片选择器
+ (TZImagePickerController *)configImgPicker:(TZImagePickerController *)vc;

#pragma mark 获取按钮
+ (SHButton *)getBtn;

@end

NS_ASSUME_NONNULL_END
