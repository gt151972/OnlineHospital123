//
//  AppDelegate.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/7.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "LGTabBarController.h"
#import "LGNavigationController.h"
#import "PNSHttpsManager.h"
#import <ATAuthSDK/ATAuthSDK.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WechatManager.h"
#import "LiveAcrossViewController.h"
#import "GetuiModel.h"
#import "LiveOnByeViewController.h"
#import <CloudPushSDK/CloudPushSDK.h>
//#import <PLMediaStreamingKit/PLMediaStreamingKit.h>
// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#define kGtAppId           @"2Dd5iWhdLA8GjXeZE7eo2"
#define kGtAppKey          @"uMUwhoHJvY91T7IemXdEf4"
#define kGtAppSecret       @"YEtGtwpPrBA6ZwlNUQgDJ9"

#define AliAppKey       @"333413132"
#define AlitAppSecret       @"392ee75089d04cca9524d493f232f8b4"
@interface AppDelegate ()<LiveOnByeViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (@available(iOS 13.0, *)) {
    
      } else {
          self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
          self.window.rootViewController = [[LGTabBarController alloc]init];
          self.window.backgroundColor = [UIColor whiteColor];
          [self.window makeKeyAndVisible];
          
      }
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    NSString *authSDKInfo = [[NSUserDefaults standardUserDefaults] objectForKey:PNSATAUTHSDKINFOKEY];
    if (!authSDKInfo || authSDKInfo.length == 0) {
        authSDKInfo = PNSATAUTHSDKINFO;
    }
    [PNSHttpsManager requestATAuthSDKInfo:^(BOOL isSuccess, NSString * _Nonnull authSDKInfo) {
        if (isSuccess) {
            [[NSUserDefaults standardUserDefaults] setObject:authSDKInfo forKey:PNSATAUTHSDKINFOKEY];
        }
    }];
    [[TXCommonHandler sharedInstance] setAuthSDKInfo:authSDKInfo
                                            complete:^(NSDictionary * _Nonnull resultDic) {
        NSLog(@"设置秘钥结果：%@", resultDic);
    }];
    
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
//        [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册远程通知
//       [GeTuiSdk registerRemoteNotification: (UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge)];
        // 注册 APNs
//        [self registerRemoteNotification];
//    [GeTuiSdk registerRemoteNotification: (UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge)];
    
    // 点击通知将App从关闭状态启动时，将通知打开回执上报
        // [CloudPushSDK handleLaunching:launchOptions];(Deprecated from v1.8.1)
    
    // APNs注册，获取deviceToken并上报
    [self registerAPNS:application];
    // 初始化SDK
    
    [self initCloudPush];
//    NSDictionary *dic =[SaveData readLogin];
//    NSLog(@"id == %@",dic[@"id"]);
//    [self addAlias:dic[@"id"]];
//    [self unbindAccount];
    [self bindAccount:[SaveData readToken]];
    // 监听推送通道打开动作
//    [self listenerOnChannelOpened];
    // 监听推送消息到达
    [self registerMessageReceive];
        [CloudPushSDK sendNotificationAck:launchOptions];
    //向微信注册,发起支付必须注册
     BOOL isSuccess = [WXApi registerApp:@"wx0d3748088b7e2f59" universalLink:@"https://duoermei/onlinehospital/app/"];
    if (isSuccess) {
            NSLog(@"微信支付API注册成功");
        } else {
            NSLog(@"微信支付API注册失败");
        }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(gologin)
                                                     name:UserNotificationJumpLogin
                                                   object:nil];
    //
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
            if (@available(iOS 10.0, *)) {
                UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
                __weak typeof(self) weakSelf = self;
                [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    if (granted) {
                        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                            if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                                });
                            }
                        }];
                    }
                }];
            }
        } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
            if (@available(iOS 8.0, *)) {
                if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                    UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
                    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                } else {
                    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
                }
            }
        }
    return YES;
}

