//
//  videoOrderModel.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/11/26.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface videoOrderModel : NSObject
@property (nonatomic, copy)NSString *buyLevel;//购买等级购买等级 1. 旁听 2. 互动
@property (nonatomic, copy)NSString *content;//互动问题
@property (nonatomic, copy)NSString *createdDate;//创建时间
@property (nonatomic, copy)NSString *department;//科室
@property (nonatomic, copy)NSString *descriptions;//直播描述
@property (nonatomic, copy)NSString *doctorName;//医生姓名
@property (nonatomic, copy)NSString *doctorId;//医生ID
@property (nonatomic, copy)NSString *doctorFocus;//是否关注
@property (nonatomic, copy)NSString *doctorDescription;//医生简介，说明
@property (nonatomic, copy)NSString *icon;//医生头像
@property (nonatomic, copy)NSString *customId;//订单id
@property (nonatomic, copy)NSString *orderId;//订单id
@property (nonatomic, copy)NSString * liveId;//直播ID
@property (nonatomic, copy)NSString *liveStatus;//视频状态:1:未开始,2:报名中,3:直播中,4:已结束,5:已取消
@property (nonatomic, copy)NSString *liveTitle;//直播标题
@property (nonatomic, copy)NSString *liveType;//直播类型 1:名医视频  2:专家讲座
@property (nonatomic, copy)NSString *normalAmount;//应付金额
@property (nonatomic, copy)NSString *paidAmount;//实际支付金额
@property (nonatomic, copy)NSString *paidDate;//支付时间
@property (nonatomic, copy)NSString *payOrderId;//交易号
@property (nonatomic, copy)NSString *payStatus;//支付状态 订单状态0：待支付，1：已支付，2：已消费，3：申请退款，4：已超时，5：已退款
@property (nonatomic, copy)NSString *startDate;//直播开始时间
@property (nonatomic, copy)NSString *title;//职称
@property (nonatomic, copy)NSString *typeCode;//观看类型
@property (nonatomic, copy)NSString *refundTimeOut;//退款超时时间

@end

NS_ASSUME_NONNULL_END
