//
//  LoginViewController.m
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "LoginViewController.h"
#import "SHWebViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) SHButton *codeBtn;

@property (nonatomic, assign) BOOL switchState;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarBGAlpha = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.window endEditing:YES];
}

#pragma mark - 配置
- (void)configUI{
    //关闭
    SHButton *closeBtn = [[SHButton alloc]init];
    closeBtn.size = CGSizeMake(24, 24);
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    @weakify(self);
    [closeBtn addClickBlock:^(UIButton * _Nonnull btn) {
        @strongify(self);
        [self backAction];
    }];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:closeBtn];
    
    //注册
    SHButton *rightBtn = [[SHButton alloc]init];
    [rightBtn setTitle:@"注册" forState:UIControlStateNormal];
    rightBtn.backgroundColor = kColorMain;
    rightBtn.titleLabel.font = kBoldFont(14);
    rightBtn.size = CGSizeMake(44, 24);
    [rightBtn addClickBlock:^(UIButton * _Nonnull btn) {
        [SHRouting routingWithUrl:[SHRouting getUrlWithName:RoutingName_register]
                             type:SHRoutingType_nav
                            block:nil];
    }];
    [rightBtn borderRadius:4];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    //内容
    //图标
    UIImageView *icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"login_head"];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_offset(0);
        make.top.mas_offset(0);
        make.size.mas_equalTo(CGSizeMake(kSHWidth, 200));
    }];
    
    //手机
    UITextField *phoneView = [self getTextField];
    phoneView.tag = 12;
    phoneView.placeholder = @"请输入手机号";
    [self.view addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(kSHWidth - 2*30);
        make.centerX.mas_offset(0);
    }];
    
    //密码
    UITextField *passwordView = [self getTextField];
    passwordView.tag = 10;
    [self.view addSubview:passwordView];
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneView.mas_bottom). mas_offset(24);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(kSHWidth - 2*30);
        make.centerX.mas_offset(0);
    }];
    
    //登录
    SHButton *loginBtn = [SHToolHelper getBtn];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [loginBtn addClickBlock:^(UIButton * _Nonnull btn) {
        [self.window endEditing:YES];
        [self doneAction];
    }];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(phoneView);
        make.top.equalTo(passwordView.mas_bottom).mas_offset(32);
        make.height.mas_equalTo(43);
        make.centerX.mas_offset(0);
    }];
    
    //切换
    SHButton *switchBtn = [SHButton buttonWithType:UIButtonTypeCustom];
    switchBtn.tag = 11;
    [switchBtn borderRadius:8 width:1 color:kColorMain];
    [switchBtn setTitleColor:kColorMain forState:UIControlStateNormal];
    [self.view addSubview:switchBtn];
    [switchBtn addClickBlock:^(UIButton * _Nonnull btn) {
        @strongify(self);
        self.switchState = !self.switchState;
        [self switchAction];
    }];
    [switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(phoneView);
        make.top.equalTo(loginBtn.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(43);
        make.centerX.mas_offset(0);
    }];
    [self switchAction];
}

#pragma mark 输入框
- (UITextField *)getTextField{
    UITextField *textField = [[UITextField alloc]init];
    textField.placeholder = @"请输入内容";
    textField.font = kFont(14);
    textField.backgroundColor = [UIColor redColor];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.backgroundColor = kColor245;
    [textField borderRadius:4];
    
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 23, 0)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 23, 0)];
    textField.rightViewMode = UITextFieldViewModeAlways;
 
    return textField;
}

#pragma mark 初始化验证码
- (void)initCode{
    self.codeBtn.enabled = YES;
    [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeBtn setTitleColor:kColorMain forState:UIControlStateNormal];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - 事件
#pragma mark 切换
- (void)switchAction{
    //密码
    UITextField *passwordView = [self.view viewWithTag:10];
    passwordView.text = @"";
    //切换
    SHButton *switchBtn = [self.view viewWithTag:11];

    if (self.switchState) {
        //短信
        passwordView.placeholder = @"请输入验证码";
        passwordView.secureTextEntry = NO;
        passwordView.rightView = self.codeBtn;
        [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
        
        [switchBtn setTitle:@"用账号密码登录" forState:UIControlStateNormal];
    }else{
        //密码
        passwordView.placeholder = @"请输入密码";
        passwordView.secureTextEntry = YES;
        passwordView.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 23, 0)];
        
        [switchBtn setTitle:@"用短信验证码登录" forState:UIControlStateNormal];
    }
}

- (void)doneAction{
    UITextField *passwordView = [self.view viewWithTag:10];
    UITextField *phoneView = [self.view viewWithTag:12];
    if (!phoneView.text.length) {
        [SHToast showWithText:phoneView.placeholder];
        return;
    }
    if (!passwordView.text.length) {
        [SHToast showWithText:passwordView.placeholder];
        return;
    }
   
    [self requestData];
}

#pragma mark - 请求
- (void)requestData{
    
    UITextField *phoneView = [self.view viewWithTag:12];
    UITextField *passwordView = [self.view viewWithTag:10];
    
//    [SHServerRequest requestLoginWithMobile:phoneView.text
//                                   password:passwordView.text
//                                     result:^(SHRequestBaseModel * _Nonnull baseModel, NSError * _Nonnull error) {
//
//        if (!error) {
//            //成功
//        }
        SHRequestBaseModel *baseModel = [[SHRequestBaseModel alloc]init];
        baseModel.data = @{@"user_id":@"1"};
        [SHToolHelper loginSuccess:baseModel];
        [self backAction];
//    }];
}

#pragma mark - 懒加载
- (SHButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn = [SHButton buttonWithType:UIButtonTypeCustom];
        _codeBtn.titleLabel.font = kWidthFont(14);
        
        @weakify(self);
        [_codeBtn addClickBlock:^(UIButton * _Nonnull btn) {
            @strongify(self);
            UITextField *phoneView = [self.view viewWithTag:12];
            if (!phoneView.text.length) {
                [SHToast showWithText:@"请输入手机号"];
                return;
            }
            if (self.timer) {
                [self.timer invalidate];
                self.timer = nil;
            }
            __block NSInteger time = 60;
            
            btn.enabled = NO;
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"%ld秒",(long)time] forState:UIControlStateNormal];
            
            self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                time--;
                if (time > 0) {
                    [btn setTitle:[NSString stringWithFormat:@"%ld秒",(long)time] forState:UIControlStateNormal];
                }else{
                    [self initCode];
                }
            }];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }];
        [self initCode];
    }
    return _codeBtn;
}

@end
