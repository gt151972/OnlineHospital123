//
//  StateVideoTableViewCell.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/20.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "StateVideo2TableViewCell.h"

@implementation StateVideo2TableViewCell
- (void)layoutSubviews{
    self.labQuestion.text = _orderModel.questionContent;
    if ([_orderModel.typeCode isEqualToString:@"FamousAudit"]) {
        self.labTitle.text = @"名医视频-旁听";
    }else if ([_orderModel.typeCode isEqualToString:@"FamousInteract"]){
        self.labTitle.text = @"名医视频-互动";
    }else if([_orderModel.typeCode isEqualToString:@"Lecture"]){
        self.labTitle.text = @"专家讲座";
    }
    if (_type == 1) {
        [self addModelView];
    }else if(_type == 2){
        [self addEnrollModelView];
    }else{
        [self addFamousModelView];
    }
    if (_isShowDate) {
        _labMoney.hidden = YES;
        _labPay.hidden = NO;
        _labAllMoney.hidden = NO;
        _labAllTitle.hidden = NO;
        _labPay.text = [NSString stringWithFormat:@"提交时间: %@",[BaseDataChange getDateStringWithTimeStr:_orderModel.createdDate]];
        _labAllMoney.text = _orderModel.normalAmount;
        _line.hidden = YES;
    }else{
        _labPay.hidden = NO;
        _labMoney.hidden = NO;
        _labAllMoney.hidden = YES;
        _labAllTitle.hidden = YES;
    }
    if (_isReturn) {
        _labState.hidden = YES;
    }else{
        _labState.hidden = NO;
    }
}

- (void)addModelView{
    NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE,rootURL2,_model.icon];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"mine_head"]];
    if ([_model.typeCode isEqualToString:@"FamousAudit"]) {
        self.labTitle.text = @"名医视频-旁听";
    }else if ([_model.typeCode isEqualToString:@"FamousInteract"]){
        self.labTitle.text = @"名医视频-互动";
    }else if([_model.typeCode isEqualToString:@"Lecture"]){
        self.labTitle.text = @"专家讲座";
    }
    self.labContent.text =  _model.liveTitle;
    self.labQuestion.text =  _model.content;
    self.labMoney.text = _model.paidAmount;
    self.labDoctor.text = [NSString stringWithFormat:@"%@ | %@ | %@",_model.doctorName, _model.title, _model.department];
    self.labTime.text = [NSString stringWithFormat:@"直播开始时间: %@", [BaseDataChange getDateStringWithTimeStr:_model.startDate]];
    switch ([_model.liveStatus intValue]) {
        case 1:{
            self.labLiveStatus.text = @"未开始";
            self.labLiveStatus.textColor = BLUE_COLOR_MAIN;
        }
            break;
        case 2:
        {
            self.labLiveStatus.text = @"报名中";
            self.labLiveStatus.textColor = ORANGE_COLOR_MAIN;
        }
            break;
        case 3:{
            self.labLiveStatus.text = @"直播中";
            self.labLiveStatus.textColor = GREEN_COLOR_MAIN;
        }
            break;
        case 4:{
            self.labLiveStatus.text = @"已结束";
            self.labLiveStatus.textColor = TEXT_COLOR_MAIN;
        }
            break;
        case 5:{
            self.labLiveStatus.text = @"已取消";
            self.labLiveStatus.textColor = TEXT_COLOR_MAIN;
        }
            break;

        default:
            break;
    }
    NSString *strPay = [NSString stringWithFormat:@"总价 ¥%.2f   ",[_model.normalAmount floatValue]];
