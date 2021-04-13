//
//  Address.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/7.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#ifndef Address_h
#define Address_h

#

//开发环境
#define rootURL2 @"http://60.190.243.228:10060"
#define rootURL @"http://60.190.243.228:10072"
#define POPULAR_SCIENCE @"http://60.190.243.228:10075/"//科普

//测试环境
//#define rootURL2 @"http://test.api.demzhmzb.com:10060"
//#define rootURL @"http://test.api.demzhmzb.com:10072"
//#define POPULAR_SCIENCE @"http://test.article.demzhmzb.com"

//登录注册
#define POST_LOGIN @"%@/user/login" //用户登录接口
#define POST_SENDCODE @"%@/user/sendcode" //发送验证码接口
#define POST_SIGNUP @"%@/user/signup" //用户注册接口
#define PUT_PASSWORD @"%@/user/password" //修改密码接口
//一键登录
#define PNSATAUTHSDKINFOKEY @"ATAuthSDKInfoKey"
#define PNSATAUTHSDKINFO @"LAy70+IouxBmYbofCgQIXhiokafzl9zbY/okQJ+PFLnXV0894Ee37wP6j3W4AGGurz3sGTe5anDdrl8ShlHvKrYukfsX1hvgWyiOFZ86wltRHd+otFl3z3/3PqL2mWXyvdRPvYEMTJW6nblbHl/GY/Fvt4HgiX0wmi6QgSa5j7Qg3cl4hu54M3rLUN3zYuyl/Gxb0ETi6C2veFD0G8K1+1fxKSy+6zvXBMDoVG4i/Fz0QC83N2VXtm6WfoUXQJV6EKp8VLB/MNKBCuKBNmXl/w=="

//个人中心
#define PUT_UPDATE @"%@/user/update" //修改用户信息接口
#define POST_INFO @"%@/user/info"//用户信息接口
#define POST_MEMBER_INFO @"%@/member/info/get" //获取用户会员信息
#define POST_MEMBER_PRODUCT @"%@/member/product/get" //获取用户会员信息
#define GET_VIP_ORDER @"%@/user/vip/order"//用户VIP订单列表
#define POST_RECOMMEND_GET @"%@/live/famous/recommend/get" //获取推荐名医视频列表(支付成功后页面)
#define POST_FAVORITES @"%@/content/favorites/get"//获取收藏列表接口(文章)
#define POST_FAVORITES_LIST @"%@/live/favorite/list"//收藏列表接口(视频,讲座)
#define POST_LIVE_ORDER @"%@/user/live/order"//用户视频订单列表
#define POST_REFUND @"%@/order/refund"//申请退款
#define POST_FOCUS @"%@/doctor/doctors/focus"//关注的医生列表接口
//科普
#define PUT_DELETE_FAVORITE @"%@/content/favorite"//添加收藏接口 取消收藏接口

//上传下载
#define POST_OSS_UPDATE @"%@/oss/upload"//上传文件头像
#define POST_OSS_DOWNDATE @"%@/oss/down/%@"//下载图像
//主页
#define POST_BANNERS @"%@/banner/banners/get"//banner
#define POST_DOCTORS @"%@/doctor/doctors/get"//搜索医生接口
#define POST_RECOMMEND @"%@/doctor/famous/recommend"//名医推荐列表接口
#define POST_ARTICAL @"%@/content/home/get" //获取首页文章接口
#define POST_FAMOUS @"%@/live/famous/get"//获取名医视频列表
#define POST_LECTURES @"%@/live/lectures/get"//获取专家讲座列表
#define POST_DEPARTMENTS @"%@/doctor/doctor/departments/get"//获取医生科室列表
#define POST_TITLE @"%@//doctor/doctor/titles/get" //获取医生职称列表
#define POST_DOCTOR @"%@/doctor/doctor/get" //获取医生信息
#define POST_PARAMETER @"%@/live/live/get"//获取直播详情(名医视频,专家讲座通用)
#define POST_QUESTION @"%@/live/live/questions" //获取咨询列表
#define PUT_DELETE_FOCUS @"%@/doctor/doctor/focus"//关注取消医生接口
#define POST_ENROLL @"%@/live/live/enroll"//报名直播
#define PATH_EXPLAIN @"http://agreement.demzhmzb.com/Explain.html" //说明网页
//消息
#define POST_MESSAGE_LIST @"%@/user/message/list"//消息列表
#define POST_MESSAGE_DELETE @"%@/user/message/delete"//删除消息/批量删除
#define POST_MESSAGE_READ @"%@/user/message/read"//删除消息/批量删除
#define POST_UPDATE_CID @"%@/user/message/updatecid"//更新用户cid
#define POST_READ_ALL @"%@/user/message/allread"//全部已读
//音视频
#define POST_LIVE_MAKE @"%@/livetest/live/make"//生成视频文件
#define POST_MEETINGPARAMS @"%@/live/live/meetingparams"//获取会议参数
#define POST_LIVE_PULLADDRESS @"%@/live/live/pulladdress"//获取直播地址
#define PUT_DELETE_LIVE_COLLECT @"%@/live/favorite"//添加收藏接口
//支付
#define POST_ORDER_SUBMIT @"%@/order/order/submit"//提交订单(vip)
#define POST_PAY @"%@/pay/pay"//统一支付接口
#define POST_ORDER_GET @"%@/order/order/get"//获取订单详情
#define POST_CANCEL @"%@/order/order/cancel"//取消订单
#define POST_CONSUMPTION @"%@/order/consumption"//消费订单-当用户跳转视频，或直播时调用次接口修改订单状态为已消费

//宁波方url
//#define NB_FLOWERUP @"https://pre-release.jyhk.com/duoermei-h5/#/pages/Referral/Home/Index"//在线复诊入口
#define NB_FLOWERUP @"https://test.yeshaojun.com"//在线复诊入口

#define NB_REGISTRATION @"https://pre-release.jyhk.com/duoermei-h5/#/pages/Register/Home/Index?token="//预约挂号入口
//#define NB_REGISTRATION @"https://pre-release.jyhk.com/duoermei-h5/#/pages/Main/HospitalPortal/HospitalPortal"
#define NB_ORDER @"https://pre-release.jyhk.com/duoermei-h5/#/pages/Referral/referral/list?token="//复诊订单入口
#define NB_RECORD @"https://pre-release.jyhk.com/duoermei-h5/#/pages/Register/Mine/Mine?token="//挂号记录入口
#define NB_PRESCRIPTION @"https://pre-release.jyhk.com/duoermei-h5/#/pages/Referral/order/list?token="//电子处方入口
#define NB_MANAGE @"https://pre-release.jyhk.com/duoermei-h5/#/pages/FamilyMember/List?token="//就诊人管理入口

#define LOGIN_POLICY @"http://agreement.demzhmzb.com/%E9%9A%90%E7%A7%81%E6%9D%83%E5%8D%8F%E8%AE%AE.html"
#define LOGIN_AGREEMENT @"http://agreement.demzhmzb.com/Agreement.html"
#endif /* Address_h */
