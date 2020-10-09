//
//  SHBaseNavViewController.h
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HideNav
//只要遵守了这个协议，该控制器就会隐藏导航栏
@end

@interface SHBaseNavViewController : UINavigationController

@end

NS_ASSUME_NONNULL_END
