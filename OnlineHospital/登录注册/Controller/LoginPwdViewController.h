//
//  LoginPwdViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/14.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTLoginViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface LoginPwdViewController : GTLoginViewController
/// 1:密码登录
/// 2:找回密码1
/// 3:找回密码2
///4:修改密码1
///5修改密码2
@property(nonatomic, assign)int type;

@property(nonatomic, strong)NSString *strPhone;
@property(nonatomic, strong)NSString *strCode;
@end

NS_ASSUME_NONNULL_END
