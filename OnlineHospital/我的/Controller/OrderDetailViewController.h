//
//  OrderDetailViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/22.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "videoOrderModel.h"
#import "OrderModel.h"
#import "FamousModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailViewController : UIViewController
@property (strong, nonatomic)videoOrderModel *model;
@property (strong, nonatomic)OrderModel *orderModel;
@property (strong, nonatomic)FamousModel *famousModel;
@property (strong, nonatomic)NSString *strReason;
@property (assign, nonatomic)BOOL isRefund;
@property (assign, nonatomic)BOOL isPay;
@property (assign, nonatomic)BOOL isRefunding;
@property (assign, nonatomic)BOOL isMessage;
@end

NS_ASSUME_NONNULL_END
