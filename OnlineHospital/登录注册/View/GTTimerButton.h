//
//  GTTimerButton.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/14.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTTimerButton : UIButton
+(GTTimerButton *)button;
-(void)openCountdown: (UIButton *)btn;
@end

NS_ASSUME_NONNULL_END
