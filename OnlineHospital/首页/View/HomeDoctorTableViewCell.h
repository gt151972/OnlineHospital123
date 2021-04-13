//
//  HomeDoctorTableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/19.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeDoctorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labName;
@property (weak, nonatomic) IBOutlet UILabel *labSecion;
@property (weak, nonatomic) IBOutlet UIButton *btnAttention;
@property (weak, nonatomic) IBOutlet UILabel *labResume;
@property (weak, nonatomic) IBOutlet UIButton *btnServe;
@property (weak, nonatomic) IBOutlet UIImageView *imageHead;

- (IBAction)btnAttentionClicked:(UIButton *)sender;
@end

NS_ASSUME_NONNULL_END
