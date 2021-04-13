//
//  HomeDoctorTableViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/19.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "HomeDoctorTableViewCell.h"

@implementation HomeDoctorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.btnAttention.layer.borderWidth = 1;
    self.btnAttention.layer.cornerRadius = 10;
    self.btnAttention.layer.masksToBounds = YES;
    [self.btnAttention setBackgroundColor:BG_COLOR_WHITE forState:UIControlStateNormal];
    [self.btnAttention setBackgroundColor:BLUE_COLOR_MAIN forState:UIControlStateSelected];
    [self.btnAttention setTitle:@"关注" forState:UIControlStateNormal];
    [self.btnAttention setTitle:@"已关注" forState:UIControlStateSelected];
  
    self.imageHead.backgroundColor = BG_COLOR;
    [self.btnServe setBackgroundColor:BLUE_COLOR_MAIN forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnAttentionClicked:(UIButton *)sender {
}
@end
