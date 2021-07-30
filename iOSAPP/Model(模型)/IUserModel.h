//
//  IUserModel.h
//  iOSAPP
//
//  Created by CSH on 2018/3/20.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "SHBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 用户
@interface IUserModel : SHBaseModel

@property (nonatomic, copy) NSString *user_id;

@end

NS_ASSUME_NONNULL_END
