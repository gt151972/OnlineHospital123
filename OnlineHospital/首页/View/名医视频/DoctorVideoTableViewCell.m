//
//  DoctorVideoTableViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/18.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "DoctorVideoTableViewCell.h"

@implementation DoctorVideoTableViewCell
- (void)layoutSubviews{
    
    if (_LivingState == LivingStateLiving) {
        self.labState.text = @"正在直播中...";
        self.labState.textColor = GREEN_COLOR_MAIN;
        [self.btnGo setHidden:NO];
        [self.btnGo setTitle:@"进入" forState:UIControlStateNormal];
        [self.btnGo setBackgroundColor:GREEN_COLOR_MAIN forState:UIControlStateNormal];
        [self.btnGo setTitleColor:BG_COLOR_WHITE forState:UIControlStateNormal];
        self.btnGo.layer.borderColor = GREEN_COLOR_MAIN.CGColor;
        self.btnGo.layer.borderWidth = 1.0;
    }else if (_LivingState == LivingStateApplying){
        self.labState.text = @"报名中";
        self.labState.textColor = TEXT_COLOR_MAIN;
        [self.btnGo setHidden:NO];
        [self.btnGo setTitle:@"报名" forState:UIControlStateNormal];
        [self.btnGo setBackgroundColor:BLUE_COLOR_MAIN forState:UIControlStateNormal];
        [self.btnGo setTitleColor:BG_COLOR_WHITE forState:UIControlStateNormal];
        self.btnGo.layer.borderColor = BLUE_COLOR_MAIN.CGColor;
        self.btnGo.layer.borderWidth = 1.0;
    }else if (_LivingState ==LivingStateWillStart){
        self.labState.textColor = TEXT_COLOR_MAIN;
        self.btnGo.hidden = YES;
    }else if (_LivingState == LivingStateEnd){
        self.labState.text = @"直播已结束";
        self.labState.textColor = TEXT_COLOR_MAIN;
        [self.btnGo setHidden:NO];
        [self.btnGo setTitle:@"回看" forState:UIControlStateNormal];
        [self.btnGo setBackgroundColor:BG_COLOR_WHITE forState:UIControlStateNormal];
        [self.btnGo setTitleColor:TEXT_COLOR_MAIN forState:UIControlStateNormal];
        self.btnGo.layer.borderColor = TEXT_COLOR_MAIN.CGColor;
        self.btnGo.layer.borderWidth = 1.0;
    }else{
        NSLog(@"啥也不是%lu",(unsigned long)_LivingState);
    }
    
    [[_btnAttention rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^( UIButton * _Nullable x) {
        x.selected = !x.selected;
        [x setImage:[UIImage imageNamed:@"video_nomal"] forState:UIControlStateNormal];
        [x setImage:[UIImage imageNamed:@"video_select"] forState:UIControlStateSelected];
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labTime.textColor = TEXT_COLOR_DETAIL;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (IBAction)btnGoClicked:(UIButton *)sender {
//
//}
//
//- (IBAction)btnCollectClicked:(UIButton *)sender {
////    sender.selected = !sender.selected;
////    [self.delegate collectDoctor:sender];
//}
@end
