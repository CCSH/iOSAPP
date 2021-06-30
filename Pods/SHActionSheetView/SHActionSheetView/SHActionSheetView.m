

//
//  SHActionSheetView.m
//  iOSAPP
//
//  Created by CSH on 16/8/16.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHActionSheetView.h"
#import "UIView+SHExtension.h"

@interface SHActionSheetView () < UITableViewDelegate, UITableViewDataSource ,UIGestureRecognizerDelegate>
//内容
@property (nonatomic, strong) UIView *contentView;
//选项
@property (nonatomic, strong) UITableView *listView;
//是否显示
@property (nonatomic, assign) BOOL isShow;

@end

@implementation SHActionSheetView

static NSString *const reuseIdentifier = @"Cell";

- (instancetype)initWithFrame:(CGRect)frame
{
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self)
    {
        [self configData];
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.contentView]) {
        return NO;
    }
    return YES;
}

#pragma mark - 配置默认数据
- (void)configData
{
    self.isClickDisappear = YES;
    self.maxNum = 8;

    self.contentH = 57;
    self.headH = 57;
    self.separatorH = 3;

    self.titleFont = [UIFont systemFontOfSize:14];
    self.contentFont = [UIFont systemFontOfSize:16];
    self.cancelFont = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    
    self.maskColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.listColor = [UIColor whiteColor];
    self.headTextColor = [UIColor blackColor];
    self.contentTextColor = [UIColor grayColor];
    self.specialTextColor = [UIColor redColor];
    self.cancelTextColor = [UIColor blackColor];
    
    self.separatorColor = [UIColor colorWithWhite:0.7 alpha:1];
    self.cancelSeparatorColor = [UIColor clearColor];
}

#pragma mark - 懒加载
- (UITableView *)listView
{
    if (!_listView)
    {
        _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0) style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.separatorInset = UIEdgeInsetsZero;
        _listView.showsVerticalScrollIndicator = NO;
        _listView.backgroundColor = [UIColor clearColor];
        _listView.bounces = NO;
        [self.contentView addSubview:_listView];
        [self.contentView sendSubviewToBack:_listView];
    }
    return _listView;
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] init];
        _contentView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
        _contentView.userInteractionEnabled = YES;
        [self addSubview:_contentView];
    }
    return _contentView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.messageArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.contentH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.headH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }

    //设置数据
    [self setCellDataSoureWithCell:cell IndexPath:indexPath];

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headView = [[UILabel alloc] init];

    headView.frame = CGRectMake(0, 0, tableView.width, self.headH);
    headView.backgroundColor = self.listColor;
    headView.textColor = self.headTextColor;
    headView.textAlignment = NSTextAlignmentCenter;
    headView.font = self.titleFont;
    headView.text = self.model.title;
    //设置内容
    if ([self.model.title isKindOfClass:[NSAttributedString class]])
    {
        headView.attributedText = self.model.title;
    }

    return headView;
    ;
}

- (void)setCellDataSoureWithCell:(UITableViewCell *)cell IndexPath:(NSIndexPath *)indexPath
{
    UILabel *lab = [cell.contentView viewWithTag:10];
    if (!lab)
    {
        lab = [self getContent];
        [cell.contentView addSubview:lab];
    }

    lab.textColor = self.contentTextColor;

    id obj = self.model.messageArr[indexPath.row];

    for (NSString *index in self.model.specialArr)
    {
        if ([index intValue] == indexPath.row)
        {
            lab.textColor = self.specialTextColor;
            break;
        }
    }

    lab.text = obj;
    //设置内容
    if ([obj isKindOfClass:[NSAttributedString class]])
    {
        lab.attributedText = obj;
    }
}

- (UILabel *)getContent
{
    UILabel *lab = [[UILabel alloc] init];
    lab.backgroundColor = self.listColor;
    lab.font = self.contentFont;
    lab.textColor = self.contentTextColor;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    lab.frame = CGRectMake(0, 0, self.listView.frame.size.width, self.contentH);
    return lab;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //回调
    if (self.block)
    {
        self.block(self, indexPath.row);
    }

    [self dismiss];
}