- (void)gologin{
//    [self getCurrentVC];
    UIViewController *vc = [self getDisViewController];
    [self beginLogin:vc];
}

- (void)beginLogin : (UIViewController *)viewController{
    [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    TXCustomModel *model = [OneClickLogin buildModel];
    __weak typeof(self) weakSelf = viewController;
    [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:3.0
                                                    controller:viewController
                                                         model:model
                                                      complete:^(NSDictionary * _Nonnull resultDic) {
        NSString *resultCode = [resultDic objectForKey:@"resultCode"];
        if ([PNSCodeLoginControllerPresentSuccess isEqualToString:resultCode]) {
            NSLog(@"授权页拉起成功回调：%@", resultDic);
            [MBProgressHUD hideHUDForView:viewController.view animated:YES];
        } else if ([PNSCodeLoginControllerClickCancel isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickCheckBoxBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickLoginBtn isEqualToString:resultCode] ||
                   [PNSCodeLoginControllerClickProtocol isEqualToString:resultCode]) {
          
            NSLog(@"页面点击事件回调：%@", resultDic);
        }else if ([PNSCodeLoginControllerClickChangeBtn isEqualToString:resultCode]){
            
            LoginMessageViewController *controller = [[LoginMessageViewController alloc] init];
            controller.isHiddenNavgationBar = YES;
            UINavigationController *nav= viewController.navigationController;
            if (viewController.presentedViewController) {
                //如果授权页成功拉起，这个时候则需要使用授权页的导航控制器进行跳转
                nav = (UINavigationController *)viewController.presentedViewController;
            }
            [nav pushViewController:controller animated:YES];
//
        }
        else if ([PNSCodeSuccess isEqualToString:resultCode]) {
            NSLog(@"获取LoginToken成功回调：%@", resultDic);
            //NSString *token = [resultDic objectForKey:@"token"];
            NSLog(@"接下来可以拿着Token去服务端换取手机号，有了手机号就可以登录，SDK提供服务到此结束");
            //[weakSelf dismissViewControllerAnimated:YES completion:nil];
            [self postLoginWithToken:[resultDic objectForKey:@"token"]];
            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
        } else {
            NSLog(@"获取LoginToken或拉起授权页失败回调：%@", resultDic);
            [MBProgressHUD hideHUDForView:viewController.view animated:YES];
            //失败后可以跳转到短信登录界面

            LoginMessageViewController *controller = [[LoginMessageViewController alloc] init];
            controller.isHiddenNavgationBar = YES;
            UINavigationController *nav= viewController.navigationController;
            if (viewController.presentedViewController) {
                //如果授权页成功拉起，这个时候则需要使用授权页的导航控制器进行跳转
                nav = (UINavigationController *)viewController.presentedViewController;
            }
            [nav pushViewController:controller animated:YES];
//            [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:YES complete:nil];
        }
    }];
}
#pragma mark ----登录
- (void)postLoginWithToken: (NSString *)token{
    NSString *url = [NSString stringWithFormat:POST_LOGIN,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:token forKey:@"id"];//密码登陆为用户名,手机验证码登陆时为手机号码,移动运营商一键登录（阿里sdk)时为token,微信登录时为微信code
    [parameDic setObject:@"MOBILE_ALI" forKey:@"type"];//PASSWORD-密码登录,CODE-验证码登录,WECHAT-微信登录,MOBILE_ALI
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject==%@", responseObject);
        NSMutableDictionary *respDic= [responseObject objectForKey:@"result"] ;
        [SaveData SaveLoginWithDic:respDic];
        [SaveData saveToken:[respDic objectForKey:@"token"]];
        [self addAlias: respDic[@"id"]];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSLog(@"%@",url);
    return YES;
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    NSLog(@"%@",url);
    NSLog(@"Calling Application Bundle ID: %@", options[UIApplicationOpenURLOptionsSourceApplicationKey]);
             NSLog(@"URL scheme: %@", [url scheme]);
             NSLog(@"URL query: %@", [url query]);
    //微信
           //支付宝
           if ([url.host isEqualToString:@"safepay"]) {
               //跳转支付宝钱包进行支付，处理支付结果
               [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                   NSLog(@"result = %@",resultDic);
                   NSLog(@"支付宝客户端支付结果result = %@",resultDic);
//                   [PHTitleAlertView showWithAlerTitle:resultDic[@"memo"]];
                   /*
                   9000 订单支付成功
                   8000 正在处理中
                   4000 订单支付失败
                   6001 用户中途取消
                   6002 网络连接出错
                   */
                   if (resultDic && [resultDic objectForKey:@"resultStatus"] && ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000)) {
                       
                       // 发通知带出支付成功结果
                       [[NSNotificationCenter defaultCenter] postNotificationName:UserNotificationAlipayOrWechatSuccess object:resultDic];
                   } else {
                       
                       // 发通知带出支付失败结果
                       [[NSNotificationCenter defaultCenter] postNotificationName:UserNotificationAlipayOrWechatFail object:resultDic];
                   }
               }];
           }else{
               NSLog(@"%@",url);
               return [WechatManager handleOpenUrl:url];
//               if ([url.absoluteString containsString:[NSString stringWithFormat:@"%@://pay", WeiXinPayKey]]) {
//
//                      } else if ([url.absoluteString containsString:[NSString stringWithFormat:@"%@://oauth?", WeiXinPayKey]]) {
//                          return [WechatManager handleOpenUrl:url];
//                      }
           }
       return YES;
