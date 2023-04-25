//
//  AdViewController.m
//  iOSAPP
//
//  Created by CCSH on 2021/6/4.
//  Copyright © 2021 CSH. All rights reserved.
//

#import "AdViewController.h"

@interface AdViewController ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configUI];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self doneAction];
    [SHToolHelper changeIcon:@"icon"];
}

#pragma mark - 配置
- (void)configUI{
    //背景
    UIImageView *bgImage = [[UIImageView alloc]init];
    bgImage.frame = self.view.bounds;
    [bgImage sd_setImageWithURL:[NSURL URLWithString:@"http://web.frnnet.com/Attachment/Images/20210604/60b9bc738f6d8.jpg"] placeholderImage:[SHToolHelper placeholderImage]];
    [self.view addSubview:bgImage];
    //跳过
    SHButton *btn = [[SHButton alloc]init];
    [self.view addSubview:btn];
    [btn borderRadius:15 width:0 color:[UIColor clearColor]];
    btn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    btn.titleLabel.font = kFontWidth(12);
    @weakify(self);
    [btn addClickBlock:^(UIButton * _Nonnull btn) {
        @strongify(self);
        [self doneAction];
    }];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(kStatusBarH + 10);
        make.right.mas_offset(-kSpaceW);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    __block NSInteger time = 3;
    [btn setTitle:[NSString stringWithFormat:@"%ld秒",(long)time] forState:UIControlStateNormal];
    self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        time--;
        if (time > 0) {
            [btn setTitle:[NSString stringWithFormat:@"%ld秒",(long)time] forState:UIControlStateNormal];
        }else{
            [self doneAction];
        }
    }];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 事件
- (void)doneAction{
    
    if (self.timer) {
        [self.timer invalidate];
    }
    [kAppDelegate configVC:RootVCType_main];
}

@end
