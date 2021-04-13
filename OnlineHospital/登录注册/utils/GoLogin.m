//
//  GoLogin.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/1/19.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import "GoLogin.h"

@implementation GoLogin
+ (void)beginLoginWithViewController: (UIViewController *)vc{
    [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
    TXCustomModel *model = [OneClickLogin buildModel];
    __weak typeof(self) weakSelf = vc;
    [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:3.0
                                                    controller:vc
                                                         model:model
                                                      complete:^(NSDictionary * _Nonnull resultDic) {
        NSString *resultCode = [resultDic objectForKey:@"resultCode"];
        if ([PNSCodeLoginControllerPresentSuccess isEqualToString:resultCode]) {
            NSLog(@"授权页拉起成功回调：%@", resultDic);
            [MBProgressHUD hideHUDForView:vc.view animated:YES];
        } else if ([PNSCodeLoginControllerClickCancel isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickLoginBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickProtocol isEqualToString:resultCode]) {
          
            NSLog(@"页面点击事件回调：%@", resultDic);
        }else if ([PNSCodeLoginControllerClickChangeBtn isEqualToString:resultCode]){
            LoginMessageViewController *controller = [[LoginMessageViewController alloc] init];
            controller.isHiddenNavgationBar = YES;
            UINavigationController *nav= vc.navigationController;
            if (vc.presentedViewController) {
                //如果授权页成功拉起，这个时候则需要使用授权页的导航控制器进行跳转
                nav = (UINavigationController *)vc.presentedViewController;
            }
            [nav pushViewController:controller animated:YES];
        }
        else if ([PNSCodeSuccess isEqualToString:resultCode]) {
            NSLog(@"获取LoginToken成功回调：%@", resultDic);
            //NSString *token = [resultDic objectForKey:@"token"];
            NSLog(@"接下来可以拿着Token去服务端换取手机号，有了手机号就可以登录，SDK提供服务到此结束");
            //[weakSelf dismissViewControllerAnimated:YES completion:nil];
            [self postLoginWithToken:[resultDic objectForKey:@"token"]];
            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
        } else {
            NSLog(@"获取LoginToken或拉起授权页失败回调：%@", resultDic);
            [MBProgressHUD hideHUDForView:vc.view animated:YES];
            //失败后可以跳转到短信登录界面

            LoginMessageViewController *controller = [[LoginMessageViewController alloc] init];
            controller.isHiddenNavgationBar = YES;
            UINavigationController *nav= vc.navigationController;
            if (vc.presentedViewController) {
                //如果授权页成功拉起，这个时候则需要使用授权页的导航控制器进行跳转
                nav = (UINavigationController *)vc.presentedViewController;
            }
            [nav pushViewController:controller animated:YES];
        }
    }];
}

#pragma mark ----登录
+ (void)postLoginWithToken: (NSString *)token{
    NSString *url = [NSString stringWithFormat:POST_LOGIN,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:token forKey:@"id"];//密码登陆为用户名,手机验证码登陆时为手机号码,移动运营商一键登录（阿里sdk)时为token,微信登录时为微信code
    [parameDic setObject:@"MOBILE_ALI" forKey:@"type"];//PASSWORD-密码登录,CODE-验证码登录,WECHAT-微信登录,MOBILE_ALI
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject==%@", responseObject);
        NSMutableDictionary *respDic= [responseObject objectForKey:@"result"] ;
        [SaveData SaveLoginWithDic:respDic];
        [SaveData saveToken:[respDic objectForKey:@"token"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
