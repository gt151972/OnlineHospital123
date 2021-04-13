//
//  HomeSearchView.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "HomeSearchView.h"

@implementation HomeSearchView

+(HomeSearchView *)homeSearchViewWithFrame:(CGRect)frame title:(NSString *)title{
    HomeSearchView *view = [[HomeSearchView alloc] initWithFrame:frame];
    view.backgroundColor = BG_COLOR_WHITE;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 10;
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(13, 13, 14, 14)];
    UIImage *image = [UIImage imageNamed:@"home_search"];
    imageview.image = image;
    [view addSubview:imageview];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.height, 0, frame.size.width - frame.size.height, frame.size.height)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = TEXT_COLOR_DETAIL;
    label.textAlignment = NSTextAlignmentLeft;
     [view addSubview:label];
    return view;
}
@end
