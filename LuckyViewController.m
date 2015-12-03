


//
//  LuckyViewController.m
//  WorthToBuy
//
//  Created by qianfeng on 15/11/17.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "LuckyViewController.h"

#import "MyHeader.h"

#import <AFNetworking.h>
#import <MMProgressHUD.h>

@interface LuckyViewController ()

@property(nonatomic,strong)UIWebView *webView;
@end

@implementation LuckyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    
    [self requsetData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -网页请求
-(void)requsetData
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:kLuckyUrl]];
    [self.webView loadRequest:request];
}
@end
