//
//  IUesrModel.m
//  iOSAPP
//
//  Created by CSH on 2018/3/20.
//  Copyright © 2018年 CSH. All rights reserved.
//

#import "IUesrModel.h"

@implementation IUesrModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"_id" : @"id"};
}


+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"banner_list" : @"BannerModel"};
}


@end
