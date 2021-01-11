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

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backAction)];
    
    [SHSQLite addLoginInfoWithModel:@{@"user_id":@"1"}];
}

- (void)requestData{
    [SHServerRequest requestLoginWithMobile:@"1" password:@"1" result:^(SHRequestBaseModel * _Nonnull baseModel, NSError * _Nonnull error) {
        
        if (!error) {
            //成功
        }else{
            if ([error.domain isEqualToString:error_domain]) {
                //服务器错误
                //                baseModel.result
                //                baseModel.msg
            }else{
                //网络错误
            }
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
