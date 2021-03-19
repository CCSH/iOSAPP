//
//  SHEmptyView.m
//  SHEmptyViewExample
//
//  Created by CSH on 2020/9/23.
//

#import "SHEmptyView.h"

@implementation SHEmptyView

- (void)reloadView{
    
    //大小
    self.labView.width = self.width;
    
    self.imgView.centerX = self.centerX;
    self.labView.centerX = self.centerX;
    self.btnView.centerX = self.centerX;
    
    self.labView.y = self.imgView.maxY + 10;
    self.btnView.y = self.labView.maxY + 10;
    
    //设置图片
    switch (self.type) {
        case SHEmptyViewType_default:
        {
            _imgView.image = [self getImageWithName:@"empty-image-default"];
        }
            break;
        case SHEmptyViewType_error:
        {
            _imgView.image = [self getImageWithName:@"empty-image-error"];
        }
            break;
        case SHEmptyViewType_search:
        {
            _imgView.image = [self getImageWithName:@"empty-image-search"];
        }
            break;
        case SHEmptyViewType_custom:
            break;
        default:
            break;
    }
}

#pragma mark - 懒加载{
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.frame = CGRectMake(0, 10, 160, 160);
        _imgView.image = [self getImageWithName:@"empty-image-default"];
        [self addSubview:_imgView];
    }
    return _imgView;
}

- (UILabel *)labView{
    if (!_labView) {
        _labView = [[UILabel alloc]init];
        _labView.height = 30;
        _labView.textColor = [UIColor colorWithWhite:0 alpha:0.3];
        _labView.font = [UIFont systemFontOfSize:14];
        _labView.textAlignment = NSTextAlignmentCenter;
        _labView.text = @"暂无数据";
        [self addSubview:_labView];
    }
    return _labView;
}

- (UIButton *)btnView{
    if (!_btnView) {
        _btnView = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnView.size = CGSizeMake(80, 30);
        _btnView.titleLabel.font = [UIFont systemFontOfSize:12];
        _btnView.titleLabel.textColor = [UIColor whiteColor];
        _btnView.backgroundColor = [UIColor redColor];
        [_btnView setTitle:@"点击重试" forState:0];
        _btnView.layer.cornerRadius = _btnView.height/2;
        [self addSubview:_btnView];
    }
    return _btnView;
}

#pragma mark 获取Bundle路径
- (NSString *)getBundle{
    
    return [[NSBundle bundleForClass:[SHEmptyView class]] pathForResource:@"SHEmptyView.bundle" ofType:nil];
}

#pragma mark 获取图片
- (UIImage *)getImageWithName:(NSString *)name{
    
    NSString *path = [NSString stringWithFormat:@"%@/%@.png",[self getBundle],name];
    NSData *data = [NSData dataWithContentsOfFile:path];

    return [UIImage imageWithData:data];
}


@end
