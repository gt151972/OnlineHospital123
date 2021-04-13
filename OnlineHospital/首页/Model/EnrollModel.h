//
//  EnrollModel.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/12/3.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EnrollModel : NSObject
@property (nonatomic, copy)NSString *createdDate;//创建时间
@property (nonatomic, copy)NSString *doctorDepartment;//医生科室
@property (nonatomic, copy)NSString *doctorId;//医生id
@property (nonatomic, copy)NSString *doctorName;//医生姓名
@property (nonatomic, copy)NSString *enrollType;//参与类型，1:互动,2:旁听
@property (nonatomic, copy)NSString *interactQuestion;//互动问题
@property (nonatomic, copy)NSString *liveId;//直播id
@property (nonatomic, copy)NSString *liveTitle;//直播标题
@property (nonatomic, copy)NSString *liveType;//直播类型 1:名医视频  2:专家讲座
@property (nonatomic, copy)NSString *orderId;//订单id
@property (nonatomic, copy)NSString *payAmount;//支付金额
@property (nonatomic, copy)NSString *payType;//支付方式,可用值:ALIPAY,WECHAT,APPLEAPY,VOUCHER,FLOWER
@property (nonatomic, copy)NSString *price;//订单金额
@property (nonatomic, copy)NSString *refundDetail;//退款详情
@property (nonatomic, copy)NSString *refundReason;//退款原因
@property (nonatomic, copy)NSString *status;//支付状态 订单状态0：待支付，1：已支付，2：已消费，3：申请退款，4：已超时，5：已退款
@property (nonatomic, copy)NSString *icon;//医生头像
@property (nonatomic, copy)NSString *liveStatus;//视频状态:1:未开始,2:报名中,3:直播中,4:已结束,5:已取消
@property (nonatomic, copy)NSString *startDate;//直播开始时间
@property (nonatomic, copy)NSString *doctorTitle;//直播开始时间

@end

NS_ASSUME_NONNULL_END
