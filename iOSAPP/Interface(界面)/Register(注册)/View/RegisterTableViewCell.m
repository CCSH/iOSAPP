//
//  RegisterTableViewCell.m
//  iOSAPP
//
//  Created by CCSH on 2021/9/10.
//  Copyright © 2021 CSH. All rights reserved.
//

#import "RegisterTableViewCell.h"

@interface RegisterTableViewCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIView *verLine;
@property (nonatomic, strong) UITextField *inputView;

@end

@implementation RegisterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initView{
    [super initView];
    self.divider.hidden = NO;
    [self.divider mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(30);
        make.right.mas_offset(-30);
    }];
}

- (void)setData:(NSDictionary *)data{
    _data = data;
    NSString *name = data.allKeys[0];
    self.nameLab.text = name;
    
    self.inputView.text = data.allValues[0];
    self.inputView.placeholder = [NSString stringWithFormat:@"请输入%@",name];
    self.inputView.secureTextEntry = NO;
    self.inputView.rightViewMode = UITextFieldViewModeNever;
    
    if ([name isEqualToString:@"验证码"]) {
        self.inputView.rightViewMode = UITextFieldViewModeAlways;
    }else if ([name isEqualToString:@"密码"]){
        self.inputView.secureTextEntry = YES;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.callBack) {
        self.callBack(textField.text);
    }
}

#pragma mark - 懒加载
- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc]init];
        _nameLab.font = kFont(14);
        _nameLab.textColor = [UIColor grayColor];
        [self.contentView addSubview:_nameLab];
        
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.divider).mas_equalTo(12);
            make.centerY.mas_offset(10);
            make.width.mas_equalTo(60);
        }];
    }
    return _nameLab;
}

- (UIView *)verLine{
    if (!_verLine) {
        _verLine = [[UIView alloc]init];
        _verLine.backgroundColor = kColor245;
        [self.contentView addSubview:_verLine];
        
        [_verLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLab.mas_right);
            make.size.mas_equalTo(CGSizeMake(1, 10));
            make.centerY.equalTo(self.nameLab);
        }];
    }
    return _verLine;
}

- (UITextField *)inputView{
    if (!_inputView) {
        _inputView = [[UITextField alloc]init];
        _inputView.font = kFont(14);
        _inputView.rightViewMode = UITextFieldViewModeAlways;
        _inputView.delegate = self;
        [self.contentView addSubview:_inputView];
        _inputView.rightView = self.codeBtn;
        
        [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.verLine.mas_right).mas_offset(27);
            make.right.equalTo(self.divider).mas_offset(-14);
            make.centerY.equalTo(self.nameLab);
            make.height.mas_equalTo(40);
        }];
        
        [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
    }

    return _inputView;
}

- (SHButton *)codeBtn{
    if (!_codeBtn) {
        _codeBtn = [SHButton buttonWithType:UIButtonTypeCustom];
        _codeBtn.titleLabel.font = kWidthFont(14);
        [_codeBtn setTitleColor:kColorMain forState:UIControlStateNormal];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        @weakify(self);
        [_codeBtn addClickBlock:^(UIButton * _Nonnull btn) {
            @strongify(self);
            [self.window endEditing:YES];
            if (self.callBack) {
                self.callBack(self->_codeBtn);
            }
        }];

    }
    return _codeBtn;
}

@end
