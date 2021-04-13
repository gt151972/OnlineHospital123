//
//  GTBlueButton.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/14.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GTBlueButton : UIButton

/// 蓝色大按钮
/// @param frame <#frame description#>
/// @param buttonTitle <#buttonTitle description#>
+(GTBlueButton *)blueButtonWithFrame:(CGRect)frame ButtonTitle:(NSString *)buttonTitle;


/// 白色大按钮
/// @param frame <#frame description#>
/// @param buttonTitle <#buttonTitle description#>
+(GTBlueButton *)whiteButtonWithFrame:(CGRect)frame ButtonTitle:(NSString *)buttonTitle;

/// 蓝字小按钮
/// @param frame <#frame description#>
/// @param buttonTitle <#buttonTitle description#>
+(GTBlueButton *)minBlueButtonWithFrame:(CGRect)frame ButtonTitle:(NSString *)buttonTitle;

/// 金色
/// @param frame <#frame description#>
/// @param buttonTitle <#buttonTitle description#>
+(GTBlueButton *)glodButtonWithFrame:(CGRect)frame ButtonTitle:(NSString *)buttonTitle;

/// 黑色
/// @param frame <#frame description#>
/// @param buttonTitle <#buttonTitle description#>
+(GTBlueButton *)blackButtonWithFrame:(CGRect)frame ButtonTitle:(NSString *)buttonTitle;
@end

NS_ASSUME_NONNULL_END
