//
//  MineAttentionViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "MineAttentionViewController.h"
#import "HomeDoctorViewController.h"
#import "DoctorModel.h"

#import "StateAttentionTableViewCell.h"
static NSString *identifier = @"StateAttentionTableViewCell";
@interface MineAttentionViewController ()<UITableViewDelegate, UITableViewDataSource>{
    int page ;//页数
    int pageSize ;//每页数量
    
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *arrayFocus;
@property (nonatomic, strong)NullView *nullView;
@end

@implementation MineAttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的关注";
    self.nullView = [[NullView alloc] initWithTitle:@"暂无任何内容" frame:CGRectMake(0, SafeAreaTopHeight, Screen_W, Screen_H-SafeAreaTopHeight)];
    [self.view insertSubview:self.nullView belowSubview:self.tableView];
    [self.nullView setHidden:YES];
    self.arrayFocus = [NSMutableArray array];
    self.view.backgroundColor = BG_COLOR;
    self.navigationController.navigationBar.backgroundColor = BG_COLOR_WHITE;
    [self postFucus];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
}
- (void)refreshAction {
    [_arrayFocus removeAllObjects];
    page = 0;
    [self postFucus];
}
- (void)footRefresh {
    page++;
    [self postFucus];
    
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
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayFocus.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 130;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        StateAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[StateAttentionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
    cell.backgroundColor = BG_COLOR_WHITE;
    DoctorModel *model = self.arrayFocus[indexPath.row];
    cell.model = model;
    [[[cell.btnAttention rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIButton * _Nullable x) {
            x.selected = !x.selected;
        if (x.selected) {
            [self putFocus:model.doctorId];
        }else{
            [self deleteFocus:model.doctorId];
        }
            
    }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DoctorModel *model = self.arrayFocus[indexPath.row];
    HomeDoctorViewController *vc = [[HomeDoctorViewController alloc] init];
    vc.strDoctorID = model.doctorId;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------关注的医生列表接口
- (void)postFucus{
    int offset = page * pageSize;
    pageSize = 10;
    NSString *url = [NSString stringWithFormat:POST_FOCUS,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:[NSString stringWithFormat:@"%d",offset] forKey:@"offset"];
    [parameDic setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject==%@", responseObject);
        NSArray *respArr = [[responseObject objectForKey:@"result"] objectForKey:@"content"] ;
        NSMutableArray *array = [DoctorModel mj_objectArrayWithKeyValuesArray:respArr];
              [self.arrayFocus addObjectsFromArray:array];
               [self.tableView reloadData];
               [self.tableView.mj_header endRefreshing];
               [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        if (self.arrayFocus.count <1) {
            [self.nullView setHidden:NO];
        }else{
            [self.nullView setHidden:YES];
        }
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
