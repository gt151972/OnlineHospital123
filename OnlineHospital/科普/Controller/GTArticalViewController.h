//
//  GTArticalViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/12/8.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeArticalModel.h"

NS_ASSUME_NONNULL_BEGIN
//typedef enum : NSUInteger {
//    MessageStatePlay,//开播提醒
//    MessageStateRefund,//退款提醒
//    MessageStateApply,//报名成功提醒
//    MessageStatePay,//支付成功提醒
//} MessageState;
@interface GTArticalViewController : UIViewController
@property (nonatomic, strong) NSString *strPath;
@property (nonatomic,assign) BOOL isShowCollect;
@property (nonatomic, strong)HomeArticalModel *model;
@end

NS_ASSUME_NONNULL_END
