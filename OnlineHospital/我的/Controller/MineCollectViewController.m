//
//  MineCollectViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "MineCollectViewController.h"
#import "StateCollectHeadView.h"
#import "CollectArticalTableViewCell.h"
#import "DoctorVideoTableViewCell.h"
#import "LiveViewController.h"
#import "HomeArticalModel.h"
#import "FamousModel.h"
#import "UserInfoModel.h"
#import "OrderPayViewController.h"
#import "ApplyViewController.h"
#import "GTArticalViewController.h"
static NSString *identifier = @"CollectArticalTableViewCell";
static NSString *identifier1 = @"DoctorVideoTableViewCell";
@interface MineCollectViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    int page;

}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)StateCollectHeadView *headView;
@property (nonatomic, assign)int selectIndex;
@property (nonatomic, strong)NSMutableArray *arrayArtical;
@end

@implementation MineCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectIndex = 0;
    self.title = @"我的收藏";
    self.arrayArtical = [NSMutableArray array];
    self.view.backgroundColor = BG_COLOR;
    self.headView = [[StateCollectHeadView alloc] initWithFrame:CGRectMake(0, 8, Screen_W, 50)];
          self.headView.selectIndex = self.selectIndex;
          WS
          self.headView.viewButtonClickBlock = ^(UIButton * _Nonnull sender, NSInteger index) {
                             weakSelf.selectIndex = index;
              [weakSelf.arrayArtical removeAllObjects];
              if (index == 0) {
                  [weakSelf postFavorites];
              }else{
                  [weakSelf postFavoriteList];
              }
//              [weakSelf.tableView reloadData];
          //                   [weakSelf beginRefreshing];
                         };
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self postFavorites];
}

