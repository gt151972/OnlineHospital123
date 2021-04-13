//
//  HomeVideoViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/19.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "HomeVideoViewController.h"
#import "DoctorVideoTableViewCell.h"
#import "ApplyViewController.h"
#import "ZHCollectionViewFlowLayout.h"
#import "ZHCollectionViewCell.h"
#import "FamousModel.h"
#import "LiveViewController.h"
#import "OrderPayViewController.h"
#import "UserInfoModel.h"
static NSString *identifier = @"DoctorVideoTableViewCell";


@interface HomeVideoViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate,UICollectionViewDataSource,ZHCollectionViewFlowLayoutDelegate, UIGestureRecognizerDelegate, HomeVideoDelegate>{
    int page;
}
@property(nonatomic,strong)NSArray *  dataArray;
@property(nonatomic,strong)NSMutableArray *  arrayFamous;
@property(nonatomic,weak)UICollectionView * collectionView;
@property (nonatomic, strong)UITableView *tableView;
//@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *viewScreen;
@property (nonatomic, strong)NullView *nullView;
@property (nonatomic, strong)NSMutableArray *arrayDepartmentsInAll;//科室
@property (nonatomic, strong)NSMutableArray *arrayDoctorTitleInAll;//医生职称
@property (nonatomic, strong)NSMutableArray *arrayDepartmentsIn;//科室
@property (nonatomic, strong)NSMutableArray *arrayDoctorTitleIn;//医生职称
@property (nonatomic, strong)NSMutableArray *arrayStatusIn;//视频状态
@property (nonatomic, strong)NSMutableArray *arrayDoctor;//收藏医生
@property (nonatomic, assign)BOOL isRefreshAction;
@end

@implementation HomeVideoViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(test)
//                                                     name:@"ApplyHasDid"
//                                                   object:nil];
//    [self refreshAction];
//    if (_isRefreshAction) {
//        if ([self.title isEqualToString:@"名医视频"]) {
//            [self postFamous];
//        }else{
//            [self postLetures];
//        }
//    }
   
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ApplyHasDid" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self postTitle];
//    self.title = @"名医视频";
    self.arrayFamous = [NSMutableArray array];
    self.view.backgroundColor = BG_COLOR;
    [self.view addSubview:self.tableView];
    [self initData];
    [self initNav];
    [self screenView];
    [self.viewScreen setHidden:YES];
    [self refreshAction];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
   
    OrderPayViewController *vc = [[OrderPayViewController alloc] init];
    vc.delegate = self;
}
- (void)test{
    _isRefreshAction = YES;
}


- (void)returnName:(NSString *)name{
    NSLog(@"name == %@",name);
    page = 0;
    if ([name isEqualToString:@"名医视频"]) {
        [self postFamous];
    }else{
        [self postLetures];
    }
}
#pragma mark －＝－＝－＝－＝－－＝－＝＝＝－＝刷新与加载
- (void)refreshAction {
    page = 0;
    if ([self.title isEqualToString:@"名医视频"]) {
        [self postFamous];
    }else{
        [self postLetures];
    }
}
- (void)footRefresh {
    page++;
    if ([self.title isEqualToString:@"名医视频"]) {
        [self postFamous];
    }else{
        [self postLetures];
    }
}

- (void)stopRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)initData{
    self.arrayStatusIn = [[NSMutableArray alloc] init];
    self.arrayDoctorTitleIn = [[NSMutableArray alloc] init];
    self.arrayDepartmentsIn = [[NSMutableArray alloc] init];
    self.arrayDepartmentsInAll = [[NSMutableArray alloc] init];
    self.arrayDoctorTitleInAll = [[NSMutableArray alloc] init];
}

-(void) initNav{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 60)];
    [btn addTarget:self action:@selector(btnnn) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"筛选" forState:UIControlStateNormal];
    [btn setTitleColor:TEXT_COLOR_MAIN forState:UIControlStateNormal];
    //    [btn setBackgroundColor:BLUE_COLOR_MAIN forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    UIBarButtonItem *BarButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = BarButton;
    
    self.nullView = [[NullView alloc] initWithTitle:@"暂无任何内容" frame:self.view.frame];
    [self.view insertSubview:self.nullView belowSubview:self.tableView];
    [self.nullView setHidden:YES];
}

- (void)btnnn{
   
    [self.viewScreen setHidden:NO];
    
}

