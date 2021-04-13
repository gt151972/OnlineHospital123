//
//  RecommandTableViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/18.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "RecommandTableViewCell.h"
#import "ZAMTBtnView.h"
#import "DoctorModel.h"

#define cell_w Screen_W-24
#define item_w (Screen_W-72)/3
@interface RecommandTableViewCell ()<UIScrollViewDelegate>

@end
@implementation RecommandTableViewCell
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
    int page1;
    if (_menuArray.count <= 0) {
        page1 = 0;
    }else{
        page1 = (_menuArray.count-1)/3;
        NSLog(@"page1 == %d",page1);
    }
    // UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(12, 0, cell_w, 160)];
    scrollView.contentSize = CGSizeMake((page1 + 1)*Screen_W, 160);
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.backgroundColor = BG_COLOR_WHITE;
    [self.contentView addSubview:scrollView];
    for (int index = 0 ; index <= page1; index ++) {
        UIView *backview =  [[UIView alloc] initWithFrame:CGRectMake(12 + Screen_W*page1, 0, cell_w, 140)];
        backview.tag = page1+100;
//        backview.backgroundColor = [UIColor redColor];
        [scrollView addSubview:backview];
    }
    // 轮播图第一页
//    _backView1 = [[UIView alloc] initWithFrame:CGRectMake(12, 0, cell_w, 140)];
//
//    // 轮播图第二页
//    _backView2 = [[UIView alloc] initWithFrame:CGRectMake(Screen_W + 12, 0, cell_w, 140)];
//    _backView3 = [[UIView alloc] initWithFrame:CGRectMake(Screen_W*2 +12, 0, cell_w, 140)];
//
//
//    [scrollView addSubview:_backView1];
//    [scrollView addSubview:_backView2];
//    [scrollView addSubview:_backView3];
   
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(12, 160, Screen_W - 24, 10)];
    view.backgroundColor = BG_COLOR_WHITE;
    [self addSubview:view];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(REDIUS,REDIUS)];
         CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = view.bounds;
         maskLayer.path = maskPath.CGPath;
         view.layer.mask = maskLayer;
    //创建8个view
    for (int i = 0; i < _menuArray.count; i++) {
        int index = i%3;
        int page = i/3;
//        NSLog(@"i == %d == %d == %d",i,index,page);
    
        CGRect frame = CGRectMake(i*item_w + 12*(i+1) + 12*page , 0, item_w, 140);
        //            NSString *title = [_menuArray[i] objectForKey:@"title"];
        //            NSString *imageStr = [_menuArray[i] objectForKey:@"image"];
        DoctorModel *model = _menuArray[i];
                    NSString *title = model.name;
        NSString *detailTitle = model.department;
                    NSString *imageStr =model.icon;
        ZAMTBtnView *btnView = [[ZAMTBtnView alloc] initWithFrame:frame title:title detailTitle:detailTitle imageStr:imageStr];
                    btnView.tag = 10+i;
//        _backView1 = (UIView *)[self viewWithTag:100+page];
        [scrollView addSubview:btnView];
//                    if (page == 0) {
//                        [_backView1 addSubview:btnView];
//                    }else if (page == 1){
//                        [_backView2 addSubview:btnView];
//                    }else{
//                        [_backView3 addSubview:btnView];
//                    }
//
        
                    // 点击手势
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOneView:)];
                    [btnView addGestureRecognizer:tap];
        
    }
    
    //UIPageControl
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((Screen_W -97)/2, 160, 0, 10)];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = page1+1;
    [self addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (self);
        make.bottom.mas_equalTo(self);
    }];
    
    [_pageControl setCurrentPageIndicatorTintColor:TEXT_COLOR_MAIN];
    [_pageControl setPageIndicatorTintColor:TEXT_COLOR_DETAIL];
}

#pragma mark -手势点击事件

-(void)tapOneView:(UITapGestureRecognizer *)sender{
    
    if ([self.onTapBtnViewDelegate respondsToSelector:@selector(OnTapBtnView:)]) {
        
        [self.onTapBtnViewDelegate OnTapBtnView:sender];
    }
    
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    _pageControl.currentPage = page;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
