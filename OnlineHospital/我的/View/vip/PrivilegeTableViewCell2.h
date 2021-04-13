//
//  PrivilegeTableViewCell2.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/17.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PrivilegeTableViewCell2Delegate <NSObject>

- (void)vipCardPass:(NSInteger )item;

@end
@interface PrivilegeTableViewCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic , assign) id<PrivilegeTableViewCell2Delegate> delegate;
// 数组
@property(nonatomic,copy)NSMutableArray *menuArray;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray;
@end

NS_ASSUME_NONNULL_END
