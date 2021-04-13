//
//  GTLoginTextField.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/14.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "GTLoginTextField.h"

@implementation GTLoginTextField

+(GTLoginTextField *)textFieldWithPlaceholder:(NSString *)placeholder{
    GTLoginTextField *text = [[GTLoginTextField alloc] initWithFrame:CGRectMake(14, 14, Screen_W - 68, 22)];
    text.textColor = TEXT_COLOR_MAIN;
    text.font = [UIFont systemFontOfSize:16];
    text.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *placeholder1 = [[NSMutableAttributedString alloc] initWithString:placeholder];
    [placeholder1 addAttribute:NSForegroundColorAttributeName
                            value:TEXT_COLOR_DETAIL
                            range:NSMakeRange(0, placeholder.length)];
    text.attributedPlaceholder = placeholder1;
    return text;
}

@end
