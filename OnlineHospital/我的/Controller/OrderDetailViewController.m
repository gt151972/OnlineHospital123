//
//  OrderDetailViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/22.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderPayViewController.h"
#import "StateVideoTableViewCell.h"
#import "OrderDetailMoneyTableViewCell.h"
#import "OrderInfoTableViewCell.h"
#import "HomeDoctorViewController.h"
#import "DoctorModel.h"
#import "MineOrderViewController.h"
static NSString *identifier = @"StateVideoTableViewCell";
static NSString *identifier2 = @"OrderDetailMoneyTableViewCell";
static NSString *identifier3 = @"OrderInfoTableViewCell";
@interface OrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频订单详情";
    [self postOrder:_model.orderId];
    self.view.backgroundColor = BG_COLOR;
    [self.view addSubview:self.tableView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake(0,0,40.0f,40.0f);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
-(void)backBtnAction{
    if (_isRefunding) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[MineOrderViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
                return;
            }
         }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(12, 8, Screen_W-24, Screen_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = BG_COLOR;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
        [self.tableView registerNib:[UINib nibWithNibName:identifier2 bundle:nil] forCellReuseIdentifier:identifier2];
        [self.tableView registerNib:[UINib nibWithNibName:identifier3 bundle:nil] forCellReuseIdentifier:identifier3];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!_isPay) {
        return 3;
    }
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if ([_model.buyLevel intValue] ==2 && [_model.liveType intValue] == 1) {
            return 247;
        }else{
            return 165;
        }
    }else if (indexPath.section == 1){
        return 90;
    }else if (indexPath.section == 3){
        return 50;
    }else{
        if ([_model.payStatus intValue] == 1 || [_model.payStatus intValue] == 2) {
            return 170;
        }else{
            return 120;
        }
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
        if (_isMessage) {
            cell.orderModel = _orderModel;
            cell.famousModel = _famousModel;
            cell.type = 3;
            cell.labAllMoney.hidden = YES;
        }else{
            cell.model = _model;
            cell.type = 1;
            cell.isReturning = _isRefunding;
            NSLog(@"_isRefund == %d",_isRefund);
//            if (_isRefund) {
//                cell.labState.text = @"退款中";
//            }
        }
        WS
        [[cell.btnHeadClicked rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
            [self postDoctor:weakSelf.model.doctorId];
        }];
        cell.backgroundColor = BG_COLOR_WHITE;
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
               return cell;
    }else if (indexPath.section == 1){
        OrderDetailMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
                      if (cell == nil) {
                          cell = [[OrderDetailMoneyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
                      }
        if (_isMessage) {
            cell.labShould.text = [NSString stringWithFormat:@"¥%.2f",[_famousModel.normalPrice floatValue]];
            cell.labFact.text = [NSString stringWithFormat:@"¥%.2f",[_orderModel.normalAmount floatValue]];
        }else{
            cell.labShould.text = [NSString stringWithFormat:@"¥%.2f",[_model.normalAmount floatValue]];
            cell.labFact.text = [NSString stringWithFormat:@"¥%.2f",[_model.paidAmount floatValue]];
        }

                      cell.backgroundColor = BG_COLOR_WHITE;
                      cell.selectionStyle = UITableViewCellSelectionStyleNone;
                      return cell;
    }else if(indexPath.section == 2){
        OrderInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3];
        if (cell == nil) {
            cell = [[OrderInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier3];
        }
        if (_isMessage) {
            cell.label1.text = [NSString stringWithFormat:@"订单编号:  %@",_orderModel.customNO];
            cell.label2.text = [NSString stringWithFormat:@"交易号:      %@",_orderModel.productId];
            if ([_model.payStatus intValue] == 1 || [_model.payStatus intValue] == 2) {
                cell.label3.text = [NSString stringWithFormat:@"提交时间:  %@",[BaseDataChange getDateStringWithTimeStr:_orderModel.createdDate]];
                cell.label4.text = [NSString stringWithFormat:@"支付时间:  %@",[BaseDataChange getDateStringWithTimeStr:_orderModel.paidDate]];
            }else{
                cell.label2.text = [NSString stringWithFormat:@"提交时间:  %@",[BaseDataChange getDateStringWithTimeStr:_orderModel.createdDate]];
                cell.label3.hidden = YES;
                cell.label4.hidden = YES;
            }
            if (_isRefund) {
                cell.label5.text = [NSString stringWithFormat:@"退款理由:  %@",_strReason];
            }else{
                cell.label5.hidden = YES;
            }
        }else{
            cell.label1.text = [NSString stringWithFormat:@"订单编号:  %@",_model.customId];
            cell.label2.text = [NSString stringWithFormat:@"交易号:      %@",_model.payOrderId];
            if ([_model.payStatus intValue] == 1 || [_model.payStatus intValue] == 2) {
                cell.label3.text = [NSString stringWithFormat:@"提交时间:  %@",[BaseDataChange getDateStringWithTimeStr:_model.createdDate]];
                cell.label4.text = [NSString stringWithFormat:@"支付时间:  %@",[BaseDataChange getDateStringWithTimeStr:_model.paidDate]];
            }else{
                cell.label2.text = [NSString stringWithFormat:@"提交时间:  %@",[BaseDataChange getDateStringWithTimeStr:_model.createdDate]];
                cell.label3.hidden = YES;
                cell.label4.hidden = YES;
            }
            if (_isRefund) {
                cell.label5.text = [NSString stringWithFormat:@"退款理由:  %@",_strReason];
            }else{
                cell.label5.hidden = YES;
            }
        }
      
        cell.backgroundColor = BG_COLOR_WHITE;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *identifier = @"HomeLeadViewController";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.backgroundColor = BG_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        GTBlueButton *btnAudit = [GTBlueButton whiteButtonWithFrame:CGRectMake(0, 0, (Screen_W - 24)/3, 50) ButtonTitle:@" 取消订单"];
        [cell.contentView addSubview:btnAudit];
        WS
        [[btnAudit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton * _Nullable x) {
            [self postOrderCancel];
        }];
        GTBlueButton *btn = [GTBlueButton blueButtonWithFrame:CGRectMake(0 + (Screen_W - 24)/3, 0, (Screen_W - 24)*2/3, 50) ButtonTitle:@"支付"];
        [cell.contentView addSubview:btn];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton * _Nullable x) {
            OrderPayViewController *vc = [[OrderPayViewController alloc] init];
            vc.type = 1;
            vc.model = weakSelf.model;
            vc.strID = weakSelf.model.orderId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
//        GTBlueButton *btn = [GTBlueButton blueButtonWithFrame:CGRectMake(0, 0, Screen_W - 24, 50) ButtonTitle:@"支付"];
//        [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:btn];
        return cell;
    }
}

- (void)btnClicked{
    OrderPayViewController *vc = [[OrderPayViewController alloc] init];
    vc.type = 2;
    vc.model = _model;
    vc.strID = _model.orderId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -----取消订单
- (void)postOrderCancel{
    NSString *url = [NSString stringWithFormat:POST_CANCEL,rootURL];
    [RequestUtil POST:url parameters:_model.orderId withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        [SVProgressHUD showSuccessWithStatus:@"订单已取消"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
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

#pragma mark -----获取订单详情
- (void)postOrder : (NSString *)string{
    NSString *url = [NSString stringWithFormat:POST_ORDER_GET,rootURL];
    [RequestUtil POST:url parameters:string withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSDictionary *respDic = [responseObject objectForKey:@"result"];
        _orderModel = [OrderModel mj_objectWithKeyValues:respDic];
        _model.payStatus = _orderModel.status;
//        _isMessage = 1;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
