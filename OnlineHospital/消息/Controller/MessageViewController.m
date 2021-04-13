//
//  MessageViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/7.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "MessageViewController.h"
#import "BaseNavgation.h"
#import "MessageTableViewCell.h"
#import "MessageModel.h"
#import "UITabBar+Badge.h"

#import "LiveViewController.h"
#import "OrderPayViewController.h"
#import "OrderDetailViewController.h"
#import "OrderReturnViewController.h"
#import "MineVIPViewController.h"
#import "ParameterModel.h"
#import "OrderModel.h"
#import "videoOrderModel.h"
static NSString *identifier = @"MessageTableViewCell";
@interface MessageViewController ()<UITableViewDelegate, UITableViewDataSource>{
    int page ;//页数
   int pageSize ;//每页数量
}
@property (nonatomic, strong)UIView *redview;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *arrMessage;
@property (nonatomic, strong)FamousModel *famousModel;
@property (nonatomic, strong)OrderModel *orderModel;
@property (nonatomic, strong)NSString *strParams;
@end

@implementation MessageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrMessage = [NSMutableArray array];
    [self postMessageList];
    self.view.backgroundColor = BG_COLOR;
    BaseNavgation *view = [BaseNavgation messageNavigationViewWithTitle:@"暖宝宝"];
    [self.view addSubview:view];
    
    UIButton *btnRight = [[UIButton alloc] init];
    [btnRight setTitle:@"全部已读" forState:UIControlStateNormal];
    [btnRight setTitleColor:TEXT_COLOR_MAIN forState:UIControlStateNormal];
    btnRight.titleLabel.textAlignment = NSTextAlignmentRight;
    [btnRight.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btnRight addTarget:self action:@selector(btnRightClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnRight];
    [btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(view);
    }];
//    [self addredview];
//    [view addSubview:self.redview];
//    [self.redview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(btnRight);
//        make.width.height.mas_equalTo(8);
//        make.left.equalTo(btnRight.mas_right);
//    }];
    
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    

}

#pragma mark －＝－＝－＝－＝－－＝－＝＝＝－＝刷新与加载
- (void)refreshAction {
    [_arrMessage removeAllObjects];
    page = 0;
    [self postMessageList];
}
- (void)footRefresh {
    page++;
    [self postMessageList];
}


- (void)addredview{
    self.redview = [[UIView alloc] init];
    self.redview.size = CGSizeMake(8, 8);
    self.redview.layer.cornerRadius = 4;
    self.redview.layer.masksToBounds = YES;
    self.redview.backgroundColor = [UIColor redColor];
}

-(void)btnRightClicked: (UIButton *)button{
//    [self postMessageDelete];
    [self.redview setHidden:YES];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [_arrMessage enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //获取数组中元素
        MessageModel *model = _arrMessage[idx];
        [array addObject:model.mid];
    }];
    NSLog(@"array == %@",array);
//    [self postMessageRead:array];
    [self postReadAll];
}

#pragma mark --- UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, Screen_W, Screen_H-100) style:UITableViewStylePlain];
        _tableView.backgroundColor = BG_COLOR;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            [self postMessageList];
        }];
        [self.tableView.mj_header beginRefreshing];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
       [_tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _arrMessage.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = self.arrMessage[indexPath.section];
    CGFloat height =  [self getLabelHeightByWidth:Screen_W - 74 Title:model.title font:[UIFont systemFontOfSize:14]];
    return 90+height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.model = _arrMessage[indexPath.section];
//    cell.labContent.text = cell.model.content;
//    cell.MessageState = indexPath.section;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //\n // \n // 9. 会员付费成功 10.互动开始，收到后请调用获取会议参数进入互动11.互动接入失败提醒',
    MessageModel *model = _arrMessage[indexPath.section];
    [_arrMessage removeObjectAtIndex:indexPath.section];
    NSArray *array = [NSArray arrayWithObject:model.mid];
    [self postMessageRead:array];
    
    int type = [model.type intValue];
    _strParams = model.params;
    switch (type) {
        case 1:{//1. 关注的医生开直播给予消息推送
            [self postLiveWithPid:model.params];
            break;
        }
        case 2:{//2. 订单提交未支付给予消息提示
            [self postOrder:model.params];
            break;
        }
        case 3:{//3. 订单支付成功给与提示
            [self postLiveWithPid:model.params];
            break;
        }
        case 4:{//4. 后台管理员确认问题后给予用户提示
            [self postLiveWithPid:model.params];
            break;
        }
        case 5:{//5.用户被管理员剔除报名后退款给予提示
            [self postOrder:model.params];
            break;
        }
        case 6:{//6. 开播前1小时给予提示
            [self postLiveWithPid:model.params];
            break;
        }
        case 7:{// 7. 开播前5分钟给予提示
            [self postLiveWithPid:model.params];
            break;
        }
        case 8:{//8. 退费成功后给予提示
            [self postOrder:model.params];
            break;
        }
        case 11:{//11.互动接入失败提醒
            [self postLiveWithPid:model.params];
        }
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{

    return UITableViewCellEditingStyleDelete;

}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
        //只要实现这个方法，就实现了默认滑动删除！！！！！
        if (editingStyle == UITableViewCellEditingStyleDelete)
        {
            // 删除数据
            MessageModel *model = _arrMessage[indexPath.section];
            [_arrMessage removeObjectAtIndex:indexPath.section];
            NSLog(@"count == %lu",(unsigned long)_arrMessage.count);
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self postMessageDelete:model.mid];
            [self.tableView reloadData];
        }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
          return @"删除";
}

