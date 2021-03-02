//
//  SHBaseTableViewCell.m
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHBaseTableViewCell.h"

@implementation SHBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCustomView:(UIView *)customView{
    if (_customView != customView) {
        [_customView removeFromSuperview];
    }
    _customView = customView;
    if (![self.contentView.subviews containsObject:customView])
    {
        [self.contentView addSubview:customView];
    }
}

#pragma mark - 懒加载
- (UIView *)divider{
    if (!_divider) {
        _divider = [[UIView alloc]init];
        [self.contentView addSubview:_divider];
        _divider.backgroundColor = kColorDivider;
        _divider.hidden = YES;
        [_divider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.5);
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
    }
    return _divider;
}

@end
