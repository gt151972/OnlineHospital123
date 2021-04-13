//
//  HomeGrideView.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "HomeGrideView.h"
#define space 12.0f //两边间隙
#define distance 8.0f //上下间隙

#define btn1_w Screen_W - (space *8)
#define btn1_h 79
#define btn2_w Screen_W - (space *5)
#define btn2_h 80
@implementation HomeGrideView
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"HomeGrideView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}
- (IBAction)btnClicked:(UIButton *)sender{
    [self.delegate homeGridePass:sender.tag];
}
@end
