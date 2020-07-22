//
//  SHBaseViewController.m
//  iOSAPP
//
//  Created by CSH on 2020/7/21.
//  Copyright © 2020 CSH. All rights reserved.
//

#import "SHBaseViewController.h"

@interface SHBaseViewController ()



@end

@implementation SHBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    self.window = [[[UIApplication sharedApplication] delegate] window];
}

@end
