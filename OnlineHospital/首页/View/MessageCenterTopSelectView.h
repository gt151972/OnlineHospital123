//
//  MessageCenterTopSelectView.h
//  DuoErJianHu
//
//  Created by Jack's Mac on 2020/5/12.
//  Copyright © 2020 daibing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ViewButtonClickBlock)(UIButton *sender, NSInteger index);

@interface MessageCenterTopSelectView : UIView


@property (nonatomic, assign)NSInteger selectIndex;
@property (nonatomic, assign)BOOL showLeftRedPoint;
@property (nonatomic, assign)BOOL showRightRedPoint;

@property (nonatomic, copy)ViewButtonClickBlock viewButtonClickBlock;


@end

NS_ASSUME_NONNULL_END
