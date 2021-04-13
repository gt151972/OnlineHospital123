//
//  VipTypeTableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/11/2.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol VipTypeTableViewCellDelegate <NSObject>
// 轮播图手势点击代理
- (void)VipTypeClicked:(UITapGestureRecognizer *)sender;
//- (void)btnHeadClicked:()

@end
@interface VipTypeTableViewCell : UITableViewCell
// 数组
@property(nonatomic,copy)NSMutableArray *menuArray;
// 轮播图手势点击代理
@property(nonatomic,assign)id<VipTypeTableViewCellDelegate> delegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray;
@end

NS_ASSUME_NONNULL_END
