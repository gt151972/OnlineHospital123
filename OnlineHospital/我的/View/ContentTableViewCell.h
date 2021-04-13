//
//  ContentTableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/11/26.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    PayStateToBePaid = 0,//待支付
    PayStatePaid = 1,//已支付
    PayStateConsumed = 2,//已消费
    PayStateRequestRefund = 3,//申请退款
    PayStateTimedOut = 4,//已超时
    PayStateRefunded = 5,//已退款
} PayState;
@interface ContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnGo;
@property(nonatomic, assign)PayState payState;
@end

NS_ASSUME_NONNULL_END
