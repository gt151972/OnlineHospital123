//
//  LiveOnByeViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/3/18.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol LiveOnByeViewControllerDelegate <NSObject>

- (void) LiveOnByeAlertBtnClicked:(NSString *)item;

@end
@interface LiveOnByeViewController : UIViewController
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) UIView *content;
@property (nonatomic,assign) id <LiveOnByeViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
