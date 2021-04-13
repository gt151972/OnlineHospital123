//
//  MessageModel.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/10/27.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageModel : NSObject
@property (nonatomic, copy)NSString *content;//消息内容
@property (nonatomic, copy)NSString *mid;//消息id
@property (nonatomic, copy)NSString *isRead;//1: 已读0: 未读
@property (nonatomic, copy)NSString *page;//页面相关操作参数
@property (nonatomic, copy)NSString *params;//补充参数
@property (nonatomic, copy)NSString *title;//标题
@property (nonatomic, copy)NSString *type;//1: 系统消息2: 普通消息
@property (nonatomic, copy)NSString *createdDate;
@end

NS_ASSUME_NONNULL_END
