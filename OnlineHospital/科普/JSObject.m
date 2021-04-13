//
//  JSObject.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/3/11.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import "JSObject.h"

@implementation JSObject
- (NSString *)token{
    NSLog(@"token == %@",[SaveData readToken]);
    return [SaveData readToken];
}
- (void)token2{
    NSLog(@"token" );
}
@end
