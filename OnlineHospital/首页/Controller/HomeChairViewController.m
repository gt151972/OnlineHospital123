//
//  HomeChairViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/19.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "HomeChairViewController.h"

@interface HomeChairViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (strong, nonatomic) IBOutlet UIView *view;

@end

@implementation HomeChairViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // 这一步非常重要
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.tabBarController.tabBar.hidden=NO;
}
- (IBAction)btnGoclicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
         [self.delegate passValue:@"HomeChairViewController"];
    }];
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
    [self dismissViewControllerAnimated:NO completion:^{
        [self.delegate passValue:@"HomeChairViewController"];
    }];
}
@end
