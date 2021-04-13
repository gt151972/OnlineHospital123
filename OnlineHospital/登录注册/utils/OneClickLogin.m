//
//  OneClickLogin.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/12/2.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "OneClickLogin.h"

@implementation OneClickLogin
+(TXCustomModel *)buildModel{
    TXCustomModel *model = [[TXCustomModel alloc] init];
    model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
    model.navColor = BG_COLOR;
    NSDictionary *attributes3 = @{
        NSForegroundColorAttributeName : TEXT_COLOR_MAIN,
        NSFontAttributeName : [UIFont systemFontOfSize:20.0]
    };
    model.navTitle = [[NSAttributedString alloc] initWithString:@"" attributes:attributes3];
    model.privacyOne = @[@"《用户协议》", @"https://www.taobao.com"];
    model.privacyTwo= @[@"《隐私权政策》", @"https://www.taobao.com"];
    
    model.numberColor = TEXT_COLOR_MAIN;
    model.numberFont = [UIFont systemFontOfSize:26];
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = Screen_H - 336;
        frame.size.height = 37;
        return frame;
    };
    
    NSDictionary *attributes2 = @{
        NSForegroundColorAttributeName : TEXT_COLOR_DETAIL,
        NSFontAttributeName : [UIFont systemFontOfSize:14.0]
    };
    model.sloganText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@认证",[TXCommonUtils getCurrentCarrierName]] attributes:attributes2];
    model.sloganFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame.origin.y = Screen_H - 336+37;
        frame.size.height = 20;
        return frame;
    };
    
    
    NSDictionary *attributes = @{
        NSForegroundColorAttributeName : BG_COLOR_WHITE,
        NSFontAttributeName : [UIFont systemFontOfSize:16.0]
    };
    model.loginBtnText = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
    UIImage *image = [UIImage imageNamed:@"button_bg_blue"];
    model.loginBtnBgImgs = @[image,image,image];
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame = CGRectMake(20, Screen_H - 276 + 37, Screen_W - 40, 50);
        return frame;
    };
    NSDictionary *attributes1 = @{
        NSForegroundColorAttributeName : TEXT_COLOR_MAIN,
        NSFontAttributeName : [UIFont systemFontOfSize:16.0]
    };
    model.changeBtnTitle = [[NSAttributedString alloc] initWithString:@"其他方式登录" attributes:attributes1];
    model.changeBtnIsHidden = NO;
    model.changeBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        frame = CGRectMake(20, Screen_H - 216 + 37, Screen_W - 40, 50);
        return frame;
    };
    model.checkBoxIsChecked = YES;
    model.checkBoxIsHidden = YES;
    model.privacyAlignment = NSTextAlignmentCenter;
    model.privacyOperatorPreText = @"《";
    model.privacyOperatorSufText = @"》";
    model.privacyFont = [UIFont systemFontOfSize:12];
    model.privacyPreText = @"登录即代表您同意";
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    view.backgroundColor = BG_COLOR;
    
    
    UILabel *labNav = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 200, 26)];
    labNav.text = @"登录";
    labNav.textColor = TEXT_COLOR_MAIN;
    labNav.font = [UIFont systemFontOfSize:26];
    labNav.textAlignment = NSTextAlignmentLeft;
    
    UILabel *labDetail = [[UILabel alloc] initWithFrame:CGRectMake(20, 48, 200, 24)];
    labDetail.text = @"朵尔医生欢迎你";
    labDetail.textColor = TEXT_COLOR_DETAIL;
    labDetail.font = [UIFont systemFontOfSize:14];
    labDetail.textAlignment = NSTextAlignmentLeft;
    
    UIImageView *otherButtonBg = [[UIImageView alloc] initWithFrame:CGRectMake(20, Screen_H - 216 + 37, Screen_W - 40, 50)];
    otherButtonBg.image = [UIImage imageNamed:@"button_bg_w"];
    
    model.customViewBlock = ^(UIView * _Nonnull superCustomView) {

        [superCustomView addSubview:view];
        [superCustomView addSubview:otherButtonBg];
        [superCustomView addSubview:labNav];
        [superCustomView addSubview:labDetail];
    };
    return model;
}

@end
