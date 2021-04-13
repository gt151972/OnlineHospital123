//
//  VIPApplyViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/1/11.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol VIPApplyViewControllerDelegate <NSObject>

- (void)vipApplyBtnClicked:(NSInteger )item;

@end
@interface VIPApplyViewController : UIViewController
@property (nonatomic , assign) id<VIPApplyViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *labDetail;
@property (nonatomic,strong) NSString  *numFamous;
@property (nonatomic,strong) NSString  *numLetures;
@end

NS_ASSUME_NONNULL_END
