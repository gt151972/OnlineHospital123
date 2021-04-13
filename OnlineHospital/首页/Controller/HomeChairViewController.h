//
//  HomeChairViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/19.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PassValueDelegate <NSObject>

-(void)passValue:(NSString *)value;
@end
@interface HomeChairViewController : UIViewController
@property (nonatomic, assign)id <PassValueDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
