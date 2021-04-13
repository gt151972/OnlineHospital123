//
//  PrivilegeTableViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/17.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "PrivilegeTableViewCell.h"

@implementation PrivilegeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    NSLog(@" 1 == %f",self.frame.size.width);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
