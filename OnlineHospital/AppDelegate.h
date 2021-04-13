//
//  AppDelegate.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/7.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//#import <GTSDK/GeTuiSdk.h>     // GetuiSdk头文件应用
#import <WXApi.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate , WXApiDelegate>//GeTuiSdkDelegate

@property (readonly, strong) NSPersistentCloudKitContainer *persistentContainer;
@property (nonatomic, strong) UIWindow * window;
@property(nonatomic, assign)BOOL allowRotation;
- (void)saveContext;


@end

