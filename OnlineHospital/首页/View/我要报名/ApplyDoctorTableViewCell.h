//
//  ApplyDoctorTableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/21.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApplyDoctorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UIButton *btnAttention;
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labDetail;
@property (assign, nonatomic)BOOL isAttention;
@end

NS_ASSUME_NONNULL_END
