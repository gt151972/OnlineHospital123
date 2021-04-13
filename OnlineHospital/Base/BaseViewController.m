//
//  BaseViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/20.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
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
    // Do any additional setup after loading the view.
}

-(UIView*)flowerNavigationViewWithTitle:(NSString *)title{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, SafeAreaTopHeight)];
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, Screen_W, 44)];
    labTitle.text = title;
    labTitle.textColor = [UIColor whiteColor];
    labTitle.font = [UIFont systemFontOfSize:18];
    labTitle.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labTitle];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnBack];
    
    return view;
}
-(UIView*)applyNavigationViewWithTitle:(NSString *)title right:(NSString *)right{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_W)];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:view.frame];
    bg.image = [UIImage imageNamed:@"home_doctor_bg"];
    [view addSubview:bg];
       UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, Screen_W, 44)];
       labTitle.text = title;
       labTitle.textColor = [UIColor whiteColor];
       labTitle.font = [UIFont systemFontOfSize:18];
       labTitle.textAlignment = NSTextAlignmentCenter;
       [view addSubview:labTitle];
       
       UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0,  kStatusBarHeight, 44, 44)];
       [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
       [btnBack addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
       [view addSubview:btnBack];
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(Screen_W- 52, kStatusBarHeight, 44, 44)];
    [btnRight setTitle:right forState:UIControlStateNormal];
    [btnRight setTitleColor:BG_COLOR_WHITE forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(btnRightClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnRight];
    return view;
}
-(UIView*)vipNavigationViewWithTitle:(NSString *)title right:(NSString *)right{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_W)];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:view.frame];
    bg.image = [UIImage imageNamed:@"vip_bg"];
    [view addSubview:bg];
       UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, Screen_W, 44)];
       labTitle.text = title;
    labTitle.textColor = TEXT_COLOR_GLOD2;
       labTitle.font = [UIFont systemFontOfSize:18];
       labTitle.textAlignment = NSTextAlignmentCenter;
       [view addSubview:labTitle];
       
       UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0,  kStatusBarHeight, 44, 44)];
       [btnBack setImage:[UIImage imageNamed:@"vip_back"] forState:UIControlStateNormal];
       [btnBack addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
       [view addSubview:btnBack];
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(Screen_W- 100, kStatusBarHeight, 100, 44)];
    [btnRight setTitle:@"我的订单" forState:UIControlStateNormal];
    [btnRight.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [btnRight setTitleColor:TEXT_COLOR_GLOD2 forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(btnRightClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnRight];
    return view;
}
- (void)pop{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnRightClicked{
    
}
@end
