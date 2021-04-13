//
//  PayResultViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/22.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PayResultViewController : UIViewController
@property (strong, nonatomic)OrderModel *model;
@property (nonatomic,assign) int type; //type:0 成功; type:1 失败
@end

NS_ASSUME_NONNULL_END