#pragma mark ---UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(12, 0, Screen_W - 24, Screen_H-SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];


    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_arrayFamous) {
        return _arrayFamous.count;
    }else{
        return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DoctorVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DoctorVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = BG_COLOR_WHITE;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FamousModel *modelFamous = self.arrayFamous[indexPath.row];
    NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE, rootURL2,modelFamous.doctorIcon];
    [cell.headImgeView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"mine_head"]];
    cell.labTitle.text = modelFamous.title;
    cell.labDoctor.text = [NSString stringWithFormat:@"%@ | %@", modelFamous.doctorTitle,modelFamous.doctorDepartment];//@"副主任医师  |  儿科";
    cell.LivingState = [modelFamous.liveStatus intValue];
//    NSLog(@"LivingState==%lu",(unsigned long)cell.LivingState);
    if (cell.LivingState == 1) {
        cell.labState.text = [NSString stringWithFormat:@"报名时间:%@",[BaseDataChange getDateStringWithTimeStr:modelFamous.enrollDate]];
    }
    cell.labTime.text = [NSString stringWithFormat:@"开讲时间:%@",[BaseDataChange getDateStringWithTimeStr:modelFamous.startDate]];
    cell.btnGo.tag = 50+indexPath.section;
//    NSLog(@"------------%d", [modelFamous.doctorFocus intValue]);
    cell.btnAttention.selected = [modelFamous.doctorFocus intValue];
    [[[cell.btnAttention rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]  subscribeNext:^(__kindof UIButton * _Nullable x) {
//        NSLog(@"index === %ld",(long)indexPath.row);
        FamousModel *model = [self.arrayFamous objectAtIndex:indexPath.row];
        [self putFocus:model.doctorId:indexPath];
//        if (!x.selected) {
//            [self putFocus:model.doctorId];
//        }else{
//            [self deleteFocus:model.doctorId];
////            [self putFocus:model.doctorId];
//        }
    }];
    [[[cell.btnGo rac_signalForControlEvents:UIControlEventTouchUpInside]takeUntil:cell.rac_prepareForReuseSignal]  subscribeNext:^(UIButton * _Nullable x) {
        [self goViewController:indexPath];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_W - 24, 140) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    }
    if (indexPath.row == 3) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_W - 24, 140) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self goViewController:indexPath];
}

- (void)screenView{
    self.viewScreen = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    _viewScreen.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.6];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissScreen)];
    recognizer.delegate = self;
    [_viewScreen addGestureRecognizer:recognizer];
    [self.view addSubview:_viewScreen];
    
    ZHCollectionViewFlowLayout * flowLayout = [[ZHCollectionViewFlowLayout alloc]init];
    flowLayout.delegate =self;
    flowLayout.itemSize = CGSizeMake(50, 30);
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 412) collectionViewLayout:flowLayout];
    
    
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = BG_COLOR;
    //       [_viewScreen addSubview:collectionView];
    
    
    self.collectionView = collectionView;
    
    [collectionView registerClass:[ZHCollectionViewCell class] forCellWithReuseIdentifier:@"identifer"];
    [_viewScreen addSubview:self.collectionView];
    
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 412, Screen_W, 50)];
    bg.backgroundColor = BG_COLOR;
    [_viewScreen addSubview:bg];
    GTBlueButton *btnRe = [GTBlueButton whiteButtonWithFrame:CGRectMake(0, 0, Screen_W/2, 50) ButtonTitle:@"重置"];
    btnRe.layer.cornerRadius = 0;
    btnRe.tag = 21;
    [btnRe addTarget:self action:@selector(dismissScreen:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btnRe];
    GTBlueButton *btnSure = [GTBlueButton blueButtonWithFrame:CGRectMake(Screen_W/2, 0, Screen_W/2, 50) ButtonTitle:@"确定"];
    btnSure.layer.cornerRadius = 0;
    btnSure.tag = 22;
    [btnSure addTarget:self action:@selector(dismissScreen:) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btnSure];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZHCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"identifer" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 1;
    cell.layer.cornerRadius = 10;
    //    cell.backgroundColor= [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    NSArray *array = self.dataArray[indexPath.section];
    cell.label.text = array[indexPath.row];
    cell.label.textColor = TEXT_COLOR_MAIN;
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView Customlayout:(ZHCollectionViewFlowLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.dataArray[indexPath.section];
    NSString * string = array[indexPath.row];
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT + 20, 30) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size;
    
    return size.width;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 60);
}

