//
//  MessageTableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/19.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    MessageStatePlay,//开播提醒
    MessageStateRefund,//退款提醒
    MessageStateApply,//报名成功提醒
    MessageStatePay,//支付成功提醒
} MessageState;
// 1. 关注的医生开直播给予消息推送2. 订单提交未支付给予消息提示3. 订单支付成功给与提示4. 后台管理员确认问题后给予用户提示\n // 5.用户被管理员剔除报名后退款给予提示6. 开播前1小时给予提示7. 开播前5分钟给予提示 8. 退费成功后给予提示\n // 9. 会员付费成功 10.互动开始，收到后请调用获取会议参数进入互动11.互动接入失败提醒',

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labContent;
@property (weak, nonatomic) IBOutlet UIButton *btnState;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UIView *readView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, assign)MessageState MessageState;
@property (nonatomic, strong)MessageModel *model;
@end

NS_ASSUME_NONNULL_END
