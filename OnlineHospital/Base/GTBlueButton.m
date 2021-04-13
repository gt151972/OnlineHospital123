//
//  GTBlueButton.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/14.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "GTBlueButton.h"

@implementation GTBlueButton
+(GTBlueButton *)blueButtonWithFrame:(CGRect)frame ButtonTitle:(NSString *)buttonTitle{
    GTBlueButton *button = [GTBlueButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:BLUE_COLOR_MAIN forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = REDIUS;
//    int index = 5;
//    objc_setAssociatedObject(self, @"blueButton", [NSNumber numberWithInt:index], OBJC_ASSOCIATION_ASSIGN);
    return button;
}
+(GTBlueButton *)whiteButtonWithFrame:(CGRect)frame ButtonTitle:(NSString *)buttonTitle{
    GTBlueButton *button = [GTBlueButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = REDIUS;
    return button;
}
+(GTBlueButton *)glodButtonWithFrame:(CGRect)frame ButtonTitle:(NSString *)buttonTitle{
    GTBlueButton *button = [GTBlueButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:TEXT_COLOR_GLOD forState:UIControlStateNormal];
    [button setBackgroundColor:TEXT_COLOR_GLOD2 forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = REDIUS;
    return button;
}

+(GTBlueButton *)minBlueButtonWithFrame:(CGRect)frame ButtonTitle:(NSString *)buttonTitle{
    GTBlueButton *button = [GTBlueButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:BLUE_COLOR_MAIN forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    return button;
}

+(GTBlueButton *)blackButtonWithFrame:(CGRect)frame ButtonTitle:(NSString *)buttonTitle{
    GTBlueButton *button = [GTBlueButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button.titleLabel setTextAlignment:NSTextAlignmentRight];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:TEXT_COLOR_MAIN forState:UIControlStateNormal];
    button.titleLabel.textAlignment = NSTextAlignmentLeft;
    [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
    return button;
}
@end
