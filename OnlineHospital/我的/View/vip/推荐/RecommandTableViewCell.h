//
//  RecommandTableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/18.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol RecommandTableViewCellDelegate <NSObject>
// 轮播图手势点击代理
- (void)OnTapBtnView:(UITapGestureRecognizer *)sender;
//- (void)btnHeadClicked:()

@end
@interface RecommandTableViewCell : UITableViewCell
// 轮播图第一页
@property(nonatomic,strong)UIView *backView1;
// 轮播图第二页
@property(nonatomic,strong)UIView *backView2;
// 轮播图第3页
@property(nonatomic,strong)UIView *backView3;
// UIPageControl
@property(nonatomic,strong)UIPageControl *pageControl;
// 图片标题数组
@property(nonatomic,copy)NSMutableArray *menuArray;
// 轮播图手势点击代理
@property(nonatomic,assign)id<RecommandTableViewCellDelegate> onTapBtnViewDelegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray;


@end

NS_ASSUME_NONNULL_END
