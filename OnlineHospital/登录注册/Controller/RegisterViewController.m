//
//  RegisterViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/10/15.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "RegisterViewController.h"
#import "GTLoginTextField.h"
#import "GTTimerButton.h"

@interface RegisterViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) GTLoginTextField *textPhone;
@property (nonatomic, strong) GTLoginTextField *textCode;
@property (nonatomic, strong) GTLoginTextField *textPwd1;
@property (nonatomic, strong) GTLoginTextField *textPwd2;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = NO;
        //将触摸事件添加到当前view
        [self.view addGestureRecognizer:tapGestureRecognizer];
    [self addNavigationtitleWithTitle:@"注册" detailTitle:@"已有账号,请返回"];
             UIView *bg1 =  [self textFieldBgViewWithFrame:CGRectMake(20, 240, Screen_W - 40, 50)];
             [self.view addSubview:bg1];
             UIView *bg2 = [self textFieldBgViewWithFrame:CGRectMake(20, 300, Screen_W - 40, 50)];
             [self.view addSubview:bg2];
    UIView *bg3 = [self textFieldBgViewWithFrame:CGRectMake(20, 360, Screen_W - 40, 50)];
    [self.view addSubview:bg3];
    UIView *bg4 = [self textFieldBgViewWithFrame:CGRectMake(20, 420, Screen_W - 40, 50)];
    [self.view addSubview:bg4];
    self.textPhone = [GTLoginTextField textFieldWithPlaceholder:@"请输入手机号"];
    self.textPhone.delegate = self;
    [bg1 addSubview:self.textPhone];
    self.textCode = [GTLoginTextField textFieldWithPlaceholder:@"请输入验证码"];
    self.textCode.delegate = self;
    [bg2 addSubview:self.textCode];
    GTTimerButton *btnTimer = [GTTimerButton button];
    [btnTimer setTitle:@"获取验证码" forState:UIControlStateNormal];
    [btnTimer addTarget:self action:@selector(btnTimerClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bg2 addSubview:btnTimer];
    self.textPwd1 = [GTLoginTextField textFieldWithPlaceholder:@"请输入密码(至少6位)"];
    self.textPwd1.delegate = self;
     [bg3 addSubview: self.textPwd1];
    self.textPwd2 = [GTLoginTextField textFieldWithPlaceholder:@"请再次输入密码"];
    self.textPwd2.delegate = self;
     [bg4 addSubview:self.textPwd2];
    
    GTBlueButton *btnblue = [GTBlueButton blueButtonWithFrame:CGRectMake(20, 510, Screen_W - 40, 50) ButtonTitle:@"注册"];
    [btnblue addTarget:self action:@selector(btnSignUpClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnblue];
}

-(void)btnTimerClicked: (GTTimerButton *)button{
    [button openCountdown:button];
    [self postCode];
}

- (void)btnSignUpClicked{
    [self postRegister];
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.textPhone resignFirstResponder];
    [self.textCode resignFirstResponder];
    [self.textPwd1 resignFirstResponder];
    [self.textPwd2 resignFirstResponder];
}

#pragma mark -----获取验证码
- (void)postCode{
    if (self.textPhone.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    if (self.textPhone.text.length !=11) {
        [SVProgressHUD showErrorWithStatus:@"您输入的手机号有误,请核实后重新输入"];
        return;
    }
    NSString *url = [NSString stringWithFormat:POST_SENDCODE,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:self.textPhone.text forKey:@"mobile"];
    [parameDic setObject:@"SignUp" forKey:@"type"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameDic options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"验证码已发送,请注意查收"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark ----注册
- (void)postRegister{
    if (self.textPhone.text.length ==0) {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
        return;
    }
    if (self.textCode.text.length ==0) {
        [SVProgressHUD showErrorWithStatus:@"验证码不能为空"];
        return;
    }
    if (self.textPwd1.text.length < 6) {
        [SVProgressHUD showErrorWithStatus:@"密码不能小于6位"];
        return;
    }
    if (![self.textPwd1.text isEqual:self.textPwd2.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码输入不同"];
        return;
    }
    NSString *url = [NSString stringWithFormat:POST_SIGNUP,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:self.textCode.text forKey:@"code"];//验证码
    [parameDic setObject:self.textPhone.text forKey:@"mobile"];//手机号
    [parameDic setObject:self.textPwd1.text forKey:@"password"];//密码
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject==%@", responseObject);
        NSMutableDictionary *respDic= [responseObject objectForKey:@"result"] ;
        [SaveData SaveLoginWithDic:respDic];
        [SaveData saveToken:[respDic objectForKey:@"token"]];
        NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-2]animated:NO];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
