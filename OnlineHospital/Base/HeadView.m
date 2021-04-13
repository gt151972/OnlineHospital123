//
//  HeadView.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/22.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "HeadView.h"
@interface HeadView()
@property(nonatomic,strong) NSString *strtitle;
@end
@implementation HeadView

- (instancetype)initWithTitle: (NSString *)title isMore:(BOOL)isMore{
  if ( self =  [super init]) {
        self.backgroundColor = [UIColor clearColor];
        UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 8, Screen_W- 24, 50)];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
         CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
         maskLayer.frame = bgview.bounds;
         maskLayer.path = maskPath.CGPath;
         bgview.layer.mask = maskLayer;
         bgview.backgroundColor = BG_COLOR_WHITE;
        [self addSubview:bgview];
        self.strtitle = title;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, bgview.size.width - 28, 50)];
        label.text = title;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = TEXT_COLOR_MAIN;
        [bgview addSubview:label];
        
        if (isMore) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(bgview.size.width - 14 - 60, 0, 60, 50)];
            [btn setTitle:@"查看更多" forState:UIControlStateNormal];
            [btn.titleLabel setFont: [UIFont systemFontOfSize:14]];
            [btn setTitleColor:TEXT_COLOR_DETAIL forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnclicked) forControlEvents:UIControlEventTouchUpInside];
            [bgview addSubview:btn];
        }
      
    }
      return self;
}

- (instancetype)initWithFrame: (CGRect)frame title: (NSString *)title  isMore:(BOOL)isMore{
    if ( self =  [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 8, Screen_W- 24, 50)];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgview.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
         CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
         maskLayer.frame = bgview.bounds;
         maskLayer.path = maskPath.CGPath;
         bgview.layer.mask = maskLayer;
         bgview.backgroundColor = BG_COLOR_WHITE;
        [self addSubview:bgview];
        self.strtitle = title;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, bgview.size.width - 28, 50)];
        label.text = title;
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = TEXT_COLOR_MAIN;
        [bgview addSubview:label];
        
        if (isMore) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(bgview.size.width - 14 - 60, 0, 60, 50)];
            [btn setTitle:@"查看更多" forState:UIControlStateNormal];
            [btn.titleLabel setFont: [UIFont systemFontOfSize:14]];
            [btn setTitleColor:TEXT_COLOR_DETAIL forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnclicked) forControlEvents:UIControlEventTouchUpInside];
            [bgview addSubview:btn];
        }
      
    }
      return self;
}

- (void)btnclicked{

        [self.onTapBtnViewDelegate passMoreHeadView:self title:self.strtitle];

}
@end
