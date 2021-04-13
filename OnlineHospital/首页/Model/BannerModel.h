//
//  BannerModel.h
//  OnlineHospital
//  获取banner列表
//  Created by 高天的Mac on 2020/10/15.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannerModel : NSObject
@property (nonatomic, copy)NSString *content;//内容
@property (nonatomic, copy)NSString *jumpType;//跳转类型,1:富文本,2:链接,3:纯图片,4:科普文章
@property (nonatomic, copy)NSString *image;//图片
@property (nonatomic, copy)NSString *sort;//排序
@property (nonatomic, copy)NSString *title;//标题
@property (nonatomic, copy)NSString *type;//类型,1:首页轮播图,2:科普轮播图
@end

NS_ASSUME_NONNULL_END
