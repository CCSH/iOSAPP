//
//  IServerBaseModel.h
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IServerBaseModel : NSObject

//结果
@property (nonatomic, copy) NSString *result;
//提示信息
@property (nonatomic, copy) NSString *message;
//内容
@property (nonatomic, copy) id data;

@end
