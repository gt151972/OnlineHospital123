//
//  MineOrderViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "MineOrderViewController.h"
#import "OrderDetailViewController.h"
#import "OrderPayViewController.h"
#import "OrderReturnViewController.h"
#import "StateVideoHeadView.h"
#import "StateVideoTableViewCell.h"
#import "ContentTableViewCell.h"
#import "videoOrderModel.h"
#import "HomeDoctorViewController.h"
#import "DoctorModel.h"
#import "LiveViewController.h"
static NSString *identifier = @"StateVideoTableViewCell";
static NSString *identifier2 = @"ContentTableViewCell";
@interface MineOrderViewController ()<UITableViewDelegate, UITableViewDataSource>{
    int page ;//页数
   int pageSize ;//每页数量
   
}
@property (nonatomic, strong)NullView *nullView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)StateVideoHeadView *headView;
@property (nonatomic, strong)NSMutableArray *arrayOrder;
@property (nonatomic, assign)int selectIndex;


@end

@implementation MineOrderViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshAction];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectIndex = 0;
    self.title = @"视频订单";
    self.arrayOrder = [NSMutableArray array];
    self.view.backgroundColor = BG_COLOR;
    self.headView = [[StateVideoHeadView alloc] initWithFrame:CGRectMake(012, 8, Screen_W-24, 50)];
          self.headView.selectIndex = self.selectIndex;
          WS
          self.headView.viewButtonClickBlock = ^(UIButton * _Nonnull sender, NSInteger index) {
                             weakSelf.selectIndex = index;
              [weakSelf.arrayOrder removeAllObjects];
              [weakSelf postOrder];
//              [weakSelf.tableView reloadData];
          //                   [weakSelf beginRefreshing];
                         };
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
    self.nullView = [[NullView alloc] initWithTitle:@"暂无任何内容" frame:CGRectMake(0, SafeAreaTopHeight+50, Screen_W, Screen_H-SafeAreaTopHeight - 50)];
        [self.view insertSubview:self.nullView belowSubview:self.tableView];
        [self.nullView setHidden:YES];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self postOrder];
}

- (void)refreshAction {
    [_arrayOrder removeAllObjects];
    page = 0;
    [self postOrder];
}
- (void)footRefresh {
    page++;
    [self postOrder];
    
}

- (void)stopRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark ---UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(12, 58, Screen_W-24, Screen_H - SafeAreaTopHeight - 58) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = BG_COLOR;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
        [self.tableView registerNib:[UINib nibWithNibName:identifier2 bundle:nil] forCellReuseIdentifier:identifier2];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrayOrder.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    videoOrderModel *model = [_arrayOrder objectAtIndex:section];
    //订单状态0：待支付，1：已支付，2：已消费，3：申请退款，4：已超时，5：已退款
    int payStatus = [model.payStatus intValue];
    if (payStatus == 1 || payStatus == 2  || payStatus == 0) {
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        videoOrderModel *model = [_arrayOrder objectAtIndex:indexPath.section];
        if ([model.typeCode isEqualToString:@"FamousInteract"]) {
            return 247;
        }else{
            return 165;
        }
    }else{
        return 50;
    }
    
//   return 247;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    videoOrderModel *model = [_arrayOrder objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        StateVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
               if (cell == nil) {
                   cell = [[StateVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
               }
        cell.model = model;
        cell.type = 1;
        [[cell.btnHeadClicked rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
            [self postDoctor:model.doctorId];
        }];
        cell.backgroundColor = BG_COLOR_WHITE;
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
               return cell;
    }else {
        ContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
               if (cell == nil) {
                   cell = [[ContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
               }
        cell.backgroundColor = BG_COLOR_WHITE;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSLog(@"payState == %@",model.payStatus);
        cell.payState = [model.payStatus intValue];
        [[[cell.btnGo rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(UIButton * _Nullable x) {
            if (cell.payState == PayStateToBePaid) {
                OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
                vc.model = model;
                vc.isPay = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                OrderReturnViewController *vc = [[OrderReturnViewController alloc] init];
                vc.model = model;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    videoOrderModel *model = [_arrayOrder objectAtIndex:indexPath.section];
    BOOL isPay = [model.payStatus intValue] == 1 || [model.payStatus intValue] == 2;
    BOOL isGoLiving = [model.liveStatus intValue] == 3 || [model.liveStatus intValue] == 4;
    if (isPay && isGoLiving) {
        LiveViewController *vc = [[LiveViewController alloc] init];
        vc.pid = model.liveId;
        vc.isFamous = model.liveType ? @"1" : 0;
        if ([model.liveStatus intValue] == 3) {
            vc.channel = livingChannePlay;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        int payState = [model.payStatus intValue];
       OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
       vc.model = model;
       vc.isPay = !payState;
       [self.navigationController pushViewController:vc animated:YES];
    }
}

-(NSMutableAttributedString *)getPriceAttribute:(NSString *)string pay: (NSString *)pay{
    
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
    NSRange range = [string rangeOfString:pay];
    NSRange pointRange = NSMakeRange(range.location, 1);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    dic[NSForegroundColorAttributeName] = ORANGE_COLOR_MAIN;
    [attribut addAttributes:dic range:pointRange];
    return attribut;
}

#pragma mark -----用户视频订单列表

/// 订单状态0：待支付，1：已支付，2：已消费，3：申请退款，4：已超时，5：已退款
-(void)postOrder{
    NSArray *arrayState = [[NSArray alloc] init];
    switch (_selectIndex) {
        case 0://全部
            arrayState =@[];
            break;
        case 2://已支付
            arrayState =@[@1];
            break;
        case 1://待支付
            arrayState =@[@0];
            break;
        case 3://退款
            arrayState =@[@5, @3];
            break;
            
        default:
            break;
    }

    NSString *url = [NSString stringWithFormat:POST_LIVE_ORDER,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    int offset = page * pageSize;
    pageSize = 10;
    [parameDic setObject:[NSString stringWithFormat:@"%d",offset] forKey:@"offset"];
        [parameDic setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];
    [parameDic setObject:arrayState forKey:@"status"];
    [parameDic setObject:@[] forKey:@"typeCodes"];
    NSLog(@"array == %@",arrayState);
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"%@",responseObject);
        NSArray *respArr = [[responseObject objectForKey:@"result"] objectForKey:@"content"];
        NSMutableArray *array = [videoOrderModel mj_objectArrayWithKeyValuesArray:respArr];
              [self.arrayOrder addObjectsFromArray:array];
               [self.tableView reloadData];
               [self.tableView.mj_header endRefreshing];
               [self.tableView.mj_footer endRefreshing];
       if (self.arrayOrder.count <1) {
                   [self.nullView setHidden:NO];
               }else{
                   [self.nullView setHidden:YES];
               }
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
