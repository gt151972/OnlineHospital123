//
//  LoginMessageViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/14.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "LoginMessageViewController.h"
#import "GTLoginTextField.h"
#import "LoginPwdViewController.h"
#import "GTTimerButton.h"
#import <AFNetworkActivityIndicatorManager.h>
#import "UserInfoModel.h"
#import "GTArticalViewController.h"
#import <YYKit/YYKit.h>
@interface LoginMessageViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) GTLoginTextField *textPhone;
@property (nonatomic, strong) GTLoginTextField *textCode;
@property (nonatomic, strong) GTTimerButton *btnTimer;
@end

@implementation LoginMessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isHiddenNavgationBar) {
        //显示系统导航栏
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isHiddenNavgationBar) {
        //隐藏系统导航栏
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = NO;
        //将触摸事件添加到当前view
        [self.view addGestureRecognizer:tapGestureRecognizer];
   [self addNavigationtitleWithTitle:@"短信登录" detailTitle:@"未注册的手机号码将自动注册,"];
    GTBlueButton *btnPwdLogin = [GTBlueButton minBlueButtonWithFrame:CGRectMake(148, 136, Screen_W - 200, 20) ButtonTitle:@"密码登录"];
    [btnPwdLogin addTarget:self action:@selector(btnPwdLoginClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPwdLogin];
    UIView *bg1 =  [self textFieldBgViewWithFrame:CGRectMake(20, 240, Screen_W - 40, 50)];
    [self.view addSubview:bg1];
    UIView *bg2 = [self textFieldBgViewWithFrame:CGRectMake(20, 300, Screen_W - 40, 50)];
    [self.view addSubview:bg2];
    self.textPhone = [GTLoginTextField textFieldWithPlaceholder:@"请输入手机号"];
    self.textPhone.delegate = self;
    [bg1 addSubview:self.textPhone];
    self.textCode = [GTLoginTextField textFieldWithPlaceholder:@"请输入验证码"];
    self.textCode.delegate = self;
     [bg2 addSubview:self.textCode];
    self.btnTimer = [GTTimerButton button];
    [self.btnTimer setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.btnTimer addTarget:self action:@selector(btnCodeClicked) forControlEvents:UIControlEventTouchUpInside];
        [bg2 addSubview:self.btnTimer];
    GTBlueButton *btnblue = [GTBlueButton blueButtonWithFrame:CGRectMake(20, 390, Screen_W - 40, 50) ButtonTitle:@"登录"];
    [btnblue addTarget:self action:@selector(btnBlueClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnblue];
//    [self postLogin];
    NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString:@"登录即代表您同意《用户协议》和《隐私权政策》"];
    [text setTextHighlightRange:[[text string] rangeOfString:@"《用户协议》"] color:BLUE_COLOR_MAIN backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"点击了《用户协议》");
        GTArticalViewController *vc = [[GTArticalViewController alloc] init];
        vc.strPath = LOGIN_AGREEMENT;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [text setTextHighlightRange:[[text string] rangeOfString:@"《隐私权政策》"] color:BLUE_COLOR_MAIN backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"点击了《用户协议》");
        GTArticalViewController *vc = [[GTArticalViewController alloc] init];
        vc.strPath = LOGIN_POLICY;
        [self.navigationController pushViewController:vc animated:YES];
    }];

     YYLabel*labProtocol =[[YYLabel alloc] init];
    labProtocol.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    labProtocol.textAlignment = NSTextAlignmentCenter;
    labProtocol.attributedText = text;
    [self.view addSubview:labProtocol];
    [labProtocol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btnblue.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
    
}
//密码登录
- (void)btnPwdLoginClicked{
    LoginPwdViewController *vc = [[LoginPwdViewController alloc] init];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
}
//登录
- (void)btnBlueClicked{
    [self postLogin];
     
}
//获取验证码
- (void)btnCodeClicked{
    if (self.textPhone.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    [self.btnTimer openCountdown:self.btnTimer];
    [self postCode];
}

-(void)getUserInfo{
    
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.textPhone resignFirstResponder];
    [self.textCode resignFirstResponder];
}
#pragma mark -----获取验证码
- (void)postCode{
    NSString *url = [NSString stringWithFormat:POST_SENDCODE,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:self.textPhone.text forKey:@"mobile"];
    [parameDic setObject:@"Login" forKey:@"type"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark ----登录
- (void)postLogin{
    NSString *url = [NSString stringWithFormat:POST_LOGIN,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:self.textCode.text forKey:@"authString"];//密码登陆时为密码,验证码登录时为验证码
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    [parameDic setObject:@"phoneVersion" forKey:@"device"];//登录设备,选填
    [parameDic setObject:self.textPhone.text forKey:@"id"];//密码登陆为用户名,手机验证码登陆时为手机号码,移动运营商一键登录（阿里sdk)时为token,微信登录时为微信code
    [parameDic setObject:@"CODE" forKey:@"type"];//PASSWORD-密码登录,CODE-验证码登录,WECHAT-微信登录,MOBILE_ALI
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject==%@", responseObject);
        NSMutableDictionary *respDic= [responseObject objectForKey:@"result"] ;
        [SaveData SaveLoginWithDic:respDic];
        [SaveData saveToken:[respDic objectForKey:@"token"]];
        [self.navigationController popViewControllerAnimated:YES];
        [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
//        NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
//
//        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:NO];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
