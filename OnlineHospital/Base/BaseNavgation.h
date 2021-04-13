//
//  BaseNavgation.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/17.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseNavgation : UIView
//vip
+(BaseNavgation *)navigationViewWithTitle:(NSString *)title right: (NSString *)right;

//消息界面
+(BaseNavgation *)messageNavigationViewWithTitle:(NSString *)title;

//医生主页
+(BaseNavgation *)doctorNavigationViewWithTitle:(NSString *)title;

//我的花朵
+(BaseNavgation *)flowerNavigationViewWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
