//
//  AttentionModel.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/11/30.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AttentionModel : NSObject
@property (nonatomic, copy)NSString *department;//科室
@property (nonatomic, copy)NSString *departmentId;//科室
@property (nonatomic, copy)NSString *departmentName;//科室名
@property (nonatomic, copy)NSString *descriptions;//说明
@property (nonatomic, copy)NSString *doctorFocus;//是否关注
@property (nonatomic, copy)NSString *expertEnable;//是否开启专家视频
@property (nonatomic, copy)NSString *famousEnable;//是否开启名医讲座
@property (nonatomic, copy)NSString * famousSort;//名医推荐排名
@property (nonatomic, copy)NSString * homePage;//是否置于首页
@property (nonatomic, copy)NSString *icon;//头像
@property (nonatomic, copy)NSString *doctorId;//医生id
@property (nonatomic, copy)NSString *mobile;//电话
@property (nonatomic, copy)NSString *name;//医生姓名
@property (nonatomic, copy)NSString *nickName;//昵称
@property (nonatomic, copy)NSString *skillful;//擅长
@property (nonatomic, copy)NSString *title;//职称
@property (nonatomic, copy)NSString *token;//登录标识token
@end

NS_ASSUME_NONNULL_END
