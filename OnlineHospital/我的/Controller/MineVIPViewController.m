//
//  MineVIPViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "MineVIPViewController.h"
#import "BaseNavgation.h"
#import "HeadView.h"
#import "VipPayViewController.h"
#import "VipHistoryViewController.h"
#import "HomeRecommendViewController.h"
#import "HomeVideoViewController.h"
#import "HomeDoctorViewController.h"

#import "VipCardTableViewCell.h"
#import "PrivilegeTableViewCell.h"
#import "PrivilegeTableViewCell2.h"
#import "PrivilegeTableViewCell3.h"
#import "RecommandTableViewCell.h"
#import "DoctorVideoTableViewCell.h"

#import "VipTypeModel.h"
#import "FamousModel.h"
#import "VipOrderModel.h"
#import <WXApi.h>
#import "WechatManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APOrderInfo.h"
#import "APRSASigner.h"
#import "wechatPayModel.h"
#define space 12.0f //两边间隙
#define distance 8.0f //上下间隙
static NSString *identifierCard = @"VipCardTableViewCell";
static NSString *identifierPrivilege = @"PrivilegeTableViewCell";
static NSString *identifierPrivilege2 = @"PrivilegeTableViewCell2";
static NSString *identifierPrivilege3 = @"PrivilegeTableViewCell3";
static NSString *identifierRecommand = @"RecommandTableViewCell";
static NSString *identifierDoctor = @"DoctorVideoTableViewCell";
@interface MineVIPViewController ()<UITableViewDelegate, UITableViewDataSource, RecommandTableViewCellDelegate, HeadViewDelegate, PrivilegeTableViewCell2Delegate,VipPayDelegate>
@property(nonatomic,strong)UITableView *tableView;
//VIP会员
@property(nonatomic,strong)VipCardTableViewCell *cardCell;
//会员特权
@property(nonatomic,strong)PrivilegeTableViewCell *privilegeCell;
@property(nonatomic,strong)PrivilegeTableViewCell2 *privilegeCell2;
@property(nonatomic,strong)NSMutableArray *arrayVipType;
@property(nonatomic,strong)PrivilegeTableViewCell3 *privilegeCell3;
//名医推荐
@property(nonatomic,strong)RecommandTableViewCell *recommandCell;
//名医讲堂
@property(nonatomic,strong)DoctorVideoTableViewCell *doctorCell;

@property (nonatomic, strong)VipTypeModel *modelVIP;
@property (nonatomic, strong)NSMutableArray *arrayDoctor;//名医推荐
@property (nonatomic, strong)NSMutableArray *arrayDoctorGet;//名医讲堂
@property (nonatomic, strong)VipOrderModel *modelVipOrder;//名医讲堂

@property (nonatomic, assign)int type;
@end

@implementation MineVIPViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:BG_COLOR];
    //    [self  initNavigation];
    UIView *nav = [self vipNavigationViewWithTitle:@"我的会员" right:@"我的订单"];
    [self.view addSubview:nav];
    [self.view addSubview:self.tableView];
    [self postVIPProduct];
}

//- (void)initNavigation{
//    BaseNavgation *navView = [BaseNavgation navigationViewWithTitle:@"我的会员" right:@"我的订单"];
//    [self.view addSubview:navView];
//}

