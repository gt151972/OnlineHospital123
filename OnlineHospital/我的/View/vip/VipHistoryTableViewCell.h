//
//  VipHistoryTableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/25.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VipHistoryTableViewCell : UITableViewCell

/// 生效时间
@property (weak, nonatomic) IBOutlet UILabel *labStartDate;

/// 到期时间
@property (weak, nonatomic) IBOutlet UILabel *labExpireDate;

/// 支付方式
@property (weak, nonatomic) IBOutlet UILabel *labPayType;

/// 支付时间
@property (weak, nonatomic) IBOutlet UILabel *labPaidDate;

/// 订单编号
@property (weak, nonatomic) IBOutlet UILabel *labVid;
@end

NS_ASSUME_NONNULL_END
