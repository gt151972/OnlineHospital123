//
//  MessageModel.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/10/27.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"mid": @"id"};
    
}
@end