//    NSString *str =[NSString stringWithFormat:@"总价 ¥%@.00  已退款",model.paidAmount];
//    cell.labPay.attributedText = [self getPriceAttribute:str pay:model.paidAmount];
    switch ([_model.payStatus intValue]) {//0：待支付，1：已支付，2：已消费，3：申请退款，4：已超时，5：已退款
        case 0:
            self.labPay.text = [NSString stringWithFormat:@"%@待付款¥",strPay];
            self.labMoney.text = _model.normalAmount;
            break;
        case 1:
            self.labPay.text = [NSString stringWithFormat:@"%@已支付¥",strPay];
            break;
        case 2:
            self.labPay.text = [NSString stringWithFormat:@"%@已消费¥",strPay];
            break;
        case 3:
            self.labPay.text = [NSString stringWithFormat:@"%@已支付¥",strPay];
            break;
        case 4:
            self.labPay.text = [NSString stringWithFormat:@"%@待付款¥",strPay];
            self.labMoney.text = _model.normalAmount;
            break;
        case 5:
            self.labPay.text = [NSString stringWithFormat:@"%@已退款¥",strPay];
            break;

        default:
            break;
    }
//    self.labMoney.text = _model.paidAmount;
    switch ([_model.payStatus intValue]) {//0：待支付，1：已支付，2：已消费，3：申请退款，4：已超时，5：已退款
        case 0:
            self.labState.text = @"待支付";
            break;
        case 1:
            self.labState.text = @"已支付";
            break;
        case 2:
            self.labState.text = @"已退款";
            break;
        case 3:
            self.labState.text = @"退款中";
            break;
        case 4:
            self.labState.text = @"已超时";
            break;
            
        default:
            break;
    }
}

-(void)addEnrollModelView{
    NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE,rootURL2,_enrollModel.icon];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"mine_head"]];
//    if ([_enrollModel.liveType intValue] == 1) {
//        if ([_enrollModel.enrollType intValue] == 2) {
//            self.labTitle.text = @"名医视频-旁听";
//        }else if ([_enrollModel.enrollType intValue] == 1){
//            self.labTitle.text = @"名医视频-互动";
//        }else{
//            self.labTitle.text = @"名医视频";
//        }
//    }else if ([_enrollModel.liveType intValue] == 2){
//        self.labTitle.text = @"专家讲座";
//    }
    self.labContent.text = _enrollModel.liveTitle ;
    NSLog(@"_enrollModel.doctorName == %@\n _enrollModel.doctorDepartment == %@",_enrollModel.doctorName,_enrollModel.doctorDepartment);
    self.labDoctor.text = [NSString stringWithFormat:@"%@ | %@ | %@",_enrollModel.doctorName, _enrollModel.doctorTitle, _enrollModel.doctorDepartment];
    self.labTime.text = [NSString stringWithFormat:@"直播开始时间: %@", [BaseDataChange getDateStringWithTimeStr:_enrollModel.startDate]];
    switch ([_enrollModel.liveStatus intValue]) {
        case 1:{
            self.labLiveStatus.text = @"未开始";
            self.labLiveStatus.textColor = BLUE_COLOR_MAIN;
        }
            break;
        case 2:
        {
            self.labLiveStatus.text = @"报名中";
            self.labLiveStatus.textColor = ORANGE_COLOR_MAIN;
        }
            break;
        case 3:{
            self.labLiveStatus.text = @"直播中";
            self.labLiveStatus.textColor = GREEN_COLOR_MAIN;
        }
            break;
        case 4:{
            self.labLiveStatus.text = @"已结束";
            self.labLiveStatus.textColor = TEXT_COLOR_MAIN;
        }
            break;
        case 5:{
            self.labLiveStatus.text = @"已取消";
            self.labLiveStatus.textColor = TEXT_COLOR_MAIN;
        }
            break;
            
        default:
            break;
    }
    NSString *strPay = [NSString stringWithFormat:@"总价 ¥%.2f   ",[_enrollModel.price floatValue]];
