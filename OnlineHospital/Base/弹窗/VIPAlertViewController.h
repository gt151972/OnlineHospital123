//
//  VIPAlertViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/1/8.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol VIPAlertViewControllerDelegate <NSObject>

- (void)VIPAlertBtnClicked:(NSInteger )item;

@end
@interface VIPAlertViewController : UIViewController
@property (nonatomic , assign) id<VIPAlertViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
