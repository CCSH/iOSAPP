//
//  RegisterViewController.m
//  iOSAPP
//
//  Created by CSH on 2017/12/8.
//  Copyright © 2017年 CSH. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterTableViewCell.h"

@interface RegisterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isAgreement;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 配置
- (void)configUI{
    self.dataSource = [[NSMutableArray alloc]init];

    [self.dataSource addObjectsFromArray:@[@{@"手机号":@""},@{@"验证码":@""},@{@"密码":@""}]];
    [self.tableView reloadData];
}

- (void)handleCode:(SHButton *)btn{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    btn.enabled = YES;
    [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btn setTitleColor:kColorMain forState:UIControlStateNormal];
}

#pragma mark - 事件
- (void)doneAction{
    if (!self.isAgreement) {
        [SHToast showWithText:@"请同意协议"];
        return;
    }
    for (NSDictionary *obj in self.dataSource) {
        NSString *key = obj.allKeys[0];
        NSString *value = obj.allValues[0];
        if (!value.length) {
            [SHToast showWithText:[NSString stringWithFormat:@"请输入%@",key]];
            return;
        }
    }
    
    SHRequestBaseModel *model = [[SHRequestBaseModel alloc]init];
    model.data = @{@"user_id":@"1"};
    [SHToolHelper loginSuccess:model];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *data = self.dataSource[indexPath.row];
    
    static NSString *reuseIdentifier = @"RegisterTableViewCell";
    RegisterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[RegisterTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        @weakify(self);
        @weakify(cell);
        cell.callBack = ^(id obj){
            @strongify(self);
            @strongify(cell);
            if ([obj isKindOfClass:[NSString class]]) {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                dic[data.allKeys[0]] = obj;
                [self.dataSource replaceObjectAtIndex:indexPath.row withObject:dic];
            }else{
                //获取验证码
                NSString *phone = [self.dataSource[0] allValues][0];
                if (!phone.length) {
                    [SHToast showWithText:@"请输入手机号"];
                    return;
                }
                
                [self handleCode:cell.codeBtn];
                
                __block NSInteger time = 60;
                
                cell.codeBtn.enabled = NO;
                [cell.codeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [cell.codeBtn setTitle:[NSString stringWithFormat:@"%ld秒",(long)time] forState:UIControlStateNormal];
                
                self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                    time--;
                    if (time > 0) {
                        [cell.codeBtn setTitle:[NSString stringWithFormat:@"%ld秒",(long)time] forState:UIControlStateNormal];
                    }else{
                        [self handleCode:cell.codeBtn];
                    }
                }];
                [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            }
        };
    }
    cell.data = data;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 88;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.size = CGSizeMake(kSHWidth, 88);
    
    SHButton *btn = [[SHButton alloc]init];
    NSString *name = @"agreement";
    if (self.isAgreement) {
        name = @"agreement_h";
    }
    [btn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [view addSubview:btn];
    [btn addClickBlock:^(UIButton * _Nonnull btn) {
        self.isAgreement = !self.isAgreement;
        [self.tableView reloadData];
    }];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(43);
        make.width.height.mas_equalTo(14);
        make.top.mas_offset(30);
    }];
    
    NSString *str = @"注册账号，同意并接受";
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@《注册服务协议及隐私协议》",str]];
    att.yy_font = kFont(12);
    att.yy_lineSpacing = 6;
    
    [att yy_setColor:kColorMain range:NSMakeRange(str.length, att.length - str.length)];

    NSRange range = [att.string rangeOfString:@"《注册服务协议及隐私协议》"];

    //点击
    YYTextHighlight *hight = [[YYTextHighlight alloc]init];
    [att yy_setTextHighlight:hight range:range];
    hight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
    [SHRouting routingWithUrl:[SHRouting getUrlWithName:RoutingName_web]
                        param:@{@"url":@"http://gg.gg/ccsh-blog"}
                         type:SHRoutingType_modal
                        block:nil];
    };
    
    YYLabel *lab = [[YYLabel alloc]init];
    lab.attributedText = att;
    lab.textVerticalAlignment = YYTextVerticalAlignmentTop;
    lab.numberOfLines = 0;
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btn.mas_right).mas_offset(6);
        make.right.mas_offset(-60);
        make.top.equalTo(btn);
        make.bottom.mas_offset(0);
    }];

    return view;
}

#pragma mark - 懒加载
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 62;
        _tableView.bounces = NO;
        
        UIView *view = [[UIView alloc]init];
        view.size = CGSizeMake(kSHWidth, 43);
        _tableView.tableFooterView = view;
        
        SHButton *btn = [SHToolHelper getBtn];
        [view addSubview:btn];
        [btn setTitle:@"注册并登录" forState:UIControlStateNormal];
        [btn addClickBlock:^(UIButton * _Nonnull btn) {
            [self.window endEditing:YES];
            [self doneAction];
        }];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kSHWidth -2*30);
            make.top.mas_offset(0);
            make.height.mas_equalTo(43);
            make.centerX.mas_offset(0);
        }];

        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
