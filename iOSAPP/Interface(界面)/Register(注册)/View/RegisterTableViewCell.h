//
//  RegisterTableViewCell.h
//  iOSAPP
//
//  Created by CCSH on 2021/9/10.
//  Copyright © 2021 CSH. All rights reserved.
//

#import "SHBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

/// 注册cell
@interface RegisterTableViewCell : SHBaseTableViewCell

@property (nonatomic, strong) SHButton *codeBtn;

@property (nonatomic, strong) NSDictionary *data;

@end

NS_ASSUME_NONNULL_END
