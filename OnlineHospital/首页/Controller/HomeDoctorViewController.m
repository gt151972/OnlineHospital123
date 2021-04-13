//
//  HomeDoctorViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/19.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "HomeDoctorViewController.h"
#import "LiveViewController.h"
#import "BaseNavgation.h"
#import "HomeDoctorTableViewCell.h"
#import "MessageCenterTopSelectView.h"
#import "DoctorVideoTableViewCell.h"
#import "ApplyViewController.h"
#import "FamousModel.h"
static NSString *identifier = @"HomeDoctorTableViewCell";
static NSString *identifierVideo = @"DoctorVideoTableViewCell";
@interface HomeDoctorViewController ()<UITableViewDelegate, UITableViewDataSource>{
    int page ;//页数
   int pageSize ;//每页数量
   
}
@property (nonatomic, strong)NullView *nullView;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)MessageCenterTopSelectView *messageCenterTopView;
@property (nonatomic, assign)NSInteger selectIndex;
@property (nonatomic, strong)NSMutableArray *arrayFamous;
@property (nonatomic, strong)NSMutableArray *arrayLectures;
@end

@implementation HomeDoctorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_COLOR;
    self.selectIndex = 0;
    UIView *view = [self applyNavigationViewWithTitle:@"医生主页" right:@""];
    self.arrayFamous = [NSMutableArray array];
    self.arrayLectures = [NSMutableArray array];
    [self.view addSubview:view];
    [self.view addSubview:self.tableView];
    self.nullView = [[NullView alloc] initWithTitle:@"暂无任何内容" frame:self.view.frame];
        [self.view insertSubview:self.nullView belowSubview:self.tableView];
        [self.nullView setHidden:YES];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
//    [self postFamous];
    [self postDoctor:_model.doctorId];
}
- (void)refreshAction {
    [_arrayFamous removeAllObjects];
    page = 0;
    if (_selectIndex == 0) {
       
        [self postFamous];
    }else{
        [self postLectures];
    }
}
- (void)footRefresh {
    page++;
    if (_selectIndex == 0) {
        [self postFamous];
    }else{
        [self postLectures];
    }
    
}

- (void)stopRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark ---UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(12, 88, Screen_W - 24, Screen_H - 88) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
        [self.tableView registerNib:[UINib nibWithNibName:identifierVideo bundle:nil] forCellReuseIdentifier:identifierVideo];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return self.arrayFamous.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat height =  [self getLabelHeightByWidth:Screen_W - 64 Title:_model.descriptions font:[UIFont systemFontOfSize:12]];
        return 290+height;
    }
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 50 + 8;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HomeDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[HomeDoctorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.labName.text = _model.name;
        cell.labSecion.text = [NSString stringWithFormat:@"%@ | %@", _model.title,_model.department];
        cell.labResume.text = _model.skillful;
        [cell.btnAttention setSelected:[_model.doctorFocus intValue]];
        NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE,rootURL2,_model.icon];
        if (cell.btnAttention.selected) {
            cell.btnAttention.layer.borderColor = [[UIColor clearColor] CGColor];
        }else{
            cell.btnAttention.layer.borderColor = [TEXT_COLOR_MAIN CGColor];
        }
        [[[cell.btnAttention rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal]  subscribeNext:^(UIButton * _Nullable x) {
            x.selected = !x.selected;
            if (x.selected) {
                [self putFocus];
                x.layer.borderColor = [[UIColor clearColor] CGColor];
            }else{
                [self deleteFocus];
                x.layer.borderColor = [TEXT_COLOR_MAIN CGColor];
            }
        }];
        [[[cell.btnServe rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal]  subscribeNext:^( UIButton * _Nullable x) {
            NSLog(@"go服务");
        }];
        [cell.imageHead sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"home_doctor_head"]];
        return cell;
    }else{
        DoctorVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierVideo];
        if (cell == nil) {
            cell = [[DoctorVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierVideo];
        }
        cell.backgroundColor = BG_COLOR_WHITE;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        FamousModel *modelFamous = self.arrayFamous[indexPath.row];
        NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE, rootURL2,modelFamous.doctorIcon];
        [cell.headImgeView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"mine_head"]];
        cell.labTitle.text = modelFamous.title;
        cell.labDoctor.text = [NSString stringWithFormat:@"%@ | %@", modelFamous.doctorTitle,modelFamous.doctorDepartment];//@"副主任医师  |  儿科";
        cell.LivingState = [modelFamous.liveStatus intValue];
        if (cell.LivingState == 1) {
            cell.labState.text = [NSString stringWithFormat:@"报名时间: %@",[BaseDataChange getDateStringWithTimeStr:modelFamous.enrollDate]];
        }
        cell.labTime.text = [NSString stringWithFormat:@"开讲时间:%@",[BaseDataChange getDateStringWithTimeStr:modelFamous.startDate]];
        [cell.btnGo setHidden:YES];
        [cell.btnAttention setHidden:YES];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        if (indexPath.row == 2) {
//            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_W - 24, 140) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
//            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//            maskLayer.frame = cell.bounds;
//            maskLayer.path = maskPath.CGPath;
//            cell.layer.mask = maskLayer;
//        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W - 24, 58)];
        bg.backgroundColor = [UIColor clearColor];
        self.messageCenterTopView = [[MessageCenterTopSelectView alloc] initWithFrame:CGRectMake(0, 8, Screen_W - 24, 50)];
        self.messageCenterTopView.selectIndex = self.selectIndex;
        WS
        self.messageCenterTopView.viewButtonClickBlock = ^(UIButton * _Nonnull sender, NSInteger index) {
            [weakSelf.arrayFamous removeAllObjects];
            weakSelf.selectIndex = index;
            [weakSelf beginRefreshing];
        };
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.messageCenterTopView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.messageCenterTopView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.messageCenterTopView.layer.mask = maskLayer;
        [bg addSubview:self.messageCenterTopView];
        return bg;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        FamousModel *model = self.arrayFamous[indexPath.row];
        
        int live = [model.liveStatus intValue];
        int type = [model.liveType intValue];
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
            liveVC.channel = livingChannePlay;
            liveVC.pid = model.fid;
            [self.navigationController pushViewController:liveVC animated:YES];
        }else if (live == 4 && type == 1){//已结束-视频
            //跳转直播页
            LiveViewController *liveVC = [[LiveViewController alloc] init];
            liveVC.channel = livingChannelExamine;
            [self.navigationController pushViewController:liveVC animated:YES];
        }else if (live == 5 && type == 1){//已取消-视频
            //刷新列表
            [self refreshAction];
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
    }
}