//    if ([url.host isEqualToString:@"safepay"]) {
//        // 支付跳转支付宝钱包进行支付，处理支付结果
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            NSLog(@"result = %@",resultDic);
//        }];
//
//
//    }
//    return YES;
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    NSURL *continueURL = userActivity.webpageURL;
    NSString *relativePath = continueURL.relativePath;
    NSLog(@"relativePath == %@",relativePath);
    return [WXApi handleOpenUniversalLink:userActivity delegate:[WechatManager shareInstance]];
//    [relativePath containsString:WeiXinPayKey] &&
//    if ([relativePath containsString:@"pay"]) {
//        return [WXApi handleOpenUniversalLink:userActivity delegate:[WechatManager shareInstance]];
//    }
//    return YES;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskLandscapeLeft ;
    }else{
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentCloudKitContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentCloudKitContainer alloc] initWithName:@"OnlineHospital"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

#pragma mark ---阿里云推送
- (void)initCloudPush {
    // SDK初始化
    [CloudPushSDK asyncInit:AliAppKey appSecret:AlitAppSecret callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
}
//绑定别名
- (void)addAlias:(NSString *)alias {
    [CloudPushSDK addAlias:alias withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"别名绑定成功");
            NSDictionary *dic =[SaveData readLogin];
            NSLog(@"id == %@",dic[@"id"]);
            [self postUpdateCid:dic[@"id"]];
//            [SVProgressHUD showSuccessWithStatus:@"别名绑定成功"];
        } else {
            NSLog(@"别名绑定失败");
//            [SVProgressHUD showSuccessWithStatus:@"别名绑定失败"];
        }
    }];
}
/**
 *    注册苹果推送，获取deviceToken用于推送
 *
 *    @param     application
 */
- (void)registerAPNS:(UIApplication *)application {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:
          (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                           categories:nil]];
        [application registerForRemoteNotifications];
    }
    else {
        // iOS < 8 Notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
}
#pragma mark -----个推
/**
 * [ 参考代码，开发者注意根据实际需求自行修改 ] 注册远程通知
 *
 * 警告：Xcode8及以上版本需要手动开启“TARGETS -> Capabilities -> Push Notifications”
 * 警告：该方法需要开发者自定义，以下代码根据APP支持的iOS系统不同，代码可以对应修改。以下为参考代码
 * 注意根据实际需要修改，注意测试支持的iOS系统都能获取到DeviceToken
 *
 */
