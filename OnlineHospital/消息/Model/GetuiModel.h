//
//  GetuiModel.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/3/30.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GetuiModel : NSObject
@property (nonatomic, copy)NSString *content;//消息内容
//@property (nonatomic, copy)NSString *mid;//消息id
@property (nonatomic, copy)NSString *isVisible;//1: 已读0: 未读
//@property (nonatomic, copy)NSString *page;//页面相关操作参数
@property (nonatomic, copy)NSString *params;//补充参数
@property (nonatomic, copy)NSString *title;//标题
@property (nonatomic, copy)NSString *type;//1: 系统消息2: 普通消息
@end

NS_ASSUME_NONNULL_END
