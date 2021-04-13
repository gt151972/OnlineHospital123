//
//  UITabBar+Badge.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/4/6.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import "UITabBar+Badge.h"
#define TabbarBadge_Nums 4.0
@implementation UITabBar (Badge)
//显示小红点

/**
 展示小红点
 @param index 下标
 */
-(void)showBadgeOfIndex:(NSInteger)index{
    [self removeBadgeOfIndex:index];
    
    UIView *badgeV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    badgeV.tag = 999+index;
    badgeV.layer.cornerRadius = 5;
    badgeV.clipsToBounds = YES;
    badgeV.backgroundColor = [UIColor redColor];
    
    //确定小红点的位置
    CGRect tabFrame = self.frame;
    float percentX = (index +0.6) / TabbarBadge_Nums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeV.frame = CGRectMake(x, y, 10, 10);
    
//    NSLog(@"the badge new frame is %@",NSStringFromCGRect(badgeV.frame));
    [self addSubview:badgeV];
}

/**
 隐藏小红点
 @param index 下标
 */
-(void)hiddenBadgeOfIndex:(NSInteger)index{
    [self removeBadgeOfIndex:index];
}

/**
 移除小红点
 @param index 下标
 */
-(void)removeBadgeOfIndex:(NSInteger)index{
    for (UIView *view in self.subviews) {
        if (view.tag == 999+index) {
            [view removeFromSuperview];
        }
    }
}


@end
