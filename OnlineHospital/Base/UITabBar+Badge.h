//
//  UITabBar+Badge.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/4/6.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (Badge)
-(void)showBadgeOfIndex:(NSInteger)index;
-(void)hiddenBadgeOfIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
