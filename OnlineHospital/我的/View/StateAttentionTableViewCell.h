//
//  StateAttentionTableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/20.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttentionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface StateAttentionTableViewCell : UITableViewCell
@property (strong, nonatomic)AttentionModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labSecion;
@property (weak, nonatomic) IBOutlet UILabel *labDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnAttention;

@end

NS_ASSUME_NONNULL_END
