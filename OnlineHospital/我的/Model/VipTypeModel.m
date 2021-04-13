//
//  VipTypeModel.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/11/3.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "VipTypeModel.h"

@implementation VipTypeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"vid": @"id",
             @"descriptions":@"description"};
}
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
       if ([VipTypeModel isEmpty:oldValue]) {// 以字符串类型为例
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
