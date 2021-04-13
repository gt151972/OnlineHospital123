//
//  ReasonViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/11/27.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "ReasonViewController.h"

@interface ReasonViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)UIButton *btnState1;
@property (strong, nonatomic)UIButton *btnState2;
@property (strong, nonatomic)UIButton *btnState3;
@property (strong, nonatomic)NSString *strReason;
@end

@implementation ReasonViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // 这一步非常重要
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _strReason = @"";
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    if (IPHONE_X) {
        self.viewBg.frame = CGRectMake(0, Screen_H - SafeAreaBottomHeight - 352, Screen_W, 352+SafeAreaBottomHeight);
    }else{
        self.viewBg.frame = CGRectMake(0, Screen_H - 352, Screen_W, 352);
    }
    [self.viewBg addSubview:self.tableView];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_W, 352) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.viewBg.bounds;
    maskLayer.path = maskPath.CGPath;
    self.viewBg.layer.mask = maskLayer;
    
    GTBlueButton *btn = [GTBlueButton blueButtonWithFrame:CGRectMake(12, 262, Screen_W - 24, 50) ButtonTitle:@"确定"];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBg addSubview:btn];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 动画效果
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.viewBg.alpha = 1;
                        } completion:nil];
}

- (void)dismiss {
    if (_strReason.length >0) {
        [self dismissViewControllerAnimated:NO completion:^{
            [self.delegate reason:_strReason];
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请选择退款原因"];
    }
    
}

#pragma mark ---UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, Screen_W, 180) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = BG_COLOR;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arrayTitle = @[@"与其他直播时间冲突", @"临时有事", @"其他原因"];
    static NSString *identifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.backgroundColor = BG_COLOR_WHITE;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = arrayTitle[indexPath.row];
    UIButton * btnState = [[UIButton alloc] init];
    [cell.contentView addSubview:btnState];
    [btnState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView).mas_offset(-20);
        make.width.and.height.mas_equalTo(16);
    }];
    [btnState setImage:[UIImage imageNamed:@"vip_btn_nomal"] forState:UIControlStateNormal];
    [btnState setImage:[UIImage imageNamed:@"vip_btn_select"] forState:UIControlStateSelected];
    [btnState setSelected:NO];
    [btnState setTag:indexPath.row];

    switch (indexPath.row) {
        case 0:{
            _btnState1 = btnState;
//            [cell.contentView addSubview:_btnState1];
        }
            break;
        case 1:{
            _btnState2 = btnState;
//            [cell.contentView addSubview:_btnState1];
        }
            break;
        case 2:{
            _btnState3 = btnState;
//            [cell.contentView addSubview:_btnState1];
        }
            break;
            
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arrayTitle = @[@"与其他直播时间冲突", @"临时有事", @"其他原因"];
    if (indexPath.row == 0) {
        _btnState1.selected = !_btnState1.selected;
        _btnState2.selected = NO;
        _btnState3.selected = NO;
        if (_btnState1.selected) {
            _strReason = arrayTitle[0];
        }
    }
    else if (indexPath.row == 1) {
        _btnState2.selected = !_btnState2.selected;
        _btnState1.selected = NO;
        _btnState3.selected = NO;
        if (_btnState2.selected) {
            _strReason = arrayTitle[1];
        }
    }
    else if (indexPath.row == 2) {
        _btnState3.selected = !_btnState3.selected;
        _btnState2.selected = NO;
        _btnState1.selected = NO;
        if (_btnState3.selected) {
            _strReason = arrayTitle[2];
        }
    }
    
}
@end
