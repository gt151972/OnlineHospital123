//
//  MineInfoViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "MineInfoViewController.h"

@interface MineInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    NSString *strImage;
    NSString *strNickName;
    NSString *strRealName;
    NSString *stridCard;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic, strong)UIImageView *headView;
@property(nonatomic, strong)UITextField *textfield;
@end

@implementation MineInfoViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = BG_COLOR_WHITE;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self postInfo];
    self.view.backgroundColor = BG_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:BG_COLOR] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    self.title = @"个人资料";
    [self.view addSubview:self.tableView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
        tapGestureRecognizer.cancelsTouchesInView = NO;
        //将触摸事件添加到当前view
        [self.tableView addGestureRecognizer:tapGestureRecognizer];
//    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
//    gestureRecognizer.numberOfTapsRequired = 1;
//    gestureRecognizer.cancelsTouchesInView = NO;
//    [self.tableView addGestureRecognizer:gestureRecognizer];
    GTBlueButton *btnblue = [GTBlueButton blueButtonWithFrame:CGRectMake(20, 400, Screen_W - 40, 50) ButtonTitle:@"保存"];
    [btnblue addTarget:self action:@selector(btnBlueClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnblue];
}

- (void)initDate{
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[SaveData readUserInfo]];
    strNickName = dic[@"nickName"];
    strRealName = dic[@"realName"];
    stridCard = dic[@"idCard"];
}
#pragma mark --- UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = BG_COLOR;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
               self.tableView.separatorColor = BG_COLOR;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }else{
        return 64;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = @[@"头像", @"账号", @"昵称", @"真实姓名", @"身份证号码"];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.textLabel.text = array[indexPath.row];
    cell.textLabel.textColor = TEXT_COLOR_MAIN;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {

        self.headView = [[UIImageView alloc] init];
        self.headView.layer.masksToBounds = YES;
        self.headView.layer.cornerRadius = 30;
//        self.headView.backgroundColor = BLUE_COLOR_MAIN;
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[SaveData readUserInfo]];
        NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE,rootURL2,[dic objectForKey:@"headSculpturec"] ];
        [self.headView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"mine_head"]];
        [cell.contentView addSubview:self.headView];
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.centerY.equalTo(cell.contentView);
            make.width.height.mas_equalTo(60);
        }];
    }else if (indexPath.row == 1){
        
        cell.detailTextLabel.text = [[SaveData readUserInfo] objectForKey:@"userId"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.textColor = TEXT_COLOR_DETAIL;
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[SaveData readUserInfo]];
        if (indexPath.row == 1 && [dic objectForKey:@"mobile"] ) {
            cell.detailTextLabel.text = dic[@"mobile"];
        }
        
    }else{
        self.textfield  = [[UITextField alloc] initWithFrame:CGRectMake(55, 0, maxScreenWidth-70, cell.contentView.size.height)];
        self.textfield.tag = 30+indexPath.row;
        self.textfield.textAlignment = NSTextAlignmentRight;
        self.textfield.borderStyle = UITextBorderStyleNone;
        self.textfield.placeholder = @"请输入";
        self.textfield.textColor = TEXT_COLOR_DETAIL;
        self.textfield.delegate = self;
        self.textfield.font = [UIFont systemFontOfSize:16];
        self.textfield.keyboardType = UIKeyboardTypeDefault;
        [cell.contentView addSubview:self.textfield];
        [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.and.centerY.equalTo(cell.contentView);
        }];
        [[self.textfield rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        }];
        if ([SaveData readUserInfo]) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[SaveData readUserInfo]];
             if (indexPath.row == 2 && [dic objectForKey:@"nickName"] ) {
                self.textfield.text = dic[@"nickName"];
            }else  if (indexPath.row == 3 && [dic objectForKey:@"realName"] ) {
                self.textfield.text = dic[@"realName"];
            }else  if (indexPath.row == 4 && [dic objectForKey:@"idCard"] ) {
                    self.textfield.text = dic[@"idCard"];
            }
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        [self openCamera];
    }else if (indexPath.section == 2){
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)openCamera {
     UIAlertController *userIconActionSheet = [UIAlertController alertControllerWithTitle:@"请选择上传类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
      //相册选择
      UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//          WKLog(@"相册选择");
          //这里加一个判断，是否是来自图片库
          if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
              UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
              imagePicker.delegate = self;            //协议
              imagePicker.allowsEditing = YES;
              imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
              [self presentViewController:imagePicker animated:YES completion:nil];
          }
      }];
      //系统相机拍照
      UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//          WKLog(@"相机选择");
          if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                 UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
              imagePicker.delegate = self;
              imagePicker.allowsEditing = YES;
              imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
              [self presentViewController:imagePicker animated:YES completion:nil];
          }
      }];
      UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
          //取消
//          WKLog(@"取消");
      }];
      [userIconActionSheet addAction:albumAction];
      [userIconActionSheet addAction:photoAction];
      [userIconActionSheet addAction:cancelAction];
      [self presentViewController:userIconActionSheet animated:YES completion:nil];
}
 
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSLog(@"info == %@",info);
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.headView setImage:image];
}
//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"tf == %@",textField.text);
    if (textField.tag == 32) {
        strNickName = textField.text;
    }else if (textField.tag == 33){
        strRealName = textField.text;
    }else if (textField.tag == 34){
        stridCard = textField.text;
    }
}


- (void)btnBlueClicked{
//    if (stridCard.length != 18) {
//        [SVProgressHUD showErrorWithStatus:@"请输入正确的身份证号"];
//        return;
//    }
    [self updateImage];
//    [self putUpdate];
    [self.navigationController popViewControllerAnimated:YES];

}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
//    [self.textfield resignFirstResponder];
    [self.view endEditing:YES];
//    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark -----修改用户信息接口
- (void)putUpdate{
    if (strNickName.length == 0) {
        strNickName = @"";
    }
    if (strRealName.length == 0) {
        strRealName = @"";
    }
    if (stridCard.length == 0) {
        stridCard = @"";
    }
    NSString *url = [NSString stringWithFormat:PUT_UPDATE,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
//    [parameDic setObject:nil forKey:@"headSculpture"];
    [parameDic setObject:strNickName forKey:@"nickName"];
    [parameDic setObject:strRealName forKey:@"realName"];
    [parameDic setObject:stridCard forKey:@"idCard"];
    [RequestUtil Put:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
            
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark -----上传头像
- (void)updateImage{
    NSString *url = [NSString stringWithFormat:POST_OSS_UPDATE,rootURL2];
//    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
//    [parameDic setObject:strNickName forKey:@"nickName"];
    [RequestUtil uploadSingleImage:url withSign:NO
                            params:nil indexName:@"" image:self.headView.image success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark -----用户信息接口
- (void)postInfo{
    NSString *url = [NSString stringWithFormat:POST_INFO,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setValue:[SaveData readToken] forKey:@"token"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        [SaveData SaveUserInfoWithDic:[responseObject objectForKey:@"result"]];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
