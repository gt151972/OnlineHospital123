//
//  InteractionViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/22.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnrollModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface InteractionViewController : UIViewController
@property (nonatomic, strong)NSString *strLiveID;//直播id
@property (nonatomic, assign)int type;//报名类型 1:旁听,2:互动
@property (nonatomic, strong)EnrollModel *model;
@end

NS_ASSUME_NONNULL_END
