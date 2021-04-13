//
//  TagSelectView.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/20.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagSelectView : UIView<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sectionTitle;
@property (nonatomic, assign) NSInteger level;

- (void)initTagSelectViewWithArray:(NSArray*)title;
@end

NS_ASSUME_NONNULL_END
