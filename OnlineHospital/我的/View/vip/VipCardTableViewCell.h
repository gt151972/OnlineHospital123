//
//  VipCardTableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/17.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipOrderModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    VipCardStateOFF,
    VipCardStateOn,
} VipCardState;
@interface VipCardTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString *strDate;

@property (weak, nonatomic, readonly) IBOutlet UILabel *labTitle;
@property (weak, nonatomic, readonly) IBOutlet UILabel *labdetail;
@property (weak, nonatomic, readonly) IBOutlet UIImageView *imageTime;
@property (weak, nonatomic, readonly) IBOutlet UILabel *labDate;
@property (weak, nonatomic, readonly) IBOutlet UILabel *labGo;
@property (weak, nonatomic, readonly) IBOutlet UILabel *labTime;

@property(nonatomic, assign)VipCardState state;
@end

NS_ASSUME_NONNULL_END
