//
//  LiveAcrossViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/4/6.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import "LiveAcrossViewController.h"

#import "LiveSelectView.h"
#import "liveTableViewCell.h"
#import "ApplyDoctorTableViewCell.h"
#import "ApplyDetailTableViewCell.h"
#import "ApplyFooterTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
 #import <AVKit/AVKit.h>
#import <MediaPlayer/MPVolumeView.h>
#import "AppDelegate.h"
#import "ParameterModel.h"
#import "QuestionModel.h"
#import <AliRTCSdk/AliRTCSdk.h>
#import "RtcModel.h"
#import "RTCSampleRemoteUserManager.h"
#import "OrderPayViewController.h"
#import <IMSLinkVisualMedia/IMSLinkVisualMedia.h>
#import "LiveOnByeViewController.h"
#import "ListViewController.h"
#import "RTCManager.h"
#import "UserInfoModel.h"
#import "VIPApplyViewController.h"
static NSString *identifier2 = @"liveTableViewCell";
static NSString *identifierDoctor = @"ApplyDoctorTableViewCell";
static NSString *identifierDetail = @"ApplyDetailTableViewCell";
static NSString *identifierFoot = @"ApplyFooterTableViewCell";
@interface LiveAcrossViewController ()<UITableViewDelegate, UITableViewDataSource,AliRtcEngineDelegate,IMSLinkVisualDelegate,VIPApplyViewControllerDelegate,ListViewControllerDelegate>{
    int isOpen;
     BOOL isAttention;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UIView *viewBG;
@property (nonatomic, assign)int selectIndex;
@property (nonatomic, assign)int isVIP;
//@property (nonatomic, strong)AVPlayerViewController *playerVc;
@property (nonatomic, strong)IMSLinkVisualPlayerViewController *playerVc;
/**
 @brief SDK管理
 */
@property (nonatomic, strong) RTCManager *rtcManager;
/**
 @brief 远端用户管理
 */
@property (nonatomic, strong)ParameterModel *model;
@property (nonatomic, strong)UIView *viewDoctor;
@property (nonatomic, strong)RtcModel *rtcModel;

@property (nonatomic, strong)UILabel *labTitle;
@property (nonatomic, strong)UILabel *labDetail;
@property (nonatomic, strong)NSMutableArray *questionArray;
@property (nonatomic, strong)EnrollModel *enrollModel;

@property (nonatomic, strong)AliRenderView *patient;
/**
 @brief SDK实例
 */
@property (nonatomic, strong) AliRtcEngine *engine;
/**
 @brief 远端用户管理
 */
@property(nonatomic, strong) RTCSampleRemoteUserManager *remoteUserManager;

/**
@brief 主屏显示的用户
*/
@property(nonatomic,strong) RTCSampleRemoteUserModel *remoteUsermodel;

/**
 @brief 是否入会
 */
@property(nonatomic, assign) BOOL isJoinChannel;
@end

@implementation LiveAcrossViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotation = NO;
    [self supportRotion:UIInterfaceOrientationPortrait];
}
- (void)supportRotion:(int)rotion
{
    NSNumber *value = [NSNumber numberWithInt:rotion];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (BOOL)shouldAutorotate

{

return NO;

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationLandscapeLeft;;
}


- (BOOL)prefersStatusBarHidden
{
    return NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).allowRotation = YES;
    [self supportRotion:UIInterfaceOrientationLandscapeLeft];
    _remoteUserManager = [RTCSampleRemoteUserManager shareManager];
    if ([_model.startDate intValue] < [[BaseDataChange getTimestampFromTime] intValue] ) {
        [self postMeetingparams];
    }else{
        [self initView];
    }
    
}


