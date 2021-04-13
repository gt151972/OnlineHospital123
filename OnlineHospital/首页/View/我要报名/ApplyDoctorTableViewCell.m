//
//  ApplyDoctorTableViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/21.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "ApplyDoctorTableViewCell.h"

@implementation ApplyDoctorTableViewCell
- (void)layoutSubviews{
    [_btnAttention setTitleColor:BG_COLOR_WHITE forState:UIControlStateSelected];
    [_btnAttention setBackgroundColor:BLUE_COLOR_MAIN forState:UIControlStateSelected];
 [_btnAttention setTitle:@"已关注" forState:UIControlStateSelected];
 
    [_btnAttention setBackgroundColor:BG_COLOR_WHITE forState:UIControlStateNormal];
    [_btnAttention setTitleColor:TEXT_COLOR_MAIN forState:UIControlStateNormal];
//    [_btnAttention setTitle:@"关注" forState:UIControlStateNormal];
//    _btnAttention.layer.borderWidth = 1;
    _btnAttention.layer.borderColor = TEXT_COLOR_MAIN.CGColor;
    if (!_btnAttention.selected) {
        _btnAttention.layer.borderWidth = 0;
    }else{
        _btnAttention.layer.borderWidth = 1;
        _btnAttention.layer.borderColor = TEXT_COLOR_MAIN.CGColor;
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
