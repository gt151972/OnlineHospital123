//
//  GTTimerButton.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/14.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "GTTimerButton.h"

@implementation GTTimerButton

+(GTTimerButton *)button{
    GTTimerButton *button = [[GTTimerButton alloc] initWithFrame:CGRectMake(Screen_W-28-14-80, 14, 80, 22)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:TEXT_COLOR_MAIN forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentRight];
    return button;
}
-(void)openCountdown: (UIButton *)btn{

    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{

                //设置按钮的样式
                [btn setTitle:@"重新发送" forState:UIControlStateNormal];
//                [btn addTarget:self action:@selector(getInfo) forControlEvents:UIControlEventTouchUpInside];
                btn.userInteractionEnabled = YES;
            });

        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{

                //设置按钮显示读秒效果
                [btn setTitle:[NSString stringWithFormat:@"%.2ds", seconds] forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}
@end
