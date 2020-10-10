//
//  UIScrollView+SHExtension.h
//  
//
//  Created by jxdwinter on 2020/7/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^RefreshHeaderCallback)(void);
typedef void (^RefreshFooterCallback)(void);

@interface UIScrollView (SHExtension)

// 添加刷新UI
- (void)refreshHeaderBlock:(RefreshHeaderCallback)block;
// 添加加载UI
- (void)refreshFooterBlock:(RefreshFooterCallback)block;

//停止所有加载的状态
- (void)stopAllLoadingStatus;

@end

NS_ASSUME_NONNULL_END