#pragma mark ------页面控件
- (void)initView{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [self.view addGestureRecognizer:tap];
        [tap addTarget:self action:@selector(viewTouch)];
    _viewBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W,  Screen_W)];
    _viewBG.backgroundColor = [UIColor clearColor];
    [self.view addSubview : _viewBG] ;
    
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight - 44, 44, 44)];
    [btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view  addSubview:btnBack];
    WS
    [[btnBack rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
        [weakSelf.engine leaveChannel];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    UIButton *btnClose= [[UIButton alloc] initWithFrame:CGRectMake(Screen_W - 44, SafeAreaTopHeight - 44, 44, 44)];
    [btnClose setImage:[UIImage imageNamed:@"bs-gb"] forState:UIControlStateNormal];
    [self.view  addSubview:btnClose];
    [[btnClose rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
        [weakSelf.engine leaveChannel];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UIButton *btnRefresh= [[UIButton alloc] initWithFrame:CGRectMake(Screen_W - 44 - 69, SafeAreaTopHeight - 44, 69, 44)];
    [btnRefresh setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.view addSubview:btnRefresh];
    [[btnRefresh rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
        [self postMeetingparams];
    }];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(14, Screen_H - 64, 34, 34)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.55];
    view.layer.cornerRadius = 10;
    [self.view  addSubview:view];
    MPVolumeView *volumeView   = [[MPVolumeView alloc] init];
    volumeView.showsRouteButton = NO;
    UISlider *volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]) {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
            volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    
    // change system volume, the value is between 0.0f and 1.0f
    [volumeViewSlider setValue:0.3f animated:NO];

    // send UI control event to make the change effect right now. 立即生效
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
    volumeView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    [volumeView setFrame:CGRectMake(21, Screen_H - 34 - 30 -150, 34, 150)];
//    volumeView.backgroundColor = [UIColor redColor];
        [self.view  addSubview:volumeView];
    volumeView.hidden = YES;
    UIButton *btnVoice = [[UIButton alloc] initWithFrame:CGRectMake(14, Screen_H - 64, 34, 34)];
//    [btnVoice setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.55]];
    [btnVoice setImage:[UIImage imageNamed:@"zb-sy"] forState:UIControlStateNormal];
    btnVoice.layer.cornerRadius = 10;
    [[btnVoice rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
        x.selected = !x.selected;
        if (x.selected) {
            volumeView.hidden = NO;
            view.frame = CGRectMake(14, Screen_H - 64 - 150, 34, 186);
        }else{
            volumeView.hidden = YES;
            view.frame = CGRectMake(14, 172, 34, 34);
            view.frame = CGRectMake(14, Screen_H - 64, 34, 34);
        }
        NSLog(@"%d",volumeView.hidden);
    }];
    [self.view  addSubview:btnVoice];
    
    UIButton *btnTb = [[UIButton alloc] initWithFrame:CGRectMake(Screen_W - 54, Screen_H - 64, 34, 34)];
    [btnTb setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.55]];
    [btnTb setImage:[UIImage imageNamed:@"zb-zx"] forState:UIControlStateNormal];
    btnTb.layer.cornerRadius = 10;
    [self.view  addSubview:btnTb];
    [[btnTb rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
        [self postQuestion:1];
    }];
    
    [self.view  addSubview:self.tableView];
    self.tableView.hidden = YES;
}
#pragma mark - initializeSDK
/**
 @brief 初始化SDK
 */
- (void)initializeSDK{
    // 创建SDK实例，注册delegate，extras可以为空
    _remoteUserManager = [RTCSampleRemoteUserManager shareManager];
    _engine = [AliRtcEngine sharedInstance:self extras:@""];
    
}
- (void)startPreview{
//    [self patientView];
    
  
    // 设置本地预览视频
    AliVideoCanvas *canvas   = [[AliVideoCanvas alloc] init];
    AliRenderView *viewLocal = [[AliRenderView alloc] initWithFrame:CGRectMake(100,100,100,100)];
    canvas.view = viewLocal;
    canvas.renderMode = AliRtcRenderModeCrop;
    [self.view addSubview:viewLocal];
    [self.engine setLocalViewConfig:canvas forTrack:AliRtcVideoTrackCamera];
//    [self.engine setDeviceOrientationMode:AliRtcOrientationModeLandscapeLeft];//
    // 开启本地预览
    [self.engine startPreview];
    self.viewDoctor = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view insertSubview: self.viewDoctor belowSubview:viewLocal];
    [self initView];
}

- (void)patientView{
    self.patient = [[AliRenderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.patient .backgroundColor = [UIColor greenColor];
    RTCSampleRemoteUserModel *model =  [self.remoteUserManager allOnlineUsers][0];
    self.patient = model.view;
    [self.view addSubview:self.patient];

}


#pragma mark - action (需手动填写鉴权信息)

/**
 @brief 登陆服务器，并开始推流
 */
- (void)joinBegin{
    

    NSArray <NSString *> *agent =  @[@""];
    
    
    //配置SDK
    //设置自动(手动)模式
    [self.engine setAutoPublish:YES withAutoSubscribe:YES];
    
    //随机生成用户名，仅是demo展示使用
    NSString *userName = [NSString stringWithFormat:@"iOSUser%u",arc4random()%1234];
    
    //AliRtcAuthInfo:各项参数均需要客户App Server(客户的server端) 通过OpenAPI来获取，然后App Server下发至客户端，客户端将各项参数赋值后，即可joinChannel
    AliRtcAuthInfo *authInfo = [[AliRtcAuthInfo alloc] init];
    authInfo.appid = _rtcModel.appId;
    authInfo.user_id = _rtcModel.userId;//_rtcModel.userId;
    authInfo.channel = _rtcModel.conferenceId;
    authInfo.nonce = _rtcModel.nonce;
    authInfo.timestamp = [_rtcModel.timestamp intValue];
    authInfo.token = _rtcModel.token;
    authInfo.gslb = _rtcModel.gslb;
    authInfo.agent = agent;
    
    //加入频道
    [self.engine joinChannel:authInfo name:userName onResult:^(NSInteger errCode) {
        //加入频道回调处理
        NSLog(@"joinChannel result: %d", (int)errCode);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errCode != 0) {
                //入会失败
                NSLog(@"入会失败");
            }
            _isJoinChannel = YES;
        });
    }];
    [self postConsumption];
    [self.engine setVideoProfile:AliRtcVideoProfile_1080_1920P_30 forTrack:AliRtcVideoTrackCamera];
}

