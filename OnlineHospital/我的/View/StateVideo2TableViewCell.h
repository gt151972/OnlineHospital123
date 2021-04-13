//
//  StateVideoTableViewCell.h
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/20.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "videoOrderModel.h"
#import "EnrollModel.h"
#import "FamousModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface StateVideo2TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnHeadClicked;//头像点击跳转医生主页
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labContent;
@property (weak, nonatomic) IBOutlet UILabel *labDoctor;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labLiveStatus;
@property (weak, nonatomic) IBOutlet UILabel *labPay;
@property (weak, nonatomic) IBOutlet UILabel *labQuestion;
@property (weak, nonatomic) IBOutlet UILabel *labMoney;
@property (weak, nonatomic) IBOutlet UILabel *labState;
@property (weak, nonatomic) IBOutlet UILabel *labAllTitle;
@property (weak, nonatomic) IBOutlet UILabel *labAllMoney;
@property (weak, nonatomic) IBOutlet UIView *line;

@property (strong, nonatomic)videoOrderModel *model;
@property (strong, nonatomic)EnrollModel *enrollModel;
@property (strong, nonatomic)FamousModel *famousModel;
@property (assign, nonatomic)int type;
@property (assign, nonatomic)BOOL isShowDate;
@property (assign, nonatomic)BOOL isReturn;
@property (strong, nonatomic)OrderModel *orderModel;
@end

NS_ASSUME_NONNULL_END
