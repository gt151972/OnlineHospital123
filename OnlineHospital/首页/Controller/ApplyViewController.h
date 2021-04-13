//
//  ApplyViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/20.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
enum ApplyViewState{
    ApplyViewStateWillStart,//报名未开始
    ApplyViewStateDidStart,//报名已开始
    ApplyViewStateVideo,//名医视频报名界面
    ApplyViewStateLectureWillStart,//专家讲座报名未开始
    ApplyViewStateLectureDidStart,//专家讲座报名已开始
};
typedef enum ApplyViewState ApplyViewState;
@interface ApplyViewController : BaseViewController
@property (nonatomic, assign)ApplyViewState state;
@property (nonatomic, strong)NSString *pid;
@property (nonatomic, strong)NSString  *endEnrollInteractDate;
@end

NS_ASSUME_NONNULL_END
