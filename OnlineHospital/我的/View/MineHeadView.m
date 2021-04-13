//
//  MineHeadView.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "MineHeadView.h"
#define space 12.0f //两边间隙
#define distance 8.0f //上下间隙
@implementation MineHeadView

+(MineHeadView *)mineHeadViewWithFrame:(CGRect)frame title:(NSString *)title{
    MineHeadView *view = [[MineHeadView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(space, distance, Screen_W- (space*2), view.size.height)];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
     CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
     maskLayer.frame = bgview.bounds;
     maskLayer.path = maskPath.CGPath;
     bgview.layer.mask = maskLayer;
     bgview.backgroundColor = BG_COLOR_WHITE;
    [view addSubview:bgview];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, bgview.size.width - 28, view.size.height)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = TEXT_COLOR_MAIN;
    [bgview addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(14, frame.size.height - 1, Screen_W- (26*2), 1)];
        line.backgroundColor = BG_COLOR;
       [view addSubview:line];
    return view;
}
@end
