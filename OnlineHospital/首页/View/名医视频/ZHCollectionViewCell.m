//
//  ZHCollectionViewCell.m
//  CollectionViewAdaptiveWinth
//
//  Created by chaoxing-dev on 17/3/16.
//  Copyright © 2017年 chaoxing-dev. All rights reserved.
//

#import "ZHCollectionViewCell.h"

@implementation ZHCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        
        UILabel * label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [self addSubview:label];
        self.label = label;
        
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
//    self.label.frame = CGRectMake(0, 0, self.bounds.size.width + 20, self.bounds.size.height + 20);
    self.label.frame = self.bounds;
}
@end
