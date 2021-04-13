//
//  CollectArticalTableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/20.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectArticalTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageArtical;
@property (weak, nonatomic) IBOutlet UIButton *btnCollect;

@end

NS_ASSUME_NONNULL_END
