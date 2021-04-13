//
//  PrivilegeCollectionViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/17.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "PrivilegeCollectionViewCell.h"

@implementation PrivilegeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.backgroundColor = [UIColor colorWithRed:227/255.0 green:181/255.0 blue:147/255.0 alpha:0.05];
    self.bgView.layer.borderWidth = 3;
    self.bgView.layer.borderColor = [BG_COLOR CGColor];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    
    self.labPrice.textColor = [UIColor redColor];
}

@end
