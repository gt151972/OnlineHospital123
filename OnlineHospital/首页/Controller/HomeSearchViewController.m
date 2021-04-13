//
//  HomeSearchViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/19.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "HomeSearchViewController.h"
#import "HomeDoctorViewController.h"

#import "DoctorModel.h"

@interface HomeSearchViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>{
    int page ;//页数
   int pageSize ;//每页数量
   
}
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arrayData;
@property (nonatomic, strong)NullView *nullView;
@end

@implementation HomeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arrayData = [NSMutableArray array];
    self.nullView = [[NullView alloc] initWithTitle:@"暂无任何内容" frame:self.view.frame];
        [self.view insertSubview:self.nullView belowSubview:self.tableView];
        [self.nullView setHidden:YES];
    self.view.backgroundColor = BG_COLOR;
    self.title = @"搜索";
    [self addSearchView];
    [self.tableView setHidden:YES];
    [self.view addSubview:self.tableView];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];

}
- (void)refreshAction {
    [_arrayData removeAllObjects];
    page = 0;
    [self postDoctor];
}
- (void)footRefresh {
    page++;
    [self postDoctor];
    
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(12, 58, Screen_W - 24, Screen_H - SafeAreaTopHeight-56) style:UITableViewStylePlain];
        _tableView.backgroundColor = BG_COLOR;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"HomeSearchTableViewCell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    DoctorModel *model = _arrayData[indexPath.row];
    UILabel *labName = [[UILabel alloc] initWithFrame:CGRectMake(36, 0, 50, 50)];
    labName.text = model.name;
    labName.textColor = TEXT_COLOR_MAIN;
    labName.textAlignment = NSTextAlignmentCenter;
    labName.font = [UIFont systemFontOfSize:16];
    [cell.contentView addSubview:labName];
    
    UILabel *labDetail = [[UILabel alloc] initWithFrame:CGRectMake(94, 0, 200, 50)];
    labDetail.text =[NSString stringWithFormat:@"%@  |  %@",model.title,model.department]; //@"副主任医师  |  儿科";
    labDetail.textColor = TEXT_COLOR_MAIN;
    labDetail.textAlignment = NSTextAlignmentCenter;
    labDetail.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:labDetail];
    
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
    vc.model = _arrayData[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)btnSearchClicked{
    [self postDoctor];
    
//    [self.tableView reloadData];
}

#pragma mark -----搜索医生接口
- (void)postDoctor{
    [self.arrayData removeAllObjects];
    NSString *url = [NSString stringWithFormat:POST_DOCTORS,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:_textfield.text forKey:@"department"];//根据科室筛选
    [parameDic setObject:_textfield.text forKey:@"name"];//根据姓名筛选
    int offset = page * pageSize;
    pageSize = 10;
    [parameDic setObject:[NSString stringWithFormat:@"%d",offset] forKey:@"offset"];
        [parameDic setObject:[NSString stringWithFormat:@"%d",pageSize] forKey:@"pageSize"];

    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject==%@", responseObject);
        NSArray *respArr = [[responseObject objectForKey:@"result"] objectForKey:@"content"] ;
        NSMutableArray *tempDataArr = [NSMutableArray array];
        NSMutableArray *array = [DoctorModel mj_objectArrayWithKeyValuesArray:respArr];
              [self.arrayData addObjectsFromArray:array];
               [self.tableView reloadData];
               [self.tableView.mj_header endRefreshing];
               [self.tableView.mj_footer endRefreshing];
       if (self.arrayData.count <1) {
                   [self.nullView setHidden:NO];
               }else{
                   [self.nullView setHidden:YES];
                   [self.tableView setHidden:NO];
               }
//        tempDataArr = [DoctorModel mj_objectArrayWithKeyValuesArray:respArr];
//        self.arrayData = [NSMutableArray arrayWithArray:tempDataArr];
//        [self.tableView setHidden:NO];
//        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
