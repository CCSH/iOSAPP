//
//  SHWebViewController.h
//  iOSAPP
//
//  Created by CSH on 2020/10/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHBaseViewController.h"
#import "IShareModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHWebViewController : SHBaseViewController

@property (nonatomic, strong) IShareModel *shareModel;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) BOOL needUid;

@property (nonatomic, copy) void (^block)(NSString *name, NSDictionary *param);

@end

NS_ASSUME_NONNULL_END
