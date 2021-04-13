//
//  VipPayViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/22.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "VipPayViewController.h"
#import "VipAlertView.h"
@interface VipPayViewController (){
    int type;
}
@property (weak, nonatomic) IBOutlet UIView *viewBg;
//@property (weak, nonatomic) IBOutlet UILabel *labFamous;
//@property (weak, nonatomic) IBOutlet UILabel *labLecture;
@property (weak, nonatomic) IBOutlet UIButton *btnAlipay;
@property (weak, nonatomic) IBOutlet UIButton *btnWechat;
@property (weak, nonatomic) IBOutlet UIImageView *imgAlipay;
@property (weak, nonatomic) IBOutlet UIImageView *imgWechat;
@end

@implementation VipPayViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // 这一步非常重要
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    type=4;
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
    [self.viewBg.layer insertSublayer:layer atIndex:0];
    
    GTBlueButton *btn = [GTBlueButton glodButtonWithFrame:CGRectMake(28, 327 , Screen_W - 56, 50) ButtonTitle:@"立即开通"];
    [btn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBg addSubview:btn];
    
    _labFamous.text = _strFamous;
    _labLecture.text = _strLecture;
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
    [self.delegate vipPay:type];
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

- (IBAction)btnClicked:(UIButton *)sender {
    if (sender == _btnAlipay) {
        _imgAlipay.image = [UIImage imageNamed:@"vip_btn_select"];
         _imgWechat.image = [UIImage imageNamed:@"vip_btn_nomal"];
        type = 4;
    }else{
         _imgAlipay.image = [UIImage imageNamed:@"vip_btn_nomal"];
         _imgWechat.image = [UIImage imageNamed:@"vip_btn_select"];
        type = 3;
    }
}

@end
