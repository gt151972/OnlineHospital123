//
//  HomeArticalModel.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "HomeArticalModel.h"

@implementation HomeArticalModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"nid": @"id",
             @"Visit":@"initVisit"};
    
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
       if ([HomeArticalModel isEmpty:oldValue]) {// 以字符串类型为例
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
