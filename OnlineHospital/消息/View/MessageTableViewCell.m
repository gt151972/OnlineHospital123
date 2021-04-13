//
//  MessageTableViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/19.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "MessageTableViewCell.h"


@implementation MessageTableViewCell

- (void)layoutSubviews{
    int type = [_model.type intValue];
    switch (type) {
        case 1:{//1，关注的医生开直播给予消息推送
            [self.btnState setImage:[UIImage imageNamed:@"message_kb"] forState:UIControlStateNormal];
//            [self.btnState setTitle:@"关注的医生正在直播" forState:UIControlStateNormal];
            break;
        }
        case 2:{//2，订单提交未支付给予消息提示
            [self.btnState setImage:[UIImage imageNamed:@"message_zfcg"] forState:UIControlStateNormal];
//            [self.btnState setTitle:@"退款提醒" forState:UIControlStateNormal];
            break;
        }
        case 3:{//3，订单支付成功给与提示
            [self.btnState setImage:[UIImage imageNamed:@"message_zfcg"] forState:UIControlStateNormal];
//            [self.btnState setTitle:@"报名成功提醒" forState:UIControlStateNormal];
            break;
        }
        case 4:{//4，后台管理员确认问题后给予用户提示
            [self.btnState setImage:[UIImage imageNamed:@"message_kb"] forState:UIControlStateNormal];
//            [self.btnState setTitle:@"支付成功提醒" forState:UIControlStateNormal];
            break;
        }
        case 5:{//5，用户被管理员剔除报名后退款给予提示
            [self.btnState setImage:[UIImage imageNamed:@"message_tk"] forState:UIControlStateNormal];
//            [self.btnState setTitle:@"支付成功提醒" forState:UIControlStateNormal];
            break;
        }
        case 6:{//6， 开播前1小时给予提示
            [self.btnState setImage:[UIImage imageNamed:@"message_kb"] forState:UIControlStateNormal];
//            [self.btnState setTitle:@"支付成功提醒" forState:UIControlStateNormal];
            break;
        }
        case 7:{//7开播前5分钟给予提示；
            [self.btnState setImage:[UIImage imageNamed:@"message_kb"] forState:UIControlStateNormal];
//            [self.btnState setTitle:@"支付成功提醒" forState:UIControlStateNormal];
            break;
        }
        case 8:{//8， 退费成功后给予提示
            [self.btnState setImage:[UIImage imageNamed:@"message_tk"] forState:UIControlStateNormal];
//            [self.btnState setTitle:@"支付成功提醒" forState:UIControlStateNormal];
            break;
        }
        case 9:{//9，会员付费成功
            [self.btnState setImage:[UIImage imageNamed:@"message_zfcg"] forState:UIControlStateNormal];
//            [self.btnState setTitle:@"支付成功提醒" forState:UIControlStateNormal];
            break;
        }
        case 11:{//11，.互动接入失败提醒'
            [self.btnState setImage:[UIImage imageNamed:@"message_bmcg"] forState:UIControlStateNormal];
//            [self.btnState setTitle:@"支付成功提醒" forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
    self.readView.hidden = [_model.isRead intValue];
    [self.btnState setTitle:[NSString stringWithFormat:@" %@",_model.title] forState:UIControlStateNormal];
    self.labDate.text = [BaseDataChange getDateStringWithTimeStr:_model.createdDate];
    self.labContent.text = _model.content;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.readView.hidden = YES;
    // Configure the view for the selected state
}

@end