//刷新列表数据
- (void) beginRefreshing{
    if (self.selectIndex == 0) {
        [self postFamous];
        page =1;
    }else{
        [self postLectures];
        page =1;
    }
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
#pragma  mark --------获取医生信息
- (void)postDoctor : (NSString *)strDoctorId{
    NSString *url = [NSString stringWithFormat:POST_DOCTOR,rootURL];
    [RequestUtil POST:url parameters:strDoctorId withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *respDic = [responseObject objectForKey:@"result"];
        self.model = [DoctorModel mj_objectWithKeyValues:respDic];
        [self postFamous];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark -----关注医生接口
- (void)putFocus{
    NSString *url = [NSString stringWithFormat:PUT_DELETE_FOCUS,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:_model.doctorId forKey:@"doctorId"];
    [RequestUtil Put:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD showSuccessWithStatus:@"关注成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark ------取消关注医生接口
- (void)deleteFocus{
    NSString *url = [NSString stringWithFormat:PUT_DELETE_FOCUS,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:_model.doctorId forKey:@"doctorId"];
    [RequestUtil DELETE:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark ----获取名医视频列表
- (void)postFamous{
    NSString *url = [NSString stringWithFormat:POST_FAMOUS,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:_model.doctorId forKey:@"doctorId"];
    int offset = page * pageSize;
    pageSize = 10;
    [parameDic setObject:[NSString stringWithFormat:@"%d",offset] forKey:@"offset"];
        [parameDic setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSArray *respArr = [[responseObject objectForKey:@"result"] objectForKey:@"data"];
        NSMutableArray *array = [FamousModel mj_objectArrayWithKeyValuesArray:respArr];
              [self.arrayFamous addObjectsFromArray:array];
               [self.tableView reloadData];
               [self.tableView.mj_header endRefreshing];
               [self.tableView.mj_footer endRefreshing];
       if (self.arrayFamous.count <1) {
                   [self.nullView setHidden:NO];
               }else{
                   [self.nullView setHidden:YES];
               }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark -----获取专家讲座列表
- (void)postLectures{
    NSString *url = [NSString stringWithFormat:POST_LECTURES,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:_model.doctorId forKey:@"doctorId"];
    int offset = page * pageSize;
    pageSize = 10;
    [parameDic setObject:[NSString stringWithFormat:@"%d",offset] forKey:@"offset"];
        [parameDic setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSArray *respArr = [[responseObject objectForKey:@"result"] objectForKey:@"data"];
        
        NSMutableArray *array = [FamousModel mj_objectArrayWithKeyValuesArray:respArr];
              [self.arrayFamous addObjectsFromArray:array];
               [self.tableView reloadData];
               [self.tableView.mj_header endRefreshing];
               [self.tableView.mj_footer endRefreshing];
       if (self.arrayFamous.count <1) {
                   [self.nullView setHidden:NO];
               }else{
                   [self.nullView setHidden:YES];
               }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
