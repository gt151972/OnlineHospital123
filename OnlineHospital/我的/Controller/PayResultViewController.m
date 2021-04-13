//
//  PayResultViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/22.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "PayResultViewController.h"
#import "HomeVideoViewController.h"
#import "HeadView.h"
#import "DoctorVideoTableViewCell.h"
#import "LiveViewController.h"
#import "FamousModel.h"
#import "ApplyViewController.h"
#import "MineOrderViewController.h"
static NSString *identifierVideo = @"DoctorVideoTableViewCell";
@interface PayResultViewController ()<UITableViewDelegate, UITableViewDataSource, HeadViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *labReturn;
@property (weak, nonatomic) IBOutlet UIImageView *imageResult;
@property (weak, nonatomic) IBOutlet UILabel *labId;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;
@property (nonatomic, strong)NSMutableArray *arrayDoctorGet;
@end

@implementation PayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付结果";
    self.view.backgroundColor = BG_COLOR;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    button.frame=CGRectMake(0,0,40.0f,40.0f);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self initView];
    [self.view addSubview:self.tableView];
    
    if (_type) {
        self.imageResult.image = [UIImage imageNamed:@"pay_cancel"];
        self.labReturn.text = @"支付失败";
    }else{
        self.imageResult.image = [UIImage imageNamed:@"pay_success"];
        self.labReturn.text = @"支付成功";
    }
    self.labId.text = [NSString stringWithFormat:@"订单编号:  %@",_model.customNO ];
    self.labMoney.text = [NSString stringWithFormat:@"支付金额: ¥%.2f",[_model.normalAmount floatValue]];
    [self postRecommendGet];
}

- (void)initView{
    self.arrayDoctorGet = [[NSMutableArray alloc] init];
}

#pragma mark ---UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(12, 286, Screen_W - 24, 330) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = BG_COLOR;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView registerNib:[UINib nibWithNibName:identifierVideo bundle:nil] forCellReuseIdentifier:identifierVideo];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 58;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeadView *view = [[HeadView alloc] initWithTitle:@"名医视频推荐" isMore:1];
//    [HeadView headViewTitle:@"名医视频推荐" isMore:1];
    view.onTapBtnViewDelegate = self;
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   DoctorVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierVideo];
            if (cell == nil) {
                cell = [[DoctorVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierVideo];
            }
            cell.backgroundColor = BG_COLOR_WHITE;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FamousModel *modelFamous = [_arrayDoctorGet objectAtIndex:indexPath.row];
    NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE, rootURL2,modelFamous.doctorIcon];
    [cell.headImgeView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"mine_head"]];
    cell.labTitle.text = modelFamous.title;
    cell.labDoctor.text = [NSString stringWithFormat:@"%@ | %@", modelFamous.doctorTitle,modelFamous.doctorDepartment];//@"副主任医师  |  儿科";
    cell.LivingState = [modelFamous.liveStatus intValue];
    if (cell.LivingState == 1) {
        cell.labState.text = [NSString stringWithFormat:@"报名时间:%@",[BaseDataChange getDateStringWithTimeStr:modelFamous.enrollDate]];
    }
    cell.labTime.text = [NSString stringWithFormat:@"开讲时间:%@",[BaseDataChange getDateStringWithTimeStr:modelFamous.startDate]];
    cell.btnGo.tag = 50+indexPath.section;
//    NSLog(@"------------%d", [modelFamous.doctorFocus intValue]);
    cell.btnAttention.selected = [modelFamous.doctorFocus intValue];
    [[[cell.btnAttention rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal]  subscribeNext:^(__kindof UIButton * _Nullable x) {
//        NSLog(@"index === %ld",(long)indexPath.row);
        FamousModel *model = [self.arrayDoctorGet objectAtIndex:indexPath.row];
        if (!x.selected) {
            [self putFocus:model.doctorId];
        }else{
            [self deleteFocus:model.doctorId];
//            [self putFocus:model.doctorId];
        }
    }];
    [[[cell.btnGo rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal]  subscribeNext:^(UIButton * _Nullable x) {
        
        FamousModel *model = self.arrayDoctorGet[indexPath.row];
        
        int live = [model.liveStatus intValue];
        int type = [model.liveType intValue];
        int buy = [model.buyStatus intValue];
        if (live == 1 && type == 1) {//未开始-视频
            ApplyViewController *vc = [[ApplyViewController alloc] init];
            vc.pid = model.fid;
            vc.state = ApplyViewStateWillStart;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (live == 2 && type == 1){//报名中-视频
            ApplyViewController *vc = [[ApplyViewController alloc] init];
            vc.pid = model.fid;
            vc.state = ApplyViewStateDidStart;
            vc.endEnrollInteractDate = model.endEnrollInteractDate;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (live == 3 && type == 1){//直播中-视频
            //跳转直播页
            LiveViewController *liveVC = [[LiveViewController alloc] init];
            liveVC.pid = model.fid;
            if (buy == 1 || buy == 2) {
                liveVC.channel = livingChannePlay;
            }else{
                liveVC.channel = livingChannelExamine;
            }
            [self.navigationController pushViewController:liveVC animated:YES];
        }else if (live == 4 && type == 1){//已结束-视频
            //跳转直播页
            LiveViewController *liveVC = [[LiveViewController alloc] init];
            if (buy == 1 || buy == 2) {
                liveVC.channel = livingChannePlay;
            }else{
                liveVC.channel = livingChannelExamine;
            }
            [self.navigationController pushViewController:liveVC animated:YES];
        }else if (live == 5 && type == 1){//已取消-视频
            //刷新列表
            [self postRecommendGet];
        }else if (live == 1 && type == 2){//未开始-讲座
            ApplyViewController *vc = [[ApplyViewController alloc] init];
            vc.state = ApplyViewStateLectureWillStart;
            vc.pid = model.fid;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (live == 2 && type == 2){//报名中-讲座
            ApplyViewController *vc = [[ApplyViewController alloc] init];
            vc.pid = model.fid;
            vc.state = ApplyViewStateLectureDidStart;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
            [cell.btnAttention setHidden:YES];
                           cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 1) {
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_W - 24, 140) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = cell.bounds;
                maskLayer.path = maskPath.CGPath;
                cell.layer.mask = maskLayer;
            }
            return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveViewController *vc = [[LiveViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)passMoreHeadView:(UIView *)headView title:(NSString *)title{
    HomeVideoViewController *vc = [[HomeVideoViewController alloc] init];
    vc.title = @"名医视频推荐";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backBtnAction{
    HomeVideoViewController *homeVC = [[HomeVideoViewController alloc] init];
    MineOrderViewController *orderVC = [[MineOrderViewController alloc] init];
    NSLog(@"views == %@",self.navigationController.viewControllers);
//    if ([self.navigationController.viewControllers containsObject:[HomeVideoViewController class]]) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[HomeVideoViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
         }
//    }else if ([self.navigationController.viewControllers containsObject:orderVC]){
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[MineOrderViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
//    }else{
//        [self.navigationController popViewControllerAnimated:YES];
//    }
   
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
#pragma mark -----关注医生接口
- (void)putFocus: (NSString *)doctorID{
   
    NSString *url = [NSString stringWithFormat:PUT_DELETE_FOCUS,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    
    [parameDic setObject:doctorID forKey:@"doctorId"];
    [RequestUtil Put:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD showSuccessWithStatus:@"关注成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark ------取消关注医生接口
- (void)deleteFocus:(NSString *)doctorID{
    NSString *url = [NSString stringWithFormat:PUT_DELETE_FOCUS,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:doctorID forKey:@"doctorId"];
    [RequestUtil DELETE:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


@end
