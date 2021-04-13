//
//  GTLoginViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/14.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTLoginViewController : UIViewController

/// 头部
/// @param title <#title description#>
/// @param detailTitle <#detailTitle description#>
- (void)addNavigationtitleWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle;


/// textfield背景
/// @param frame <#frame description#>
-(UIView *)textFieldBgViewWithFrame:(CGRect)frame;


@end

NS_ASSUME_NONNULL_END
