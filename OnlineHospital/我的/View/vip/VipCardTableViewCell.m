//
//  VipCardTableViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/17.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "VipCardTableViewCell.h"
#import "UserInfoModel.h"
@implementation VipCardTableViewCell
- (instancetype)init{
    if (self = [super init]) {
        self.strDate = @"";
    }
    return self;
}
- (void)layoutSubviews{
    if (_state == VipCardStateOFF) {
           self.labTime.hidden = YES;
           self.labGo.text = @"开通会员";
        self.labDate.text = _strDate;
       }else{
           self.labTime.hidden = NO;
           self.labGo.text = @"互动报名";
           NSDictionary *dic = [SaveData readUserInfo];
           UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:dic];
           NSString *pay1 = model.famousTimes;
           NSString *pay2 = model.lectureTimes;
           NSString *str = [NSString stringWithFormat:@"视频旁听 %@ 次权限  |  讲座旁听 %@ 次权限",pay1,pay2];
           self.labTime.text = str;
           NSMutableAttributedString *attr1 = [[NSMutableAttributedString alloc] initWithString:self.labTime.text];
           [attr1 addAttribute:NSForegroundColorAttributeName value:ORANGE_COLOR_MAIN range:NSMakeRange(5, pay1.length)];
           [attr1 addAttribute:NSForegroundColorAttributeName value:ORANGE_COLOR_MAIN range:NSMakeRange(19 + pay1.length, pay2.length)];
           [attr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(5, pay1.length)];
           [attr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(19+pay1.length, pay2.length)];
           [self.labTime setAttributedText:attr1];
//           self.labDate.hidden = YES;
           self.labDate.text = _strDate;
           self.labDate.layer.masksToBounds = YES;
           self.labDate.layer.cornerRadius = 8;
           self.labDate.backgroundColor = TEXT_COLOR_GLOD;
           self.labDate.textColor = TEXT_COLOR_GLOD2;
       }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labTitle.textColor = TEXT_COLOR_GLOD;
    self.labdetail.textColor = TEXT_COLOR_GLOD;
    self.labTime.textColor = TEXT_COLOR_GLOD;
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
