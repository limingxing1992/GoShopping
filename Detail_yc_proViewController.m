//
//  Detail_yc_proViewController.m
//  WorthToBuy
//
//  Created by qianfeng on 15/11/16.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "Detail_yc_proViewController.h"

#import "MyHeader.h"
#import <AFNetworking.h>
#import "AppManger.h"
#import "AppModel.h"
#import "AppStore.h"


#import <UIKit+AFNetworking.h>
#import <MMProgressHUD.h>
#import "UMSocial.h"


@interface Detail_yc_proViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property(nonatomic,copy)NSString *url;

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,strong)UIImageView *imageView;

@property(nonatomic,strong)UIScrollView *backScrollView;

@property(nonatomic,strong)UILabel *title_label;
@property(nonatomic,strong)UILabel *price_lable;


@end

@implementation Detail_yc_proViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.url = [NSString stringWithFormat:kDetai_yc_pro_url,self.type,self.Id,self.channal_id];
    
    
    [self customNavi];
    [self customView];
    [self customShop];
    [self requestData];



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 设置购买链接和分享按钮
-(void)customShop
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    
    view.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:view];
    
    //购买链接按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth- 100, 0, 100, 50)];
    
    button.showsTouchWhenHighlighted  =YES;
    
    [button setTitle:@"直达链接" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onShop) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    //分享按钮
    UIButton *buttonShare = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    buttonShare.showsTouchWhenHighlighted = YES;
    [buttonShare setTitle:@"分享" forState:UIControlStateNormal];
    [buttonShare addTarget:self action:@selector(onShare) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonShare];
    
    //返回按钮
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    buttonBack.center = CGPointMake(kScreenWidth/2, 25);
    buttonBack.showsTouchWhenHighlighted = YES;
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonBack];
    

}

#pragma mark -按钮方法
-(void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onShop
{
    
    if ([AppStore sharedInstance].detailYC_ProData) {
        AppModel *model = [AppStore sharedInstance].detailYC_ProData[0];
        NSLog(@"%@",model.article_link);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.article_url]];
    }

}

-(void)onShare
{
    
    AppModel *model = [AppStore sharedInstance].detailYC_ProData[0];
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession]];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"564986a4e0f55a15e0001aa8" shareText:model.share_title shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.share_pic]]] shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ] delegate:nil];
    
}

#pragma mark -设置导航栏和标签栏
-(void)customNavi
{

    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];
}

#pragma mark -页面指定
-(void)customView
{
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-70)];
    self.backScrollView.bounces = NO;
    [self.view addSubview:self.backScrollView];
    
    
    //图片
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    
    [self.backScrollView addSubview:self.imageView];
    
    
    //名字和价格
    self.title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 60)];
    self.title_label.numberOfLines = 0;
    
    self.price_lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 260, kScreenWidth, 30)];
    self.price_lable.textColor = [UIColor redColor];
    
    [self.backScrollView addSubview:self.title_label];
    [self.backScrollView addSubview:self.price_lable];
    
    //webView
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 290, kScreenWidth, kScreenHeight - 290)];
    self.webView.delegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    
    [self.backScrollView addSubview:self.webView];
    
    
    
    
}

#pragma mark - 数据请求
-(void)requestData
{

    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showDeterminateProgressWithTitle:@"加载中" status:@"loading"];

    [AppManger requestDataWithUrl:self.url Success:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadViews];
        });
        
        
    } Failure:^{
        
    } withBool:NO Type:kDetail_yc_proType];

}

#pragma mark -界面更新
-(void)reloadViews
{
    //图片更新
    AppModel *model = [AppStore sharedInstance].detailYC_ProData[0];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:model.article_pic] placeholderImage:[UIImage imageNamed:@"de_pic_mode_coupon"]];
    //文本更新
    self.title_label.text = model.article_title;
    self.price_lable.text = model.article_price;
    
    //网页更新
    [self.webView loadHTMLString:model.article_filter_content baseURL:nil];

}

#pragma mark -代理
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView == self.webView) {
        CGFloat height = self.webView.scrollView.contentSize.height;
        NSLog(@"%f",height);
        
        CGRect frame = self.webView.frame;
        
        frame.size.height = height;
        
        self.webView.frame = frame;
        
        self.backScrollView.contentSize = CGSizeMake(kScreenWidth, 290+height);
        [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载完成"];


    }
    

}


@end
