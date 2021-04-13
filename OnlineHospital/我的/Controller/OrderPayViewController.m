//
//  OrderPayViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/22.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "OrderPayViewController.h"
#import "StateVideo2TableViewCell.h"
#import "MineHeadView.h"
#import "PayResultViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APOrderInfo.h"
#import "APRSASigner.h"
#import "wechatPayModel.h"
#import <WXApi.h>
#import "WechatManager.h"
#import "OrderModel.h"
#import "HomeDoctorViewController.h"
#import "DoctorModel.h"
#import "HomeVideoViewController.h"
static NSString *identifier = @"StateVideo2TableViewCell";
@interface OrderPayViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
//@property (nonatomic, strong)AlipayModel *alipayModel;
@property (assign, nonatomic) NSIndexPath *selIndex;
@property (nonatomic, strong)OrderModel *orderModel;
@property (nonatomic, strong)UIButton *btnAlipay;
@property (nonatomic, strong)UIButton *btnWechat;

@end

@implementation OrderPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ailyPayOrWechatSuccessAction)
                                                     name:UserNotificationAlipayOrWechatSuccess
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ailyPayOrWechatFailAction)
                                                     name:UserNotificationAlipayOrWechatFail
                                                   object:nil];
    [self postOrder];
    self.title = @"视频订单支付";
    self.view.backgroundColor = BG_COLOR;
    [self.view addSubview:self.tableView];
    GTBlueButton *btn = [GTBlueButton blueButtonWithFrame:CGRectMake(12, Screen_H - 70 - SafeAreaBottomHeight, Screen_W - 24, 50) ButtonTitle:@"支付"];
    [btn addTarget:self action:@selector(btnPayClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake(0,0,40.0f,40.0f);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
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
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
         return 40;
    }else if (indexPath.section == 1){
        if ([_orderModel.typeCode isEqualToString:@"FamousInteract"]) {
            return 253;
        }
        return 175;
    }
   return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 58;
    }
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    if (section == 2) {
        UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 8, Screen_W- (12*2), 50)];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
         CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
         maskLayer.frame = bgview.bounds;
         maskLayer.path = maskPath.CGPath;
         bgview.layer.mask = maskLayer;
         bgview.backgroundColor = BG_COLOR_WHITE;
        [view addSubview:bgview];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, bgview.size.width - 28, bgview.size.height)];
        label.text = [NSString stringWithFormat:@"支付金额  ¥%.2f",[_orderModel.normalAmount floatValue]];//@"支付金额  ¥10.00";
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = TEXT_COLOR_MAIN;
        [bgview addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(14, 49, Screen_W- (26*2), 1)];
            line.backgroundColor = BG_COLOR;
        [bgview addSubview:line];
        [view addSubview:bgview];
    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.layer.cornerRadius = REDIUS;
        cell.contentView.layer.borderWidth = 1;
        cell.contentView.layer.borderColor = ORANGE_COLOR_MAIN.CGColor;
        long time;
        if (_type == 1) {
           time = [self timeGapWithTime:_model.createdDate];
        }else if (_type == 2){
            time = [self timeGapWithTime:_orderModel.createdDate];
        }else{
            time = [self timeGapWithTime:_orderModel.createdDate];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"请在%ld分钟内将订单支付完成，超时订单将被取消",time]; //@"请在15分钟内将订单支付完成，超时订单将被取消";
        cell.textLabel.textColor = ORANGE_COLOR_MAIN;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
         return cell;
    }else if (indexPath.section == 1){
        StateVideo2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
               if (cell == nil) {
                   cell = [[StateVideo2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
               }
        if (_type == 1) {
            cell.model = _model;
            WS
            [[cell.btnHeadClicked rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
                [self postDoctor:weakSelf.model.doctorId];
            }];
        }else if(_type == 2){
            cell.enrollModel = _enrollModel;
            WS
            [[cell.btnHeadClicked rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
                [self postDoctor:weakSelf.enrollModel.doctorId];
            }];
        }else{
            cell.famousModel = _famousModel;
            WS
            [[cell.btnHeadClicked rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
                [self postDoctor:weakSelf.famousModel.doctorId];
            }];
        }
        cell.isShowDate = YES;
        cell.type = _type;
        cell.orderModel = _orderModel;
        cell.backgroundColor = BG_COLOR_WHITE;
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
               return cell;
    }else{
        static NSString *identifier = @"HomeLeadViewController";
               UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
               if (cell == nil) {
                   cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
               }
               cell.backgroundColor = BG_COLOR_WHITE;
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
//           cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSArray *arrayImage = @[@"pay_wechat", @"pay_alipay", @"pay_apple"];
        NSArray *arrayName = @[@"微信支付", @"支付宝支付", @"Apple Pay"];
        cell.imageView.image = [UIImage imageNamed:arrayImage[indexPath.row]];
        cell.textLabel.text = arrayName[indexPath.row];
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundImage:[UIImage imageNamed:@"vip_btn_nomal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"vip_btn_select"] forState:UIControlStateSelected];
        [cell.contentView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(18);
            make.centerY.equalTo(cell.contentView);
            make.right.mas_equalTo(-8);
        }];
        if (indexPath.row == 0) {
            self.btnWechat = btn;
            self.btnWechat.selected = YES;
        }else{
            self.btnAlipay = btn;
        }
        
        if (indexPath.row == 2) {
            cell.layer.mask = [self maskLayerWithHeight:50 type:1];
        }
        return cell;
    }
   return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.indexPathsForSelectedRows.count > 1) {
           [tableView deselectRowAtIndexPath:tableView.indexPathsForSelectedRows[0] animated:NO];
        }
//    NSArray *arraytype = @[@"WECHAT", @"ALIPAY", @"APPLEAPY"];
//    [self postPayWithType:arraytype[indexPath.row]];
    if (indexPath.section == 2) {
        self.btnWechat.selected = ! indexPath.row;
        self.btnAlipay.selected =  indexPath.row;
    }
    
}
- (CAShapeLayer *)maskLayerWithHeight:(CGFloat)height type: (int)type{
    if (type == 0) {
         UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_W - 24,height) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, Screen_W - 24,height);
           maskLayer.path = maskPath.CGPath;
           return maskLayer;
    }else{
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_W - 24,height) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, Screen_W - 24,height);
           maskLayer.path = maskPath.CGPath;
        return maskLayer;
    }
}

