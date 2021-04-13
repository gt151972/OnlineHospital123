//
//  NotificationViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/1/28.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController

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
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    UIView *content = [[UIView alloc] init];
    content.backgroundColor = [UIColor whiteColor];
    content.layer.cornerRadius = REDIUS;
    content.clipsToBounds = YES;
    content.alpha = 0;
    [self.view addSubview:content];
    _content = content;
    
    // 获取语音验证码
    UILabel *titleL = [[UILabel alloc] init];
    titleL.font = [UIFont systemFontOfSize:18];
    titleL.text = @"权限提示";
    titleL.textColor = UIColor.blackColor;
    [titleL sizeToFit];
    [content addSubview:titleL];
    
    // 将电话告知您验证码，请注意接听！
    UILabel *detailL = [[UILabel alloc] init];
    detailL.font = [UIFont systemFontOfSize:18];
    detailL.textColor = UIColor.blackColor;
    detailL.text = @"当前通知权限被禁止,将影响本应用的消息推送,建议开启";
    [detailL sizeToFit];
    [content addSubview:detailL];
    
//    // 横线
//    UIView *line = [UIView new];
//    line.backgroundColor = RGBColor(0xd9d9d9);
//    [content addSubview:line];
    
    // 知道了
    UIButton *knowA = [[UIButton alloc] init];
    [knowA setTitle:@"暂不设置" forState:UIControlStateNormal];
    [knowA setBackgroundColor:BG_COLOR_WHITE forState:UIControlStateNormal];
    [knowA setTitleColor:TEXT_COLOR_DETAIL forState:UIControlStateNormal];
    [knowA.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [knowA addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [content addSubview:knowA];
    UIButton *knowB = [[UIButton alloc] init];
    [knowB setTitle:@"去设置" forState:UIControlStateNormal];
    [knowB setBackgroundColor:BLUE_COLOR_MAIN forState:UIControlStateNormal];
    [knowB setTitleColor:BG_COLOR_WHITE forState:UIControlStateNormal];
    [knowB.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [knowB addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [content addSubview:knowB];
    
    //
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(301, 180));
        make.center.equalTo(self.view);
    }];
    
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18);
        make.top.mas_equalTo(40);
        make.centerX.equalTo(content);
    }];
    
    [detailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(18);
        make.top.mas_equalTo(titleL.mas_bottom).offset(8);
        make.centerX.equalTo(content);
    }];
    
    [knowA mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(content);
        make.height.mas_equalTo(54);
        make.right.equalTo(knowA.mas_left);
    }];
    [knowB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(content);
        make.height.width.mas_equalTo(knowA);
        make.left.equalTo(knowA.mas_right);
    }];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
