//
//  UITableView+SHExtension.m
//  
//
//  Created by jxdwinter on 2020/7/24.
//

#import "UITableView+SHExtension.h"

@implementation UITableView (SHExtension)

- (void)refreshHeaderBlock:(RefreshHeaderCallback)block
{
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
    header.stateLabel.font = [UIFont systemFontOfSize:12];
    header.lastUpdatedTimeLabel.text = @"";
    self.mj_header = header;
}

- (void)refreshFooterBlock:(RefreshFooterCallback)block
{
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:block];
    footer.stateLabel.font = [UIFont systemFontOfSize:12];
    self.mj_footer = footer;
}

- (void)stopAllLoadingStatus
{
    if (self.mj_header.state == MJRefreshStateRefreshing){
        [self.mj_header endRefreshing];
    }
    if (self.mj_footer.state == MJRefreshStateRefreshing){
        [self.mj_footer endRefreshing];
    }
}


@end
