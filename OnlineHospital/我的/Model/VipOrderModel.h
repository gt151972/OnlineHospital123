//
//  VipOrderModel.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/1/12.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VipOrderModel : NSObject
@property (nonatomic, copy)NSString *normalAmount;//订单金额
@property (nonatomic, copy)NSString *payType;//支付类型 0:未知,1:花朵,2:优惠次数, 3:微信,4:支付宝,5:applepay
@property (nonatomic, copy)NSString *productId;//商品id
@property (nonatomic, copy)NSString *productQuantity;//商品数量
@property (nonatomic, copy)NSString *typeCode;//订单类型编码,用来区分具体业务, FamousInteract:名医视频--互动,FamousAudit:名医视频--旁听,Lecture:专家讲座--旁听,VIP:vip礼包。Recharge:充值
@property (nonatomic, copy)NSString *createdDate;//订单创建时间,unix时间戳
@property (nonatomic, copy)NSString *customNO;//订单编号
@property (nonatomic, copy)NSString *oid;//id
@property (nonatomic, copy)NSString *paidDate;//订单支付时间,unix时间戳
@property (nonatomic, copy)NSString *payAmount;//支付金额
@property (nonatomic, copy)NSString *payOrderId;//第三方订单号/交易号
@property (nonatomic, copy)NSString *productName;//商品名称
@property (nonatomic, copy)NSString *questionContent;//互动问题
@property (nonatomic, copy)NSString *status;//订单状态 0:待付款,1:已付款,2:已退款,3:退款中,4:已超时
@property (nonatomic, copy)NSString *timeOut;//订单超时时间,unix时间戳,状态为待支付时有效
@property (nonatomic, copy)NSString *typeName;//订单类型名称
@property (nonatomic, copy)NSString * userId;//用户id
@end

NS_ASSUME_NONNULL_END
