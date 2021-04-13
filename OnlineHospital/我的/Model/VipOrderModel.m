//
//  VipOrderModel.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/1/12.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import "VipOrderModel.h"

@implementation VipOrderModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"oid": @"id"
    };
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
       if ([VipOrderModel isEmpty:oldValue]) {// 以字符串类型为例
       return  @"";
   }
   return oldValue;
}

+(BOOL)isEmpty:(NSString*)text{
    if ([text isEqual:[NSNull null]]) {
        return YES;
    }
    else if ([text isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if (text == nil){
        return YES;
    }
    return NO;
}
@end
