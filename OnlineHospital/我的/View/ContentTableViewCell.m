//
//  ContentTableViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/11/26.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "ContentTableViewCell.h"

@implementation ContentTableViewCell
- (void)layoutSubviews{
    if (_payState == PayStateToBePaid) {
        [self.btnGo setTitle:@" 去支付" forState:UIControlStateNormal];
        [self.btnGo setBackgroundColor:BLUE_COLOR_MAIN forState:UIControlStateNormal];
        [self.btnGo setTitleColor:BG_COLOR_WHITE forState:UIControlStateNormal];
        self.btnGo.layer.borderColor = BLUE_COLOR_MAIN.CGColor;
        self.btnGo.layer.borderWidth = 1.0;
    }
    else if (_payState == PayStatePaid || _payState == PayStateConsumed){
        [self.btnGo setTitle:@"退款" forState:UIControlStateNormal];
        [self.btnGo setBackgroundColor:BG_COLOR_WHITE forState:UIControlStateNormal];
        [self.btnGo setTitleColor:TEXT_COLOR_MAIN forState:UIControlStateNormal];
        self.btnGo.layer.borderColor = TEXT_COLOR_MAIN.CGColor;
        self.btnGo.layer.borderWidth = 1.0;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
