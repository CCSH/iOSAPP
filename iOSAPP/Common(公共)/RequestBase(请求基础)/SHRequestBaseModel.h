//
//  SHRequestBaseModel.h
//  SHNetworkRequest
//
//  Created by CSH on 2019/5/31.
//  Copyright © 2019 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SHRequestBaseModel;

NS_ASSUME_NONNULL_BEGIN

//回调
typedef void (^RequestBlock)(SHRequestBaseModel *baseModel, NSError *error);

/**
 网络请求model
 */
@interface SHRequestBaseModel : NSObject

//请求code
@property (nonatomic, copy) NSString *result;
//请求文本
@property (nonatomic, copy) NSString *msg;
//内容
@property (nonatomic, strong) id data;

@end

NS_ASSUME_NONNULL_END
