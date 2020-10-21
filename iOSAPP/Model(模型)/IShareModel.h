//
//  IShareModel.h
//  iOSAPP
//
//  Created by CSH on 2020/10/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 分享
@interface IShareModel : SHBaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *imgurl;
@property (nonatomic, copy) NSString *linkUrl;

@end

NS_ASSUME_NONNULL_END
