//
//  liveTableViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/24.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "liveTableViewCell.h"

@implementation liveTableViewCell
- (void)layoutSubviews{
    self.labContent.text = _model.content;
    NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE,rootURL2,_model.userHeadSculpture];
    [self.imageHead sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"mine_head"]];
    self.labName.text = _model.name;
    self.labDate.text = [NSString stringWithFormat:@"预计回复时间:%@-%@ ",[BaseDataChange getDateStringWithTimeStr:_model.startTime formatter:@"HH:mm"],[BaseDataChange getDateStringWithTimeStr:_model.endTime formatter:@"HH:mm"]];
    self.imageVip.hidden = ![_model.isVip intValue];
    switch ([_model.status intValue]) {
        case 0:{
            self.labStatus.text = @"等待中";
            self.labStatus.textColor = BG_COLOR_WHITE;
            self.labStatus.backgroundColor = BLUE_COLOR_MAIN;
            self.labStatus.layer.borderColor = BLUE_COLOR_MAIN.CGColor;
        }
            break;
        case 1:{
            self.labStatus.text = @"咨询中";
            self.labStatus.textColor = BG_COLOR_WHITE;
            self.labStatus.backgroundColor = GREEN_COLOR_MAIN;
            self.labStatus.layer.borderColor = GREEN_COLOR_MAIN.CGColor;
        }
            break;
        case 2:{
            self.labStatus.text = @"已结束";
            self.labStatus.textColor = TEXT_COLOR_MAIN;
            self.labStatus.backgroundColor = BG_COLOR_WHITE;
            self.labStatus.layer.borderColor = TEXT_COLOR_MAIN.CGColor;
        }
        default:
            break;
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
