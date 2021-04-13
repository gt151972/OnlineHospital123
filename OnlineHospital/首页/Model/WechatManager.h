//
//  WechatManager.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/1/6.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WXApi.h>
NS_ASSUME_NONNULL_BEGIN

@interface WechatManager : NSObject
+ (id)shareInstance;

+ (BOOL)handleOpenUrl:(NSURL *)url;

+ (void)hangleWechatPayWith:(PayReq *)req;
@end

NS_ASSUME_NONNULL_END
