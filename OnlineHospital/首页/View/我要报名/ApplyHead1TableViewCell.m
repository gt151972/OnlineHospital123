//
//  ApplyHead1TableViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/21.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "ApplyHead1TableViewCell.h"

@implementation ApplyHead1TableViewCell
-(void)layoutSubviews{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([_labDetail.text isEqualToString:@" 报名已结束 "]) {
        _labDetail.textColor = BG_COLOR_WHITE;
        _labDetail.backgroundColor = TEXT_COLOR_DETAIL;
        _labDetail.layer.masksToBounds = YES;
        _labDetail.layer.cornerRadius = 7;
        _labTimeTitle.hidden = YES;
        _labTime.hidden = YES;
    }else if ([_labDetail.text isEqualToString:@" 直播进行中 "]){
        _labDetail.textColor = BG_COLOR_WHITE;
        _labDetail.backgroundColor = GREEN_COLOR_MAIN;
        _labDetail.layer.masksToBounds = YES;
        _labDetail.layer.cornerRadius = 7;
        _labTimeTitle.hidden = YES;
        _labTime.hidden = YES;
    }
    
    if ([_labTimeTitle.text isEqualToString:@"报名开始时间"]) {
//        _labTimeTitle.layer.masksToBounds = YES;
//        _labTimeTitle.layer.cornerRadius = 7;
//        _labTimeTitle.layer.borderColor = BLUE_COLOR_MAIN.CGColor;
//        _labTimeTitle.layer.borderWidth = 1;
        _labTimeTitle.backgroundColor = BLUE_COLOR_MAIN;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_labTimeTitle.frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(7,7)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _labTimeTitle.bounds;
        maskLayer.path = maskPath.CGPath;
        _labTimeTitle.layer.mask = maskLayer;
        
//        UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_labTime.frame byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(7,7)];
//        CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
//        maskLayer2.frame = _labTime.bounds;
//        maskLayer2.path = maskPath2.CGPath;
//        maskLayer2.borderColor = BLUE_COLOR_MAIN.CGColor;
//        maskLayer2.borderWidth = 1;
//        _labTime.layer.mask = maskLayer2;
        _labTime.layer.masksToBounds = YES;
        _labTime.layer.cornerRadius = 7;
        _labTime.layer.borderColor = BLUE_COLOR_MAIN.CGColor;
        _labTime.layer.borderWidth = 1;
        _labDetail.hidden = YES;
    }else if ([_labTimeTitle.text isEqualToString:@"距报名结束"]) {
    //        _labTimeTitle.layer.masksToBounds = YES;
    //        _labTimeTitle.layer.cornerRadius = 7;
    //        _labTimeTitle.layer.borderColor = BLUE_COLOR_MAIN.CGColor;
    //        _labTimeTitle.layer.borderWidth = 1;
            _labTimeTitle.backgroundColor = GREEN_COLOR_MAIN;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_labTimeTitle.frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(7,7)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = _labTimeTitle.bounds;
            maskLayer.path = maskPath.CGPath;
            
            _labTimeTitle.layer.mask = maskLayer;

            UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_labTime.frame byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(7,7)];
            CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
            maskLayer2.frame = _labTime.bounds;
            maskLayer2.path = maskPath2.CGPath;
        maskLayer2.borderColor = GREEN_COLOR_MAIN.CGColor;
        maskLayer2.borderWidth = 1;
            _labTime.layer.mask = maskLayer2;
            _labDetail.hidden = YES;
        }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
