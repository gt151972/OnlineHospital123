//
//  StateVideoHeadView.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/20.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ViewButtonClickBlock)(UIButton *sender, NSInteger index);

@interface StateVideoHeadView : UIView

@property (nonatomic, assign)NSInteger selectIndex;
@property (nonatomic, copy)ViewButtonClickBlock viewButtonClickBlock;

@end

NS_ASSUME_NONNULL_END
