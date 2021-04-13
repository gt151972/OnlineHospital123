//
//  LoginCodeViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/14.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "LoginCodeViewController.h"
#import "GTLoginTextField.h"
@interface LoginCodeViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) GTLoginTextField *textPhone;
@end

@implementation LoginCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = NO;
        //将触摸事件添加到当前view
        [self.view addGestureRecognizer:tapGestureRecognizer];
    NSString *strDetail = [NSString stringWithFormat:@"已发送验证码至%@",_strPhone];
    [self addNavigationtitleWithTitle:@"请输入验证码" detailTitle:strDetail];
    UIView *bg1 =  [self textFieldBgViewWithFrame:CGRectMake(20, 240, Screen_W - 40, 50)];
    [self.view addSubview:bg1];
    self.textPhone = [GTLoginTextField textFieldWithPlaceholder:@"请输入验证码"];
    self.textPhone.delegate = self;
    [bg1 addSubview: self.textPhone];
    GTBlueButton *btnblue = [GTBlueButton blueButtonWithFrame:CGRectMake(20, 390, Screen_W - 40, 50) ButtonTitle:@"确认"];
    [btnblue addTarget:self action:@selector(btnBlueClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnblue];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.textPhone resignFirstResponder];
}
@end
