//
//  HomeGrideView.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HomeGrideViewDelegate <NSObject>

- (void)homeGridePass:(NSInteger )item;

@end
@interface HomeGrideView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (nonatomic , assign) id<HomeGrideViewDelegate> delegate;
- (IBAction)btnClicked:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
