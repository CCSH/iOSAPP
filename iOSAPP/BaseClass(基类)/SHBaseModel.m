//
//  SHBaseModel.m
//  iOSAPP
//
//  Created by CSH on 2020/10/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHBaseModel.h"

@implementation SHBaseModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"_id" : @"id"};
}

@end
