//
//  ListViewController.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/3/30.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol ListViewControllerDelegate <NSObject>

- (void)ListViewClicked:(NSIndexPath *)indexPath;

@end
@interface ListViewController : UIViewController
@property (nonatomic , assign) id<ListViewControllerDelegate> delegate;
@property (nonatomic,strong) NSArray *questionArray;
@end


NS_ASSUME_NONNULL_END
