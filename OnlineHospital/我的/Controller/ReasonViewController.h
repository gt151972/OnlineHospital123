//
//  ReasonViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/11/27.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ReasonDelegate <NSObject>

-(void)reason:(NSString *)value;
@end
@interface ReasonViewController : UIViewController
@property (nonatomic, assign)id <ReasonDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
