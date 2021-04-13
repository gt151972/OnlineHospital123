//
//  MessageCenterTopSelectView.m
//  DuoErJianHu
//
//  Created by Jack's Mac on 2020/5/12.
//  Copyright © 2020 daibing. All rights reserved.
//

#import "MessageCenterTopSelectView.h"


@interface MessageCenterTopSelectView()
{
    
}

@property (nonatomic, strong)UILabel *leftLabel;

@property (nonatomic, strong)UILabel *rightLabel;

@property (nonatomic, strong)UIView *leftPointView;
@property (nonatomic, strong)UIView *rightPointView;

@property (nonatomic, strong)UIImageView *smallLineView;



@end

@implementation MessageCenterTopSelectView

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
    
    self.leftLabel = [self createLabelFrame:CGRectMake((CGRectGetWidth(self.frame)/2 - size.width)/2, 0, size.width, CGRectGetHeight(self.frame)) title:@"名医视频" textColor:TEXT_COLOR_MAIN textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:16]];
    [self addSubview:self.leftLabel];
    self.leftPointView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftLabel.frame) + 8, CGRectGetMinY(self.leftLabel.frame) +10, 8, 8)];
    self.leftPointView.layer.cornerRadius = CGRectGetHeight(self.leftPointView.frame)/2;
    self.leftPointView.layer.masksToBounds = YES;
    self.leftPointView.backgroundColor = [UIColor colorWithHexString:@"ff284e"];
    self.leftPointView.hidden = YES;
    
    [self addSubview:self.leftPointView];
    
    self.rightLabel = [self createLabelFrame:CGRectMake((CGRectGetWidth(self.frame)/2 - size.width)/2 + CGRectGetWidth(self.frame)/2, 0, size.width, CGRectGetHeight(self.frame)) title:@"专家讲座" textColor:TEXT_COLOR_DETAIL textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:16]];
       [self addSubview:self.rightLabel];
    
    self.rightPointView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.rightLabel.frame) + 8, CGRectGetMinY(self.rightLabel.frame) + 10, 8, 8)];
    self.rightPointView.layer.cornerRadius = CGRectGetHeight(self.rightPointView.frame)/2;
    self.rightPointView.layer.masksToBounds = YES;
     self.rightPointView.hidden = YES;
    self.rightPointView.backgroundColor = [UIColor colorWithHexString:@"ff284e"];
    [self addSubview:self.rightPointView];
    
    self.smallLineView = [self createImageViewFrame:CGRectMake((CGRectGetWidth(self.frame) - 10)/2, CGRectGetHeight(self.frame) -  3, 20, 3) imageName:@"message_small_line"];
    [self addSubview:self.smallLineView];
    
    for (NSInteger i = 0; i<2; i++) {
        UIButton *sender = [self createBtnFrame:CGRectMake(CGRectGetWidth(self.frame)/2*i, 0, CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)) title:nil bgImage:nil selectBgImage:nil image:nil target:self action:@selector(ViewButtonClickAction:)];
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
           self.leftLabel.textColor = [UIColor blackColor];
           self.rightLabel.textColor = TEXT_COLOR_DETAIL;
       }else {
          self.rightLabel.textColor = [UIColor blackColor];
           self.leftLabel.textColor = TEXT_COLOR_DETAIL;
       }
    WS
    [UIView animateWithDuration:0.5f animations:^{
        weakSelf.smallLineView.frame = CGRectMake((CGRectGetWidth(weakSelf.frame)/2 - 10)/2 +CGRectGetWidth(weakSelf.frame)/2*weakSelf.selectIndex , CGRectGetHeight(weakSelf.frame) -  3, 20, 3);
    } completion:^(BOOL finished){
        
    }];
}

-(void)setShowLeftRedPoint:(BOOL)showLeftRedPoint {
    _showLeftRedPoint = showLeftRedPoint;
    if (showLeftRedPoint) {
        self.leftPointView.hidden = NO;
    }else {
        self.leftPointView.hidden = YES;
    }
}
-(void)setShowRightRedPoint:(BOOL)showRightRedPoint {
    _showRightRedPoint = showRightRedPoint;
    if (showRightRedPoint) {
        self.rightPointView.hidden = NO;
    }else {
        self.rightPointView.hidden = YES;
    }
}

@end
