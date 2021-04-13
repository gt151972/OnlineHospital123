//
//  HomeViewController.m
//  OnlineDoctor
//
//  Created by 高天的Mac on 2020/8/7.
//  Copyright © 2020 高天的Mac. All rights reserved.
//
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "LoginMessageViewController.h"
#import "HomeSearchViewController.h"
#import "HomeVideoViewController.h"
#import "HomeLeadViewController.h"
#import "HomeChairViewController.h"
#import "HomeDoctorViewController.h"
#import "HomeRecommendViewController.h"
#import "HeadView.h"
#import "HomeSearchView.h"
#import <SDCycleScrollView.h>
#import "HomeGrideView.h"
#import "HomeArticleTableViewCell.h"
#import "RecommandTableViewCell.h"
#import "DoctorModel.h"
#import "BannerModel.h"
#import "HomeArticalModel.h"
#import "GTArticalViewController.h"
#import "RTFViewController.h"
#import <WechatOpenSDK/WXApi.h>
#import "GTArticalViewController.h"
#import "GTWebViewViewController.h"
#import "WebViewController.h"
#import "UITabBar+Badge.h"
#import "ArticleViewController.h"
#define space 12.0f //两边间隙
#define distance 8.0f //上下间隙

static NSString *identifier = @"HomeArticleTableViewCell";
static NSString *identifier1 = @"RecommandTableViewCell";
//static NSString *imagePath = @[@"home_doctor", @"home_online", @"home_consuit", @""];
@interface HomeViewController ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, RecommandTableViewCellDelegate, HomeGrideViewDelegate, PassValueDelegate,HeadViewDelegate>{
    int page ;//页数
   int pageSize;//每页数量
   
}
@property(nonatomic,strong)UITableView *tableView;
//搜索栏
@property(nonatomic,strong) HomeSearchView *searchView;
//轮播图
@property(nonatomic,strong) SDCycleScrollView *bannerAd;
@property(nonatomic,strong) NSMutableArray *arrayBanner;
//主模块
@property(nonatomic,strong) HomeGrideView *grideView;
//名医推荐
@property(nonatomic,strong) RecommandTableViewCell *dictorcell;
@property (nonatomic, strong)NSMutableArray *arraydoctor;
//科普知识
@property(nonatomic,strong)HomeChairViewController *chairVC;
@property (nonatomic, strong)NSMutableArray *arrayChair;

@property (nonatomic, strong)NSDictionary *dicReturn;
//@property(nonatomic,strong) HomeArticleTableViewCell *articleCell;
@end

@implementation HomeViewController
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.tabBarController.tabBar showBadgeOfIndex:1];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [self refreshAction];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}
-(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
      
    return decodedString;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = BG_COLOR;
    self.title = @"朵尔医生";
    self.tabBarItem.title = @"首页";
    self.arraydoctor = [NSMutableArray array];
    [self addAdress];
     [self.view addSubview:self.tableView];
//    [self postUserInfo];
//    [self getBanner];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footRefresh)];
    [self refreshAction];
}

- (void)refreshAction {
    [self.arraydoctor removeAllObjects];
    [self.arrayBanner removeAllObjects];
    [self.arrayChair removeAllObjects];
    page = 0;
    [self postUserInfo];
}
- (void)footRefresh {
    page++;
    [self postUserInfo];
    
}

- (void)stopRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}
-(void)addAdress{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 60)];
    
    [btn addTarget:self action:@selector(btnnn) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"浙江" forState:UIControlStateNormal];
    [btn setTitleColor:TEXT_COLOR_MAIN forState:UIControlStateNormal];
//    [btn setBackgroundColor:BLUE_COLOR_MAIN forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn setImage:[UIImage imageNamed:@"home_down_nomal"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"home_down_select"] forState:UIControlStateHighlighted];
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, - btn.imageView.image.size.width, 0, btn.imageView.image.size.width)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btn.titleLabel.bounds.size.width, 0, -btn.titleLabel.bounds.size.width)];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBarButton;
   
}

-(void)btnnn{
//    LoginMessageViewController *vc = [[LoginMessageViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
    launchMiniProgramReq.userName = @"gh_5ec5e310552f";  //拉起的小程序的username
    launchMiniProgramReq.path = @"";    ////拉起小程序页面的可带参路径，不填默认拉起小程序首页，对于小游戏，可以只传入 query 部分，来实现传参效果，如：传入 "?foo=bar"。
    launchMiniProgramReq.miniProgramType = WXMiniProgramTypePreview; //拉起小程序的类型
    [WXApi sendReq:launchMiniProgramReq completion:^(BOOL success) {
        
    }];
}

