//
//  liveTableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/24.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface liveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UIImageView *imageHead;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labContent;
@property (weak, nonatomic) IBOutlet UILabel *labStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imageVip;
@property (nonatomic,strong) QuestionModel *model;
@end

NS_ASSUME_NONNULL_END
