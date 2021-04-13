//
//  LiveAcrossViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/4/6.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FamousModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LiveAcrossViewController : UIViewController
@property (nonatomic, strong)NSString *pid;
@property (nonatomic, assign)BOOL isFamous;
@property (nonatomic, strong)FamousModel *famouModel;
//@property (nonatomic,assign) livingChannel channel;
@end

NS_ASSUME_NONNULL_END
