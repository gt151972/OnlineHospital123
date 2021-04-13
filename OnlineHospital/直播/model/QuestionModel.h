//
//  QuestionModel.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/12/21.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuestionModel : NSObject
@property (nonatomic, copy)NSString *content;//咨询内容
@property (nonatomic, copy)NSString *endTime;//结束时间
@property (nonatomic, copy)NSString *lastHeartbeat;//用户最近心跳时间
@property (nonatomic, copy)NSString *name;//用户名
@property (nonatomic, copy)NSString *online;//是否在线
@property (nonatomic, copy)NSString *startTime;//开始时间
@property (nonatomic, copy)NSString *status;//问题状态 0:等待中,1:咨询中,2:已结束,可用值:0,1,2
@property (nonatomic, copy)NSString *title;//标题
@property (nonatomic, copy)NSString *userHeadSculpture;//用户头像
@property (nonatomic, copy)NSString *userId;//
@property (nonatomic, copy)NSString *isVip;//
@end

NS_ASSUME_NONNULL_END
