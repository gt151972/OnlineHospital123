//
//  VipHistoryViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/25.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "VipHistoryViewController.h"
#import "VipHistoryTableViewCell.h"
#import "VIPHistoryModel.h"
static NSString *identifier = @"VipHistoryTableViewCell";
@interface VipHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>{
    int page ;//页数
   int pageSize ;//每页数量
   
}
@property (nonatomic, strong)NullView *nullView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *arrayData;

@end

@implementation VipHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.arrayData = [NSMutableArray array];
    self.view.backgroundColor = BG_COLOR;
    self.navigationController.navigationBar.backgroundColor = BG_COLOR_WHITE;
    [self.view addSubview:self.tableView];
    self.nullView = [[NullView alloc] initWithTitle:@"暂无任何内容" frame:self.view.frame];
        [self.view insertSubview:self.nullView belowSubview:self.tableView];
        [self.nullView setHidden:YES];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self getVipOrder];
}
- (void)refreshAction {
    [_arrayData removeAllObjects];
    page = 0;
    [self getVipOrder];
}
- (void)footRefresh {
    page++;
    [self getVipOrder];
    
}

- (void)stopRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark ---UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 8, Screen_W, Screen_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = BG_COLOR;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrayData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 50;
    }
    return 150;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = BG_COLOR;
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VIPHistoryModel *model = _arrayData[indexPath.section];
    if (indexPath.row == 0) {
        static NSString *identifier1 = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier1];
        }
        
        cell.textLabel.text = model.name;//@"VIP会员1个月";
        cell.textLabel.textColor = TEXT_COLOR_MAIN;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥%.2f",[model.amount floatValue]];//@"¥100.00";
        cell.detailTextLabel.textColor = TEXT_COLOR_MAIN;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        VipHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[VipHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.labStartDate.text = [BaseDataChange getDateStringWithTimeStr: model.startDate];
        cell.labExpireDate.text =[BaseDataChange getDateStringWithTimeStr: model.expireDate];
        cell.labPaidDate.text =[BaseDataChange getDateStringWithTimeStr: model.paidDate];
        cell.labVid.text = model.customId;
        switch ([model.payType intValue]) {
            case 0:
                cell.labPayType.text = @"未知";
                break;
            case 1:
                cell.labPayType.text = @"花朵支付";
                break;
            case 2:
                cell.labPayType.text = @"优惠次数";
                break;
            case 3:
                cell.labPayType.text = @"微信支付";
                break;
            case 4:
                cell.labPayType.text = @"支付宝支付";
                break;
            case 5:
                cell.labPayType.text = @"Apple Pay";
                break;
                
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark ------用户VIP订单列表
- (void)getVipOrder{
    NSString *url = [NSString stringWithFormat:GET_VIP_ORDER,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    int offset = page * pageSize;
    pageSize = 10;
    [parameDic setObject:[NSString stringWithFormat:@"%d",offset] forKey:@"offset"];
        [parameDic setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];
    [parameDic setObject:@[@1] forKey:@"status"];
    [parameDic setObject:@[@"VIP"] forKey:@"typeCodes"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject==%@", responseObject);
        NSArray *respArr = [[responseObject objectForKey:@"result"] objectForKey:@"content"] ;
        NSMutableArray *array = [VIPHistoryModel mj_objectArrayWithKeyValuesArray:respArr];
             [self.arrayData addObjectsFromArray:array];
              [self.tableView reloadData];
              [self.tableView.mj_header endRefreshing];
              [self.tableView.mj_footer endRefreshing];
      if (self.arrayData.count <1) {
                  [self.nullView setHidden:NO];
              }else{
                  [self.nullView setHidden:YES];
              }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
@end
