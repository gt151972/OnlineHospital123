//
//  ApplyViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/20.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "ApplyViewController.h"
#import "ApplyHead1TableViewCell.h"
#import "ApplyHead2TableViewCell.h"
#import "ApplyCostTableViewCell.h"
#import "ApplyDoctorTableViewCell.h"
#import "ApplyDetailTableViewCell.h"
#import "ApplyFooterTableViewCell.h"
#import "InteractionViewController.h"
#import "OrderPayViewController.h"
#import "BaseDataChange.h"
#import "ParameterModel.h"
#import "EnrollModel.h"
#import "UserInfoModel.h"
#import "VIPAlertViewController.h"
#import "MineVIPViewController.h"
#import "VIPApplyViewController.h"
#import "HomeVideoViewController.h"
#import "GTArticalViewController.h"
static NSString *identifierHead1 = @"ApplyHead1TableViewCell";
static NSString *identifierHead2 = @"ApplyHead2TableViewCell";
static NSString *identifierCost = @"ApplyCostTableViewCell";
static NSString *identifierDoctor = @"ApplyDoctorTableViewCell";
static NSString *identifierDetail = @"ApplyDetailTableViewCell";
static NSString *identifierFoot = @"ApplyFooterTableViewCell";
@interface ApplyViewController ()<UITableViewDelegate, UITableViewDataSource, VIPAlertViewControllerDelegate, VIPApplyViewControllerDelegate>{
    NSString *strTitle;
    NSString *strMain;
    BOOL isOpen;
    BOOL isAttention;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)ParameterModel *model;
@property (nonatomic, strong)BaseDataChange *labCountDown;
@property (nonatomic, strong)RACDisposable *disposable;
@property (nonatomic, strong)EnrollModel *enrollModel;
@property (nonatomic, assign)BOOL isVIP;
@end


@implementation ApplyViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_disposable dispose];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self postParameter];
//    strTitle = @"哪些时间是孩子生长发育的关键时期医生将不能针对您的问题?哪些时间是孩子生长发育的关键时期医生将不能针对您的问题?";
//    strMain = @"FM电台主持人接到听众电话。听众：我刚刚在麦当劳门口捡到一个钱包，里面有五千多元钱。主持人：非常感谢这位热心听众，请留一下你的联系电话，我们会尽快帮你找到失主。听众：不不不，我只是想点一首歌，大张伟的歌曲《倍儿爽》，表达下我现在的心情";
    
    if (_state == ApplyViewStateVideo) {
        UIView *nav = [self applyNavigationViewWithTitle:@"我要报名" right:@""];
        [self.view addSubview:nav];
    }else{
        UIView *nav = [self applyNavigationViewWithTitle:@"我要报名" right:@"说明"];
        [self.view addSubview:nav];
    }
    self.view.backgroundColor = BG_COLOR;
    [self.view addSubview:self.tableView];

    if (_state == ApplyViewStateDidStart){
        long now = [[BaseDataChange getTimestampFromTime] intValue];
        long date = [_endEnrollInteractDate intValue];
        UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:[SaveData readLogin]];
