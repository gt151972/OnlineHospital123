//
//  VIPHistoryModel.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/11/25.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VIPHistoryModel : NSObject
@property (nonatomic, copy)NSString *amount;//充值金额
@property (nonatomic, copy)NSString *createdDate;//创建时间
@property (nonatomic, copy)NSString *expireDate;//到期时间
@property (nonatomic, copy)NSString * vid;//当前页数据
@property (nonatomic, copy)NSString *memberLevel;//会员等级
@property (nonatomic, copy)NSString *mobile;//手机号
@property (nonatomic, copy)NSString *name;//商品名称
@property (nonatomic, copy)NSString *nickName;//昵称
@property (nonatomic, copy)NSString *operateBy;//操作者 \r\n SYSTEM \r\n 或者管理员id\r\n
@property (nonatomic, copy)NSString *paidAmount;//实际支付金额
@property (nonatomic, copy)NSString *paidDate;//支付时间
@property (nonatomic, copy)NSString * payType;//支付类型
@property (nonatomic, copy)NSString *rechargeContent;//充值内容
@property (nonatomic, copy)NSString *startDate;//开始时间
@property (nonatomic, copy)NSString *status;//0: 待支付,1: 已支付,2: 已消费,3: 申请退款,4: 已超时,5: 已退款,6: 已取消
@property (nonatomic, copy)NSString * userId;//用户id
@property (nonatomic, copy)NSString * customId;
@end

NS_ASSUME_NONNULL_END
