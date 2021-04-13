//
//  VipTypeModel.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/11/3.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VipTypeModel : NSObject
@property (nonatomic, copy)NSString *descriptions;//描述
@property (nonatomic, copy)NSString *famousTimes;//名医视频观看次数
@property (nonatomic, copy)NSString *vid;//会员商品id
@property (nonatomic, copy)NSString *lectureTimes;//专家讲座观看次数
@property (nonatomic, copy)NSString *memberDays;//会员天数
@property (nonatomic, copy)NSString *memberLevel;//会员等级
@property (nonatomic, copy)NSString *name;//商品名称
@property (nonatomic, copy)NSString *price;//会员价格
@end

NS_ASSUME_NONNULL_END
