//
//  JSObject.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/3/11.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN
@protocol JSObjectProtocol <JSExport>
- (NSString *)token;
- (void)token2;
@end

@interface JSObject : NSObject<JSObjectProtocol>

@end

NS_ASSUME_NONNULL_END
