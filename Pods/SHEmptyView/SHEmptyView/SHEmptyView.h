//
//  SHEmptyView.h
//  SHEmptyViewExample
//
//  Created by CSH on 2020/9/23.
//

#import <UIKit/UIKit.h>
#import "UIView+SHExtension.h"

//类型
typedef enum : NSUInteger {
    SHEmptyViewType_default,
    SHEmptyViewType_error,
    SHEmptyViewType_search,
    SHEmptyViewType_custom,
} SHEmptyViewType;

NS_ASSUME_NONNULL_BEGIN

@interface SHEmptyView : UIView

//插图
@property (nonatomic, strong) UIImageView *imgView;
//文本
@property (nonatomic, strong) UILabel *labView;
//按钮
@property (nonatomic, strong) UIButton *btnView;
//图片类型
@property (nonatomic, assign) SHEmptyViewType type;

- (void)reloadView;

@end

NS_ASSUME_NONNULL_END