- (void)registerRemoteNotification {
    float iOSVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (iOSVersion >= 10.0) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error && granted) {
                NSLog(@"[ TestDemo ] iOS request authorization succeeded!");
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        return;
    }

    if (iOSVersion >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}
/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //向个推服务器注册deviceToken
//    [GeTuiSdk registerDeviceTokenData:deviceToken];
//    NSString *string = [self dataToHexString:deviceToken];
//        NSLog(@"deviceToken==%@----%@", deviceToken,string);
//            [GeTuiSdk registerDeviceToken:string];
    
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
            if (res.success) {
                NSLog(@"Register deviceToken success, deviceToken: %@", [CloudPushSDK getApnsDeviceToken]);
            } else {
                NSLog(@"Register deviceToken failed, error: %@", res.error);
            }
        }];
}
/*
 *  苹果推送注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}
#pragma mark Channel Opened
/**
 *    注册推送通道打开监听
 */
- (void)listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChannelOpened:)
                                                 name:@"CCPDidChannelConnectedSuccess"
                                               object:nil];
}

/**
 *    推送通道打开回调
 *
 *    @param     notification
 */
- (void)onChannelOpened:(NSNotification *)notification {
//    [MsgToolBox showAlert:@"温馨提示" content:@"消息通道建立成功"];
    [SVProgressHUD showSuccessWithStatus:@"消息通道建立成功"];
}
/**
 *    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}
/**
 *    处理到来推送消息
 *
 *    @param     notification
 */
- (void)onMessageReceived:(NSNotification *)notification {
    NSLog(@"Receive one message!");
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
}
-(NSString *)dataToHexString:(NSData *)data {
    Byte *bytes = (Byte *)[data bytes];
    NSString *hexStr = @"";
    for (int i = 0; i<[data length]; i++) {
        NSString *newHexStr = [NSString stringWithFormat:@"%x", bytes[i]&0xff];
        if ([newHexStr length] == 1) {
            hexStr = [NSString stringWithFormat:@"%@0%@", hexStr, newHexStr];
        }else {
            hexStr = [NSString stringWithFormat:@"%@%@", hexStr, newHexStr];
        }
    }
    return hexStr;
}
//前台通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"Receive one notification.");
       // 取得APNS通知内容
       NSDictionary *aps = [userInfo valueForKey:@"aps"];
       // 内容
       NSString *content = [aps valueForKey:@"alert"];
       // badge数量
       NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
       // 播放声音
       NSString *sound = [aps valueForKey:@"sound"];
       // 取得Extras字段内容
       NSString *Extras = [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
       NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, Extras);
       // iOS badge 清0
       application.applicationIconBadgeNumber = 0;
       // 通知打开回执上报
       // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
       [CloudPushSDK sendNotificationAck:userInfo];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSLog(@"notification == %@",notification);
}
///**
// *  SDK运行状态通知
// *
// *  @param aStatus 返回SDK运行状态
// */
//- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus{
//    NSLog(@"aStatus == %lu",(unsigned long)aStatus);
//}
//
///**
// *  SDK通知收到个推推送的透传消息
// *
// *  @param payloadData 推送消息内容
// *  @param taskId      推送消息的任务id
// *  @param msgId       推送消息的messageid
// *  @param offLine     是否是离线消息，YES.是离线消息
// *  @param appId       应用的appId
// */
//- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId{
//    NSLog(@"payloadData == %@",payloadData);
////    [SVProgressHUD showSuccessWithStatus:payloadData];
//}
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//
////MARK: - 通知回调
//
///// 通知展示（iOS10及以上版本）
///// @param center center
///// @param notification notification
///// @param completionHandler completionHandler
//- (void)GeTuiSdkNotificationCenter:(UNUserNotificationCenter *)center
//           willPresentNotification:(UNNotification * )notification
//             completionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
//__API_AVAILABLE(macos(10.14), ios(10.0), watchos(3.0), tvos(10.0)){
//    NSLog(@"GeTuiSdkNotificationCenter");
//}
//
//
//#endif
///// 收到通知信息
///// @param userInfo apns通知内容
///// @param center UNUserNotificationCenter（iOS10及以上版本）
///// @param response UNNotificationResponse（iOS10及以上版本）
///// @param completionHandler 用来在后台状态下进行操作（iOS10以下版本）
//- (void)GeTuiSdkDidReceiveNotification:(NSDictionary *)userInfo
//                    notificationCenter:(nullable UNUserNotificationCenter *)center
//                              response:(nullable UNNotificationResponse *)response
//                fetchCompletionHandler:(nullable void (^)(UIBackgroundFetchResult))completionHandler{
//    NSLog(@"GeTuiSdkDidReceiveNotification.info == %@",userInfo);
//    NSString *string = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"title"];
//    NSLog(@"string == %@",string);
//}

