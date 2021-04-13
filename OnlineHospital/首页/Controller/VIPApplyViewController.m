//
//  VIPApplyViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/1/11.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import "VIPApplyViewController.h"
#import "UserInfoModel.h"

@interface VIPApplyViewController ()
@property (nonatomic, strong) UIView *content;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *labFamous;
@property (weak, nonatomic) IBOutlet UILabel *labLetures;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@end

@implementation VIPApplyViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // 这一步非常重要
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self postUserInfo];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *dic = [SaveData readLogin];
    UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:dic];
    self.labFamous.text = model.famousTimes;
    self.labLetures.text =model.lectureTimes;
    // Do any additional setup after loading the view from its nib.
     self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.view addGestureRecognizer:recognizer];
    CAGradientLayer *layer = [CAGradientLayer new];
    //colors存放渐变的颜色的数组
    layer.colors=@[(__bridge id)TEXT_COLOR_GLOD2.CGColor,(__bridge id)BG_COLOR_WHITE.CGColor];
    /**
     * 起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
     */
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 0.1);
    layer.frame = self.view.frame;
    [self.bgView.layer insertSublayer:layer atIndex:0];
    
    self.btnCancel.layer.borderColor = TEXT_COLOR_GLOD2.CGColor;
    self.btnCancel.layer.borderWidth = 1.0f;
    
    

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 动画效果
    [UIView animateWithDuration:0.25f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn animations:^{
                            self.bgView.alpha = 1;
                        } completion:nil];
    
    
}

-(void)dismiss{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)btnCloseClicked:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)btnChangeClicked:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.delegate vipApplyBtnClicked:1];
    
}
- (IBAction)btnNochangeClicked:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.delegate vipApplyBtnClicked:2];
}

#pragma mark -----获取用户信息
- (void)postUserInfo{
    NSString *url = [NSString stringWithFormat:POST_INFO,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSMutableDictionary *respDic= [responseObject objectForKey:@"result"] ;
        [SaveData SaveLoginWithDic:respDic];
//        [SaveData saveToken:[respDic objectForKey:@"token"]];
        UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:[SaveData readLogin]];
        self.labFamous.text = model.famousTimes;
        self.labLetures.text = model.lectureTimes;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}



@end
