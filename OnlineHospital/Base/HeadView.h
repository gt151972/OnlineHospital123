//
//  HeadView.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/22.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HeadViewDelegate <NSObject>

- (void)passMoreHeadView: (UIView *)headView title: (NSString *)title ;
@end

@interface HeadView : UIView
@property(nonatomic,assign)id<HeadViewDelegate> onTapBtnViewDelegate;

- (instancetype)initWithTitle: (NSString *)title  isMore:(BOOL)isMore;
- (instancetype)initWithFrame: (CGRect)frame title: (NSString *)title  isMore:(BOOL)isMore;
@end
NS_ASSUME_NONNULL_END
