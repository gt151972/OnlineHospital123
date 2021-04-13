//
//  OrderPayViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/22.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "videoOrderModel.h"
#import "EnrollModel.h"
#import "FamousModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HomeVideoDelegate
- (void)returnName:(NSString *)name;
@end

@interface OrderPayViewController : UIViewController
@property (strong, nonatomic)videoOrderModel *model;
@property (strong, nonatomic)EnrollModel *enrollModel;
@property (strong, nonatomic)FamousModel *famousModel;
@property (strong, nonatomic)NSString *strID;
/// 1:视频订单  2:报名 3:列表页进入
@property (nonatomic, assign)int type;

@property (nonatomic, retain) id <HomeVideoDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
