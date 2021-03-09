//
//  SHEmptyView.h
//  SHEmptyViewExample
//
//  Created by CSH on 2020/9/23.
//

#import <UIKit/UIKit.h>
#import <UIView+SHExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHEmptyView : UIView

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *labView;

@property (nonatomic, strong) UIButton *btnView;

- (void)reloadView;

@end

NS_ASSUME_NONNULL_END
