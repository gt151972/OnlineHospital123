//
//  PrivilegeTableViewCell2.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/17.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "PrivilegeTableViewCell2.h"
#import "PrivilegeCollectionViewCell.h"

#import "VipTypeModel.h"
static NSString *identifier = @"PrivilegeCollectionViewCell";
@interface PrivilegeTableViewCell2()<UICollectionViewDelegate, UICollectionViewDataSource>{
    NSInteger index;
}
@end
@implementation PrivilegeTableViewCell2

- (void)layoutSubviews{
    [super layoutSubviews];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake((Screen_W-24-48)/3.0f, 120);
        flowLayout.minimumInteritemSpacing = 20;
        flowLayout.minimumLineSpacing = 20.0f;
//        flowLayout.itemSize = CGSizeMake(Screen_W/3.0-0, Screen_H/4.0);
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        //设置代理
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = BG_COLOR_WHITE;
//    if (self.menuArray.count/3 > 0) {
        self.collectionView.collectionViewLayout = flowLayout;
//    }
    [self.collectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];

//        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
}
#pragma mark -- UICollectionDataSource
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSLog(@"menuArray.count == %lu",(unsigned long)_menuArray.count);
    return _menuArray.count;
    
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    if (self.menuArray.count > 3) {
        return 8;
    }else{
        return 16;
    }
    
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSArray *arrayTitle = @[@"连续1月", @"连续3月", @"连续6月", @"连续3月", @"连续6月"];
//    NSArray *arrayPrice = @[@"￥368", @"￥248", @"￥108", @"￥248", @"￥108"];
    VipTypeModel *model = [_menuArray objectAtIndex:indexPath.item];
    PrivilegeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.labTitle.text = model.name;
    cell.labPrice.text = model.price;
//    cell.labTitle.text = arrayTitle[indexPath.item];
//    cell.labPrice.text = arrayTitle[indexPath.item];

    if (indexPath.item == index) {
        cell.bgView.layer.borderColor = TEXT_COLOR_GLOD2.CGColor;
        cell.bgView.backgroundColor = [UIColor colorWithRed:227/255.0 green:181/255.0 blue:147/255.0 alpha:0.05];
    }else{
        cell.bgView.layer.borderColor = BG_COLOR.CGColor;
        cell.bgView.backgroundColor = BG_COLOR_WHITE;
    }
    [cell sizeToFit];
    return cell;
}


//头部展示的内容
//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
//
//    return headView;
//}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((Screen_W-24-48)/3.0f, 120);
}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 8, 8, 8);
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 8;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    index = indexPath.item;
    [self.collectionView reloadData];
    [self.delegate vipCardPass:indexPath.item];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
