//
//  WebViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/4/1.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate, WKScriptMessageHandler>
@property (nonatomic, strong)WKWebView *webview;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        self.webview = [[WKWebView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, Screen_W, Screen_H-SafeAreaTopHeight) configuration:wkWebConfig];
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://pre-release.jyhk.com/duoermei-h5/#/pages/Register/Home/Index"]]];
    self.webview.navigationDelegate = self;
        self.webview.UIDelegate = self;
    [self.webview.configuration.userContentController addScriptMessageHandler:self name:@"demObjToken"];
        
        [self.view addSubview:self.webview];
}
//- (WKWebView *)webview{
//    if (_webview == nil) {
//        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://test.article.demzhmzb.com/?token=4c1ac3f4977d0011d41f8ca601ce0340"]]];
//    }
//    return _webview;
//}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSLog(@"---%@===%@", message.name, message.body, [[message.frameInfo.request URL] absoluteString]);
    
    
    if ([message.name isEqualToString:@"demJianHuTransImageMethord"]) {
        
        [SVProgressHUD showInfoWithStatus:message.body];
        
    }
}
@end