/// 收到透传消息
/// @param userInfo    推送消息内容
/// @param fromGetui   YES: 个推通道  NO：苹果apns通道
/// @param offLine     是否是离线消息，YES.是离线消息
/// @param appId       应用的appId
/// @param taskId      推送消息的任务id
/// @param msgId       推送消息的messageid
/// @param completionHandler 用来在后台状态下进行操作（通过苹果apns通道的消息 才有此参数值）
//- (void)GeTuiSdkDidReceiveSlience:(NSDictionary *)userInfo
//                        fromGetui:(BOOL)fromGetui
//                          offLine:(BOOL)offLine
//                            appId:(nullable NSString *)appId
//                           taskId:(nullable NSString *)taskId
//                            msgId:(nullable NSString *)msgId
//           fetchCompletionHandler:(nullable void (^)(UIBackgroundFetchResult))completionHandler{
//    // [ GTSDK ]：汇报个推自定义事件(反馈透传消息)，开发者可以根据项目需要决定是否使用, 非必须
//       // [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
//       NSString *msg = [NSString stringWithFormat:@"[ TestDemo ] [APN] %@ \nReceive Slience: fromGetui:%@ appId:%@ offLine:%@ taskId:%@ msgId:%@ userInfo:%@ ", NSStringFromSelector(_cmd), fromGetui ? @"个推消息" : @"APNs消息", appId, offLine ? @"离线" : @"在线", taskId, msgId, userInfo];
//    NSLog(@"userInfo == %@",userInfo);
//    NSString *str1 = [userInfo objectForKey:@"payload"];
//    NSData *jsonData = [str1 dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves  error:nil];
//
//    NSLog(@"responseJSON == %@",responseJSON);
//    GetuiModel *model = [GetuiModel mj_objectWithKeyValues:responseJSON];
//    if ([model.type intValue] == 10) {//互动接入
//        UIViewController *vc = [self getDisViewController];
//        LiveOnByeViewController *liveVC =[[LiveOnByeViewController alloc] init];
//        liveVC.string = model.params;
//        liveVC.delegate = self;
//        [vc.navigationController presentViewController:liveVC animated:NO completion:nil];
//    }else if ([model.type intValue] == 12){//直播异常
////        UIViewController *vc = [self getDisViewController];
////        LiveViewController *liveVC = [[LiveViewController alloc] init];
////        liveVC.pid = model.params;
////        liveVC.channel = livingChannelCommunicate;
////        [vc.navigationController pushViewController:liveVC animated:YES];
//    }
//
//       if(completionHandler) {
//           // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要自行修改参数值
//           completionHandler(UIBackgroundFetchResultNoData);
//       }
//
//}

- (void)LiveOnByeAlertBtnClicked:(NSString *)item{
    UIViewController *vc = [self getDisViewController];
    LiveAcrossViewController *liveVC = [[LiveAcrossViewController alloc] init];
    liveVC.pid =item;
    [vc.navigationController pushViewController:liveVC animated:YES];
}

- (void)GeTuiSdkNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification {
    // [ 参考代码，开发者注意根据实际需求自行修改 ] 根据APP需要自行修改参数值
}


