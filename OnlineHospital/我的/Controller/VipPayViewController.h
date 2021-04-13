//
//  VipPayViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/22.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol VipPayDelegate <NSObject>

- (void)vipPay: (int)type;

@end
@interface VipPayViewController : UIViewController
@property (nonatomic, assign)id<VipPayDelegate>delegate;
@property (nonatomic,strong) NSString *strFamous;
@property (nonatomic,strong) NSString *strLecture;
@property (weak, nonatomic) IBOutlet UILabel *labFamous;
@property (weak, nonatomic) IBOutlet UILabel *labLecture;
@end

NS_ASSUME_NONNULL_END
