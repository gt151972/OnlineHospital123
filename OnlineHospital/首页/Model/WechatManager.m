//
//  WechatManager.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/1/6.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import "WechatManager.h"
@interface WechatManager()<WXApiDelegate>

@end

@implementation WechatManager
+ (id)shareInstance {
    static WechatManager *weChatPayInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        weChatPayInstance = [[WechatManager alloc] init];
    });
    return weChatPayInstance;
}

+ (BOOL)handleOpenUrl:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:[WechatManager shareInstance]];
}

+ (void)hangleWechatPayWith:(PayReq *)req {
    [WXApi sendReq:req completion:^(BOOL success) {
        if (success) {
            NSLog(@"微信支付成功");
        } else {
             NSLog(@"微信支付异常");
        }
    }];
}

#pragma mark - 微信支付回调

- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        /*
         enum  WXErrCode {
         WXSuccess           = 0,    < 成功
         WXErrCodeCommon     = -1,  < 普通错误类型
         WXErrCodeUserCancel = -2,   < 用户点击取消并返回
         WXErrCodeSentFail   = -3,   < 发送失败
         WXErrCodeAuthDeny   = -4,   < 授权失败
         WXErrCodeUnsupport  = -5,   < 微信不支持
         };
         */
        PayResp *response = (PayResp*)resp;
        switch (response.errCode) {
            case WXSuccess: {
                NSLog(@"微信回调支付成功");
                [[NSNotificationCenter defaultCenter] postNotificationName:UserNotificationAlipayOrWechatSuccess
                                                                    object:nil
                                                                  userInfo:nil];
            break;
            }
            case WXErrCodeCommon: {
                NSLog(@"微信回调支付异常");
                [[NSNotificationCenter defaultCenter] postNotificationName:UserNotificationAlipayOrWechatFail
                                                                    object:nil
                                                                  userInfo:nil];
                break;
            }
            case WXErrCodeUserCancel: {
                NSLog(@"微信回调用户取消支付");
                [[NSNotificationCenter defaultCenter] postNotificationName:UserNotificationAlipayOrWechatFail
                                                                    object:nil
                                                                  userInfo:nil];
                break;
            }
            case WXErrCodeSentFail: {
                NSLog(@"微信回调发送支付信息失败");
                [[NSNotificationCenter defaultCenter] postNotificationName:UserNotificationAlipayOrWechatFail
                                                                    object:nil
                                                                  userInfo:nil];
                break;
            }
            case WXErrCodeAuthDeny: {
                NSLog(@"微信回调授权失败");
                [[NSNotificationCenter defaultCenter] postNotificationName:UserNotificationAlipayOrWechatFail
                                                                    object:nil
                                                                  userInfo:nil];
                break;
            }
            case WXErrCodeUnsupport: {
                NSLog(@"微信回调微信版本暂不支持");
                [[NSNotificationCenter defaultCenter] postNotificationName:UserNotificationAlipayOrWechatFail
                                                                    object:nil
                                                                  userInfo:nil];
                break;
            }
            default: {
                break;
            }
        }
    }
}
@end
