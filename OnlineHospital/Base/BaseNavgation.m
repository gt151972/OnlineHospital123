//
//  BaseNavgation.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/17.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "BaseNavgation.h"

@implementation BaseNavgation

+(BaseNavgation *)navigationViewWithTitle:(NSString *)title right: (NSString *)right{
    BaseNavgation *view = [[BaseNavgation alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_W)];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:view.frame];
    bg.image = [UIImage imageNamed:@"vip_bg"];
    [view addSubview:bg];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, Screen_W, 44)];
    labTitle.text = title;
    labTitle.textColor = TEXT_COLOR_GLOD2;
    labTitle.font = [UIFont systemFontOfSize:18];
    labTitle.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labTitle];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"vip_back"] forState:UIControlStateNormal];
    [view addSubview:btnBack];
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(Screen_W - 100, kStatusBarHeight, 80, 44)];
    [btnRight setTitle:right forState:UIControlStateNormal];
    [btnRight setTitleColor:TEXT_COLOR_GLOD2 forState:UIControlStateNormal];
    [view addSubview:btnRight];
    return view;
}

+(BaseNavgation *)messageNavigationViewWithTitle:(NSString *)title{
    BaseNavgation *view = [[BaseNavgation alloc] initWithFrame:CGRectMake(0, 0, Screen_W, SafeAreaTopHeight)];
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, Screen_W, 44)];
    labTitle.text = @"消息";
    labTitle.textColor = TEXT_COLOR_MAIN;
    labTitle.font = [UIFont systemFontOfSize:18];
    labTitle.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labTitle];
    
//    UILabel *labDetail = [[UILabel alloc] initWithFrame:CGRectMake(26, 80, Screen_W, 25)];
//    labDetail.text = [NSString stringWithFormat:@"%@,早上好!",title];
//    labDetail.textColor = TEXT_COLOR_DETAIL;
//    labDetail.font = [UIFont systemFontOfSize:14];
//    labDetail.textAlignment = NSTextAlignmentLeft;
//    [view addSubview:labDetail];
    return view;
}

+(BaseNavgation *)doctorNavigationViewWithTitle:(NSString *)title{
    BaseNavgation *view = [[BaseNavgation alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_W)];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:view.frame];
    bg.image = [UIImage imageNamed:@"home_doctor_bg"];
    [view addSubview:bg];
    
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, Screen_W, 44)];
    labTitle.text = title;
    labTitle.textColor = [UIColor whiteColor];
    labTitle.font = [UIFont systemFontOfSize:18];
    labTitle.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labTitle];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [view addSubview:btnBack];
    
    return view;
}

+(BaseNavgation *)flowerNavigationViewWithTitle:(NSString *)title{
    BaseNavgation *view = [[BaseNavgation alloc] initWithFrame:CGRectMake(0, 0, Screen_W, SafeAreaTopHeight)];
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, Screen_W, 44)];
    labTitle.text = title;
    labTitle.textColor = [UIColor whiteColor];
    labTitle.font = [UIFont systemFontOfSize:18];
    labTitle.textAlignment = NSTextAlignmentCenter;
    [view addSubview:labTitle];
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(popNavigationItemAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnBack];
    
    return view;
}

@end