- (UIView *)collectionViewHeader:(UICollectionView *)collectionView layout:(ZHCollectionViewFlowLayout *)collectionViewLayout Section:(NSInteger)section
{
    NSArray *arrayTitle = @[@"直播状态", @"科室", @"医生职称"];
    UIView * view = [[UIView alloc]init];
    
    view.backgroundColor = BG_COLOR;
    UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, Screen_W - 40, 60)];
    labTitle.text = arrayTitle[section];
    labTitle.textColor = TEXT_COLOR_MAIN;
    labTitle.font = [UIFont systemFontOfSize:16];
    labTitle.textAlignment = NSTextAlignmentLeft;
    [view addSubview:labTitle];
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    ZHCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (!cell.isSelect) {
        cell.backgroundColor = BLUE_COLOR_MAIN;
        cell.label.textColor = BG_COLOR_WHITE;
        if (indexPath.section == 0) {
            NSInteger index = indexPath.item + 1;
            NSNumber *number = [NSNumber numberWithInt:indexPath.item + 1];
            [self.arrayStatusIn addObject:number];
        }else if (indexPath.section == 1){
            [self.arrayDepartmentsIn addObject:cell.label.text];
        }else{
            [self.arrayDoctorTitleIn addObject:cell.label.text];
        }
    }else{
        cell.backgroundColor = BG_COLOR_WHITE;
        cell.label.textColor = TEXT_COLOR_MAIN;
        if (indexPath.section == 0) {
            NSNumber *number = [NSNumber numberWithInt:indexPath.item + 1];
            [self.arrayStatusIn removeObject:number];
        }else if (indexPath.section == 1){
            [self.arrayDepartmentsIn removeObject:cell.label.text];
        }else{
            [self.arrayDoctorTitleIn removeObject:cell.label.text];
        }
    }
    cell.isSelect = !cell.isSelect;
}
- (void)dismissScreen{
    [_viewScreen setHidden:YES];
}
- (void)dismissScreen :(UIButton  *)button{
    [self.arrayFamous removeAllObjects];
    if (button.tag == 22) {
//        [self postFamous];
        [_viewScreen setHidden:YES];
        if ([self.title isEqualToString:@"名医视频"]) {
            [self postFamous];
        }else{
            [self postLetures];
        }
    }else{
        [self.arrayStatusIn removeAllObjects];
        [self.arrayDepartmentsIn removeAllObjects];
        [self.arrayDoctorTitleIn removeAllObjects];
        [self postTitle];
    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.collectionView]) {
        return NO;
    }
    return YES;
}

