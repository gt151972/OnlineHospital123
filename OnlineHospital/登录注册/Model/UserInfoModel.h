//
//  UserInfoModel.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/10/19.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : NSObject
@property (nonatomic, copy)NSString *uid;//用户id
@property (nonatomic, copy)NSString *mobile;//手机号
@property (nonatomic, copy)NSString *nickName;//昵称
@property (nonatomic, copy)NSString *realName;//真实姓名
@property (nonatomic, copy)NSString *token;//令牌,后续通讯需要将其加入到http headers 里面 key为 duo-token
@property (nonatomic, copy)NSString *username;//用户名
@property (nonatomic, copy)NSString *headSculpture;//头像
@property (nonatomic, copy)NSString *idCard; //身份证
@property (nonatomic, copy)NSString *expireDate;//到期时间
@property (nonatomic, copy)NSString *famousTimes;//名医视频观看次数
@property (nonatomic, copy)NSString *lectureTimes;//专家讲座观看次数
@property (nonatomic, copy)NSString *level;//会员级别
@property (nonatomic, copy)NSString *startDate;//起始时间

@end

NS_ASSUME_NONNULL_END