#pragma mark －＝－＝－＝－＝－－＝－＝＝＝－＝刷新与加载
- (void)refreshAction {
    
    page = 0;
    if (self.selectIndex == 0) {
        [self postFavorites];
    }else{
        [self postFavoriteList];
    }
    [self.arrayArtical removeAllObjects];
}
- (void)footRefresh {
    page++;
    if (self.selectIndex == 0) {
        [self postFavorites];
    }else{
        [self postFavoriteList];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 58, Screen_W, Screen_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = BG_COLOR;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
        [self.tableView registerNib:[UINib nibWithNibName:identifier1 bundle:nil] forCellReuseIdentifier:identifier1];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.selectIndex == 0) {
//        return _arrayArtical.count;
//    }
//    return 4;
    return _arrayArtical.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndex ==0) {
        return 118;
    }
   return 140;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_selectIndex == 0) {
         CollectArticalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
               if (cell == nil) {
                   cell = [[CollectArticalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
               }
        HomeArticalModel *model = [_arrayArtical objectAtIndex:indexPath.row];
        cell.labTitle.text = model.title;
        cell.btnCollect.selected = YES;
//        cell.detailLable.text = [NSString stringWithFormat:@"%@ | %@次浏览",model.authorName, model.totalVisit];
        [[cell.btnCollect rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [self deleteFavorite:model.nid];
            [self refreshAction];
//            [self.arrayArtical removeObjectAtIndex:indexPath.row];
////            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.tableView reloadData];
        }];
        NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE,rootURL2,model.cover];
        [cell.imageArtical sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"timg"]];
               cell.backgroundColor = BG_COLOR_WHITE;
               cell.selectionStyle = UITableViewCellSelectionStyleNone;
               return cell;
    }else{
        DoctorVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            cell = [[DoctorVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        FamousModel *modelFamous = self.arrayArtical[indexPath.row];
        NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE, rootURL2,modelFamous.doctorIcon];
        [cell.headImgeView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"mine_head"]];
        cell.labTitle.text = modelFamous.title;//@"吃肉给肾病患者的营养建议";
        cell.labDoctor.text = [NSString stringWithFormat:@"%@ | %@",modelFamous.doctorTitle, modelFamous.doctorDepartment];//@"副主任医师  |  儿科";
        NSString *string = [[NSString alloc] init];

        cell.LivingState = [modelFamous.liveStatus intValue];
        cell.labTime.text = [NSString stringWithFormat:@"开讲时间:%@",[BaseDataChange getDateStringWithTimeStr:modelFamous.startDate]];//@"开讲时间: 2020.07.08 13:00";
        [cell.btnAttention setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        [cell.btnGo setTitle:@"回看" forState:UIControlStateNormal];
        cell.btnGo.titleLabel.font = [UIFont systemFontOfSize:14];
        [cell.btnGo setTitleColor:TEXT_COLOR_MAIN forState:UIControlStateNormal];
        cell.btnGo.layer.borderColor = TEXT_COLOR_MAIN.CGColor;
        cell.btnGo.layer.borderWidth = 1;
        cell.btnGo.layer.cornerRadius = REDIUS;
        cell.btnGo.userInteractionEnabled = NO;
//        [cell.btnGo addTarget:self action:@selector(goViewController:) forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundColor = BG_COLOR_WHITE;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectIndex == 0) {
        HomeArticalModel *model = self.arrayArtical[indexPath.row];
        GTArticalViewController *vc = [[GTArticalViewController alloc] init];
        vc.strPath = [NSString stringWithFormat:@"%@/?token=%@#/policydetail?id=%@",POPULAR_SCIENCE,[SaveData readToken], model.nid];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self goViewController:indexPath];
    }
}
-(void)goViewController: (NSIndexPath *)index{
//    if (_isRefreshAction) {
//        [self postFamous];
//        return;
//    }
    FamousModel *model = self.arrayArtical[index.row];
    UserInfoModel *modelUser = [UserInfoModel mj_objectWithKeyValues:[SaveData readLogin]];
    if ([model.buyStatus isEqualToString:@"0"]) {//&&[modelUser.famousTimes intValue] <= 0
        OrderPayViewController *vc = [[OrderPayViewController alloc] init];
        vc.strID = model.orderId;
        vc.famousModel = model;
        vc.type = 3;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }

    else if ([model.buyStatus isEqualToString:@"1"] || [model.buyStatus isEqualToString:@"2"]){
        LiveViewController *liveVC = [[LiveViewController alloc] init];
        liveVC.channel = livingChannePlay;
        liveVC.famouModel = model;
        liveVC.pid = model.fid;
        [self.navigationController pushViewController:liveVC animated:YES];
        return;
    }
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
    }else if (live == 3 ){//直播中-视频
        //跳转直播页
        LiveViewController *liveVC = [[LiveViewController alloc] init];
        liveVC.channel = livingChannePlay;
        liveVC.famouModel = model;
        liveVC.pid = model.fid;
        [self.navigationController pushViewController:liveVC animated:YES];
    }else if (live == 4 ){//已结束-视频
        //跳转直播页
        LiveViewController *liveVC = [[LiveViewController alloc] init];
        liveVC.channel = livingChannelCatchUpTV;
        liveVC.famouModel = model;
        liveVC.pid = model.fid;
        [self.navigationController pushViewController:liveVC animated:YES];
    }else if (live == 5 ){//已取消-视频
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


- (void)btnGoClicked{
    LiveViewController *vc = [[LiveViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -----获取收藏列表接口(文章)
- (void)postFavorites{
    NSString *url = [NSString stringWithFormat:POST_FAVORITES,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
//    [parameDic setObject:[SaveData readToken] forKey:@"token"];//根据科室筛选
    int offset = page*10;
    [parameDic setObject:[NSString stringWithFormat:@"%d",offset] forKey:@"offset"];
    [parameDic setObject:@"10" forKey:@"pageSize"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSArray *respArr = [[responseObject objectForKey:@"result"] objectForKey:@"data"];
        NSMutableArray *array = [HomeArticalModel mj_objectArrayWithKeyValuesArray:respArr];
        [self.arrayArtical addObjectsFromArray:array];
        [self.tableView reloadData];
        [self stopRefresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark -----收藏列表接口(视频,讲座)
-(void)postFavoriteList{
    NSString *url = [NSString stringWithFormat:POST_FAVORITES_LIST,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
//    [parameDic setObject:[SaveData readToken] forKey:@"token"];//根据科室筛选
    int offset = page*10;
    [parameDic setObject:[NSString stringWithFormat:@"%d",offset] forKey:@"offset"];
    [parameDic setObject:@"10" forKey:@"pageSize"];
    [parameDic setObject:[NSString stringWithFormat:@"%d",self.selectIndex] forKey:@"liveType"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSArray *respArr = [[responseObject objectForKey:@"result"] objectForKey:@"content"];
        NSMutableArray *array = [FamousModel mj_objectArrayWithKeyValuesArray:respArr];
        [self.arrayArtical addObjectsFromArray:array];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark -----关注医生接口
- (void)putFavorite : (NSString *)nid{
    NSString *url = [NSString stringWithFormat:PUT_DELETE_FAVORITE,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:nid forKey:@"id"];
    [RequestUtil Put:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark ------取消关注医生接口
- (void)deleteFavorite: (NSString *)nid{
    NSString *url = [NSString stringWithFormat:PUT_DELETE_FAVORITE,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:nid forKey:@"id"];
    [RequestUtil DELETE:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