//        int now = [[BaseDataChange getTimestampFromTime] intValue];
        if (date > now && [_model.maxInteract intValue] > [_model.interactUser intValue]) {
            //旁听 互动
            GTBlueButton *btnAudit = [GTBlueButton whiteButtonWithFrame:CGRectMake(12, Screen_H - 50 -20, (Screen_W - 24)/3, 50) ButtonTitle:@" 旁听"];
            [btnAudit setImage:[UIImage imageNamed:@"pt"] forState:UIControlStateNormal];
            [self.view addSubview:btnAudit];
            
            WS
            [[btnAudit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton * _Nullable x) {
                if ([userModel.expireDate intValue] >= now && [userModel.famousTimes intValue] > 0){
                VIPApplyViewController *vc = [[VIPApplyViewController alloc] init];
                    vc.delegate = weakSelf;
                [self.navigationController presentViewController:vc animated:NO completion:nil];
                }else{
                    [self postEnroll:@"1"];
                }
            }];
            GTBlueButton *btn = [GTBlueButton blueButtonWithFrame:CGRectMake(12 + (Screen_W - 24)/3, Screen_H - 50 -20, (Screen_W - 24)*2/3, 50) ButtonTitle:@"我要互动"];
            [self.view addSubview:btn];
           
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton * _Nullable x) {
                if ([weakSelf.model.authorityType intValue] == 1 && [userModel.expireDate intValue] < now  ) {
                    VIPAlertViewController *alert = [[VIPAlertViewController alloc] init];
                    alert.delegate = weakSelf;
                    [self.navigationController presentViewController:alert animated:NO completion:nil];
                }
                else{
                    [weakSelf.disposable dispose];
                    InteractionViewController *vc = [[InteractionViewController alloc] init];
                    vc.type = 2;
                    vc.strLiveID = self.model.pid;
                    vc.model = self.model;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }];
        }else{
            //旁听
            GTBlueButton *btn = [GTBlueButton blueButtonWithFrame:CGRectMake(12, Screen_H - 50 -20, (Screen_W - 24), 50) ButtonTitle:@"我要旁听"];
            [self.view addSubview:btn];
            WS
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton * _Nullable x) {
                if ( [userModel.expireDate intValue] >= now &&[userModel.famousTimes intValue] > 0){
                    VIPApplyViewController *vc = [[VIPApplyViewController alloc] init];
                    vc.delegate = weakSelf;
                    [self.navigationController presentViewController:vc animated:NO completion:nil];
                }else{
                    [self postEnroll:@"1"];
                }
                
            }];
        }
    }else if (_state == ApplyViewStateLectureDidStart){
        //我要报名
        GTBlueButton *btn = [GTBlueButton blueButtonWithFrame:CGRectMake(12, Screen_H - 50 -20, (Screen_W - 24), 50) ButtonTitle:@"我要报名"];
        [self.view addSubview:btn];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton * _Nullable x) {
            UserInfoModel *userModel = [UserInfoModel mj_objectWithKeyValues:[SaveData readLogin]];
            long now = [[BaseDataChange getTimestampFromTime] intValue];
            WS
            if ( [userModel.expireDate intValue] >= now && [userModel.lectureTimes intValue] > 0){
                VIPApplyViewController *vc = [[VIPApplyViewController alloc] init];
                vc.delegate = weakSelf;
                vc.labDetail.text = @"本次兑换将消耗1次专家讲座特权";
                [self.navigationController presentViewController:vc animated:NO completion:nil];
            }else{
                [self postEnroll:@"1"];
            }
        }];
    }
}