#pragma mark - alirtcengine delegate

- (void)onAudioSampleCallback:(AliRtcAudioSource)audioSource audioSample:(AliRtcAudioDataSample *)audioSample{
    NSLog(@"onAudioSampleCallback");
}
- (void)onVideoSampleCallback:(NSString *)uid videoSource:(AliRtcVideoSource)videoSource videoSample:(AliRtcVideoDataSample *)videoSample{
    NSLog(@"onVideoSampleCallback == %@",uid);
}

- (void)onSubscribeChangedNotify:(NSString *)uid audioTrack:(AliRtcAudioTrack)audioTrack videoTrack:(AliRtcVideoTrack)videoTrack {
    NSLog(@"onSubscribeChangedNotify == %@",uid);
//    收到远端订阅回调
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.remoteUserManager updateRemoteUser:uid forTrack:videoTrack];
        AliVideoCanvas *canvas = [[AliVideoCanvas alloc] init];
        canvas.renderMode = AliRtcRenderModeFill;
        canvas.view = [self.remoteUserManager cameraView:uid];
        [self.rtcManager setRemoteViewConfig:canvas uid:uid forTrack:AliRtcVideoTrackCamera];
        RTCSampleRemoteUserModel *teacherCamera = [self.remoteUserManager findUser:uid forTrack:AliRtcVideoTrackCamera];
        self.remoteUsermodel = teacherCamera;
        AliRenderView *curView = nil;
        [_remoteUsermodel.view setFrame:self.viewDoctor.bounds];
        [_remoteUsermodel.view.subviews.firstObject setFrame:self.viewDoctor.bounds];
        [self.viewDoctor addSubview:_remoteUsermodel.view];
        curView = _remoteUsermodel.view;
        [self.engine setRemoteViewConfig:canvas uid:uid forTrack:AliRtcVideoTrackCamera];
       });
}

- (void)setRemoteUsermodel:(RTCSampleRemoteUserModel *)remoteUsermodel {
    if (remoteUsermodel) {
        [self.rtcManager configRemoteTrack:_remoteUsermodel.uid preferMaster:NO enable:YES];
        [self.rtcManager subscribe:_remoteUsermodel.uid onResult:^(NSString * _Nonnull uid, AliRtcVideoTrack vt, AliRtcAudioTrack at) {
            
        }];
    }
    
    _remoteUsermodel = remoteUsermodel;
           
    [self setupMainRenderView];
}
-(void)setupMainRenderView{
    AliRenderView *curView = nil;
    if(_remoteUsermodel){
        [_remoteUsermodel.view setFrame:self.viewDoctor.bounds];
        [_remoteUsermodel.view.subviews.firstObject setFrame:self.viewDoctor.bounds];
        [self.viewDoctor addSubview:_remoteUsermodel.view];
        curView = _remoteUsermodel.view;
//        curView.hidden = _remoteUsermodel.videoMuted;
        curView.tag = 100;
    }

    int delTag = 100;
    if(self.viewDoctor.subviews.count>1){
        for (UIView *view in self.viewDoctor.subviews) {
            if(view!=curView && view.tag ==delTag){
                [view removeFromSuperview];
            }
        }
    }

}
- (void)onRemoteUserOnLineNotify:(NSString *)uid {
    NSLog(@"uid == %@",uid);
    [self.patient removeFromSuperview];
}

- (void)onRemoteUserOffLineNotify:(NSString *)uid {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.remoteUserManager remoteUserOffLine:uid];
//        [self.remoteUserView reloadData];
    });
}

