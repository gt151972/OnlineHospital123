//
//  GTDataSource.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/1/22.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^CellConfigureBefore)(id cell, id model, NSIndexPath * indexPath);
@interface GTDataSource : NSObject<UITableViewDataSource,UICollectionViewDataSource>
@property (nonatomic, strong)  NSMutableArray *dataArray;;

//自定义
- (id)initWithIdentifier:(NSString *)identifier configureBlock:(CellConfigureBefore)before;

//
@property (nonatomic, strong) IBInspectable NSString *cellIdentifier;

@property (nonatomic, copy) CellConfigureBefore cellConfigureBefore;


- (void)addDataArray:(NSArray *)datas;

- (id)modelsAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