- (void)VIPAlertBtnClicked:(NSInteger)item{
    MineVIPViewController *vc = [[MineVIPViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ---UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(12, SafeAreaTopHeight+12, Screen_W-24, Screen_H-50-20-SafeAreaTopHeight - 12 ) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.estimatedRowHeight = 100.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [self.tableView registerNib:[UINib nibWithNibName:identifierHead1 bundle:nil] forCellReuseIdentifier:identifierHead1];
        [self.tableView registerNib:[UINib nibWithNibName:identifierHead2 bundle:nil] forCellReuseIdentifier:identifierHead2];
         [self.tableView registerNib:[UINib nibWithNibName:identifierCost bundle:nil] forCellReuseIdentifier:identifierCost];
        [self.tableView registerNib:[UINib nibWithNibName:identifierDoctor bundle:nil] forCellReuseIdentifier:identifierDoctor];
        [self.tableView registerNib:[UINib nibWithNibName:identifierDetail bundle:nil] forCellReuseIdentifier:identifierDetail];
        [self.tableView registerNib:[UINib nibWithNibName:identifierFoot bundle:nil] forCellReuseIdentifier:identifierFoot];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_model.pid) {
        return 3;
    }else{
        return 0;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 1;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        long now = [[BaseDataChange getTimestampFromTime] intValue];
        long date = [_endEnrollInteractDate intValue];
        if (indexPath.row == 0) {
            CGFloat height =  [self getLabelHeightByWidth:Screen_W - 64 Title:_model.title font:[UIFont systemFontOfSize:18]];
            if (_state == ApplyViewStateLectureWillStart || _state == ApplyViewStateLectureDidStart) {
                return height + 66;
            }else if (_state == ApplyViewStateDidStart && date <=  now){
                return height + 66;
            }
            else{
                return height + 106;
            }
        }else{
            if (_state == ApplyViewStateLectureWillStart || _state == ApplyViewStateLectureDidStart) {
                return 77;
            }else if (_state == ApplyViewStateDidStart && date <=  now){
                return 77;
            }
            return 97;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            return 76;
        }
        else{
            if (isOpen) {
                CGFloat height =  [self getLabelHeightByWidth:Screen_W - 64 Title:_model.doctorDescription font:[UIFont systemFontOfSize:12]];
                return height + 94;
            }else{
                 return 104;
            }
        }
    }
    else{
        CGFloat height =  [self getLabelHeightByWidth:Screen_W - 64 Title:_model.descriptions font:[UIFont systemFontOfSize:14]];
        return height + 100;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ApplyHead2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierHead2];
            if (cell == nil) {
                cell = [[ApplyHead2TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierHead2];
            }
            cell.backgroundColor = BG_COLOR_WHITE;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.labTitle.text =_model.title;
            CGFloat height =  [self getLabelHeightByWidth:Screen_W - 64 Title:_model.title font:[UIFont systemFontOfSize:18]];
            cell.layer.mask = [self maskLayerWithHeight:height + 106 type:0];
            if (_state == ApplyViewStateWillStart) {
                cell.labTimeTitle.text = @"报名开始时间";
                cell.labTime.text = [NSString stringWithFormat:@"   %@",[BaseDataChange getDateStringWithTimeStr:_model.enrollDate formatter:@"yyyy.MM.dd HH:mm:ss"]];//@"   2020.09.09 15:00:00 ";
                int num = [_model.maxInteract intValue] - [_model.enrollNum intValue];
                NSString *pay1 = [NSString stringWithFormat:@"%d",num];
                NSString *str1 = [NSString stringWithFormat:@"报名剩余人数: %@名额",pay1];
                cell.labNum.text = str1;
                NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:cell.labNum.text];
                [attr1 addAttribute:NSForegroundColorAttributeName value:BLUE_COLOR_MAIN range:NSMakeRange(8, pay1.length)];
                [cell.labNum setAttributedText:attr1];
                [cell.labDetail setHidden:YES];
                cell.labTimeTitle.hidden = NO;
            }else if (_state == ApplyViewStateDidStart){
                long now = [[BaseDataChange getTimestampFromTime] intValue];
                long date = [_model.endEnrollInteractDate intValue];
                if (date > now) {
                    cell.labTimeTitle.text = @"距报名结束";
                    cell.labTime.text = [self getNowTimeWithString:_model.endEnrollInteractDate];
                    CGFloat width = [self getLabelWidthByHeight:20 Title:cell.labTime.text font:[UIFont systemFontOfSize:12]];
                    [cell.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(width);
                    }];
                    __weak __typeof(self) weakSelf= self;
                        RACSignal *timerSignal = [RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler];
                        // 订阅该信号
                        _disposable = [timerSignal subscribeNext:^(id  _Nullable x) {
                            cell.labTime.text = [weakSelf getNowTimeWithString:weakSelf.model.endEnrollInteractDate];
                            [cell.labTime sizeToFit];
                            CGFloat width = [self getLabelWidthByHeight:20 Title:cell.labTime.text font:[UIFont systemFontOfSize:12]];
                            [cell.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.width.mas_equalTo(width);
                            }];
                        }];
                    int num = [_model.maxInteract intValue] - [_model.enrollNum intValue];
                    NSString *pay1 = [NSString stringWithFormat:@"%d",num];
                    NSString *str1 = [NSString stringWithFormat:@"报名剩余人数: %@名额",pay1];
                    cell.labNum.text = str1;
                    NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:cell.labNum.text];
                    [attr1 addAttribute:NSForegroundColorAttributeName value:BLUE_COLOR_MAIN range:NSMakeRange(8, pay1.length)];
                    [cell.labNum setAttributedText:attr1];
                    [cell.labDetail setHidden:YES];
                    cell.labTimeTitle.hidden = NO;
                }else{
                    cell.labTimeTitle.hidden = YES;
                    cell.labTime.hidden = YES;
                    cell.labNum.hidden = YES;
                    cell.labDetail.text = @" 报名已结束 ";
                }
            }else if (_state == ApplyViewStateLectureWillStart){
                cell.labTime.text = [NSString stringWithFormat:@"   %@  ",[BaseDataChange getDateStringWithTimeStr:_model.enrollDate]];//@"   2020.09.09 15:00:00 ";
                cell.labTimeTitle.text = @"报名时间";
                CGFloat width = [self getLabelWidthByHeight:20 Title:cell.labTime.text font:[UIFont systemFontOfSize:12]];
                [cell.labTime mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo(width);
                }];
                [cell.labNum setHidden:YES];
                [cell.labDetail setHidden:YES];
            }else if (_state == ApplyViewStateLectureDidStart){
                cell.labDetail.text = @"   报名中   ";
                [cell.labNum setHidden:YES];
                [cell.labTime setHidden:YES];
                [cell.labTimeTitle setHidden:YES];
            }

            return cell;

        }else if(indexPath.row == 1){
            ApplyCostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCost];
            if (cell == nil) {
                cell = [[ApplyCostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierCost];
            }
            if (_state == ApplyViewStateLectureDidStart) {
                cell.image3.hidden = YES;
                cell.label3.hidden = YES;
                NSString *pay2 = _model.normalPrice;//@"¥10.00";
                NSString *str2 = [NSString stringWithFormat:@"报名费用: %.2f元",[pay2 floatValue]];
                cell.label2.text = str2;
                NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:cell.label2.text];
                [attr2 addAttribute:NSForegroundColorAttributeName value:BLUE_COLOR_MAIN range:NSMakeRange(6, pay2.length)];
                [cell.label2 setAttributedText:attr2];
                cell.image2.image = cell.image3.image;
                
                cell.label1.text = [NSString stringWithFormat:@"开播时间: %@",[BaseDataChange getDateStringWithTimeStr:_model.startDate]];
            }else if (_state == ApplyViewStateWillStart){
                NSString *pay1 = _model.interactPrice;//@"¥10.00";
                NSString *str1 = [NSString stringWithFormat:@"报名互动费用: %.2f元",[pay1 floatValue]];
                cell.label3.text = str1;
                NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:cell.label3.text];
                [attr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8, pay1.length)];
                [cell.label3 setAttributedText:attr1];
                NSString *pay2 = _model.normalPrice;//@"¥10.00";
                NSString *str2 = [NSString stringWithFormat:@"报名旁听费用: %.2f元",[pay2 floatValue]];
                cell.label2.text = str2;
                NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:cell.label2.text];
                [attr2 addAttribute:NSForegroundColorAttributeName value:GREEN_COLOR_MAIN range:NSMakeRange(8, pay2.length)];
                [cell.label2 setAttributedText:attr2];
                cell.label1.text = [NSString stringWithFormat:@"开播时间:  %@",[BaseDataChange getDateStringWithTimeStr:_model.startDate]];
            }else if (_state == ApplyViewStateDidStart){
                long now = [[BaseDataChange getTimestampFromTime] intValue];
                long date = [_model.endEnrollInteractDate intValue];
                NSString *pay1 = _model.interactPrice;//@"¥10.00";
                NSString *str1 = [NSString stringWithFormat:@"报名互动费用: %.2f元",[pay1 floatValue] ];
                cell.label3.text = str1;
                NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:cell.label3.text];
                [attr1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(8, pay1.length)];
                [cell.label3 setAttributedText:attr1];
                [cell.image3 setImage:[UIImage imageNamed:@"apply_bm"]];
                NSString *pay2 = _model.normalPrice;//@"¥10.00";
                NSString *str2 = [NSString stringWithFormat:@"报名旁听费用: %.2f元",[pay2 floatValue]];
                cell.label2.text = str2;
                NSMutableAttributedString *attr2 = [[NSMutableAttributedString alloc] initWithString:cell.label2.text];
                [attr2 addAttribute:NSForegroundColorAttributeName value:GREEN_COLOR_MAIN range:NSMakeRange(8, pay2.length)];
                [cell.label2 setAttributedText:attr2];
                cell.label1.text = [NSString stringWithFormat:@"开播时间:  %@",[BaseDataChange getDateStringWithTimeStr:_model.startDate]];
                if (date <= now) {
                    cell.label3.hidden = YES;
                    cell.image3.hidden = YES;
                }
            }
            cell.backgroundColor = BG_COLOR_WHITE;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.layer.mask = [self maskLayerWithHeight:97 type:1];
            return cell;
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            ApplyDoctorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierDoctor];
            if (cell == nil) {
                cell = [[ApplyDoctorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierDoctor];
            }
//            cell.headImage.image = [UIImage imageNamed:@"mine_head"];
            NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE, rootURL2,_model.doctorIcon];
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"mine_head"]];
            cell.labName.text = _model.doctorName;
            cell.labDetail.text = [NSString stringWithFormat:@"%@  |  %@",_model.doctorDepartment,_model.doctorTitle];
            cell.btnAttention.selected = [_model.doctorFocus intValue];
            [[cell.btnAttention rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
                            if (!x.selected) {
                                [self putFocus];
                                cell.btnAttention.layer.borderWidth = 0;
                                cell.btnAttention.layer.borderColor = BLUE_COLOR_MAIN.CGColor;
                            }else{
                                [self deleteFocus];
                                cell.btnAttention.layer.borderWidth = 1;
                                cell.btnAttention.layer.borderColor = TEXT_COLOR_MAIN.CGColor;
                            }
                x.selected = !x.selected;
            }];
