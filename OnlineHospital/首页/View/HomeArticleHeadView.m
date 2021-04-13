//
//  HomeArticleHeadView.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "HomeArticleHeadView.h"
#define space 12.0f //两边间隙
#define distance 8.0f //上下间隙
@implementation HomeArticleHeadView

+(HomeArticleHeadView *)homeArticleHeadViewWithFrame:(CGRect)frame title:(NSString *)title{
    HomeArticleHeadView *view = [[HomeArticleHeadView alloc] initWithFrame:frame];
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
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(bgview.size.width - 14 - 60, 0, 60, view.size.height)];
    [btn setTitle:@"查看更多" forState:UIControlStateNormal];
    [btn.titleLabel setFont: [UIFont systemFontOfSize:14]];
    [btn setTitleColor:TEXT_COLOR_DETAIL forState:UIControlStateNormal];
    [bgview addSubview:btn];
    return view;
}
@end
