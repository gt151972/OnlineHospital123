//
//  RtcModel.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/12/23.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RtcModel : NSObject
@property (nonatomic, copy)NSString *appId;//应用ID
@property (nonatomic, copy)NSString *conferenceId;//频道号
@property (nonatomic, copy)NSArray *gslb;//服务器地址
@property (nonatomic, copy)NSString *nonce;//令牌随机码
@property (nonatomic, copy)NSString *timestamp;//时间戳
@property (nonatomic, copy)NSString *token;//令牌
@property (nonatomic, copy)NSString *userId;//用户ID

@end

NS_ASSUME_NONNULL_END