- (void)GeTuiSdkDidOccurError:(NSError *)error {
    NSString *msg = [NSString stringWithFormat:@"[ TestDemo ] [GeTuiSdk GeTuiSdkDidOccurError]:%@\n\n",error.localizedDescription];

    // SDK发生错误时，回调异常错误信息
    NSLog(@"%@", msg);
}

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
    [self postUpdateCid:clientId];
//    [self postUpdateCid:@""];
}

- (UIViewController *)getCurrentVC
{
    UIViewController  *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else{
        result = window.rootViewController;
    }
    return result;
}
- (UIViewController *)getDisViewController
{
    UIViewController *currVC;
    if ([[self getCurrentVC] isKindOfClass:[LGTabBarController class]]) {//判断是是不是tabbar  是tabbar找到最好导航最后一个控制器是当前控制器
        LGTabBarController *tabBar = (LGTabBarController *)[self getCurrentVC];
        LGNavigationController *mainNC = tabBar.selectedViewController;
        return mainNC.viewControllers.lastObject;
    }
    /*else if ([ [self getCurrentVC] isKindOfClass:[WJInterpreterTabBarController class]])
    {
        WJInterpreterTabBarController *tabBar = (WJInterpreterTabBarController *)[self getCurrentVC];
        WJNAVController *mainNC = tabBar.selectedViewController;
        return mainNC.viewControllers.lastObject;
    }*/
     else if ([ [self getCurrentVC] isKindOfClass:[LGNavigationController class]]){//如果当前页面是导航，找到导航数组中最后一个控制器 ，是当前屏幕显示的控制器
         LGNavigationController *mainNC = (LGNavigationController *)[self getCurrentVC];
        return mainNC.viewControllers.lastObject;
    }else if ([ [self getCurrentVC] isKindOfClass:[UIViewController class]]){
        return [self getCurrentVC] ;
    }else{
        return [self getCurrentVC] ;
    }
}

-(void)notificationGoVC:(NSDictionary *)dictionaray{
    NSDictionary *apnsDic = [NSDictionary dictionaryWithDictionary:[[dictionaray objectForKey:@"aps"]objectForKey:@"alert"]];
    NSString *title = [apnsDic objectForKey:@"title"];
    NSString *content = [apnsDic objectForKey:@"body"];
    
}
- (void)bindAccount:(NSString *)account {
    if (account == nil || account.length == 0) {
        return;
    }
    [CloudPushSDK bindAccount:account withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            [userDefaultes setObject:account forKey:@"bindAccount"];
            [userDefaultes synchronize];
            NSLog(@"账号绑定成功");
//            [self showLog:@"账号绑定成功"];
//            [SVProgressHUD showSuccessWithStatus:@"账号绑定成功"];
//            NSDictionary *dic =[SaveData readLogin];
            [self postUpdateCid:[SaveData readToken]];
        } else {
            NSLog(@"账号绑定失败");
//            [self showLog:[NSString stringWithFormat:@"账号绑定失败，错误: %@", res.error]];
//            [SVProgressHUD showSuccessWithStatus:@"账号绑定失败"];
        }
    }];
}

- (void)unbindAccount {
    [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
            [userDefaultes setObject:nil forKey:@"bindAccount"];
            [userDefaultes synchronize];
//            [self showLog:@"账号解绑成功"];
            NSLog(@"账号解绑成功");
            [SVProgressHUD showSuccessWithStatus:@"账号解绑成功"];
        } else {
//            [self showLog:[NSString stringWithFormat:@"账号解绑失败，错误: %@", res.error]];
            NSLog(@"账号解绑败");
            [SVProgressHUD showSuccessWithStatus:@"账号解绑败"];
        }
    }];
}


#pragma mark -------- 更新用户cid
- (void)postUpdateCid: (NSString *)cid{
        NSString *url = [NSString stringWithFormat:POST_UPDATE_CID,rootURL];
        NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
        [parameDic setObject:cid forKey:@"thirdId"];
        [parameDic setObject:@"ios" forKey:@"device"];
        [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"responseObject == %@",responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
}

@end
