//
//  MineViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/7.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "MineViewController.h"
#import "MineInfoTableViewCell.h"
#import "MineVIPTableViewCell.h"
#import "MineHeadView.h"
#import "MineStateTableViewCell.h"
#import "MineToolTableViewCell.h"

#import "MineInfoViewController.h"
#import "MineVIPViewController.h"

#import "MineFlowerViewController.h"
#import "MineAttentionViewController.h"
#import "MineCollectViewController.h"
#import "MineOrderViewController.h"

#import "SettingViewController.h"
#import "GTArticalViewController.h"

#import "UserInfoModel.h"

#define space 12.0f //两边间隙
#define distance 8.0f //上下间隙

static NSString *identifierInfo = @"MineInfoTableViewCell";
static NSString *identifierVIP = @"MineVIPTableViewCell";
static NSString *identifierState = @"MineStateTableViewCell";
static NSString *identifierTool = @"MineToolTableViewCell";
@interface MineViewController ()<UITableViewDelegate, UITableViewDataSource, MineStateTableViewCellDelegate, MineToolTableViewCellDelegate>
@property(nonatomic,strong)UITableView *tableView;
//个人信息
@property(nonatomic,strong)MineInfoTableViewCell *infoCell;
//vip会员
@property(nonatomic,strong)MineVIPTableViewCell *vipCell;
//我的状态
@property(nonatomic,strong)MineHeadView *stateHeadView;
@property(nonatomic,strong)MineStateTableViewCell *stateCell;
//常用工具
@property(nonatomic,strong)MineHeadView *toolHeadView;
@property(nonatomic,strong)MineToolTableViewCell *toolCell;

@property(nonatomic, strong)UserInfoModel *model;
@end

@implementation MineViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSDictionary *dic = [SaveData readUserInfo];
    _model = [UserInfoModel mj_objectWithKeyValues:dic];
    [self postUserInfo];
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = BG_COLOR;
    [self.view addSubview:self.tableView];
}
#pragma mark --- UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H - SafeAreaBottomHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = BG_COLOR;
        _tableView.dataSource = self;
        _tableView.delegate = self;
       self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableView registerNib:[UINib nibWithNibName:identifierInfo bundle:nil] forCellReuseIdentifier:identifierInfo];
        [self.tableView registerNib:[UINib nibWithNibName:identifierVIP bundle:nil] forCellReuseIdentifier:identifierVIP];
         [self.tableView registerNib:[UINib nibWithNibName:identifierState bundle:nil] forCellReuseIdentifier:identifierState];
        [self.tableView registerNib:[UINib nibWithNibName:identifierTool bundle:nil] forCellReuseIdentifier:identifierTool];
