//
//  SettingViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "SettingViewController.h"
//#import "LoginViewController.h"
#import "LoginPwdViewController.h"
@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.view.backgroundColor = BG_COLOR;
    [self.view addSubview:self.tableView];
}

#pragma mark ---UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 8, Screen_W, Screen_H - SafeAreaTopHeight-90) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = BG_COLOR;
        _tableView.scrollEnabled = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arrayTitle = @[@"当前版本号", @"清除缓存", @"隐私政策", @"设置密码"];
    static NSString *identifier = @"HomeLeadViewController";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        }
        cell.backgroundColor = BG_COLOR_WHITE;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = arrayTitle[indexPath.row];
    if (indexPath.row == 0) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = app_Version;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        
        LoginPwdViewController *vc = [[LoginPwdViewController alloc] init];
        vc.type = 4;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1){//清除缓存
        [SVProgressHUD showSuccessWithStatus:@"清理成功"];
    }
}

//
- (IBAction)btnLogout:(id)sender {
//    LoginViewController *vc = [[LoginViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)beginLogin{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TXCustomModel *model = [OneClickLogin buildModel];
    __weak typeof(self) weakSelf = self;
    [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:3.0
                                                    controller:self
                                                         model:model
                                                      complete:^(NSDictionary * _Nonnull resultDic) {
        NSString *resultCode = [resultDic objectForKey:@"resultCode"];
        if ([PNSCodeLoginControllerPresentSuccess isEqualToString:resultCode]) {
            NSLog(@"授权页拉起成功回调：%@", resultDic);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } else if ([PNSCodeLoginControllerClickCancel isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickLoginBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickProtocol isEqualToString:resultCode]) {
          
            NSLog(@"页面点击事件回调：%@", resultDic);
        }else if ([PNSCodeLoginControllerClickChangeBtn isEqualToString:resultCode]){
            LoginMessageViewController *controller = [[LoginMessageViewController alloc] init];
            controller.isHiddenNavgationBar = YES;
            UINavigationController *nav= weakSelf.navigationController;
            if (weakSelf.presentedViewController) {
                //如果授权页成功拉起，这个时候则需要使用授权页的导航控制器进行跳转
                nav = (UINavigationController *)weakSelf.presentedViewController;
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
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            //失败后可以跳转到短信登录界面

            LoginMessageViewController *controller = [[LoginMessageViewController alloc] init];
            controller.isHiddenNavgationBar = YES;
            UINavigationController *nav= weakSelf.navigationController;
            if (weakSelf.presentedViewController) {
                //如果授权页成功拉起，这个时候则需要使用授权页的导航控制器进行跳转
                nav = (UINavigationController *)weakSelf.presentedViewController;
            }
            [nav pushViewController:controller animated:YES];
        }
    }];
}
#pragma mark ----登录
- (void)postLoginWithToken: (NSString *)token{
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

- (IBAction)btnlogoutClicked:(UIButton *)sender {
    [SaveData removeToken];
    self.navigationController.tabBarController.hidesBottomBarWhenPushed=NO;
    self.navigationController.tabBarController.selectedIndex=0;
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [self beginLogin];
}
@end
