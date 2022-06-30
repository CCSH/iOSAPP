//
//  SHToolHelper.m
//  iOSAPP
//
//  Created by CCSH on 2021/5/12.
//  Copyright © 2021 CSH. All rights reserved.
//

#import "SHToolHelper.h"
#import <MapKit/MapKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>

@implementation SHToolHelper

#pragma mark 占位图
+ (UIImage *)placeholderImage {
    return [UIImage imageNamed:@"loadfail"];
}

#pragma mark 地图导航
+ (void)mapNavigationWithLon:(CGFloat)lon lat:(CGFloat)lat name:(NSString *)name {
    
//    SHActionSheetView *sheet = [[SHActionSheetView alloc] init];
//    SHActionSheetModel *model = [[SHActionSheetModel alloc] init];
//    model.title = @"导航";
//    NSMutableArray *temp = [[NSMutableArray alloc]init];
//    NSString *appName = [SHTool appName];
//    //苹果导航
//    [temp addObject:@"Apple导航"];
//    //百度
//    NSString *baidu = [NSString stringWithFormat:@"baidumap://map/marker?location=%f,%f&title=%@&content=%@", lat, lon, name,appName];
//    baidu = [baidu stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:baidu]]) {
//        [temp addObject:@"百度导航"];
//    }
//    //高德
//    NSString *gaode = [NSString stringWithFormat:@"iosamap://path?dlat=%f&dlon=%f&dname=%@&dev=0&t=0&sourceApplication=%@",lat, lon,name,appName];
//    gaode = [gaode stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:gaode]]) {
//        [temp addObject:@"高德导航"];
//    }
//    //腾讯
//    NSString *tengxun = [NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&tocoord=%f,%f&referer=%@",lat,lon,@"X2OBZ-PZKCO-TCOW5-STPML-CSSE6-FEBQ4"];
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:tengxun]]) {
//        [temp addObject:@"腾讯导航"];
//    }
//
//    model.messageArr = temp;
//    sheet.model = model;
//    sheet.style = SHActionSheetStyle_system;
//
//    sheet.block = ^(SHActionSheetView *sheetView, NSInteger buttonIndex) {
//        if (buttonIndex >= 0) {
//            NSString *select = model.messageArr[buttonIndex];
//            if ([select isEqualToString:@"Apple导航"]) {
//                CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lon);
//
//                //当前地址
//                MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//
//                MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:nil]];
//                toLocation.name = name;
//                [MKMapItem openMapsWithItems:@[ currentLocation, toLocation ]
//                               launchOptions:@{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
//                                               MKLaunchOptionsShowsTrafficKey : [NSNumber numberWithBool:YES]}];
//            } else if ([select isEqualToString:@"百度导航"]) {
//
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:baidu] options:@{} completionHandler:nil];
//            } else if ([select isEqualToString:@"高德导航"]) {
//
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:gaode] options:@{} completionHandler:nil];
//            } else if ([select isEqualToString:@"腾讯导航"]) {
//
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tengxun] options:@{} completionHandler:nil];
//            }
//        }
//    };
//    [sheet show];
}

#pragma mark 获取头部view
+ (UIView *)getHeadViewWithName:(NSString *)name{
    UIView *view = [[UIView alloc]init];
    view.size = CGSizeMake(kSHWidth, kHeadH);
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(10, 0, kSHWidth - 20, kHeadH);
    lab.font = kFontBold(16);
    lab.text = name;
    
    [view addSubview:lab];
    return view;
}

#pragma mark 是否登录
+ (BOOL)isLogin{
    if ([self getUserId].length) {
        return YES;
    }
    return NO;
}

#pragma mark 需要登录
+ (BOOL)needLogin{
    if ([self isLogin]) {
        return YES;
    }
    [self gotoLogin];
    return NO;
}

#pragma mark 去登录
+ (void)gotoLogin{
    [SHRouting routingWithUrl:[SHRouting getUrlWithName:RoutingName_login]
                         type:SHRoutingType_modal
                        block:nil];
}

#pragma mark 登录成功
+ (void)loginSuccess:(SHRequestBaseModel *)obj{
    IUserModel *model = [IUserModel mj_objectWithKeyValues:obj.data];
    [SHSQLite addLoginInfoWithModel:model];
    
    AppDelegate *app = kAppDelegate;
    app.userInfo = model;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotLoginSuccess object:nil];
}

#pragma mark 退出登录
+ (void)loginOut{
    [SHSQLite deleteLoginInfo];
    
    AppDelegate *app = kAppDelegate;
    app.userInfo = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotLoginOut object:nil];
}

#pragma mark 获取用户ID
+ (NSString *)getUserId{
    AppDelegate *app = kAppDelegate;
    return app.userInfo.user_id ?: @"";
}

#pragma mark 配置图片选择器
+ (TZImagePickerController *)configImgPicker:(TZImagePickerController *)vc {
    vc.naviBgColor = kColorMain;
    vc.naviTitleColor = [UIColor whiteColor];
    vc.barItemTextColor = [UIColor whiteColor];
    vc.allowPickingVideo = NO;
    vc.allowPickingGif = NO;
    vc.preferredLanguage = @"zh-Hans";
    vc.oKButtonTitleColorNormal = [UIColor whiteColor];
    vc.oKButtonTitleColorDisabled = [UIColor whiteColor];
    vc.iconThemeColor = kColorMain;
    return vc;
}

#pragma mark 获取按钮
+ (SHButton *)getBtn{
    SHButton *btn = [SHButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = kColorMain;
    [btn borderRadius:8];
    return btn;
}

#pragma mark 更换图标
+ (void)changeIcon:(NSString *)icon{
    
    if (![[UIApplication sharedApplication] supportsAlternateIcons]) {
        return;
    }
    [[UIApplication sharedApplication] setAlternateIconName:icon completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"更换app图标发生错误了： %@",error);
        }
    }];
}

@end