//    NSString *str =[NSString stringWithFormat:@"总价 ¥%@.00  已退款",model.paidAmount];
//    cell.labPay.attributedText = [self getPriceAttribute:str pay:model.paidAmount];
    switch ([_enrollModel.status intValue]) {//0：待支付，1：已支付，2：已消费，3：申请退款，4：已超时，5：已退款
        case 0:
            self.labPay.text = [NSString stringWithFormat:@"%@待付款¥",strPay];
            break;
        case 1:
            self.labPay.text = [NSString stringWithFormat:@"%@已支付¥",strPay];
            break;
        case 2:
            self.labPay.text = [NSString stringWithFormat:@"%@已消费¥",strPay];
            break;
        case 3:
            self.labPay.text = [NSString stringWithFormat:@"%@已支付¥",strPay];
            break;
        case 4:
            self.labPay.text = [NSString stringWithFormat:@"%@待付款¥",strPay];
            break;
        case 5:
            self.labPay.text = [NSString stringWithFormat:@"%@已退款¥",strPay];
            break;
            
        default:
            break;
    }
    self.labMoney.text = _enrollModel.price;
    switch ([_orderModel.status intValue]) {//0：待支付，1：已支付，2：已消费，3：申请退款，4：已超时，5：已退款
        case 0:
            self.labState.text = @"待支付";
            break;
        case 1:
            self.labState.text = @"已支付";
            break;
        case 2:
            self.labState.text = @"已退款";
            break;
        case 3:
            self.labState.text = @"退款中";
            break;
        case 4:
            self.labState.text = @"已超时";
            break;
            
        default:
            break;
    }
}

-(void)addFamousModelView{
    NSString *imagePath = [NSString stringWithFormat:POST_OSS_DOWNDATE,rootURL2,_famousModel.doctorIcon];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"mine_head"]];
//FamousInteract:名医视频--互动,FamousAudit:名医视频--旁听,Lecture:专家讲座--旁听,VIP:vip礼包。Recharge:充值
   
    self.labContent.text =  _famousModel.title;
    self.labDoctor.text = [NSString stringWithFormat:@"%@ | %@ | %@",_famousModel.doctorName, _famousModel.doctorTitle, _famousModel.doctorDepartment];
    self.labTime.text = [NSString stringWithFormat:@"直播开始时间: %@", [BaseDataChange getDateStringWithTimeStr:_famousModel.startDate]];
    switch ([_famousModel.liveStatus intValue]) {
        case 1:{
            self.labLiveStatus.text = @"未开始";
            self.labLiveStatus.textColor = BLUE_COLOR_MAIN;
        }
            break;
        case 2:
        {
            self.labLiveStatus.text = @"报名中";
            self.labLiveStatus.textColor = ORANGE_COLOR_MAIN;
        }
            break;
        case 3:{
            self.labLiveStatus.text = @"直播中";
            self.labLiveStatus.textColor = GREEN_COLOR_MAIN;
        }
            break;
        case 4:{
            self.labLiveStatus.text = @"已结束";
            self.labLiveStatus.textColor = TEXT_COLOR_MAIN;
        }
            break;
        case 5:{
            self.labLiveStatus.text = @"已取消";
            self.labLiveStatus.textColor = TEXT_COLOR_MAIN;
        }
            break;

        default:
            break;
            
            
    }
    NSString *strPay = [NSString stringWithFormat:@"订单金额   ¥%.2f   ",[_orderModel.normalAmount floatValue]];
    self.labPay.text = strPay;
    self.labMoney.hidden = YES;
    switch ([_orderModel.status intValue]) {//0：待支付，1：已支付，2：已消费，3：申请退款，4：已超时，5：已退款
        case 0:
            self.labState.text = @"待支付";
            break;
        case 1:
            self.labState.text = @"已支付";
            break;
        case 2:
            self.labState.text = @"已退款";
            break;
        case 3:
            self.labState.text = @"退款中";
            break;
        case 4:
            self.labState.text = @"已超时";
            break;
            
        default:
            break;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tapHead:(UITapGestureRecognizer *)sender {
    
}
- (IBAction)btnHeadClicked:(UIButton *)sender {
}

-(NSString *) decimalwithFloatV:(NSString *)strNum{
    float num = [strNum floatValue];
NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
[numberFormatter setPositiveFormat:@"0.00"];
return [numberFormatter stringFromNumber:[NSNumber numberWithFloat:num]];
}
@end
