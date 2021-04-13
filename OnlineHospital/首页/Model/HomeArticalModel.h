//
//  HomeArticalModel.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeArticalModel : NSObject
@property (nonatomic, copy)NSString *authorName;//作者
@property (nonatomic, copy)NSString *catalogueId;//目录id
@property (nonatomic, copy)NSString *catalogueName;//目录名
@property (nonatomic, copy)NSString *content;//目录名
@property (nonatomic, copy)NSString *cover;//封面 url
@property (nonatomic, copy)NSString *disable;//失效
@property (nonatomic, copy)NSString *favorite;//收藏
@property (nonatomic, copy)NSString *homePage;//是否置于首页
@property (nonatomic, copy)NSString *nid;//订单id
@property (nonatomic, copy)NSString *Visit;//虚拟阅读量
@property (nonatomic, copy)NSString *publishDate;//发表时间
@property (nonatomic, copy)NSString *realVisit;//实际阅读量
@property (nonatomic, copy)NSString *sort;//排序
@property (nonatomic, copy)NSString *summary;//内容摘要，纯文本,获取列表的时候替代 content
@property (nonatomic, copy)NSString *title;//标题
@property (nonatomic, copy)NSString *topping;//是否置顶
@property (nonatomic, copy)NSString *totalVisit;//总阅读量
@property (nonatomic, copy)NSString *userId;//用户id
@end

NS_ASSUME_NONNULL_END
