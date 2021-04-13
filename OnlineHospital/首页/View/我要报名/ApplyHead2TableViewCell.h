//
//  ApplyHead2TableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/21.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ApplyHead2TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labDetail;
@property (weak, nonatomic) IBOutlet UILabel *labNum;
@property (weak, nonatomic) IBOutlet UILabel *labTimeTitle;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (strong, nonatomic)ParameterModel *model;
@end

NS_ASSUME_NONNULL_END
