//
//  MineFlowerViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "MineFlowerViewController.h"
#import "BaseNavgation.h"
@interface MineFlowerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnadd;

@end

@implementation MineFlowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CAGradientLayer *layer = [CAGradientLayer new];
    //colors存放渐变的颜色的数组
    layer.colors=@[(__bridge id)BLUE_COLOR_MAIN.CGColor,(__bridge id)BG_COLOR.CGColor];
    /**
     * 起点和终点表示的坐标系位置，(0,0)表示左上角，(1,1)表示右下角
     */
    layer.startPoint = CGPointMake(0.5, 0);
    layer.endPoint = CGPointMake(0.5, 1);
    layer.frame = self.view.frame;
    [self.view.layer insertSublayer:layer atIndex:0];

    UIView *nav = [self flowerNavigationViewWithTitle:@"我的花朵"];
    [self.view addSubview:nav];
    self.btnadd.layer.borderColor = [TEXT_COLOR_MAIN CGColor];
    self.btnadd.layer.borderWidth = 1;
    self.btnadd.layer.masksToBounds = YES;
    self.btnadd.layer.cornerRadius = 10;
    [self.btnadd setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.btnadd.imageView.image.size.width, 0, self.btnadd.imageView.image.size.width)];
       [self.btnadd setImageEdgeInsets:UIEdgeInsetsMake(0, self.btnadd.titleLabel.bounds.size.width, 0, -self.btnadd.titleLabel.bounds.size.width)];
//       self.btnadd.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
}
@end
