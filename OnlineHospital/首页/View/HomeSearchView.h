//
//  HomeSearchView.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeSearchView : UIView

/// 搜索栏
/// @param frame <#frame description#>
/// @param title <#title description#>
+(HomeSearchView *)homeSearchViewWithFrame:(CGRect)frame title:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
