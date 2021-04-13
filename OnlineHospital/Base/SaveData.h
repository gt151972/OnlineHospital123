//
//  SaveData.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/10/19.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaveData : NSObject
//存储token值
+(void)saveToken:(NSString *)token;
//读取token
+(NSString *)readToken;
//移除token
+(void)removeToken;
//存储用户的的登录信息
+(void)SaveLoginWithDic:(NSMutableDictionary *)dic;
//读取用户登录后的信息
+ (NSMutableDictionary *)readLogin;
//存储个人信息
+(void)SaveUserInfoWithDic:(NSMutableDictionary *)dic;
//读取个人信息
+ (NSMutableDictionary *)readUserInfo;
@end

NS_ASSUME_NONNULL_END