#pragma mark --- SDCycleScrollView
-(SDCycleScrollView *)bannerAd {
    
    if (!_bannerAd) {
        _bannerAd = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(space, distance, Screen_W-(space *2), 140) delegate:self placeholderImage:[UIImage imageNamed:@"home_ad"]];
        _bannerAd.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _bannerAd.currentPageDotColor = [UIColor whiteColor];
        _bannerAd.layer.masksToBounds = YES;
        _bannerAd.layer.cornerRadius = REDIUS;
        _bannerAd.showPageControl = YES;
        _bannerAd.hidesForSinglePage = YES;
        _bannerAd.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
//        if (_arrayBanner.count>0) {
////            _bannerAd.imageURLStringsGroup = _arrayBanner;
//            _bannerAd.imageURLStringsGroup = imagesURLStrings;
//            NSMutableArray *array = [[NSMutableArray alloc] init];
//                        for (BannerModel *model in _arrayBanner) {
//                            NSString *strimage = [NSString stringWithFormat:POST_OSS_DOWNDATE,rootURL2,model.image];
//                            [array addObject:strimage];
//                        }
//            NSLog(@"array == %@",array);
//            _bannerAd.imageURLStringsGroup = array;
//        }
    }
    
    return _bannerAd;
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    BannerModel *model = [_arrayBanner objectAtIndex:index];
    if ([model.jumpType intValue] == 1) {//富文本
        RTFViewController *vc = [[RTFViewController alloc] init];
        vc.strRTF = model.content;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([model.jumpType intValue] == 2){//链接
        GTArticalViewController *vc = [[GTArticalViewController alloc] init];
        vc.strPath = model.content;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([model.jumpType intValue] == 4){//科普文章
        GTArticalViewController *vc = [[GTArticalViewController alloc] init];
        vc.strPath = [NSString stringWithFormat:@"%@/?token=%@#/policydetail?id=%@",POPULAR_SCIENCE,[SaveData readToken], model.content];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat sectionHeaderHeight = 50;
    if(scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0,0);
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
#pragma mark --- UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H -SafeAreaBottomHeight- SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = BG_COLOR;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            [self getBanner];
        }];
        [self.tableView.mj_header beginRefreshing];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier1];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return 1;
    }else if (section == 4) {
        return _arrayChair.count;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 170;
    }else if (indexPath.section == 4){
        return 118;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 40 + distance;
    }else if(section == 1 ){
        return 140 + distance;
    }else if (section == 2){
        return 220 + distance;
    }else if (section == 3){
        return 50 + distance;
    }else{
        return 50 + distance;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        HomeArticleTableViewCell *cell = [[HomeArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_arrayChair) {
            HomeArticalModel *model = _arrayChair[indexPath.row];
            cell.titleLabel.text = model.title;
            cell.detailLable.text = [NSString stringWithFormat:@"%@  %@次浏览",model.authorName, model.totalVisit];
            NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE,rootURL2,model.cover];
            [cell.ImgView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"timg"]];
        }
       
            return cell;
    }else{
         self.dictorcell = [[RecommandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1 menuArray:_arraydoctor];
         if (self.dictorcell == nil) {
             
         }
         self.dictorcell.onTapBtnViewDelegate = self;
         self.dictorcell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.dictorcell.menuArray = _arraydoctor;
         return self.dictorcell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgview = [[UIView alloc] init];
    if (section == 0) {
        self.searchView = [HomeSearchView homeSearchViewWithFrame:CGRectMake(space, distance, Screen_W- (space*2), 40) title:@"搜索医生,科室"];
        [bgview addSubview:self.searchView];
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchViewTapEvent)];
        [bgview addGestureRecognizer:tapGesture];
    }else if (section == 1){//banner
        [bgview addSubview: self.bannerAd];
    }else if (section == 2){//模块
        self.grideView = [[HomeGrideView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 220+distance)];
        [bgview addSubview:self.grideView];
        self.grideView.delegate = self;
    }else if (section == 3){//名医推荐
        HeadView *view = [[HeadView alloc] initWithFrame:CGRectMake(12, 0, Screen_W - 24, 50) title:@"名医推荐" isMore:YES];
               view.onTapBtnViewDelegate = self;
               [bgview addSubview:view];
    }else if (section == 4){//科普知识
        HeadView *view = [[HeadView alloc] initWithFrame:CGRectMake(12, 0, Screen_W - 24, 50) title:@"科普知识" isMore:YES];
        view.onTapBtnViewDelegate = self;
        [bgview addSubview:view];
    }
   return bgview;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        HomeArticalModel *model =_arrayChair[indexPath.row];
        GTArticalViewController *vc = [[GTArticalViewController alloc] init];
        vc.strPath = [NSString stringWithFormat:@"%@/?token=%@#/policydetail?id=%@",POPULAR_SCIENCE,[SaveData readToken],model.nid];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
