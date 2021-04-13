//
//  Header.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/7.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#ifndef Header_h
#define Header_h

/**  请求类 */
#import "RequestUrls.h"
#import "RequestUtil.h"
#import "ObjectTool.h"
#import "LGStatisticsRequstUtil.h"
#import "AlertTools.h" //提示信息
//#import <MBProgressHUD+RY.h>
#import "MBProgressHUD+RY.h"//提示信息

#import "SaveData.h"//信息存储读取

/**  第三方库 */
#import "AFNetworking.h"
#import "Masonry.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import <ReactiveObjC.h>
#import <MBProgressHUD.h>
#import <SVProgressHUD.h>

//登录
#import "OneClickLogin.h"
#import "LoginMessageViewController.h"
/**  类目 */
//view相关
#import "UIView+Extensions.h"
#import "BasePublicClass.h"
//image相关
#import "UIImage+Color.h"
#import <SDWebImage/UIImageView+WebCache.h>

//NSString相关
#import "NSString+Hash.h"
#import "NSString+LGExtenison.h"
//NSData相关
#import "NSData+Base64.h"
#import "BaseDataChange.h"
//NSObject相关
//#import "ObjectTool.h"
#import "NSObject+additions.h"
//UIButton相关
#import "UIButton+BackgroundColor.h"
#import "UIBarButtonItem+DFYGExtension.h"
#import "UILabel+LGExtension.h"
#import "YLButton.h"
#import "GTBlueButton.h"
//UILabel相关
#import "UILabel+ChangeLineSpaceAndWordSpace.h"
//#import <YYKit/YYKit.h>
//TextView相关
#import "FSTextView.h"
//UIDevice相关
#import "UIDevice-Hardware.h"
//UIColor相关
#import "UIColor+LGExtension.h"
#import "UIColor+ColorChange.h"
//UIScrollView
//#import "UIScrollView+EmptyDataSet.h"
//防止crash
#import "NSArray+NSRangeException.h"
//#import "NSDictionary+NilSafe.h"

#import "BaseViewController.h"
#import "NullView.h"

// .h
#define singleton_interface(class) +(instancetype) shared##class;
// .m
#define singleton_implementation(class)         \
static class *_instance;                        \
\
+(id) allocWithZone : (struct _NSZone *) zone { \
static dispatch_once_t onceToken;           \
dispatch_once(&onceToken, ^{                \
_instance = [super allocWithZone:zone]; \
});                                         \
\
return _instance;                           \
}                                               \
\
+(instancetype) shared##class                   \
{                                           \
if (_instance == nil) {                     \
_instance = [[class alloc] init];       \
}                                           \
\
return _instance;                            \
}

#endif /* Header_h */
