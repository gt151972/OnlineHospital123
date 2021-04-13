//
//  MineInfoTableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineInfoTableViewCell : UITableViewCell<UICollectionViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *labtitle;
@property (weak, nonatomic) IBOutlet UILabel *labDetail;
@property (weak, nonatomic) IBOutlet UIImageView *imageHead;
@property (weak, nonatomic) IBOutlet UIImageView *imageVip;

@end

NS_ASSUME_NONNULL_END
