//
//  StateAttentionTableViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/20.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "StateAttentionTableViewCell.h"

@implementation StateAttentionTableViewCell

- (void)layoutSubviews{
    NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE, rootURL2,self.model.icon];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"mine_head"]];
    self.labName.text = _model.name;
    self.labSecion.text = [NSString stringWithFormat:@"%@ | %@",_model.title,_model.department];
    self.labDetail.text = _model.skillful;
    self.btnAttention.selected = [_model.doctorFocus intValue];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _labDetail.textColor = TEXT_COLOR_DETAIL;
    [_btnAttention setBackgroundColor:BLUE_COLOR_MAIN forState:UIControlStateSelected];
    [_btnAttention setBackgroundColor:BG_COLOR_WHITE forState:UIControlStateNormal];
    [_btnAttention setTitle:@"已关注" forState:UIControlStateSelected];
    [_btnAttention setTitle:@"关注" forState:UIControlStateNormal];
    [_btnAttention setTitleColor:BG_COLOR_WHITE forState:UIControlStateSelected];
    [_btnAttention setTitleColor:BLUE_COLOR_MAIN forState:UIControlStateNormal];
    _btnAttention.layer.borderColor = BLUE_COLOR_MAIN.CGColor;
    _btnAttention.layer.borderWidth = 1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
