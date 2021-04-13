//
//  DoctorVideoTableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/18.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//@protocol DoctorVideoTableViewCellDelegate <NSObject>
//- (void)goDoctor:(NSInteger )item ;
//- (void)collectDoctor: (UIButton *)button;
//@end
typedef enum : NSUInteger {
    LivingStateWillStart = 1,//报名未开始
    LivingStateApplying = 2,//报名中
    LivingStateLiving = 3,//直播中
    LivingStateEnd = 4,//直播结束
} LivingState;
@interface DoctorVideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgeView;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labDoctor;
@property (weak, nonatomic) IBOutlet UILabel *labState;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UIButton *btnGo;
@property (weak, nonatomic) IBOutlet UIButton *btnAttention;
//@property (weak, nonatomic)id<DoctorVideoTableViewCellDelegate> delegate;
@property(nonatomic, assign)LivingState LivingState;
//- (IBAction)btnCollectClicked:(UIButton *)sender;
//- (IBAction)btnGoClicked:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_END