//            [cell.btnAttention addTarget:self action:@selector(btnAttentionClicked) forControlEvents:UIControlEventTouchUpInside];
//            cell.isAttention = [_model.doctorFocus intValue];
//            cell.btnAttention.selected = isAttention;
            cell.backgroundColor = BG_COLOR_WHITE;
            cell.layer.mask = [self maskLayerWithHeight:76 type:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            ApplyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierDetail];
            if (cell == nil) {
                cell = [[ApplyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierDetail];
            }
            cell.btn.userInteractionEnabled = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.lab.text = _model.doctorDescription;
            if (isOpen) {
                 CGFloat height =  [self getLabelHeightByWidth:Screen_W - 64 Title:strMain font:[UIFont systemFontOfSize:12]];
                cell.layer.mask = [self maskLayerWithHeight:height + 94 type:1];
                [cell.btn setImage:[UIImage imageNamed:@"home_up_nomal"] forState:UIControlStateNormal];
            }else{
                cell.layer.mask = [self maskLayerWithHeight:104 type:1];
                [cell.btn setImage:[UIImage imageNamed:@"home_down_nomal"] forState:UIControlStateNormal];
            }
            
            return cell;
        }
    }else if(indexPath.section == 2){
        ApplyFooterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierFoot];
        if (cell == nil) {
            cell = [[ApplyFooterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierFoot];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labMain.text = _model.descriptions;
        cell.labMain.numberOfLines = 0;
        return cell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 1) {
        isOpen = !isOpen;
        [self.tableView reloadData];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
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

-(CGFloat)getLabelWidthByHeight:(CGFloat)Height Title:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, Height)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 1;
    [label sizeToFit];
    CGFloat width = label.frame.size.width;
    return width;
}

