//
//  ZAMTBtnView.m
//  类似美团轮播
//
//  Created by 纵昂 on 2017/2/24.
//  Copyright © 2017年 纵昂. All rights reserved.
//

#import "ZAMTBtnView.h"

@implementation ZAMTBtnView
-(id)initWithFrame:(CGRect)frame title:(NSString *)title detailTitle: (NSString *)detailTitle imageStr:(NSString *)imageStr{
    self = [super initWithFrame:frame];
    if (self) {
        //
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (Screen_W - 72)/3, 140)];
        bgView.layer.borderWidth = 3;
        bgView.layer.borderColor = [BG_COLOR CGColor];
        bgView.layer.masksToBounds = YES;
        bgView.layer.cornerRadius = 10;
        [self addSubview:bgView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-30, 10, 60, 60)];
        imageView.layer.cornerRadius = 30;
        imageView.layer.masksToBounds = YES;
        
        NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE,rootURL2,imageStr];
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"mine_head"]];
        [self addSubview:imageView];
        //
        UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, frame.size.width, 20)];
        titleLable.text = title;
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleLable];
        
        UILabel *DetailLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 95, frame.size.width, 20)];
               DetailLable.text = detailTitle;
               DetailLable.textAlignment = NSTextAlignmentCenter;
               DetailLable.font = [UIFont systemFontOfSize:12];
               [self addSubview:DetailLable];
    }
    return self;
}
@end