//        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 64;
    }else if (indexPath.section == 1){
        return 40;
    }else if (indexPath.section == 2){
        return 50;
    }
    else if (indexPath.section == 3) {
        return 112;
    }else if (indexPath.section == 4){
        return 180;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return distance+64;
    }else if(section == 1 ){
        return 0;
    }else if (section == 2){
        return distance;
    }else if (section == 3){
        return 50 + distance;
    }else{
        return 50 + distance;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.infoCell = [tableView dequeueReusableCellWithIdentifier:identifierInfo];
        NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE,rootURL2,_model.headSculpture];
        [self.infoCell.imageHead sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"mine_head"]];
        [self.infoCell.imageHead setCornerRidus:32];
        self.infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_model.nickName) {
            self.infoCell.labtitle.text = [NSString stringWithFormat:@"HI, %@",_model.nickName];
        }else{
            self.infoCell.labtitle.text = @"未登录";
        }
        if ([_model.expireDate intValue] > [[BaseDataChange getTimestampFromTime] intValue]) {
            self.infoCell.labDetail.text = [NSString stringWithFormat:@"会员到期: %@",[BaseDataChange getDateStringWithTimeStr:_model.expireDate formatter:@"yyyy-MM-dd"]];
            self.infoCell.imageVip.hidden = NO;
        }else{
            self.infoCell.labDetail.text = @"成为会员, 享受更多精彩服务";
            self.infoCell.imageVip.hidden = YES;
        }
        return _infoCell;
    }else if (indexPath.section == 2){
        self.vipCell = [tableView dequeueReusableCellWithIdentifier:identifierVIP];
        self.vipCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        BOOL isvip = 1;
        if ([_model.expireDate intValue] > [[BaseDataChange getTimestampFromTime] intValue]) {
             self.vipCell.labDetail.textColor = TEXT_COLOR_GLOD;
            self.vipCell.bgimage.image = [UIImage imageNamed:@"mine_vip_select"];
            NSString *str =[NSString stringWithFormat:@"视频旁听 %@ 次权限  |  讲座旁听 %@ 次权限",_model.famousTimes,_model.lectureTimes];
            self.vipCell.labDetail.attributedText = [self getPriceAttribute:str];
           
        }else{
            self.vipCell.labDetail.textColor = TEXT_COLOR_DETAIL;
             self.vipCell.bgimage.image = [UIImage imageNamed:@"mine_vip_nomal"];
            NSString *str = @"买会员, 畅听名医视频";
            self.vipCell.labDetail.text = str;
            
        }
        return _vipCell;
    }
    else if (indexPath.section == 3){
        self.stateCell = [tableView dequeueReusableCellWithIdentifier:identifierState];
        self.stateCell.delegate = self;
        self.stateCell.arrayTitle = @[@"我的花朵", @"我的关注", @"我的收藏", @"视频订单"];
        self.stateCell.arrayImage = @[@"mine_state_flower", @"mine_state_attention", @"mine_state_collect", @"mine_state_order"];
        self.stateCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _stateCell;;
    }else if (indexPath.section == 4){
        self.toolCell = [tableView dequeueReusableCellWithIdentifier:identifierTool];
        self.toolCell.delegate = self;
        self.toolCell.arrayTitle = @[@"复诊订单", @"挂号记录", @"电子处方", @"就诊人管理", @"我的评价", @"设置"];
        self.toolCell.arrayImage = @[@"mine_tool_fzdd", @"mine_tool_ghjl", @"mine_tool_dzcf", @"mine_tool_jzrgl", @"mine_tool_wdpj", @"mine_tool_setting"];
        self.toolCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _toolCell;
    }
    else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgview = [[UIView alloc] init];
    if (section == 3){
       self.stateHeadView = [MineHeadView mineHeadViewWithFrame:CGRectMake(0, 0, Screen_W, 50) title:@"我的状态"];
        [bgview addSubview:self.stateHeadView];
    }else if (section == 4){
        self.toolHeadView = [MineHeadView mineHeadViewWithFrame:CGRectMake(0, 0, Screen_W, 50) title:@"常用工具"];
        [bgview addSubview:self.toolHeadView];
    }
   return bgview;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MineInfoViewController *vc = [[MineInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 2){
        MineVIPViewController *vc = [[MineVIPViewController alloc] init];
        vc.modelInfo = _model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark --- MineStateTableViewCellDelegate
- (void)passState:(NSInteger)item{
    if (item == 0) {//我的花朵
        MineFlowerViewController *vc = [[MineFlowerViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (item == 1){//我的关注
        MineAttentionViewController *vc = [[MineAttentionViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (item == 2){//我的收藏
        MineCollectViewController *vc = [[MineCollectViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{//我的订单
        MineOrderViewController *vc = [[MineOrderViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark --- MineToolTableViewCellDelegate
- (void)passTool:(NSInteger)item{
    if (item == 0) {//复诊订单
        GTArticalViewController *vc = [[GTArticalViewController alloc] init];
        vc.strPath = [NSString stringWithFormat:@"%@%@",NB_ORDER,[SaveData readToken]];
        vc.isShowCollect = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (item == 1){//挂号记录
        GTArticalViewController *vc = [[GTArticalViewController alloc] init];
        vc.strPath = [NSString stringWithFormat:@"%@%@",NB_RECORD,[SaveData readToken]];
        vc.isShowCollect = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (item == 2){//电子处方
        GTArticalViewController *vc = [[GTArticalViewController alloc] init];
        vc.strPath = [NSString stringWithFormat:@"%@%@",NB_PRESCRIPTION,[SaveData readToken]];
        vc.isShowCollect = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (item == 3){//就诊人管理
        GTArticalViewController *vc = [[GTArticalViewController alloc] init];
        vc.strPath = [NSString stringWithFormat:@"%@%@",NB_MANAGE,[SaveData readToken]];
        vc.isShowCollect = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (item == 4){//我的评价
        
    }else if (item == 5) {//设置
        SettingViewController *vc = [[SettingViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//利用切分先得数组,再根据索引计算
- (NSMutableArray *)getDuplicateSubStrLocInCompleteStr:(NSString *)completeStr withSubStr:(NSString *)subStr
{
    NSArray * separatedStrArr = [completeStr componentsSeparatedByString:subStr];
    NSMutableArray * locMuArr = [[NSMutableArray alloc]init];
    
    NSInteger index = 0;
    for (NSInteger i = 0; i<separatedStrArr.count-1; i++) {
        NSString * separatedStr = separatedStrArr[i];
        index = index + separatedStr.length;
        NSNumber * loc_num = [NSNumber numberWithInteger:index];
        [locMuArr addObject:loc_num];
        index = index+subStr.length;
    }
    return locMuArr;
}
-(NSMutableAttributedString *)getPriceAttribute:(NSString *)string{
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
    if ([_model.famousTimes isEqualToString:_model.lectureTimes]) {
        NSArray *array = [NSArray arrayWithArray:[self getDuplicateSubStrLocInCompleteStr:string withSubStr:_model.lectureTimes]];
        NSRange pointRange = NSMakeRange([array[0] intValue], _model.famousTimes.length);
        NSRange pointRange2 = NSMakeRange([array[1] intValue], _model.lectureTimes.length);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    //    dic[NSForegroundColorAttributeName] = TEXT_COLOR_GLOD;
        [attribut addAttributes:dic range:pointRange];
        [attribut addAttributes:dic range:pointRange2];
    }else{
        NSArray *array = [NSArray arrayWithArray:[self getDuplicateSubStrLocInCompleteStr:string withSubStr:_model.lectureTimes]];
        //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
        NSRange range = [string rangeOfString:_model.famousTimes];
        NSRange range2 = [string rangeOfString:_model.lectureTimes];
        NSRange pointRange = NSMakeRange(range.location, _model.famousTimes.length);
        NSRange pointRange2 = NSMakeRange(range2.location, _model.lectureTimes.length);
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    //    dic[NSForegroundColorAttributeName] = TEXT_COLOR_GLOD;
        [attribut addAttributes:dic range:pointRange];
        [attribut addAttributes:dic range:pointRange2];
    }
    return attribut;
}

//-(NSMutableAttributedString *)getPricetoAttribute:(NSString *)string{
//
//    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
//    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
//    NSRange range = [string rangeOfString:@"9"];
//    NSRange pointRange = NSMakeRange(range.location, 3);
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[NSFontAttributeName] = [UIFont systemFontOfSize:12];
//    dic[NSParagraphStyleAttributeName] = TEXT_COLOR_GLOD;
//    [attribut addAttributes:dic range:pointRange];
//    return attribut;
//}

#pragma mark -----获取用户信息
- (void)postUserInfo{
    NSString *url = [NSString stringWithFormat:POST_INFO,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setValue:[SaveData readToken] forKey:@"token"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *respDic = [responseObject objectForKey:@"result"];
        self.model = [UserInfoModel mj_objectWithKeyValues:respDic];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
//#pragma mark -----获取VIP信息
//- (void)postVIPInfo{
//    NSString *url = [NSString stringWithFormat:POST_MEMBER_INFO,rootURL];
//    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
//    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
////        NSLog(@"%@",responseObject);
////        NSDictionary *respDic = [responseObject objectForKey:@"result"];
////        self.model = [UserInfoModel mj_objectWithKeyValues:respDic];
////        [self.tableView reloadData];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//    }];
//}
@end
