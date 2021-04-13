//
//  VipTypeTableViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/11/2.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "VipTypeTableViewCell.h"
#import "PrivilegeCollectionViewCell.h"
#define cell_w Screen_W-24
#define item_w (Screen_W-72)/3
static NSString *identifier = @"PrivilegeCollectionViewCell";
@interface VipTypeTableViewCell ()<UIScrollViewDelegate,UICollectionViewDelegate, UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collecitonView;
@end
@implementation VipTypeTableViewCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSMutableArray *)menuArray{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.menuArray = [NSMutableArray array];
        
        self.menuArray = menuArray;
        
        // 初始化cell布局
        [self setUpSubViews];
        
    }
    return self;
}

#pragma mark -初始化cell布局

- (void)setUpSubViews {
    self.backgroundColor = [UIColor clearColor];
    int page = self.menuArray.count/3 + 1;
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(12, 0, cell_w, 146)];
//    scrollView.contentSize = CGSizeMake(page*Screen_W, 146);
//    scrollView.pagingEnabled = YES;
//    scrollView.delegate = self;
//    scrollView.showsHorizontalScrollIndicator = NO;
//    scrollView.backgroundColor = BG_COLOR_WHITE;
//    [self.contentView addSubview:scrollView];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(CGRectGetWidth(self.frame)/4.0f, 70);
        //横向滚动
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collecitonView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.frame), 70) collectionViewLayout:layout];
        self.collecitonView.backgroundColor = [UIColor whiteColor];
        self.collecitonView.delegate = self;
        self.collecitonView.dataSource = self;
        [self.contentView addSubview:self.collecitonView];
        [self.collecitonView registerClass:[PrivilegeCollectionViewCell class] forCellWithReuseIdentifier:identifier];
        self.collecitonView.pagingEnabled = YES;
         
    for (int index = 0; index < page; index ++) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(12+ Screen_W*index, 0, cell_w, 146)];
    }
}

//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    int page = self.menuArray.count/3 + 1;
//    return  page ;
//
//}

#pragma mark -- UICollectionDataSource
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arrayTitle = @[@"连续1月", @"连续3月", @"连续6月", @"连续3月", @"连续6月"];
    NSArray *arrayPrice = @[@"￥368", @"￥248", @"￥108", @"￥248", @"￥108"];
    PrivilegeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.labTitle.text = [arrayTitle objectAtIndex:indexPath.item];
    cell.labPrice.text = [arrayPrice objectAtIndex:indexPath.item];
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
//    index = indexPath.item;
//    [self.collectionView reloadData];
//    [self.delegate passTool:indexPath.item];
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
