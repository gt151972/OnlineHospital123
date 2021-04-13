//
//  OrderModel.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/12/30.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderModel : NSObject
@property (nonatomic, copy)NSString *createdDate;//创建时间
@property (nonatomic, copy)NSString *customNO;//订单编号
@property (nonatomic, copy)NSString *orderId;//订单id
@property (nonatomic, copy)NSString *normalAmount;//订单金额
@property (nonatomic, copy)NSString *paidDate;//订单支付时间,unix时间戳
@property (nonatomic, copy)NSString *payAmount;//支付金额
@property (nonatomic, copy)NSString *payOrderId;//第三方订单号/交易号
@property (nonatomic, copy)NSString *payType;//支付方式,可用值:ALIPAY,WECHAT,APPLEAPY,VOUCHER,FLOWER
@property (nonatomic, copy)NSString *productId;//商品id
@property (nonatomic, copy)NSString *productName;//商品名称
@property (nonatomic, copy)NSString *productQuantity;//商品数量
@property (nonatomic, copy)NSString *questionContent;//互动问题
@property (nonatomic, copy)NSString *status;//订单状态 '0: 待支付\r\n            1: 已支持\r\n            2: 已消费\r\n            3: 退款中\r\n            4: 已超时\r\n            5: 已退款\r\n            6: 已取消',
@property (nonatomic, copy)NSString *timeOut;//订单超时时间,unix时间戳,状态为待支付时有效
@property (nonatomic, copy)NSString *typeCode;//订单类型编码,用来区分具体业务, FamousInteract:名医视频--互动,FamousAudit:名医视频--旁听,Lecture:专家讲座--旁听,VIP:vip礼包。Recharge:充值
@property (nonatomic, copy)NSString *typeName;//订单类型名称
@property (nonatomic, copy)NSString *userId;//用户id


@end

NS_ASSUME_NONNULL_END
