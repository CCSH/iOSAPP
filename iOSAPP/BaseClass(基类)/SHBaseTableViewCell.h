//
//  SHBaseTableViewCell.h
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHBaseTableViewCell : UITableViewCell

//自定义视图
@property (nonatomic, strong) UIView *customView;
//分割线
@property (nonatomic, strong) UIView *divider;

@end

NS_ASSUME_NONNULL_END
