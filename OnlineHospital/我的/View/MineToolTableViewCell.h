//
//  MineToolTableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/16.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol MineToolTableViewCellDelegate <NSObject>

- (void)passTool:(NSInteger )item;

@end
@interface MineToolTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic)NSArray *arrayTitle;
@property (strong, nonatomic)NSArray *arrayImage;
@property (nonatomic , assign) id<MineToolTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
