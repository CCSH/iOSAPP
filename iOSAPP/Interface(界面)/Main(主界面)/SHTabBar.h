//
//  SHTabbar.h
//  FengRuiNong
//
//  Created by CSH on 2020/9/11.
//  Copyright © 2020 Xiaodong Jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHTabBar : UITabBar

@property (nonatomic, strong) NSArray *dataArr;

#pragma mark  - tabbar点击
- (void)didSelectItem:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
