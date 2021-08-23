//
//  SHToolHelper.h
//  iOSAPP
//
//  Created by CCSH on 2021/5/12.
//  Copyright © 2021 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TZImagePickerController.h"

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

#pragma mark 底部安全高度
+ (CGFloat)getSafeBottomH;

#pragma mark 顶部安全高度
+ (CGFloat)getSafeTopH;

#pragma mark app名字
+ (NSString *)appName;

#pragma mark 拨打电话
+ (void)callPhone:(NSString *_Nonnull)phone;

#pragma mark 配置图片选择器
+ (TZImagePickerController *)configImgPicker:(TZImagePickerController *)vc;

#pragma mark 获取推送Token
+ (NSString *)getDeviceToken:(NSData *)deviceToken;

#pragma mark 获取文件夹（没有的话创建）
+ (NSString *)getCreateFilePath:(NSString *)path;

#pragma mark 麦克风权限
+ (void)requestMicrophoneaPemissionsWithResult:(void(^)( BOOL granted))completion;

#pragma mark 相机权限
+ (void)requestCameraPemissionsWithResult:(void(^)( BOOL granted))completion;

@end

NS_ASSUME_NONNULL_END
