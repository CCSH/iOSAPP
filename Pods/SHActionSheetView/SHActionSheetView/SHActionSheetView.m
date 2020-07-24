//
//  SHActionSheetView.m
//  iOSAPP
//
//  Created by CSH on 16/8/16.
//  Copyright © 2016年 CSH. All rights reserved.
//

#import "SHActionSheetView.h"

@interface SHActionSheetView ()<UITableViewDelegate,UITableViewDataSource>
 //蒙版
@property (nonatomic, strong) UIView *backView;
//内容
@property (nonatomic, strong) UIView *contentView;
//选项
@property (nonatomic, strong) UITableView *listView;
//是否显示
@property (nonatomic, assign) BOOL isShow;

@end

@implementation SHActionSheetView

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)initWithFrame:(CGRect)frame{
    
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configData];
    }
    return self;
}

#pragma mark - 配置默认数据
- (void)configData{
    self.maxNum = 6;
    self.contentH = 57;
    self.headH = 57;
    self.separatorH = 10;
    
    self.titleFont = [UIFont systemFontOfSize:13];
    self.contentFont = [UIFont systemFontOfSize:18];
    self.cancelFont = [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    self.maskColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    self.listColor = [UIColor clearColor];
    self.separatorColor = [UIColor lightGrayColor];
    self.headTextColor = [UIColor blackColor];
    self.specialTextColor = [UIColor redColor];
    self.contentTextColor = kRGB(54, 90, 247, 1);
    self.cancelSeparatorColor = [UIColor clearColor];
}

#pragma mark - 懒加载
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.frame = self.bounds;
        [self addSubview:_backView];
        [self sendSubviewToBack:_backView];
    }
    return _backView;
}

- (UITableView *)listView{
    if (!_listView) {
        _listView =  [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0) style:UITableViewStylePlain];
        _listView.delegate = self;
        _listView.dataSource = self;
        _listView.separatorInset = UIEdgeInsetsZero;
        _listView.showsVerticalScrollIndicator = NO;
        _listView.bounces = NO;
        [self.contentView addSubview:_listView];
        [self.contentView sendSubviewToBack:_listView];
    }
    return _listView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.frame = CGRectMake(0, 0, self.frame.size.width, 0);
        _contentView.userInteractionEnabled = YES;
        [self addSubview:_contentView];
    }
    return _contentView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.messageArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.contentH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    //设置数据
    [self setCellDataSoureWithCell:cell IndexPath:indexPath];
    
    return cell;
}

- (void)setCellDataSoureWithCell:(UITableViewCell *)cell IndexPath:(NSIndexPath *)indexPath{
    
    UILabel *lab = [cell.contentView viewWithTag:10];
    if (!lab) {
        lab = [self getContent];
        [cell.contentView addSubview:lab];
    }
    
    lab.textColor = self.contentTextColor;
    
    id obj = self.model.messageArr[indexPath.section];
    
    for (NSString *index in self.model.specialArr) {
        if ([index intValue] == indexPath.section) {
            lab.textColor = self.specialTextColor;
            break;
        }
    }
    
    //设置内容
    if ([obj isKindOfClass:[NSAttributedString class]]) {
        
        lab.attributedText = obj;
    }else if ([obj isKindOfClass:[NSString class]]){
        
        lab.text = obj;
    }
}

- (UILabel *)getContent{
    UILabel *lab = [[UILabel alloc]init];
    lab.backgroundColor = [UIColor whiteColor];
    lab.font = self.contentFont;
    lab.textColor = self.contentTextColor;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.numberOfLines = 0;
    lab.tag = 10;
    lab.frame = CGRectMake(0, 0, self.listView.frame.size.width, self.contentH);
    return lab;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //回调
    if (self.block){
        self.block(self, indexPath.section);
    }
    
    [self dismiss];
}

#pragma mark - 取消点击
- (void)cancelAction:(UIButton *)button {
    
    //回调
    if (self.block){
        NSInteger index = button.tag;
        self.block(self, index);
    }
    
    [self dismiss];
}

