//
//  SaveData.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/10/19.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "SaveData.h"
static NSString *dataLogin = @"Login.plist";
static NSString *dataToken = @"token";
static NSString *dataUserInfo = @"UserInfo.plist";

@implementation SaveData
//存储token值
+(void)saveToken:(NSString *)token{
    NSUserDefaults *myPwdData = [NSUserDefaults standardUserDefaults];
    [myPwdData setObject:token forKey:dataToken];
    [myPwdData synchronize];  //即时保存
}
//读取token
+(NSString *)readToken{
    NSUserDefaults *myPwdData = [NSUserDefaults standardUserDefaults];
    return [myPwdData objectForKey:dataToken];
}

//移除token
+(void)removeToken{
    NSLog(@"移除token");
    NSUserDefaults *myPwdData = [NSUserDefaults standardUserDefaults];
    [myPwdData removeObjectForKey:dataToken];
    [myPwdData synchronize];  //即时保存
}

//存储个人信息
+(void)SaveUserInfoWithDic:(NSMutableDictionary *)dic{
    [self SaveBaseWithDic:dic path:dataUserInfo];
}
//读取用户个人信息
+ (NSMutableDictionary *)readUserInfo {
    return [self readBaseWithPath:dataUserInfo];
}
//存储用户的的登录信息
+(void)SaveLoginWithDic:(NSMutableDictionary *)dic{
    [self SaveBaseWithDic:dic path:dataLogin];
}
//读取用户登录后的信息
+ (NSMutableDictionary *)readLogin{
    return [self readBaseWithPath:dataLogin];
}

#pragma mark ------base
+ (NSMutableDictionary *)readBaseWithPath : (NSString *)strPath{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    
    NSLog(@"---%@", path);
    //获取一个plist文件
    NSString *filename=[path stringByAppendingPathComponent:strPath];
    //读文件
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:filename];//[NSMutableArray arrayWithContentsOfFile:filename];
    return dic;
}
+(void)SaveBaseWithDic:(NSMutableDictionary *)dic path: (NSString *)strPath{
    //1. 创建一个plist文件
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSLog(@"path = %@",path);
    NSString *filename=[path stringByAppendingPathComponent:strPath];
    //创建
    NSFileManager* fm = [NSFileManager defaultManager];
    [fm createFileAtPath:filename contents:nil attributes:nil];
    [dic writeToFile:filename atomically:YES];
}
@end