#pragma mark ----获取名医视频列表
- (void)postFamous{
    [SVProgressHUD show];
    int offset = page*10;
    NSString *url = [NSString stringWithFormat:POST_FAMOUS,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    if (_arrayDepartmentsIn.count > 0) {
        [parameDic setObject:_arrayDepartmentsIn forKey:@"departmentsIn"];
    }
    if (_arrayDoctorTitleIn.count > 0) {
        [parameDic setObject:_arrayDoctorTitleIn forKey:@"doctorTitleIn"];
    }
    if (_arrayStatusIn.count > 0) {
        [parameDic setObject:_arrayStatusIn forKey:@"statusIn"];
    }
    [parameDic setObject:[NSString stringWithFormat:@"%d",offset] forKey:@"offset"];
    [parameDic setObject:@"10" forKey:@"pageSize"];
    NSLog(@"parameDic == %@",parameDic);
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSArray *respArr = [[responseObject objectForKey:@"result"] objectForKey:@"data"];
        NSMutableArray *array = [FamousModel mj_objectArrayWithKeyValuesArray:respArr];
        if (page == 0) {
            [_arrayFamous removeAllObjects];
        }
        [self.arrayFamous addObjectsFromArray:array];
        if (self.isRefreshAction) {
            NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//            _isRefreshAction = NO;
        }else{
           
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        if (self.arrayFamous.count <1) {
            [self.nullView setHidden:NO];
        }else{
            [self.nullView setHidden:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)goViewController: (NSIndexPath *)index{
//    if (_isRefreshAction) {
//        [self postFamous];
//        return;
//    }
    FamousModel *model = self.arrayFamous[index.row];
    UserInfoModel *modelUser = [UserInfoModel mj_objectWithKeyValues:[SaveData readLogin]];
    if ([model.buyStatus isEqualToString:@"0"]) {//&&[modelUser.famousTimes intValue] <= 0
        OrderPayViewController *vc = [[OrderPayViewController alloc] init];
        vc.strID = model.orderId;
        vc.famousModel = model;
        vc.type = 3;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
//    else if (_isRefreshAction){
//
//        OrderPayViewController *vc = [[OrderPayViewController alloc] init];
//        vc.strID = model.orderId;
//        vc.famousModel = model;
//        vc.type = 3;
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
//    }
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

#pragma mark ----获取医生职称列表
- (void)postTitle{
    NSString *url = [NSString stringWithFormat:POST_TITLE,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSArray *respArr = [responseObject objectForKey:@"result"];
        self.arrayDoctorTitleInAll = [NSMutableArray arrayWithArray:respArr];
        [self postDepartments];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark ----获取医生科室列表
- (void)postDepartments{
    NSString *url = [NSString stringWithFormat:POST_DEPARTMENTS,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSArray *respArr = [responseObject objectForKey:@"result"];
        self.arrayDepartmentsInAll = [NSMutableArray arrayWithArray:respArr];
        self.dataArray = @[@[@"未开始", @"报名中", @"直播中", @"已结束"],
                           self.arrayDepartmentsInAll, self.arrayDoctorTitleInAll];
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


#pragma mark -----关注医生接口
- (void)putFocus: (NSString *)doctorID : (NSIndexPath *)index{
   
    NSString *url = [NSString stringWithFormat:PUT_DELETE_FOCUS,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    
    [parameDic setObject:doctorID forKey:@"doctorId"];
    [RequestUtil Put:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [[responseObject objectForKey:@"code"] intValue];
        if (code == 999) {
            [self deleteFocus:doctorID:index];
            return;
        }
        NSLog(@"%@",responseObject);
        FamousModel *model = _arrayFamous[index.row];
        
        model.doctorFocus = @"1";
//        [_arrayFamous removeObjectAtIndex:index.row];
        [_arrayFamous replaceObjectAtIndex:index.row withObject:model];
//        [_arrayFamous replaceObjectAtIndex:model atIndex:index.row];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];

        [SVProgressHUD showSuccessWithStatus:@"关注成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"关注失败");
    }];
}

#pragma mark ------取消关注医生接口
- (void)deleteFocus:(NSString *)doctorID: (NSIndexPath *)index{
    NSString *url = [NSString stringWithFormat:PUT_DELETE_FOCUS,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:doctorID forKey:@"doctorId"];
    [RequestUtil DELETE:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        FamousModel *model = _arrayFamous[index.row];
        
        model.doctorFocus = @"0";
        [_arrayFamous replaceObjectAtIndex:index.row withObject:model];
//        [_arrayFamous removeObjectAtIndex:index.row];
//        [_arrayFamous insertObject:model atIndex:index.row];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
        [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"取消关注失败");
    }];
}

#pragma mark ---- 获取专家讲座列表
- (void)postLetures{
    int offset = page*10;
    NSString *url = [NSString stringWithFormat:POST_LECTURES,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
//    if (!self.isRefreshAction) {
        if (_arrayDepartmentsIn.count > 0) {
            [parameDic setObject:_arrayDepartmentsIn forKey:@"departmentsIn"];
        }
        if (_arrayDoctorTitleIn.count > 0) {
            [parameDic setObject:_arrayDoctorTitleIn forKey:@"doctorTitleIn"];
        }
        if (_arrayStatusIn.count > 0) {
            [parameDic setObject:_arrayStatusIn forKey:@"statusIn"];
        }
//    }
    [parameDic setObject:[NSString stringWithFormat:@"%d",offset] forKey:@"offset"];
    [parameDic setObject:@"10" forKey:@"pageSize"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSArray *respArr = [[responseObject objectForKey:@"result"] objectForKey:@"data"];
//        self.arrayFamous = [NSMutableArray array];
        if (page == 0) {
            [_arrayFamous removeAllObjects];
        }
        NSMutableArray *array = [FamousModel mj_objectArrayWithKeyValuesArray:respArr];
       [self.arrayFamous addObjectsFromArray:array];
        if (self.isRefreshAction) {
            NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//            _isRefreshAction = NO;
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        if (self.arrayFamous.count <1) {
            [self.nullView setHidden:NO];
        }else{
            [self.nullView setHidden:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark -----获取订单详情
- (void)postOrder : (NSString *)string{
    NSString *url = [NSString stringWithFormat:POST_ORDER_GET,rootURL];
    [RequestUtil POST:url parameters:string withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
//        NSDictionary *respDic = [responseObject objectForKey:@"result"];
//        _orderModel = [OrderModel mj_objectWithKeyValues:respDic];
//        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

//#pragma mark ----获取直播详情
//- (void)postParameter : (NSString *)string{
////    NSLog(@"-------%@",self.pid);
////    NSString *url = [NSString stringWithFormat:POST_PARAMETER,rootURL];
////    NSString *string = self.pid;
//    [RequestUtil POST:url parameters:string withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"responseObject == %@",responseObject);
//        NSDictionary *respDic = [responseObject objectForKey:@"result"];
//        self.model =[ParameterModel mj_objectWithKeyValues:respDic];
//        [self.tableView reloadData];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//}
@end
