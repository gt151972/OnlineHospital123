//
//  ParameterModel.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/11/6.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 获取直播详情(名医视频,专家讲座通用)
@interface ParameterModel : NSObject
@property (nonatomic, copy)NSString *authorityType;//权限类型 0: 不限制, 1:仅会员可报名互动
@property (nonatomic, copy)NSString *descriptions;//简介
@property (nonatomic, copy)NSString *doctorDepartment;//医生科室
@property (nonatomic, copy)NSString *doctorDescription;//医生简介
@property (nonatomic, copy)NSString *doctorFocus;//医生是否已关注
@property (nonatomic, copy)NSString *doctorIcon;//医生头像,如果不是url,则为文件上传服务id
@property (nonatomic, copy)NSString *doctorId;//医生id
@property (nonatomic, copy)NSString *doctorName;//医生姓名
@property (nonatomic, copy)NSString *doctorTitle;//医生职称
@property (nonatomic, copy)NSString *endDate;//直播结束时间
@property (nonatomic, copy)NSString *endEnrollInteractDate;//互动报名结束时间
@property (nonatomic, copy)NSString *enrollDate;//报名开始时间
@property (nonatomic, copy)NSString *enrollNum;//报名人数
@property (nonatomic, copy)NSString *enrolled;//是否已报名
@property (nonatomic, copy)NSString *favorite;//是否已收藏
@property (nonatomic, copy)NSString *pid;//id
@property (nonatomic, copy)NSString *interactLockedUser;//互动锁定用户数量-未支付
@property (nonatomic, copy)NSString *interactPrice;//互动价格
@property (nonatomic, copy)NSString *interactUser;//互动用户数量-已支付
@property (nonatomic, copy)NSString *liveStatus;//视频状态:1:未开始,2:报名中,3:直播中,4:已结束,5:已取消(前端接口不可使用)
@property (nonatomic, copy)NSString *liveType;//直播类型: 1:名医视频,2:专家讲座
@property (nonatomic, copy)NSString *maxInteract;//最大互动数
@property (nonatomic, copy)NSString *maxQuestion;//最大提问
@property (nonatomic, copy)NSString *normalPrice;//普通价格,旁听
@property (nonatomic, copy)NSString *orderId;//订单主键id
@property (nonatomic, copy)NSString *startDate;//开播时间
@property (nonatomic, copy)NSString *title;//标题
@property (nonatomic, copy)NSString *videoUrl;//视频地址
@end

NS_ASSUME_NONNULL_END
