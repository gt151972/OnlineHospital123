//
//  BaseViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/20.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController
-(UIView*)flowerNavigationViewWithTitle:(NSString *)title;

-(UIView*)applyNavigationViewWithTitle:(NSString *)title right:(NSString *)right;

-(UIView*)vipNavigationViewWithTitle:(NSString *)title right:(NSString *)right;

- (void)btnRightClicked;
@end



NS_ASSUME_NONNULL_END