#pragma mark --- UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, Screen_W, Screen_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView registerNib:[UINib nibWithNibName:identifierCard bundle:nil] forCellReuseIdentifier:identifierCard];
        [self.tableView registerNib:[UINib nibWithNibName:identifierPrivilege bundle:nil] forCellReuseIdentifier:identifierPrivilege];
        [self.tableView registerNib:[UINib nibWithNibName:identifierPrivilege2 bundle:nil] forCellReuseIdentifier:identifierPrivilege2];
        [self.tableView registerNib:[UINib nibWithNibName:identifierPrivilege3 bundle:nil] forCellReuseIdentifier:identifierPrivilege3];
        [self.tableView registerNib:[UINib nibWithNibName:identifierRecommand bundle:nil] forCellReuseIdentifier:identifierRecommand];
        //        [self.tableView registerClass:[DoctorVideoTableViewCell class] forCellReuseIdentifier:identifierDoctor];
        [self.tableView registerNib:[UINib nibWithNibName:identifierDoctor bundle:nil] forCellReuseIdentifier:identifierDoctor];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1){
        return 3;
    }else if (section == 3){
        return _arrayDoctorGet.count;
    }
    else {
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 160;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 74;
        }else if (indexPath.row == 1){
            return 146;
        }else{
            return 80;
        }
    }else if (indexPath.section == 2){
        return 170;
    }
    else if (indexPath.section == 3) {
        return 140;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return distance;
    }else{
        return 50+distance;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.cardCell = [tableView dequeueReusableCellWithIdentifier:identifierCard];
        self.cardCell.selectionStyle = UITableViewCellSelectionStyleNone;
        long now = [[BaseDataChange getTimestampFromTime] intValue];
        long time = [self.modelInfo.expireDate intValue];
        if (now < time) {
            self.cardCell.state = VipCardStateOn;
            self.cardCell.strDate = [NSString stringWithFormat:@"%@(到期)",[BaseDataChange getDateStringWithTimeStr:_modelInfo.expireDate]];//@" 2020年09月05日(到期) ";
        }else{
            self.cardCell.state = VipCardStateOFF;
            self.cardCell.strDate = @"名医视频 | 专家讲座";
        }
        
        return self.cardCell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            self.privilegeCell = [tableView dequeueReusableCellWithIdentifier:identifierPrivilege];
            self.privilegeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.privilegeCell.labFamous.text = [NSString stringWithFormat:@"%@ 次权限",_modelVIP.famousTimes];
            self.privilegeCell.labLecture.text = [NSString stringWithFormat:@"%@ 次权限",_modelVIP.lectureTimes];
            return self.privilegeCell;
        }else if (indexPath.row == 1){
//            self.privilegeCell2 = [[PrivilegeTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierPrivilege2 menuArray:self.arrayVipType];
            self.privilegeCell2 = [tableView dequeueReusableCellWithIdentifier:identifierPrivilege2];
            self.privilegeCell2.menuArray = _arrayVipType;
            self.privilegeCell2.delegate = self;
            self.privilegeCell2.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.privilegeCell2;
        }
        else  if (indexPath.row == 2){
            PrivilegeTableViewCell3 *cell = [tableView dequeueReusableCellWithIdentifier:identifierPrivilege3];
            if (cell == nil) {
                cell = [[PrivilegeTableViewCell3 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierPrivilege3];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.btnOpen.userInteractionEnabled = NO;
            return cell;
        }
        return nil;
    }
    else if (indexPath.section == 2){
        self.recommandCell = [[RecommandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierRecommand menuArray:self.arrayDoctor];
        if (self.recommandCell == nil) {
            
        }
        self.recommandCell.onTapBtnViewDelegate = self;
        self.recommandCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.recommandCell;
    }else if (indexPath.section == 3){
        self.doctorCell = [tableView dequeueReusableCellWithIdentifier:identifierDoctor];
        if (self.doctorCell == nil) {
            self.doctorCell = [[DoctorVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierDoctor];
        }
        FamousModel *modelGet = [_arrayDoctorGet objectAtIndex:indexPath.row];
        NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE,rootURL2,modelGet.doctorIcon];
        [self.doctorCell.headImgeView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"mine_head"]];
        self.doctorCell.labTitle.text = modelGet.title;
        self.doctorCell.labDoctor.text = [NSString stringWithFormat:@"%@ | %@",modelGet.doctorTitle,modelGet.doctorDepartment]; //@"副主任医师  |  儿科";
        self.doctorCell.LivingState = [modelGet.liveStatus intValue];
//        self.doctorCell.labState.text = @"正在直播中…";
//        self.doctorCell.labState.textColor = GREEN_COLOR_MAIN;
        self.doctorCell.labTime.text = [NSString stringWithFormat:@"开讲时间: %@",[BaseDataChange getDateStringWithTimeStr:modelGet.startDate]];//@"开讲时间: 2020.07.08 13:00";
        [self.doctorCell.btnGo setHidden:YES];
        [self.doctorCell.btnAttention setHidden:YES];
        self.doctorCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.doctorCell;
    }
    else{
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgview = [[UIView alloc] init];
    bgview.backgroundColor = [UIColor clearColor];
    if (section == 1){
        
        HeadView *view = [[HeadView alloc] initWithFrame:CGRectMake(12, 0, Screen_W - 24, 50) title:@"            会员特权" isMore:NO];
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(14 + space, 18 + distance, 30, 15)];
        image.image = [UIImage imageNamed:@"vip_icon"];
        [view   addSubview:image];
        [bgview addSubview:view];
    }else if (section == 2){
        HeadView *view = [[HeadView alloc] initWithFrame:CGRectMake(12, 0, Screen_W - 24, 50) title:@"名医推荐" isMore:YES];
        view.onTapBtnViewDelegate = self;
        [bgview addSubview:view];
    }else if (section == 3){
        HeadView *view = [[HeadView alloc] initWithFrame:CGRectMake(12, 0, Screen_W - 24, 50) title:@"名医讲堂" isMore:YES];
        view.onTapBtnViewDelegate = self;
        [bgview addSubview:view];
    }
    return bgview;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index == %@",indexPath);
    if (indexPath.section == 1 && indexPath.row == 2) {
        VipPayViewController *vc = [[VipPayViewController alloc] init];
        vc.delegate = self;
        vc.strFamous= [NSString stringWithFormat:@"2、%@次免费名医视频互动；", self.modelVIP.famousTimes];
        vc.strLecture = [NSString stringWithFormat:@"3、%@次免费名医视频互动；", self.modelVIP.lectureTimes];
        [self.navigationController presentViewController:vc animated:NO completion:nil];
    }else if (indexPath.section ==3){
        HomeDoctorViewController *vc = [[HomeDoctorViewController alloc] init];
           [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)vipPay:(int)type{
    self.type = type;
    [self postSubmit:type];
}
- (void)btnRightClicked{
    VipHistoryViewController *vc = [[VipHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)passMoreHeadView:(UIView *)headView title:(NSString *)title{
    if ([title isEqualToString:@"名医推荐"]) {
        HomeRecommendViewController *vc = [[HomeRecommendViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"名医讲堂"]){
        HomeVideoViewController *vc = [[HomeVideoViewController alloc] init];
        vc.title = @"名医视频";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)OnTapBtnView:(UITapGestureRecognizer *)sender{
    HomeDoctorViewController *vc = [[HomeDoctorViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark  ------PrivilegeTableViewCell2Delegate
- (void)vipCardPass:(NSInteger)item{
    self.modelVIP = self.arrayVipType[item];
    [self.tableView reloadData];
}

#pragma mark -----获取会员商品信息
- (void)postVIPProduct{
    NSString *url = [NSString stringWithFormat:POST_MEMBER_PRODUCT,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:[SaveData readToken] forKey:@"token"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSArray *respArr = [responseObject objectForKey:@"result"] ;
        NSMutableArray *tempDataArr = [NSMutableArray array];
        tempDataArr = [VipTypeModel mj_objectArrayWithKeyValuesArray:respArr];
        self.arrayVipType = [NSMutableArray arrayWithArray:tempDataArr];
        self.modelVIP = self.arrayVipType[0];
//        [self postVIPInfo];
        [self postRecommend];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark ----名医推荐列表接口
- (void)postRecommend{
    NSString *url = [NSString stringWithFormat:POST_RECOMMEND,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject==%@", responseObject);
        NSArray *respArr = [[responseObject objectForKey:@"result"] objectForKey:@"content"] ;
        NSMutableArray *tempDataArr = [NSMutableArray array];
        tempDataArr = [DoctorModel mj_objectArrayWithKeyValuesArray:respArr];
        self.arrayDoctor = [NSMutableArray arrayWithArray:tempDataArr];
        [self.tableView reloadData];
        [self postRecommendGet];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark ------名医讲堂
-(void)postRecommendGet{
    NSString *url = [NSString stringWithFormat:POST_RECOMMEND_GET,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject==%@", responseObject);
        NSArray *respArr = [responseObject objectForKey:@"result"] ;
        NSMutableArray *tempDataArr = [NSMutableArray array];
        tempDataArr = [FamousModel mj_objectArrayWithKeyValuesArray:respArr];
        self.arrayDoctorGet = [NSMutableArray arrayWithArray:tempDataArr];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark ------提交订单
- (void)postSubmit:(int)type{
    NSString *url = [NSString stringWithFormat:POST_ORDER_SUBMIT,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:self.modelVIP.price forKey:@"normalAmount"];
    [parameDic setObject:[NSString stringWithFormat:@"%d",type] forKey:@"payType"];
    [parameDic setObject:self.modelVIP.vid forKey:@"productId"];
    [parameDic setObject:@"1" forKey:@"productQuantity"];
    [parameDic setObject:@"VIP" forKey:@"typeCode"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject==%@", responseObject);
        NSDictionary *respDic = [responseObject objectForKey:@"result"] ;
        self.modelVipOrder= [VipOrderModel mj_objectWithKeyValues:respDic];
        NSString *string = @"ALIPAY";
        if ([self.modelVipOrder.payType isEqualToString:@"4"]) {
            string = @"ALIPAY";
        }else if([self.modelVipOrder.payType isEqualToString:@"3" ]){
            string = @"WECHAT";
        }
        [self  postPayWithType:string];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark ------统一支付接口
- (void)postPayWithType: (NSString *)type{
    NSString *url = [NSString stringWithFormat:POST_PAY,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:self.modelVipOrder.oid forKey:@"id"];
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


#pragma mark -----获取VIP信息
- (void)postVIPInfo{
    NSString *url = [NSString stringWithFormat:POST_MEMBER_INFO,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@",responseObject);
//        NSDictionary *respDic = [responseObject objectForKey:@"result"];
//        self.model = [UserInfoModel mj_objectWithKeyValues:respDic];
//        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {

    }];
}
@end