-(CGFloat)getLabelHeightByWidth:(CGFloat)width Title:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}


#pragma mark -----消息列表
- (void)postMessageList{
    NSString *url = [NSString stringWithFormat:POST_MESSAGE_LIST,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:[SaveData readToken] forKey:@"token"];//根据科室筛选
    int offset = page * pageSize;
    pageSize = 10;
    [parameDic setObject:[NSString stringWithFormat:@"%d",offset] forKey:@"offset"];
        [parameDic setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSArray *respArr = [[responseObject objectForKey:@"result"] objectForKey:@"content"];
        NSMutableArray *array = [MessageModel mj_objectArrayWithKeyValuesArray:respArr];
        [self.arrMessage addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark ----删除消息/批量删除
- (void)postMessageDelete: (NSString *)messageIds{
    NSString *url = [NSString stringWithFormat:POST_MESSAGE_DELETE,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:@[messageIds] forKey:@"messageIds"];//根据科室筛选
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark --- 已读/批量读
- (void)postMessageRead: (NSArray *)array{
    NSString *url = [NSString stringWithFormat:POST_MESSAGE_READ,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:array forKey:@"messageIds"];//根据科室筛选
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
//        [self.tableView reloadData];
        [self refreshAction];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma  mark -----全部已读
- (void)postReadAll{
    NSString *url = [NSString stringWithFormat:POST_READ_ALL,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:@"" forKey:@"messageIds"];//根据科室筛选
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
//        [self.tableView reloadData];
        [self refreshAction];
        [self.tabBarController.tabBar hiddenBadgeOfIndex:1];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark ----获取直播详情
- (void)postParameterWithPid: (NSString *)pid orderID: (NSString *)orderID{
    NSString *url = [NSString stringWithFormat:POST_PARAMETER,rootURL];
    __weak __typeof__(self) weakSelf = self;
    [RequestUtil POST:url parameters:pid withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSDictionary *respDic = [responseObject objectForKey:@"result"];
        FamousModel *model =[FamousModel mj_objectWithKeyValues:respDic];
        long time = [self timeGapWithTime:_orderModel.createdDate];
        if (time > 0) {
            OrderPayViewController *vc = [[OrderPayViewController alloc] init];
            vc.strID = orderID;
            vc.famousModel = model;
            vc.type = 3;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
            vc.orderModel = _orderModel;
            vc.famousModel = model;
            vc.isMessage = YES;
            [self.navigationController pushViewController:vc animated:YES];
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
- (void)postLiveWithPid: (NSString *)pid{
    NSString *url = [NSString stringWithFormat:POST_PARAMETER,rootURL];
    __weak __typeof__(self) weakSelf = self;
    [RequestUtil POST:url parameters:pid withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSDictionary *respDic = [responseObject objectForKey:@"result"];
        FamousModel *model =[FamousModel mj_objectWithKeyValues:respDic];
        LiveViewController *vc = [[LiveViewController alloc] init];
        vc.pid = pid;
        vc.famouModel = model;
        vc.channel = livingChannePlay;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark -----获取订单详情
- (void)postOrder : (NSString *)string{
    NSString *url = [NSString stringWithFormat:POST_ORDER_GET,rootURL];
    [RequestUtil POST:url parameters:string withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"OrderModel == %@",responseObject);
        NSDictionary *respDic = [responseObject objectForKey:@"result"];
        _orderModel = [OrderModel mj_objectWithKeyValues:respDic];
        [self postParameterWithPid:_orderModel.productId orderID:string];
//        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark -----获取订单详情
- (void)postOrderDetail : (NSString *)string{
    NSString *url = [NSString stringWithFormat:POST_ORDER_GET,rootURL];
    [RequestUtil POST:url parameters:string withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSDictionary *respDic = [responseObject objectForKey:@"result"];
        videoOrderModel *orderModel = [videoOrderModel mj_objectWithKeyValues:respDic];
        [self postReturnWithPid:string model:orderModel];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark ----获取直播详情
- (void)postReturnWithPid: (NSString *)pid model: (videoOrderModel *)model{
    NSString *url = [NSString stringWithFormat:POST_PARAMETER,rootURL];
    __weak __typeof__(self) weakSelf = self;
    [RequestUtil POST:url parameters:pid withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSDictionary *respDic = [responseObject objectForKey:@"result"];
        FamousModel *modelFamous =[FamousModel mj_objectWithKeyValues:respDic];
        OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
        vc.model = model;
        vc.isPay = YES;
        vc.isRefund = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
