//
//  StateCollectHeadView.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/20.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "StateCollectHeadView.h"

@interface StateCollectHeadView()
{
    
}

@property (nonatomic, strong)UILabel *firstLabel;
@property (nonatomic, strong)UILabel *secondLabel;
@property (nonatomic, strong)UILabel *thirdLabel;

@property (nonatomic, strong)UIImageView *smallLineView;



@end
@implementation StateCollectHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self addOtherSubViewUIMethrod];
    }
    return self;
}

-(void)addOtherSubViewUIMethrod {
    
    
       // 根据字体得到NSString的尺寸
       CGSize size = [@"名医视频" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil]];
    
    self.firstLabel = [self createLabelFrame:CGRectMake((CGRectGetWidth(self.frame)/3 - size.width)/3, 0, size.width, CGRectGetHeight(self.frame)) title:@"科普文章" textColor:TEXT_COLOR_MAIN textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:16]];
    [self addSubview:self.firstLabel];
    self.secondLabel = [self createLabelFrame:CGRectMake((CGRectGetWidth(self.frame)/3 - size.width)/3+CGRectGetWidth(self.frame)/3, 0, size.width, CGRectGetHeight(self.frame)) title:@"名医视频" textColor:TEXT_COLOR_DETAIL textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:16]];
    [self addSubview:self.secondLabel];
    self.thirdLabel = [self createLabelFrame:CGRectMake((CGRectGetWidth(self.frame)/3- size.width)/3+ CGRectGetWidth(self.frame)*2/3, 0, size.width, CGRectGetHeight(self.frame)) title:@"专家讲座" textColor:TEXT_COLOR_DETAIL textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:16]];
       [self addSubview:self.thirdLabel];
    self.smallLineView = [self createImageViewFrame:CGRectMake((CGRectGetWidth(self.frame) - 10)/3, CGRectGetHeight(self.frame) -  3, 20, 3) imageName:@"message_small_line"];
    [self addSubview:self.smallLineView];
    
    for (NSInteger i = 0; i<3; i++) {
        UIButton *sender = [self createBtnFrame:CGRectMake(CGRectGetWidth(self.frame)/3*i, 0, CGRectGetWidth(self.frame)/3, CGRectGetHeight(self.frame)) title:nil bgImage:nil selectBgImage:nil image:nil target:self action:@selector(ViewButtonClickAction:)];
        sender.tag = 800+i;
        [self addSubview:sender];
    }
    
       
    
}
- (UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title bgImage:(NSString *)bgImageName selectBgImage:(NSString *)selectImageName image:(NSString *)imageName target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
//    btn.cjr_acceptEventInterval = 0.5;
    [btn setTitle:title forState:UIControlStateNormal];
    //字体颜色修改为黑色
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.showsTouchWhenHighlighted = NO;
    btn.adjustsImageWhenHighlighted = NO;
    if (imageName) {
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
    if (bgImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
        
//        [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateHighlighted];
    }
    
    //选中图片
    if (selectImageName) {
//        [btn setBackgroundImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    }

    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    if (imageName.length>0) {
//         imgView.image = [UIImage imageNamed:imageName];
        imgView.backgroundColor = BLUE_COLOR_MAIN;
    }
    imgView.contentMode =  UIViewContentModeScaleAspectFill;
//    imgView.clipsToBounds = YES;
   
    return imgView;
}
- (UILabel *)createLabelFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)color textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    if (title.length > 0) {
         label.text = title;
    }
    label.textColor = color;
    label.textAlignment = textAlignment;
//    [label adjustsFontSizeToFitWidth];
    label.font = font;
    return label;
}


-(void)ViewButtonClickAction:(UIButton *)sender {
    _selectIndex = sender.tag - 800;
    [self updateLineViewFrame];
    if (_viewButtonClickBlock) {
        self.viewButtonClickBlock(sender, _selectIndex);
    }
}

-(void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    [self updateLineViewFrame];
}

-(void)updateLineViewFrame {
    if (_selectIndex == 0) {
           self.firstLabel.textColor = TEXT_COLOR_MAIN;
           self.secondLabel.textColor = TEXT_COLOR_DETAIL;
           self.thirdLabel.textColor = TEXT_COLOR_DETAIL;
    }else if (_selectIndex == 1){
        self.firstLabel.textColor = TEXT_COLOR_DETAIL;
        self.secondLabel.textColor = TEXT_COLOR_MAIN;
        self.thirdLabel.textColor = TEXT_COLOR_DETAIL;
    } else {
          self.firstLabel.textColor = TEXT_COLOR_DETAIL;
          self.secondLabel.textColor = TEXT_COLOR_DETAIL;
          self.thirdLabel.textColor = TEXT_COLOR_MAIN;
       }
    WS
    [UIView animateWithDuration:0.5f animations:^{
        weakSelf.smallLineView.frame = CGRectMake((CGRectGetWidth(weakSelf.frame)/3 - 10)/3 +CGRectGetWidth(weakSelf.frame)/3*weakSelf.selectIndex , CGRectGetHeight(weakSelf.frame) -  3, 20, 3);
    } completion:^(BOOL finished){
        
    }];
}

@end