#pragma mark - 取消点击
- (void)cancelAction
{
    //回调
    if (self.block)
    {
        self.block(self, -1);
    }

    [self dismiss];
}

#pragma mark - 配置UI
- (void)configUI
{
    //通用处理
    [[UIApplication sharedApplication].delegate.window addSubview:self];

    self.backgroundColor = self.maskColor;
    
    if (self.isClickDisappear) {
        //点击消失
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }

    //标题
    if (!self.model.title)
    {
        self.headH = 0;
    }

    //选项
    self.listView.size = CGSizeMake(self.width, MIN(self.model.messageArr.count, self.maxNum) * self.contentH + self.headH);
    self.listView.separatorColor = self.separatorColor;
    [self.listView reloadData];

    //分割线
    UIView *separator = [[UIView alloc] init];
    separator.frame = CGRectMake(0, self.listView.maxY, self.width, self.separatorH);
    separator.backgroundColor = self.cancelSeparatorColor;
    [self.contentView addSubview:separator];

    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, separator.maxY, self.width, self.contentH);
    cancelBtn.backgroundColor = self.listColor;
    cancelBtn.opaque = YES;
    cancelBtn.titleLabel.font = self.cancelFont;
    [cancelBtn setTitleColor:self.cancelTextColor forState:UIControlStateNormal];
    [cancelBtn setTitle:self.model.cancel ?: @"取消" forState:UIControlStateNormal];
    if ([self.model.cancel isKindOfClass:[NSAttributedString class]]) {
        [cancelBtn setAttributedTitle:self.model.cancel forState:UIControlStateNormal];
    }
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelBtn];

    //适配全面屏
    CGFloat safeBottom = ([UIApplication sharedApplication].statusBarFrame.size.height != 20) ? 34 : 0;
    UIView *safeView = [[UIView alloc] init];
    safeView.frame = CGRectMake(0, cancelBtn.maxY + self.separatorH, 0, safeBottom);
    safeView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:safeView];

    self.contentView.height = safeView.maxY;
    self.contentView.y = self.height - self.contentView.height;

    switch (self.style)
    {
        case SHActionSheetStyle_system:
        {
            self.listView.x = 10;
            self.listView.width = self.width - 2 * self.listView.x;

            separator.x = self.listView.x;
            separator.width = self.listView.width;

            cancelBtn.x = self.listView.x;
            cancelBtn.width = self.listView.width;

            self.listView.layer.cornerRadius = 14;

            cancelBtn.layer.cornerRadius = 14;
        }
        break;

        default:
            break;
    }
}

#pragma mark - public
- (void)show
{
    if (self.isShow)
    {
        return;
    }

    self.isShow = YES;

    [self configUI];

    //从下到上
    __block CGRect frame = self.contentView.frame;
    frame.origin.y = self.frame.size.height;
    self.contentView.frame = frame;
    self.alpha = 1;

    [UIView animateWithDuration:0.35f
                          delay:0
         usingSpringWithDamping:0.9f
          initialSpringVelocity:0.7f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews
                     animations:^{
                       frame.origin.y = self.frame.size.height - self.contentView.frame.size.height;
                       self.contentView.frame = frame;
                     }
                     completion:NULL];
}

- (void)dismiss
{
    self.isShow = NO;

    //从上到下
    __block CGRect frame = self.contentView.frame;
    frame.origin.y = self.frame.size.height - self.contentView.frame.size.height;
    self.contentView.frame = frame;
    self.alpha = 1;

    [UIView animateWithDuration:0.25
        animations:^{
          frame.origin.y = self.frame.size.height;
          self.contentView.frame = frame;
          self.alpha = 0;
        }
        completion:^(BOOL finished) {
          [self removeFromSuperview];
        }];
}

@end

@implementation SHActionSheetModel

@end