//                GTWebViewViewController *vc = [[GTWebViewViewController alloc] init];
//                vc.strPath = [NSString stringWithFormat:@"%@%@",ARTICLE_PATH,model.nid];
////                vc.model = model;
//                [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark --- HomeGrideViewDelegate
- (void)homeGridePass:(NSInteger)item{
   if (item == 1) {
        HomeVideoViewController *vc = [[HomeVideoViewController alloc] init];
       vc.title = @"名医视频";
        [self.navigationController pushViewController:vc animated:YES];
   }else if(item == 2){
       GTArticalViewController *vc = [[GTArticalViewController alloc] init];
       vc.strPath = NB_FLOWERUP;
       vc.isShowCollect = NO;
       [self.navigationController pushViewController:vc animated:YES];
   }else if (item == 3){
        HomeLeadViewController *vc = [[HomeLeadViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
   }else if (item == 4){
       GTArticalViewController *vc = [[GTArticalViewController alloc] init];
       vc.strPath = [NSString stringWithFormat:@"%@%@",NB_REGISTRATION,[SaveData readToken]];
       vc.isShowCollect = NO;
       [self.navigationController pushViewController:vc animated:YES];
//       ArticleViewController *vc = [[ArticleViewController alloc] init];
//        vc.strPath = [NSString stringWithFormat:@"%@%@",NB_REGISTRATION,[SaveData readToken]];
//        [self.navigationController pushViewController:vc animated:YES];
   }
   else if (item == 5){
        HomeVideoViewController *vc = [[HomeVideoViewController alloc] init];
        vc.title = @"专家讲座";
        [self.navigationController pushViewController:vc animated:YES];
//        self.chairVC = [[HomeChairViewController alloc] init];
//        self.chairVC.delegate = self;
//        self.tabBarController.tabBar.hidden=YES;
//        [self presentViewController:self.chairVC animated:NO completion:nil];
    }
}

- (void)searchViewTapEvent{
    HomeSearchViewController *vc = [[HomeSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)passValue:(NSString *)value{
    if ([value isEqualToString:@"HomeChairViewController"]) {
        self.tabBarController.tabBar.hidden=NO;
    }
}

-(void)OnTapBtnView:(UITapGestureRecognizer *)sender{
    NSLog(@"%ld",(long)sender.view.tag);
    int index = sender.view.tag - 10;
    HomeDoctorViewController *vc = [[HomeDoctorViewController alloc] init];
    vc.model = self.arraydoctor[index];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)passMoreHeadView:(UIView *)headView title:(NSString *)title{
    if ([title isEqualToString:@"名医推荐"]) {
        HomeRecommendViewController *vc = [[HomeRecommendViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([title isEqualToString:@"科普知识"]){
        self.navigationController.tabBarController.selectedIndex=2;
    }
}

- (void)beginLogin{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    TXCustomModel *model = [OneClickLogin buildModel];
    __weak typeof(self) weakSelf = self;
    [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:3.0
                                                    controller:self
                                                         model:model
                                                      complete:^(NSDictionary * _Nonnull resultDic) {
        NSString *resultCode = [resultDic objectForKey:@"resultCode"];
        if ([PNSCodeLoginControllerPresentSuccess isEqualToString:resultCode]) {
            NSLog(@"授权页拉起成功回调：%@", resultDic);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        } else if ([PNSCodeLoginControllerClickCancel isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickLoginBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickProtocol isEqualToString:resultCode]) {
          
            NSLog(@"页面点击事件回调：%@", resultDic);
        }else if ([PNSCodeLoginControllerClickChangeBtn isEqualToString:resultCode]){
            
            LoginMessageViewController *controller = [[LoginMessageViewController alloc] init];
            controller.isHiddenNavgationBar = YES;
            UINavigationController *nav= weakSelf.navigationController;
            if (weakSelf.presentedViewController) {
                //如果授权页成功拉起，这个时候则需要使用授权页的导航控制器进行跳转
                nav = (UINavigationController *)weakSelf.presentedViewController;
            }
            [nav pushViewController:controller animated:YES];
//            
        }
        else if ([PNSCodeSuccess isEqualToString:resultCode]) {
            NSLog(@"获取LoginToken成功回调：%@", resultDic);
            //NSString *token = [resultDic objectForKey:@"token"];
            NSLog(@"接下来可以拿着Token去服务端换取手机号，有了手机号就可以登录，SDK提供服务到此结束");
            //[weakSelf dismissViewControllerAnimated:YES completion:nil];
            [self postLoginWithToken:[resultDic objectForKey:@"token"]];
            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
        } else {
            NSLog(@"获取LoginToken或拉起授权页失败回调：%@", resultDic);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            //失败后可以跳转到短信登录界面

            LoginMessageViewController *controller = [[LoginMessageViewController alloc] init];
            controller.isHiddenNavgationBar = YES;
            UINavigationController *nav= weakSelf.navigationController;
            if (weakSelf.presentedViewController) {
                //如果授权页成功拉起，这个时候则需要使用授权页的导航控制器进行跳转
                nav = (UINavigationController *)weakSelf.presentedViewController;
            }
            [nav pushViewController:controller animated:YES];
//            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
        }
    }];
}
#pragma mark ----登录
- (void)postLoginWithToken: (NSString *)token{
    NSString *url = [NSString stringWithFormat:POST_LOGIN,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:token forKey:@"id"];//密码登陆为用户名,手机验证码登陆时为手机号码,移动运营商一键登录（阿里sdk)时为token,微信登录时为微信code
    [parameDic setObject:@"MOBILE_ALI" forKey:@"type"];//PASSWORD-密码登录,CODE-验证码登录,WECHAT-微信登录,MOBILE_ALI
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject==%@", responseObject);
        NSMutableDictionary *respDic= [responseObject objectForKey:@"result"] ;
        [SaveData SaveLoginWithDic:respDic];
        [SaveData saveToken:[respDic objectForKey:@"token"]];
        [self getBanner];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


#pragma mark -----获取用户信息
- (void)postUserInfo{
    NSString *url = [NSString stringWithFormat:POST_INFO,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        int code = [[responseObject objectForKey:@"code"] intValue];
        if (code == 30009) {
//            [OneClickLogin beginLoginWithViewController:self];
//            [self beginLogin];
        }else{
            NSMutableDictionary *respDic= [responseObject objectForKey:@"result"] ;
            [SaveData SaveLoginWithDic:respDic];
            [SaveData SaveUserInfoWithDic:respDic];
//            [SaveData saveToken:[respDic objectForKey:@"token"]];
            [self getBanner];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
//    [self getBanner];
}

#pragma mark --------获取banner
- (void)getBanner{
    NSString *url = [NSString stringWithFormat:POST_BANNERS,rootURL];
    NSString *string = @"1";
    [RequestUtil POST:url parameters:string withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[responseObject objectForKey:@"code"] intValue] == 0) {
            NSLog(@"%@",responseObject);
            NSArray *respArr = [responseObject objectForKey:@"result"] ;
            self.arrayBanner = [NSMutableArray array];
            self.arrayBanner  = [BannerModel mj_objectArrayWithKeyValuesArray:respArr];
//            self.arrayBanner = [NSMutableArray arrayWithArray:tempDataArr];
            if (self.arrayBanner.count>0) {
    //            _bannerAd.imageURLStringsGroup = _arrayBanner;
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (BannerModel *model in _arrayBanner) {
                                NSString *strimage = [NSString stringWithFormat:POST_OSS_DOWNDATE,rootURL2,model.image];
                                [array addObject:strimage];
                            }
                NSLog(@"array ====== %@",array);
                self.bannerAd.imageURLStringsGroup = array;
            }
       }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    [self postRecommend];
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
               [self.arraydoctor addObjectsFromArray:array];
                [self.tableView reloadData];
        [self postArtical];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark -----获取首页文章接口
-(void)postArtical{
    NSString *url = [NSString stringWithFormat:POST_ARTICAL,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSArray *respArr = [responseObject objectForKey:@"result"];
        self.arrayChair = [NSMutableArray array];
        self.arrayChair = [HomeArticalModel mj_objectArrayWithKeyValuesArray:respArr];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
