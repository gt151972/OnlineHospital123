//
//  GTWebViewViewController.m
//  OnlineHospital
//
//  Created by 高天的Mac on 2021/3/12.
//  Copyright © 2021 高天的Mac. All rights reserved.
//

#import "GTWebViewViewController.h"
#import "JSObject.h"
@interface GTWebViewViewController ()<UIWebViewDelegate>
@property (nonatomic, strong)UIWebView *webView;
@property (nonatomic, strong)JSContext *context;
@end

@implementation GTWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    [self createUIWebViewTest];
}

- (void)setupNavigationItem{
    // 后退按钮
    UIButton * goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [goBackButton setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
    [goBackButton addTarget:self action:@selector(goBackAction:) forControlEvents:UIControlEventTouchUpInside];
    goBackButton.frame = CGRectMake(0, 0, 30, StatusBarAndNavigationBarHeight);
    UIBarButtonItem * goBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:goBackButton];
    
    self.navigationItem.leftBarButtonItems = @[goBackButtonItem];
   
    self.navigationController.navigationBar.translucent = YES;
}
- (void)goBackAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
//    [_webView goBack];
}
- (void)createUIWebViewTest {
    // 1.创建webview
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    
    // 2.1 创建一个远程URL
    NSURL *remoteURL = [NSURL URLWithString:_strPath];
    // 3.创建Request
    NSURLRequest *request =[NSURLRequest requestWithURL:remoteURL];
    // 4.加载网页
    [webView loadRequest:request];
    // 5.最后将webView添加到界面
    [self.view addSubview:webView];
    webView.delegate = self;
    self.webView = webView;
}

//是否允许加载网页，也可获取js要打开的url，通过截取此url可与js交互
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
                                                 navigationType:(UIWebViewNavigationType)navigationType;{
    return YES;
}
//开始加载网页
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
//网页加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    //取得html内容
    NSLog(@"%@",[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"]);
    // 获得UIWebView中加载页面的链接地址
        NSString *urlStr = [webView stringByEvaluatingJavaScriptFromString:
            @"location.href"];
        NSLog(@"%@", urlStr);
    if (_webView.scrollView.mj_header.state == MJRefreshStateRefreshing)
    {
    [_webView.scrollView.mj_header endRefreshing];
    }
        self.context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        JSObject *jsObject = [JSObject new];
        self.context[@"demObj"] = jsObject;
        NSString *strToken = @"demObj.token()";
        [self.context evaluateScript:strToken];
    NSString *strToken2 = @"demObj.token2()";
    [self.context evaluateScript:strToken2];
}
//网页加载错误
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

@end
