//
//  LGTabBarController.m
//  haoshuimian365
//
//  Created by apple on 2017/6/19.
//  Copyright © 2017年 CYY. All rights reserved.
//  自定义tabBar:首页、社区、商城、我的

#import "LGTabBarController.h"
#import "LGNavigationController.h"

#import "HomeViewController.h"
#import "ArticleViewController.h"
#import "WebViewController.h"
#import "MessageViewController.h"
#import "MineViewController.h"
#import "GTArticalViewController.h"


@interface LGTabBarController ()

@end

@implementation LGTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UITabBar appearance].translucent = NO;
    [self creatTabBar];
}

- (void)creatTabBar{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:viewPix(10)];
    
//    attrs[NSForegroundColorAttributeName] = [titleColor3 colorWithAlphaComponent:1];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = BLUE_COLOR_MAIN;
    
    
    UITabBarItem *item = [UITabBarItem appearance];
  [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
  [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];

//    self.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor colorWithString:@"191546"]];
//    [self.tabBarController.tabBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithString:@"191546"]]];
    self.tabBar.backgroundColor = [UIColor whiteColor];
//    NSLog(@"tabBar : %@ ",self.tabBar.items ) ;
    
//    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, Screen_W, 20)];
//    [shadowView.layer addSublayer:[self shadowAsInverse]];
//    [self.tabBar addSubview:shadowView];
    
    
//
//    [self setupChildVc:[HomeViewController new] title:@"首页" image:@"shouyetab2" selectedImage:@"shouyetab1"];
    
    
    if (@available(iOS 13.0, *)) {
           UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
           if (mode == UIUserInterfaceStyleDark) {
               [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
           }
    }
    
    
    [self setupChildVc:[HomeViewController new] title:@"首页" image:@"tab_home_nomal" selectedImage:@"tab_home_select"];
     [self setupChildVc:[MessageViewController new] title:@"消息" image:@"tab_message_nomal" selectedImage:@"tab_message_select"];
    [self setupChildVc:[ArticleViewController new] title:@"科普" image:@"tab_article_nomal" selectedImage:@"tab_article_select"];
    [self setupChildVc:[MineViewController new] title:@"我的" image:@"tab_mine_nomal" selectedImage:@"tab_mine_select"];
}


#pragma mark---setChildVC
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{

    // 设置文字和图片
//    vc.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    LGNavigationController *nav = [[LGNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
    
   
}

-(void)viewDidLayoutSubviews{
    [self printViewHierarchy:self.view];
}
//view树
- (void)printViewHierarchy:(UIView *)superView
{
    static uint level = 0;
    for(uint i = 0; i < level; i++){
        printf("\t");
    }

    const char *className = NSStringFromClass([superView class]).UTF8String;
    const char *frame = NSStringFromCGRect(superView.frame).UTF8String;
    printf("%s:%s\n", className, frame);

    ++level;
    for(UIView *view in superView.subviews){
        [self printViewHierarchy:view];
    }
    --level;
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)shouldAutorotate {
    return [self.selectedViewController  shouldAutorotate];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
