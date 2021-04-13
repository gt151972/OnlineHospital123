//
//  NullView.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/11/6.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "NullView.h"

@implementation NullView

- (instancetype)initWithTitle: (NSString *)title frame:(CGRect )frame{
    if ( self =  [super init]) {
        self.frame = frame;
          self.backgroundColor = [UIColor clearColor];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"zwrhxx"]];
        [self addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-40);
        }];
        
        UILabel *labTitle = [[UILabel alloc] init];
        [self addSubview: labTitle];
        labTitle.text = title;
        labTitle.textColor = TEXT_COLOR_DETAIL;
        labTitle.font = [UIFont systemFontOfSize:14];
        labTitle.textAlignment = NSTextAlignmentCenter;
        [labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(image.mas_bottom).offset(20);
            make.centerX.equalTo(self);
        }];
      }
        return self;
}

@end
