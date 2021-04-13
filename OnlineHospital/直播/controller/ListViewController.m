//
//  ListViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/3/30.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import "ListViewController.h"
#import "liveTableViewCell.h"
static NSString *identifier2 = @"liveTableViewCell";
@interface ListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation ListViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // 这一步非常重要
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 动画效果
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.content.alpha = 1;
                        } completion:nil];
}
// 视图和布局
- (void)setviews {
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    singleTapGesture.numberOfTapsRequired =1;
    singleTapGesture.numberOfTouchesRequired  =1;
    [self.view addGestureRecognizer:singleTapGesture];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    UIView *content = [[UIView alloc] initWithFrame:CGRectMake(Screen_W/2, 0, Screen_W/2, Screen_H)];
    content.backgroundColor = [UIColor whiteColor];
    content.layer.cornerRadius = REDIUS;
    content.clipsToBounds = YES;
    content.alpha = 0;
    [self.view addSubview:content];
    _content = content;
    [_content addSubview:self.tableView];
}
#pragma mark ---UITableView
-(UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W/2, Screen_H) style:UITableViewStylePlain];
        _tableView.backgroundColor = BG_COLOR;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorColor = BG_COLOR;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.estimatedRowHeight = 100.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [self.tableView registerNib:[UINib nibWithNibName:identifier2 bundle:nil] forCellReuseIdentifier:identifier2];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _questionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    QuestionModel *mod = [_questionArray objectAtIndex:indexPath.row];
    NSString *string = mod.content;
    CGFloat height =  [self getLabelHeightByWidth:Screen_W/2-40 Title:string font:[UIFont systemFontOfSize:14]];
    return height + 105;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    liveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
    if (cell == nil) {
        cell = [[liveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
    }
    QuestionModel *model = _questionArray[indexPath.row];
    cell.model = model;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return @"咨询列表";
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *bgview = [[UIView alloc] init];
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
//     CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//     maskLayer.frame = bgview.bounds;
//     maskLayer.path = maskPath.CGPath;
//     bgview.layer.mask = maskLayer;
//     bgview.backgroundColor = BG_COLOR_WHITE;
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, bgview.size.width - 28, bgview.size.height)];
//    label.text = [NSString stringWithFormat:@"咨询列表"];
//    label.font = [UIFont systemFontOfSize:16];
//    label.textAlignment = NSTextAlignmentLeft;
//    label.textColor = TEXT_COLOR_MAIN;
//    [bgview addSubview:label];
//
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(14, 49, Screen_W- (26*2), 1)];
//        line.backgroundColor = BG_COLOR;
//    [bgview addSubview:line];
//    [bgview addSubview:bgview];
//
//    return bgview;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate ListViewClicked:indexPath];
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

- (void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