- (void)onOccurError:(int)error {
    NSLog(@"AliRtcErr == %d",error);
    if (error == AliRtcErrSessionRemoved) {
        // timeout - leaveChannel.
//        [self showAlertWithMessage:@"Session已经被移除,请点击确定退出" handler:^(UIAlertAction * _Nonnull action) {
//            [self leaveChannel:nil];
//        }];
        NSLog(@"Session已经被移除,请点击确定退出");
    }
    else if (error == AliRtcErrIceConnectionHeartbeatTimeout) {
//        [self showAlertWithMessage:@"信令心跳超时，请点击确定退出" handler:^(UIAlertAction * _Nonnull action) {
//            [self leaveChannel:nil];
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrJoinBadAppId) {
//        [self showAlertWithMessage:@"AppId不存在，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"AppId不存在，请重新pub、sub(仅提示)");
    }
    else if (error == AliRtcErrJoinInvalidAppId) {
//        [self showAlertWithMessage:@"AppId已失效，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"AppId已失效，请重新pub、sub(仅提示)");
    }
    else if (error == AliRtcErrJoinBadChannel) {
//        [self showAlertWithMessage:@"频道不存在，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"频道不存在，请重新pub、sub(仅提示)");
    }
    else if (error == AliRtcErrJoinInvalidChannel) {
//        [self showAlertWithMessage:@"频道已失效，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrJoinBadToken) {
//        [self showAlertWithMessage:@"token不存在，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrJoinTimeout) {
//        [self showAlertWithMessage:@"加入频道超时，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrJoinBadParam) {
//        [self showAlertWithMessage:@"参数错误，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrMicOpenFail) {
//        [self showAlertWithMessage:@"采集设备初始化失败，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrSpeakerOpenFail) {
//        [self showAlertWithMessage:@"播放设备初始化失败，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrMicInterrupt) {
//        [self showAlertWithMessage:@"采集过程中出现异常，请重新join(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrSpeakerInterrupt) {
//        [self showAlertWithMessage:@"播放过程中出现异常，请重新join(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrMicAuthFail) {
//        [self showAlertWithMessage:@"麦克风设备未授权，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrMicNotAvailable) {
//        [self showAlertWithMessage:@"无可用的音频采集设备，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrSpeakerNotAvailable) {
//        [self showAlertWithMessage:@"无可用的音频播放设备，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrCameraOpenFail) {
//        [self showAlertWithMessage:@"采集设备初始化失败，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrCameraInterrupt) {
//        [self showAlertWithMessage:@"采集过程中出现异常，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrDisplayOpenFail) {
//        [self showAlertWithMessage:@"渲染设备初始化失败，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrDisplayInterrupt) {
//        [self showAlertWithMessage:@"渲染过程中出现异常，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrIceConnectionConnectFail) {
//        [self showAlertWithMessage:@"媒体通道建立失败，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrIceConnectionReconnectFail) {
//        [self showAlertWithMessage:@"媒体通道重连失败，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrSdkInvalidState) {
//        [self showAlertWithMessage:@"sdk状态错误，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
    else if (error == AliRtcErrInner) {
//        [self showAlertWithMessage:@"其他错误，请重新pub、sub(仅提示)" handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
        NSLog(@"信令心跳超时，请点击确定退出");
    }
}

- (void)onBye:(int)code {
    NSLog(@"AliRtcOnByecode == %d",code);
    if (code == AliRtcOnByeBeKickedOut) {
        [SVProgressHUD showSuccessWithStatus:@"互动结束"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark ----获取咨询列表
     - (void)postQuestion: (int)type{//type:0竖屏 type:1横屏
    NSLog(@"-------%@",self.pid);
    NSString *url = [NSString stringWithFormat:POST_QUESTION,rootURL];
    NSString *string = self.pid;
    [RequestUtil POST:url parameters:string withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSArray *respArr = [responseObject objectForKey:@"result"];
        self.questionArray = [NSMutableArray array];
        self.questionArray = [QuestionModel mj_objectArrayWithKeyValuesArray:respArr];
        if(type == 0){
            [self postMeetingparams];
            [self.tableView reloadData];
        }else{
            ListViewController *vc= [[ListViewController alloc] init];
            vc.delegate = self;
            vc.questionArray = _questionArray;
            [self.navigationController presentViewController:vc animated:NO completion:nil];
        }
       
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)ListViewClicked:(NSIndexPath *)indexPath{
    [self postQuestion:1];
}


#pragma mark ----获取会议参数
- (void)postMeetingparams{
    NSLog(@"-------%@",self.pid);
    NSString *url = [NSString stringWithFormat:POST_MEETINGPARAMS,rootURL];
    NSString *string =  self.pid;
    __weak __typeof__(self) weakSelf = self;
    [RequestUtil POST:url parameters:string withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
        NSDictionary *respDic = [responseObject objectForKey:@"result"];
        self.rtcModel =[RtcModel mj_objectWithKeyValues:respDic];
        //初始化SDK内容
        [self initializeSDK];
        
        //开启本地预览
        [self startPreview];
        
        //加入房间
        [self joinBegin];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


#pragma mark ----消费订单-当用户跳转视频，或直播时调用次接口修改订单状态为已消费
- (void)postConsumption{
    NSString *url = [NSString stringWithFormat:POST_CONSUMPTION,rootURL];
    WS
    [RequestUtil POST:url parameters:_model.orderId withMask:NO withSign:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"responseObject == %@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


@end
