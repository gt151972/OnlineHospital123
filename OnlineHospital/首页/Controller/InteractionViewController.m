//
//  InteractionViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2020/8/22.
//  Copyright © 2020 高天的Mac. All rights reserved.
//

#import "InteractionViewController.h"
#import "OrderPayViewController.h"
@interface InteractionViewController ()<UITextViewDelegate>{
    NSString *strPlaceholder;
}
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation InteractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    strPlaceholder = @"请输入问题描述，如发病时间，主要病症，治疗经过，目前状况，最少输入20个字。";
    self.title = @"互动问题";
    self.view.backgroundColor = BG_COLOR;
    
    GTBlueButton *botton = [GTBlueButton blueButtonWithFrame:CGRectMake(27, 232, Screen_W - 54, 50) ButtonTitle:@"提交"];
    [botton addTarget:self action:@selector(postEnroll) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:botton];
    
    _textView.editable = YES;
    _textView.delegate = self;
    _textView.textColor = TEXT_COLOR_DETAIL;
    _textView.font = [UIFont systemFontOfSize:14];
    //设置return键的类型
    _textView.returnKeyType = UIReturnKeyDefault;
    //设置键盘类型一般为默认
    _textView.keyboardType = UIKeyboardTypeDefault;
    //文本显示的位置默认为居左
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.text = strPlaceholder;
    _textView.layer.borderWidth = 5;
    _textView.layer.borderColor = BG_COLOR.CGColor;
    _textView.layer.cornerRadius = REDIUS;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:strPlaceholder]) {
        textView.text = @"";
        textView.textColor = TEXT_COLOR_MAIN;
    }
}

//-(void)btnClick{
//    [self postEnroll];
//    OrderPayViewController *vc = [[OrderPayViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//}


#pragma mark -----报名直播
- (void)postEnroll{
    if ([_textView.text isEqualToString:strPlaceholder] || _textView.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"互动问题不能为空"];
        return;
    }
    NSString *url = [NSString stringWithFormat:POST_ENROLL,rootURL];
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setObject:_strLiveID forKey:@"liveId"];//直播id
    [parameDic setObject:[NSNumber numberWithInt:2] forKey:@"type"];
    [parameDic setObject:_textView.text forKey:@"question"];
    [RequestUtil POST:url parameters:parameDic withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSDictionary *respDic = [responseObject objectForKey:@"result"];
        self.model =[EnrollModel mj_objectWithKeyValues:respDic];
        if ([responseObject[@"code"] intValue] == 0) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ApplyHasDid"
//                                                                object:nil
//                                                              userInfo:nil];
            OrderPayViewController *vc = [[OrderPayViewController alloc] init];
            vc.type = 2;
            vc.strID = self.model.orderId;
            vc.enrollModel = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