- (void)btnPayClicked{
    if (_btnAlipay.selected && _btnWechat.selected) {
        [SVProgressHUD showErrorWithStatus:@"请选择支付方式"];
    }
    NSArray *arraytype = @[@"WECHAT", @"ALIPAY", @"APPLEAPY"];
    [self postPayWithType:arraytype[ _btnAlipay.selected]];
}

#pragma mark - 利用通知处理支付结果

// 支付成功
- (void)ailyPayOrWechatSuccessAction {
    PayResultViewController *vc = [[PayResultViewController alloc] init];
    vc.model = _orderModel;
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
    

}

// 支付失败
- (void)ailyPayOrWechatFailAction {
    PayResultViewController *vc = [[PayResultViewController alloc] init];
    vc.model = _orderModel;
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];

}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ------统一支付接口
- (void)postPayWithType: (NSString *)type{
    NSString *url = [NSString stringWithFormat:POST_PAY,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:self.strID forKey:@"id"];
    [parameDic setObject:type forKey:@"payType"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSString *string = [responseObject objectForKey:@"result"];
        if ([type isEqualToString:@"ALIPAY"]) {
           NSString *appScheme = @"DuoerHospital";
                [[AlipaySDK defaultService] payOrder:string fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
        }else if ([type isEqualToString: @"WECHAT"]){
            NSData *turnData = [string dataUsingEncoding:NSUTF8StringEncoding];
               NSDictionary *turnDic = [NSJSONSerialization JSONObjectWithData:turnData options:NSJSONReadingMutableLeaves error:nil];
            wechatPayModel *model = [wechatPayModel mj_objectWithKeyValues:turnDic];
            PayReq* req             = [[PayReq alloc] init];
            req.partnerId           = model.partnerid;
            req.prepayId            = model.prepayid;
            req.nonceStr            = model.noncestr;
            req.timeStamp           = [model.timestamp intValue];
            req.package             = model.packageValue;
            req.sign                = model.sign;
            [WechatManager hangleWechatPayWith:req];
            
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
///剩余时间
-(long)timeGapWithTime:(NSString *)time{
    NSTimeInterval timer1 = [time doubleValue];
//    NSTimeInterval timer2 = [time2 doubleValue];
        
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timer1];
    NSString *dateString1 = [formatter stringFromDate:date];
        
    NSDate *date2 = [NSDate date];
    NSString *dateString2 = [formatter stringFromDate:date2];
        
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit =NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:date2 options:0];

    NSLog(@"%@",dateString1);
    NSLog(@"%@",dateString2);
    long min = 15 - cmps.minute;
    
    return min;
}

-(void)backBtnAction{
    if (_type == 3 || _type == 2) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[HomeVideoViewController class]]) {
                if (_type == 2) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplyHasDid"
                                                                        object:nil
                                                                      userInfo:nil];
                }
                if (_type == 2) {
                    HomeVideoViewController *vc = [[HomeVideoViewController alloc] init];
                    self.delegate = vc;
                    NSString *name =_orderModel.typeCode;
                    if ([name isEqualToString:@"FamousInteract" ] || [name isEqualToString:@"FamousAudit" ]) {//FamousInteract:名医视频--互动,FamousAudit:名医视频--旁听,Lecture:专家讲座--旁听
                        [self.delegate returnName:@"名医视频"];
                    }else{
                        [self.delegate returnName:@"专家讲座"];
                    }
                    
                }
//                [vc refreshAction];
                [self.navigationController popToViewController:controller animated:YES];
               
                return;
            }
         }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -----获取订单详情
- (void)postOrder{
    NSString *url = [NSString stringWithFormat:POST_ORDER_GET,rootURL];
    [RequestUtil POST:url parameters:self.strID withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSDictionary *respDic = [responseObject objectForKey:@"result"];
        _orderModel = [OrderModel mj_objectWithKeyValues:respDic];
        [self.tableView reloadData];
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
@end
