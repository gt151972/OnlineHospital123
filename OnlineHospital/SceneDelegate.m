//
//  SceneDelegate.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/7.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "LGTabBarController.h"
#import "WechatManager.h"
#import <AlipaySDK/AlipaySDK.h>
@interface SceneDelegate ()

@end

@implementation SceneDelegate


- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
     UIWindowScene *windowScene = (UIWindowScene *)scene;
           self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//            self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
            [self.window setWindowScene:windowScene];
            [self.window setBackgroundColor:[UIColor whiteColor]];
            [self.window setRootViewController:[LGTabBarController new]];
            
            [self.window makeKeyAndVisible];
}

- (void)scene:(UIScene *)scene openURLContexts:(NSSet<UIOpenURLContext *> *)URLContexts{
    NSSet*set = URLContexts;
    NSLog(@"URLContexts == %@",URLContexts.allObjects.firstObject);
    UIOpenURLContext *urlContext = URLContexts.allObjects.firstObject;
    if ([urlContext.URL.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:urlContext.URL standbyCallback:^(NSDictionary *resultDic) {
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
        
        [WechatManager handleOpenUrl:urlContext.URL];
    }
   
//       if (urlContext) {
//           [WXApi handleOpenURL:urlContext.URL delegate:self];
//       }
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.

    // Save changes in the application's managed object context when the application transitions to the background.
    [(AppDelegate *)UIApplication.sharedApplication.delegate saveContext];
}


@end
