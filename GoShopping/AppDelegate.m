//
//  AppDelegate.m
//  GoShopping
//
//  Created by qianfeng on 15/11/19.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "AppDelegate.h"

#import "MyHeader.h"


#import "FifthViewController.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "SixthViewController.h"



#import "JYSlideSegmentController.h"
#import "SearchViewController.h"
#import "UserViewController.h"
#import "AllSubjectViewController.h"

#import "UMSocial.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


-(JYSlideSegmentController *)createMainController
{
    NSMutableArray *controllers = [NSMutableArray array];
    NSArray *names = [NSArray arrayWithObjects:@"首页",@"国内",@"海淘",@"原创",@"众测",@"资讯", nil];
    
    
    //首页
    FirstViewController *first = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    [controllers addObject:first];
    
    
    //国内
    SecondViewController *second = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    [controllers addObject:second];
    
    
    //海淘
    ThirdViewController *third = [[ThirdViewController alloc] initWithNibName:@"ThirdViewController" bundle:nil];
    [controllers addObject:third];
    
    
    
    //原创
    FourthViewController *fourth = [[FourthViewController alloc] initWithNibName:@"FourthViewController" bundle:nil];
    [controllers addObject:fourth];
    
    
    //众测
    FifthViewController *fifth =[[FifthViewController alloc] initWithNibName:@"FifthViewController" bundle:nil];
    [controllers addObject:fifth];
    
    
    //资讯
    SixthViewController *sixth = [[SixthViewController alloc] initWithNibName:@"SixthViewController" bundle:nil];
    [controllers addObject:sixth];
    
    
    
    
    JYSlideSegmentController *slider = [[JYSlideSegmentController alloc] initWithViewControllers:controllers Names:names];
    slider.indicatorInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    slider.indicator.backgroundColor = [UIColor redColor];
    
    return slider;
    
}
-(void)createTabbarController
{
    //值得买
    
    JYSlideSegmentController *jvc = [self createMainController];
    jvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"值得买" image:[UIImage imageNamed:@"mainNormal"] selectedImage:[UIImage imageNamed:@"mainSeleted"]];
    UINavigationController *mainNavi = [[UINavigationController alloc] initWithRootViewController:jvc];
    
    
    //发现
    SearchViewController *searchView = [[SearchViewController alloc] init];
    searchView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"goodsNormal"] selectedImage:[UIImage imageNamed:@"goodsseleted"]];
    UINavigationController *searchNavi = [[UINavigationController alloc] initWithRootViewController:searchView];
    
    //百科
    AllSubjectViewController *allSubjectView = [[AllSubjectViewController alloc] init];
    allSubjectView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"收藏" image:[UIImage imageNamed:@"dingyueItemNormal"] selectedImage:[UIImage imageNamed:@"dingyueItemSelected"]];
    UINavigationController *allSubjectNavi = [[UINavigationController alloc] initWithRootViewController:allSubjectView];
    
    //用户
    UserViewController *userView = [[UserViewController alloc] init];
    userView.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"personNormal"] selectedImage:[UIImage imageNamed:@"personSeleted"]];
    UINavigationController *userNavi = [[UINavigationController alloc] initWithRootViewController:userView];
    
    
    
    //标签栏控制器
    UITabBarController *tvc = [[UITabBarController alloc] init];
    tvc.tabBar.tintColor = [UIColor redColor];
    tvc.viewControllers = @[mainNavi,searchNavi,allSubjectNavi,userNavi];
    self.window.rootViewController = tvc;
    
    
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //注册友盟
    [UMSocialData setAppKey:@"564986a4e0f55a15e0001aa8"];
    
    
    
    [self createTabbarController];
    [self.window makeKeyAndVisible];
    
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