#pragma mark - 配置UI
- (void)configUI{
    
    //通用处理
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    UILabel *headView = [[UILabel alloc] init];
    headView.frame = CGRectMake(0, 0, width, self.headH);
    
    self.listView.frame = CGRectMake(0, 0, width, 0);
    
    switch (self.style) {
        case SHActionSheetStyle_custom:
        {
            
        }
            break;
        case SHActionSheetStyle_system:
        {
            
            CGRect frame = self.listView.frame;
                       frame.origin.x = 8;
                       frame.size.width = width - 2*frame.origin.x;
                       self.listView.frame = frame;
                       
                       frame.size.height = self.headH;
                       headView.frame = frame;
                       
            self.listView.layer.cornerRadius = 14;
            
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:headView.bounds
                                                           byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                                 cornerRadii:CGSizeMake(14, 14)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = headView.bounds;
            maskLayer.path = maskPath.CGPath;
            headView.layer.mask = maskLayer;
        }
            break;
            
        default:
            break;
    }
    
    //头部+内容+分割线+底部
    CGFloat headH = self.model.title.length ? self.headH : 0;
    CGFloat viewH = MIN(_model.messageArr.count, self.maxNum) * self.contentH;
    CGFloat listH = headH + viewH;
    
    CGFloat view_y = 0;
    
    self.backView.backgroundColor = self.maskColor;
    
    //标题
    if (self.model.title.length) {
        
        headView.backgroundColor = [UIColor whiteColor];
        headView.textColor = self.headTextColor;
        headView.textAlignment = NSTextAlignmentCenter;
        headView.font = self.titleFont;
        headView.text = self.model.title;
        
        UIView *line = [[UIView alloc]init];
        line.frame = CGRectMake(0, self.headH - 0.5, headView.frame.size.width, 0.5);
        line.backgroundColor = self.separatorColor;
        [headView addSubview:line];
        
        self.listView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, self.headH)];
        
        [self.contentView addSubview:headView];
    }
 
    
    CGRect frame = self.listView.frame;
    frame.size.height = listH;
    self.listView.frame = frame;
    
    //选项
    self.listView.backgroundColor = self.listColor;
    self.listView.separatorColor = self.separatorColor;
    [self.listView reloadData];
    view_y = CGRectGetMaxY(self.listView.frame);
    
    //分割线
    UIView *separator = [[UIView alloc]init];
    separator.frame = CGRectMake(0, view_y, width, self.separatorH);
    separator.backgroundColor = self.cancelSeparatorColor;
    [self.contentView addSubview:separator];
    view_y = CGRectGetMaxY(separator.frame);
    
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, view_y, width, self.contentH);
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.tag = -1;
    cancelBtn.opaque = YES;
    cancelBtn.titleLabel.font = self.cancelFont;
    [cancelBtn setTitleColor:self.contentTextColor forState:UIControlStateNormal];
    [cancelBtn setTitle:self.model.cancel?:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelBtn];
    view_y = CGRectGetMaxY(cancelBtn.frame);
    
    //适配全面屏
    CGFloat safeBottom = ([UIApplication sharedApplication].statusBarFrame.size.height != 20) ? 34 : 0;
    UIView *safeView = [[UIView alloc]init];
    safeView.frame = CGRectMake(0, view_y, width, safeBottom);
    safeView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:safeView];
    view_y = CGRectGetMaxY(safeView.frame);
    
    frame = self.contentView.frame;
    frame.size.height = view_y;
    frame.origin.y = height - view_y;
    
    self.contentView.frame = frame;
    
    
    switch (self.style) {
        case SHActionSheetStyle_custom:
        {
            
        }
            break;
        case SHActionSheetStyle_system:
        {
            cancelBtn.layer.borderColor = [UIColor clearColor].CGColor;
            cancelBtn.layer.cornerRadius = 14;
            frame = cancelBtn.frame;
            frame.origin.x = 8;
            frame.size.width -= 2*frame.origin.x;
            cancelBtn.frame = frame;
            
            safeView.backgroundColor = [UIColor clearColor];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - public
- (void)show {
    if(self.isShow) {
        return;
    }
    
    self.isShow = YES;
    
    [self configUI];
    
    //从下到上
    __block CGRect frame = self.contentView.frame;
    frame.origin.y = self.frame.size.height;
    self.contentView.frame = frame;
    self.backView.alpha = 1;
    
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        frame.origin.y = self.frame.size.height - self.contentView.frame.size.height;
        self.contentView.frame = frame;
        
    } completion:NULL];
}

- (void)dismiss {
    
    self.isShow = NO;
    
    //从上到下
    __block CGRect frame = self.contentView.frame;
    frame.origin.y = self.frame.size.height - self.contentView.frame.size.height;
    self.contentView.frame = frame;
    self.backView.alpha = 1;
    
    [UIView animateWithDuration:0.25 animations:^{
        frame.origin.y = self.frame.size.height;
        self.contentView.frame = frame;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

@implementation SHActionSheetModel

@end
