//
//  OrderReturnViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/11/26.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "OrderReturnViewController.h"
#import "StateVideoTableViewCell.h"
#import "ReasonViewController.h"
#import "OrderDetailViewController.h"
#import "HomeDoctorViewController.h"
#import "DoctorModel.h"
static NSString *identifier = @"StateVideoTableViewCell";

@interface OrderReturnViewController ()<UITableViewDelegate, UITableViewDataSource,ReasonDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSString*strReason;
@end

@implementation OrderReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频订单退款";
    self.strReason = @"";
    self.view.backgroundColor = BG_COLOR;
    [self.view addSubview:self.tableView];
    if ([_model.refundTimeOut intValue] > [[BaseDataChange getTimestampFromTime] intValue]) {
        GTBlueButton *btn = [GTBlueButton blueButtonWithFrame:CGRectMake(12, Screen_H - 100 - SafeAreaTopHeight, Screen_W - 24, 50) ButtonTitle:@"提交"];
        [btn addTarget:self action:@selector(btnPayClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

#pragma mark ---UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 8, Screen_W, Screen_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = BG_COLOR;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
//        [self.tableView registerNib:[UINib nibWithNibName:identifier2 bundle:nil] forCellReuseIdentifier:identifier2];
//        [self.tableView registerNib:[UINib nibWithNibName:identifier3 bundle:nil] forCellReuseIdentifier:identifier3];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 4;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([_model.buyLevel intValue] ==2 && [_model.liveType intValue] == 1) {
            return 250;
        }else{
            return 170;
        }
    }else {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view =[[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        StateVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
               if (cell == nil) {
                   cell = [[StateVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
               }
        cell.model = _model;
        cell.type = 1;
        cell.labState.text = @"已支付";
        cell.labState.hidden = YES;
        cell.isShowDate = YES;
        WS
        [[cell.btnHeadClicked rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
            [self postDoctor:weakSelf.model.doctorId];
        }];
        cell.backgroundColor = BG_COLOR_WHITE;
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isReturn = YES;
               return cell;
    }else{
        NSArray *arrayTitle = @[@"退款原因", @"退款金额", @"退款截止时间", @"名医视频互动请于报名截止日期之前退款，名医视频和专家讲座请于支付后2小时内退款。退款方式同支付方式。"];
        static NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            }
            cell.backgroundColor = BG_COLOR_WHITE;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = _strReason;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.text = arrayTitle[indexPath.row];
        if (indexPath.row == 3) {
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.textColor = TEXT_COLOR_DETAIL;
            cell.backgroundColor = [UIColor clearColor];
            
        }
        
        if (indexPath.row == 1) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"¥ %.2f",[_model.paidAmount floatValue] ];
        }else if (indexPath.row == 2){
            cell.detailTextLabel.text = [BaseDataChange getDateStringWithTimeStr:_model.refundTimeOut];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 1 && indexPath.row == 0) {
        ReasonViewController *vc = [[ReasonViewController alloc] init];
        vc.delegate = self;
//                self.tabBarController.tabBar.hidden=YES;
                [self presentViewController:vc animated:NO completion:nil];
    }
}

- (void)btnPayClicked{
    
    [self postRefund];
}

- (void)reason:(NSString *)value{
    self.strReason = value;
    [self.tableView reloadData];
}

#pragma mark -----申请退款
- (void)postRefund{
    if (_strReason.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择退款原因"];
        return;
    }
    NSString *url = [NSString stringWithFormat:POST_REFUND,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:_model.orderId forKey:@"id"];
    [parameDic setObject:_strReason forKey:@"refundCause"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
        vc.model = self. model;
        vc.isRefund = YES;
        vc.isRefunding = YES;
        vc.strReason = self. strReason;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

//#pragma mark -----获取订单详情
//- (void)postOrder{
//    NSString *url = [NSString stringWithFormat:POST_ORDER_GET,rootURL];
//    [RequestUtil POST:url parameters:self.strID withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"responseObject == %@",responseObject);
//        NSArray *respArr = [responseObject objectForKey:@"result"];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//}
#pragma  mark --------获取医生信息
- (void)postDoctor : (NSString *)strDoctorId{
    NSString *url = [NSString stringWithFormat:POST_DOCTOR,rootURL];
    [RequestUtil POST:url parameters:strDoctorId withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *respDic = [responseObject objectForKey:@"result"];
        DoctorModel *model = [DoctorModel mj_objectWithKeyValues:respDic];
        HomeDoctorViewController *vc = [[HomeDoctorViewController alloc] init];
        vc.strDoctorID = strDoctorId;
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
