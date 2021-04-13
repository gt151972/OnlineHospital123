//
//  wechatPayModel.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/12/30.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface wechatPayModel : NSObject
@property (nonatomic, copy)NSString *appid;
@property (nonatomic, copy)NSString *noncestr;
@property (nonatomic, copy)NSString *packageValue;
@property (nonatomic, copy)NSString *partnerid;
@property (nonatomic, copy)NSString *prepayid;
@property (nonatomic, copy)NSString *sign;
@property (nonatomic, copy)NSString *timestamp;
@end

NS_ASSUME_NONNULL_END
