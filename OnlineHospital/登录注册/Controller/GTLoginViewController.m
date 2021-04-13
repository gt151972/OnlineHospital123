//
//  GTLoginViewController.m
//  OnlineHospital
//  登录注册模块
//  Created by 高天的Mac on 2020/8/14.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "GTLoginViewController.h"

@interface GTLoginViewController ()

@end

@implementation GTLoginViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_COLOR;
}

- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addNavigationtitleWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle{
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    UILabel *labtitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 95, Screen_W - 40, 37)];
    labtitle.text = title;
    labtitle.textAlignment = NSTextAlignmentLeft;
    labtitle.textColor = TEXT_COLOR_MAIN;
    labtitle.font = [UIFont systemFontOfSize:26];
    [self.view addSubview:labtitle];
    
    UILabel *labDetailTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 136, Screen_W - 40, 20)];
    labDetailTitle.text = detailTitle;
    labDetailTitle.textAlignment = NSTextAlignmentLeft;
    labDetailTitle.textColor = TEXT_COLOR_DETAIL;
    labDetailTitle.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:labDetailTitle];
}

- (UIView *)textFieldBgViewWithFrame:(CGRect)frame{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = BG_COLOR_WHITE;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10;
    return view;
}

- (void)addTimer{
    
}

@end
