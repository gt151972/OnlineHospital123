//
//  BaseDataChange.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/11/6.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface BaseDataChange : NSObject

/// 时间戳转时间
/// @param str <#str description#>
+ (NSString *)getDateStringWithTimeStr:(NSString *)str;
///时间戳转时间带格式
+ (NSString *)getDateStringWithTimeStr:(NSString *)str formatter: (NSString *)formatter;
/// 将当前时间转换成时间戳
+ (NSString *)getTimestampFromTime;
///将时间戳转换成时间
- (NSString *)getTimeFromTimestamp;



///用NSDate日期倒计时
+(void)countDownWithStratDate:(NSDate *)startDate finishDate:(NSDate *)finishDate completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock;
///用时间戳倒计时
-(void)countDownWithStratTimeStamp:(long long)starTimeStamp finishTimeStamp:(long long)finishTimeStamp completeBlock:(void (^)(NSInteger day,NSInteger hour,NSInteger minute,NSInteger second))completeBlock;
///每秒走一次，回调block
-(void)countDownWithPER_SECBlock:(void (^)())PER_SECBlock;
-(void)destoryTimer;
-(NSDate *)dateWithLongLong:(long long)longlongValue;
@end

NS_ASSUME_NONNULL_END
