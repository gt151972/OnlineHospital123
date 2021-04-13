//
//  PrivilegeTableViewCell3.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/17.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "PrivilegeTableViewCell3.h"

@implementation PrivilegeTableViewCell3
- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@" 3 == %f",self.frame.size.width);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, Screen_W - 24, 80) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
     CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgView.bounds;
     maskLayer.path = maskPath.CGPath;
     self.bgView.layer.mask = maskLayer;
     self.bgView.backgroundColor = BG_COLOR_WHITE;
    [self.btnOpen setBackgroundColor:TEXT_COLOR_GLOD2 forState:UIControlStateNormal];
    [self.btnOpen setTitleColor:TEXT_COLOR_GLOD forState:UIControlStateNormal];
    self.btnOpen.layer.masksToBounds = YES;
    self.btnOpen.layer.cornerRadius = REDIUS;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
