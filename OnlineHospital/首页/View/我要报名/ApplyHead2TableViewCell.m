//
//  ApplyHead2TableViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/21.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "ApplyHead2TableViewCell.h"

@implementation ApplyHead2TableViewCell
- (void)layoutSubviews{
    if ([_labDetail.text isEqualToString:@" 报名已结束 "]) {
            _labDetail.textColor = BG_COLOR_WHITE;
            _labDetail.backgroundColor = TEXT_COLOR_DETAIL;
            _labDetail.layer.masksToBounds = YES;
            _labDetail.layer.cornerRadius = 7;
            _labTimeTitle.hidden = YES;
            _labTime.hidden = YES;
        }else if ([_labDetail.text isEqualToString:@" 直播进行中 "] || [_labDetail.text isEqualToString:@"   报名中   "]){
            _labDetail.textColor = BG_COLOR_WHITE;
            _labDetail.backgroundColor = GREEN_COLOR_MAIN;
            _labDetail.layer.masksToBounds = YES;
            _labDetail.layer.cornerRadius = 7;
            _labTimeTitle.hidden = YES;
            _labTime.hidden = YES;
        }else if ([_labTimeTitle.text isEqualToString:@"报名开始时间"]) {
            _labTimeTitle.backgroundColor = GREEN_COLOR_MAIN;
            _labTimeTitle.textColor = BG_COLOR_WHITE;
            _labTimeTitle.textAlignment = NSTextAlignmentCenter;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_labTimeTitle.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(7,7)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = _labTimeTitle.bounds;
            maskLayer.path = maskPath.CGPath;
            _labTimeTitle.layer.mask = maskLayer;
            _labTime.textColor = GREEN_COLOR_MAIN;
            _labTime.layer.masksToBounds = YES;
            _labTime.layer.cornerRadius = 7;
            _labTime.layer.borderColor = GREEN_COLOR_MAIN.CGColor;
            _labTime.layer.borderWidth = 1;
            _labDetail.hidden = YES;
            
        }else if ([_labTimeTitle.text isEqualToString:@"报名时间"]) {
            _labTimeTitle.backgroundColor = BLUE_COLOR_MAIN;
            _labTimeTitle.textColor = BG_COLOR_WHITE;
            _labTimeTitle.textAlignment = NSTextAlignmentCenter;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_labTimeTitle.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(7,7)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = _labTimeTitle.bounds;
            maskLayer.path = maskPath.CGPath;
            _labTimeTitle.layer.mask = maskLayer;
            _labTime.textColor = BLUE_COLOR_MAIN;
            _labTime.layer.masksToBounds = YES;
            _labTime.layer.cornerRadius = 7;
            _labTime.layer.borderColor = BLUE_COLOR_MAIN.CGColor;
            _labTime.layer.borderWidth = 1;
            _labDetail.hidden = YES;
            
        }else if ([_labTimeTitle.text isEqualToString:@"距报名结束"]) {
                _labTimeTitle.backgroundColor = GREEN_COLOR_MAIN;
            _labTimeTitle.textColor = BG_COLOR_WHITE;
                       _labTimeTitle.textAlignment = NSTextAlignmentCenter;
                UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_labTimeTitle.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(7,7)];
                CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
                maskLayer.frame = _labTimeTitle.bounds;
                maskLayer.path = maskPath.CGPath;
                _labTimeTitle.layer.mask = maskLayer;
            
            _labTime.textColor = GREEN_COLOR_MAIN;
                         _labTime.layer.masksToBounds = YES;
                         _labTime.layer.cornerRadius = 7;
                         _labTime.layer.borderColor = GREEN_COLOR_MAIN.CGColor;
                         _labTime.layer.borderWidth = 1;
                         _labDetail.hidden = YES;

            }
}

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
