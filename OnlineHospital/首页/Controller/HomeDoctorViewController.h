//
//  HomeDoctorViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/19.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeDoctorViewController : BaseViewController
@property(nonatomic, strong) NSString *strDoctorID;
@property(nonatomic, strong) DoctorModel *model;
@end

NS_ASSUME_NONNULL_END