- (CAShapeLayer *)maskLayerWithHeight:(CGFloat)height type: (int)type{
    if (type == 0) {
         UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_W - 24,height) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, Screen_W - 24,height);
           maskLayer.path = maskPath.CGPath;
           return maskLayer;
    }else{
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_W - 24,height) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = CGRectMake(0, 0, Screen_W - 24,height);
           maskLayer.path = maskPath.CGPath;
        return maskLayer;
    }
}

- (void)btnRightClicked{
    NSLog(@"说明");
    GTArticalViewController *vc = [[GTArticalViewController alloc] init];
    vc.strPath = PATH_EXPLAIN;
    vc.isShowCollect = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnAttentionClicked{
    
    if (!isAttention) {
        [self putFocus];
    }else{
        [self deleteFocus];
    }
    isAttention = !isAttention;
}

-(NSString *)getNowTimeWithString:(NSString *)aTimeString{
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 截止时间date格式
    NSDate  *expireDate = [formater dateFromString:aTimeString];
    NSDate  *nowDate = [NSDate date];
    // 当前时间字符串格式
    NSString *nowDateStr = [formater stringFromDate:nowDate];
    // 当前时间date格式
    nowDate = [formater dateFromString:nowDateStr];
    //
    NSTimeInterval time=[aTimeString doubleValue];
    NSDate *detailDate=[NSDate dateWithTimeIntervalSince1970:time];
    
    NSTimeInterval timeInterval =[detailDate timeIntervalSinceDate:nowDate];
    int days = (int)(timeInterval/(3600*24));
    int hours = (int)((timeInterval-days*24*3600)/3600);
    int minutes = (int)(timeInterval-days*24*3600-hours*3600)/60;
    int seconds = timeInterval-days*24*3600-hours*3600-minutes*60;
    
    NSString *dayStr;NSString *hoursStr;NSString *minutesStr;NSString *secondsStr;
    //天
    dayStr = [NSString stringWithFormat:@"%d",days];
    //小时
    hoursStr = [NSString stringWithFormat:@"%d",hours];
   //分钟
    if(minutes<10)
        minutesStr = [NSString stringWithFormat:@"0%d",minutes];
    else
        minutesStr = [NSString stringWithFormat:@"%d",minutes];
    //秒
    if(seconds < 10)
        secondsStr = [NSString stringWithFormat:@"0%d", seconds];
    else
        secondsStr = [NSString stringWithFormat:@"%d",seconds];
    if (hours<=0&&minutes<=0&&seconds<=0) {
        return @"   活动已经结束  ";
    }
    if (days) {
        return [NSString stringWithFormat:@"   %@天%@小时%@分  ", dayStr,hoursStr, minutesStr];
    }
    if (hours) {
        return [NSString stringWithFormat:@"   %@小时%@分%@秒  ",hoursStr , minutesStr,secondsStr];
    }
    if (minutes) {
        return [NSString stringWithFormat:@"   %@分%@秒  " , minutesStr,secondsStr];
    }
    return [NSString stringWithFormat:@"   %@秒  " ,secondsStr];
}

-(void)dealloc{

    [_disposable dispose];
//    [_labCountDown destoryTimer];
//    NSLog(@"%s dealloc",object_getClassName(self));
}

- (void)vipApplyBtnClicked:(NSInteger)item{
    switch (item) {
        case 1:{
            _isVIP = YES;
            [self postEnroll:@"1"];
            break;
        }
        case 2:{
            _isVIP = NO;
            [self postEnroll:@"1"];
            break;
        }
        default:
            break;
    }
}
#pragma mark ----获取直播详情
- (void)postParameter{
    NSLog(@"-------%@",self.pid);
    NSString *url = [NSString stringWithFormat:POST_PARAMETER,rootURL];
    NSString *string = self.pid;
    [RequestUtil POST:url parameters:string withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSDictionary *respDic = [responseObject objectForKey:@"result"];
        self.model =[ParameterModel mj_objectWithKeyValues:respDic];
        if ([_model.enrolled intValue] == 1) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                   if ([controller isKindOfClass:[HomeVideoViewController class]]) {
                       HomeVideoViewController *vc =(HomeVideoViewController *)controller;
                       [self.navigationController popToViewController:vc animated:YES];
                       
                       [vc refreshAction];//POP回去刷新页面
                   }
               }
            return;
        }
        [self.tableView reloadData];
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
//        [self.tableView reloadData];
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
//        [self.tableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"取消关注成功"];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark -----报名直播
- (void)postEnroll: (NSString *)strType{
    NSString *url = [NSString stringWithFormat:POST_ENROLL,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:_model.pid forKey:@"liveId"];//直播id
    [parameDic setObject:@"1"forKey:@"type"];
    WS
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        if ([[responseObject objectForKey:@"code"] intValue] != 0) {
            return;
        }
        NSDictionary *respDic = [responseObject objectForKey:@"result"];
        self.enrollModel =[EnrollModel mj_objectWithKeyValues:respDic];
        if (weakSelf.isVIP) {
            [self postPayWithId:self.enrollModel.orderId];
            return;
        }
        if ([responseObject[@"code"] intValue] == 0) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplyHasDid"
//                                                                object:nil
//                                                              userInfo:nil];
            [_disposable dispose];
            OrderPayViewController *vc = [[OrderPayViewController alloc] init];
            vc.type = 2;
            vc.strID = self.enrollModel.orderId;
            vc.enrollModel = self.enrollModel;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark ------统一支付接口
- (void)postPayWithId: (NSString *)orderID{
    NSString *url = [NSString stringWithFormat:POST_PAY,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:orderID forKey:@"id"];
    [parameDic setObject:@"VOUCHER" forKey:@"payType"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        [SVProgressHUD showSuccessWithStatus:@"兑换成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
