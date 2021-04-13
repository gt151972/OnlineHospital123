//
//  HomeRecommendViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/25.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "HomeRecommendViewController.h"
#import "HomeDoctorViewController.h"
#import "StateAttentionTableViewCell.h"
#import "ZHCollectionViewFlowLayout.h"
#import "ZHCollectionViewCell.h"
static NSString *identifier = @"StateAttentionTableViewCell";
@interface HomeRecommendViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,ZHCollectionViewFlowLayoutDelegate,UIGestureRecognizerDelegate>{
    int page ;//页数
   int pageSize ;//每页数量
   
}
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)UIView *viewScreen;
@property(nonatomic,strong)NSArray *  dataArray;
@property(nonatomic,strong)NSMutableArray *  arrayDoctor;
@property(nonatomic,weak)UICollectionView * collectionView;
@end

@implementation HomeRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_COLOR;
    self.title = @"名医推荐";
    [self addSearchView];
    page = 1;
    [self.view addSubview:self.tableView];
     [self initNav];
    [self screenView];
     [self.viewScreen setHidden:YES];
    self.arrayDoctor = [[NSMutableArray alloc] init];
    [self postRecommend];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
}
-(void) initNav{
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 60)];
//        [btn addTarget:self action:@selector(btnnn) forControlEvents:UIControlEventTouchUpInside];
//        [btn setTitle:@"筛选" forState:UIControlStateNormal];
//        [btn setTitleColor:TEXT_COLOR_MAIN forState:UIControlStateNormal];
//    //    [btn setBackgroundColor:BLUE_COLOR_MAIN forState:UIControlStateNormal];
//        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
//        UIBarButtonItem *BarButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
//        self.navigationItem.rightBarButtonItem = BarButton;
}

- (void)btnnn{
    [self.viewScreen setHidden:NO];
   
}
- (void)refreshAction {
    [_arrayDoctor removeAllObjects];
    page = 0;
    [self postRecommend];
}
- (void)footRefresh {
    page++;
    [self postRecommend];
    
}

- (void)stopRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)addSearchView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, 8, Screen_W - 24, 40)];
    view.backgroundColor = BG_COLOR_WHITE;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10;
    [self.view addSubview:view];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 14, 14)];
    UIImage *image = [UIImage imageNamed:@"home_search"];
    imageview.image = image;
    [view addSubview:imageview];
    
    _textfield  = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, maxScreenWidth-64, 40)];
    _textfield.textAlignment = NSTextAlignmentLeft;
    _textfield.borderStyle = UITextBorderStyleNone;
    _textfield.textColor = TEXT_COLOR_MAIN;
    _textfield.placeholder = @"搜索医生,科室";
    _textfield.delegate = self;
//    _textfield.secureTextEntry = YES;
    _textfield.font = [UIFont systemFontOfSize:16];
    _textfield.keyboardType = UIKeyboardTypeDefault;
    [view addSubview:_textfield];
    
    UIButton *btnSearch = [[UIButton alloc] init];
    [btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
    [btnSearch setTitleColor:TEXT_COLOR_MAIN forState:UIControlStateNormal];
    [btnSearch addTarget:self action:@selector(btnSearchClicked) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnSearch];
    [btnSearch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view).offset(-13);
        make.centerY.equalTo(view);
    }];
}

#pragma mark ---UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(12, 58, Screen_W - 24, Screen_H - 144) style:UITableViewStylePlain];
        _tableView.backgroundColor = BG_COLOR;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
         [self.tableView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellReuseIdentifier:identifier];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayDoctor.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
      StateAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
          if (cell == nil) {
              cell = [[StateAttentionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
          }
    cell.model = _arrayDoctor[indexPath.row];
    cell.btnAttention.hidden = YES;
          cell.selectionStyle = UITableViewCellSelectionStyleNone;
          return cell;
    
    if (indexPath.row == 0) {
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_W - 24, 50) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    }else if (indexPath.row == 4){
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_W - 24, 50) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = cell.bounds;
        maskLayer.path = maskPath.CGPath;
        cell.layer.mask = maskLayer;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeDoctorViewController *vc = [[HomeDoctorViewController alloc] init];
    vc.model = _arrayDoctor[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)btnSearchClicked{
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
}

- (void)screenView{
    self.viewScreen = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    [self.view addSubview:_viewScreen];
    _viewScreen.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.6];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissScreen)];
    recognizer.delegate = self;
       [_viewScreen addGestureRecognizer:recognizer];
    
    self.dataArray = @[@[@"未开始", @"报名中", @"直播中", @"已结束"],@[@"小儿内科", @"皮肤科", @"骨科", @"泌尿外科", @"儿童保健科", @"口腔科"],@[@"医师", @"主治医师", @"副主任医师", @"主任医师"]];
       
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
    [btnRe addTarget:self action:@selector(dismissScreen) forControlEvents:UIControlEventTouchUpInside];
    [bg addSubview:btnRe];
    GTBlueButton *btnSure = [GTBlueButton blueButtonWithFrame:CGRectMake(Screen_W/2, 0, Screen_W/2, 50) ButtonTitle:@"确定"];
     btnSure.layer.cornerRadius = 0;
    [btnSure addTarget:self action:@selector(dismissScreen) forControlEvents:UIControlEventTouchUpInside];
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
    }else{
        cell.backgroundColor = BG_COLOR_WHITE;
        cell.label.textColor = TEXT_COLOR_MAIN;
    }
    cell.isSelect = !cell.isSelect;
}

- (void)dismissScreen{
    [_viewScreen setHidden:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.collectionView]) {
        return NO;
    }
    return YES;
}

#pragma mark ----名医推荐列表接口
- (void)postRecommend{
    NSString *url = [NSString stringWithFormat:POST_RECOMMEND,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    int offset = page * pageSize;
    pageSize = 9;
    [parameDic setObject:[NSString stringWithFormat:@"%d",offset] forKey:@"offset"];
        [parameDic setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject==%@", responseObject);
        NSArray *respArr = [[responseObject objectForKey:@"result"] objectForKey:@"content"] ;
        NSMutableArray *tempDataArr = [NSMutableArray array];
        NSMutableArray *array = [DoctorModel mj_objectArrayWithKeyValuesArray:respArr];
               [self.arrayDoctor addObjectsFromArray:array];
                [self.tableView reloadData];
        [self stopRefresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

@end
