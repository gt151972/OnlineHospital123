//
//  LoginPwdViewController.m
//  OnlineHospital
//  密码登录/找回密码1/找回密码2
//  Created by 高天的Mac on 2020/8/14.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "LoginPwdViewController.h"
#import "RegisterViewController.h"
#import "GTLoginTextField.h"
#import "GTTimerButton.h"
#import <YYKit/YYKit.h>
#import "GTArticalViewController.h"
@interface LoginPwdViewController ()<UITextFieldDelegate>{
    NSString *strTitle;
    NSString *strTitleDetail;
    NSString *strTextFirst;
    NSString *strTextSecond;
    NSString *strButton;
}
@property (nonatomic, strong) GTLoginTextField *textPhone;
@property (nonatomic, strong) GTLoginTextField *textCode;
@property (nonatomic , assign) BOOL isSelect;
@end

@implementation LoginPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = NO;
        //将触摸事件添加到当前view
        [self.view addGestureRecognizer:tapGestureRecognizer];

    if (_type == 1) {
        [self typePwdLogin];
    }else if (_type == 2 || _type == 4){
        [self typeFindPwd];
    }else if (_type == 3 || _type == 5){
        [self typeFindPwd2];
    }
    [self initView];
}

- (void)typePwdLogin{
    strTitle = @"密码登录";
    strTitleDetail = @"忘记密码？点击这里";
    strTextFirst = @"请输入手机号码";
    self.textPhone.secureTextEntry = NO;
    strTextSecond = @"请输入密码";
    strButton = @"登录";
    GTBlueButton *btnRegister = [GTBlueButton blackButtonWithFrame:CGRectMake(Screen_W - 70, 20, 70,44) ButtonTitle:@"注册"];
    [btnRegister addTarget:self action:@selector(btnRegisterClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnRegister];
    GTBlueButton *btnFind = [GTBlueButton minBlueButtonWithFrame:CGRectMake(90, 136, Screen_W - 200, 20) ButtonTitle:@"找回密码"];
    [btnFind addTarget:self action:@selector(btnFindClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFind];
    

    
}


- (void)typeFindPwd{
    if (_type == 2) {
        strTitle = @"找回密码";
    }else{
        strTitle = @"修改密码";
    }
    strTitleDetail = @"请输入手机号和验证码";
    strTextFirst = @"请输入手机号码";
    self.textPhone.secureTextEntry = NO;
    strTextSecond = @"请输入验证码";
    strButton = @"确认";
    
    
}

- (void)typeFindPwd2{
    if (_type == 3) {
        strTitle = @"找回密码";
    }else{
        strTitle = @"修改密码";
    }
    strTitleDetail = @"请设置新密码";
    strTextFirst = @"请输入新密码";
    self.textPhone.secureTextEntry = YES;
    strTextSecond = @"请再输入新密码";
    strButton = @"确认";
}

- (void)initView{
    [self addNavigationtitleWithTitle:strTitle detailTitle:strTitleDetail];
             UIView *bg1 =  [self textFieldBgViewWithFrame:CGRectMake(20, 240, Screen_W - 40, 50)];
             [self.view addSubview:bg1];
             UIView *bg2 = [self textFieldBgViewWithFrame:CGRectMake(20, 300, Screen_W - 40, 50)];
             [self.view addSubview:bg2];
             self.textPhone = [GTLoginTextField textFieldWithPlaceholder:strTextFirst];
             self.textPhone.delegate = self;
             [bg1 addSubview:self.textPhone];
             self.textCode = [GTLoginTextField textFieldWithPlaceholder:strTextSecond];
    self.textCode.delegate = self;
    self.textCode.secureTextEntry = YES;
              [bg2 addSubview:self.textCode];
    if (_type == 2 || _type == 4) {
        GTTimerButton *btnTimer = [GTTimerButton button];
        [btnTimer setTitle:@"获取验证码" forState:UIControlStateNormal];
        [btnTimer addTarget:self action:@selector(btnTimerClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [bg2 addSubview:btnTimer];
    }
             GTBlueButton *btnblue = [GTBlueButton blueButtonWithFrame:CGRectMake(20, 390, Screen_W - 40, 50) ButtonTitle:strButton];
    btnblue.tag = _type;
             [btnblue addTarget:self action:@selector(btnBlueClicked:) forControlEvents:UIControlEventTouchUpInside];
             [self.view addSubview:btnblue];
    
    if (_type == 1) {
        NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString:@"登录即代表您同意《用户协议》和《隐私权政策》"];
        [text setTextHighlightRange:[[text string] rangeOfString:@"《用户协议》"] color:BLUE_COLOR_MAIN backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"点击了《用户协议》");
            GTArticalViewController *vc = [[GTArticalViewController alloc] init];
            vc.strPath = LOGIN_POLICY;
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
}

-(void)btnBlueClicked: (UIButton *)button{
    if (button.tag == 1) {
        [self postLogin];
    }else if (button.tag == 2 || button.tag == 4){
        LoginPwdViewController *vc = [[LoginPwdViewController alloc] init];
        vc.type = button.tag+1;
        vc.strPhone = self.textPhone.text;
        vc.strCode = self.textCode.text;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if (self.textPhone.text.length < 6) {
            [SVProgressHUD showErrorWithStatus:@"密码不能小于6位"];
            return;
        }
        if (![self.textPhone.text isEqualToString:self.textCode.text]) {
            [SVProgressHUD showErrorWithStatus:@"新密码不一致,请确认"];
            return;
        }
        [self putPassword];
    }
}

- (void)btnFindClicked{
//    if (self.textPhone.text.length == 0) {
//        [SVProgressHUD showErrorWithStatus:@"账号不能为空"];
//        return;
//    }
//    if (self.textPhone.text.length != 11) {
//        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
//        return;
//    }
//    if (self.textCode.text.length == 0) {
//        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
//        return;
//    }
   LoginPwdViewController *vc = [[LoginPwdViewController alloc] init];
    vc.type = 2;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.textPhone resignFirstResponder];
    [self.textCode resignFirstResponder];
}
- (void)btnRegisterClicked{
   RegisterViewController *vc = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)btnTimerClicked: (GTTimerButton *)button{
    [button openCountdown:button];
    [self postCode];
}

#pragma mark -------登录
- (void)postLogin{
    NSString *url = [NSString stringWithFormat:POST_LOGIN,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:self.textCode.text forKey:@"authString"];//密码登陆时为密码,验证码登录时为验证码
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    [parameDic setObject:@"phoneVersion" forKey:@"device"];//登录设备,选填
    [parameDic setObject:self.textPhone.text forKey:@"id"];//密码登陆为用户名,手机验证码登陆时为手机号码,移动运营商一键登录（阿里sdk)时为token,微信登录时为微信code
    [parameDic setObject:@"PASSWORD" forKey:@"type"];//PASSWORD-密码登录,CODE-验证码登录,WECHAT-微信登录,MOBILE_ALI
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject==%@", responseObject);
        NSMutableDictionary *respDic= [responseObject objectForKey:@"result"] ;
        [SaveData SaveLoginWithDic:respDic];
        [SaveData saveToken:[respDic objectForKey:@"token"]];
        NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:NO];
        [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark -----验证码(找回密码1)
- (void)postCode{
    if (self.textPhone.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    if (self.textPhone.text.length != 11) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的手机号"];
        return;
    }
    NSString *url = [NSString stringWithFormat:POST_SENDCODE,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:self.textPhone.text forKey:@"mobile"];
    [parameDic setObject:@"ResetPassword" forKey:@"type"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark -----修改密码(找回密码2)
- (void)putPassword{
    if (self.textPhone.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
        return;
    }
    if (self.textPhone.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码不能小于6位"];
        return;
    }
    if (![self.textPhone.text isEqual:self.textCode.text]) {
        [SVProgressHUD showErrorWithStatus:@"密码不能小于6位"];
        return;
    }
    NSString *url = [NSString stringWithFormat:PUT_PASSWORD,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:_strCode forKey:@"code"];
    [parameDic setObject:_strPhone forKey:@"mobile"];
//    [parameDic setObject:@"1234" forKey:@"code"];
//    [parameDic setObject:@"18815287521" forKey:@"mobile"];
    [parameDic setObject:self.textPhone.text forKey:@"newPassword"];
    [parameDic setObject:@"" forKey:@"oldPassword"];
    [parameDic setObject:@"Code" forKey:@"type"];
    
    [RequestUtil Put:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:NO];
        [SVProgressHUD showSuccessWithStatus:@"密码设置成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
