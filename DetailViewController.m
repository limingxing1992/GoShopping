
//
//  DetailViewController.m
//  什么值得买
//
//  Created by qianfeng on 15/11/12.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "DetailViewController.h"
#import "MyHeader.h"
#import <AFNetworking.h>
#import "AppManger.h"
#import "AppModel.h"
#import "AppStore.h"


#import <UIKit+AFNetworking.h>
#import <MMProgressHUD.h>
#import "UMSocial.h"
#import "DBManager.h"


@interface DetailViewController ()<UIWebViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@property(nonatomic,copy)NSString *url;

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UILabel *lable;

@property(nonatomic,strong)UIScrollView *backScrollView;

@property(nonatomic,strong)UILabel *title_lable;
@property(nonatomic,strong)UILabel *price_lable;

@property(nonatomic,strong)UIPageControl *pageControl;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.url = [NSString stringWithFormat:kDetailUrl,self.Id,self.type_id];
    
    [self requestData];
    [self customView];
    [self customShop];
    [self customNavi];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -定制导航栏添加收藏按钮
-(void)customNavi
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onAdd)];
}
#pragma mark -收藏功能
-(void)onAdd
{
    AppModel *model = [AppStore sharedInstance].detailYouhuiData[0];
    BOOL isFavorite = [[DBManager manager] selectWithTitle:model.article_title];
    if (!isFavorite) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"添加到收藏列表" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"亲，您已经收藏过了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark - 确定收藏
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex ==1) {
        //在此处实现将model添加到本地数据库里
        AppModel *model = [AppStore sharedInstance].detailYouhuiData[0];
        model.article_channel_id = self.type_id;
        [[DBManager manager] add:model];
    }
}

#pragma mark ------------------ 设置购买链接和分享按钮
-(void)customShop
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 35, kScreenWidth, 35)];
    
    view.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:view];
    
    //购买链接按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth- 100, 0, 100, 35)];
    
    button.showsTouchWhenHighlighted  =YES;
    
    [button setTitle:@"购买链接" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onShop) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    
    //分享按钮
    UIButton *buttonShare = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    buttonShare.showsTouchWhenHighlighted = YES;
    [buttonShare setTitle:@"分享" forState:UIControlStateNormal];
    [buttonShare addTarget:self action:@selector(onShare) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonShare];
    
    //返回按钮
    UIButton *buttonBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
    buttonBack.center = CGPointMake(kScreenWidth/2, 25);
    buttonBack.showsTouchWhenHighlighted = YES;
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonBack];
    

}

#pragma mark -----------------按钮方法
-(void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)onShop
{
    
    AppModel *model = [AppStore sharedInstance].detailYouhuiData[0];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.article_link]];
    
}

-(void)onShare
{

    AppModel *model = [AppStore sharedInstance].detailYouhuiData[0];

    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
    
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"564986a4e0f55a15e0001aa8" shareText:model.share_title shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.share_pic]]] shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ] delegate:nil];
    
}
#pragma mark -------------------设置视图
-(void)customView
{
    self.automaticallyAdjustsScrollViewInsets  =NO;
    
    
    
    //背景
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64,kScreenWidth , kScreenHeight-99)];
    self.backScrollView.bounces = NO;
    [self.view addSubview:self.backScrollView];

    //价格标题
    self.title_lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 60)];
    self.title_lable.numberOfLines = 0;
    self.title_lable.adjustsFontSizeToFitWidth = YES;
    self.title_lable.font = [UIFont boldSystemFontOfSize:30];
    self.price_lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 260, kScreenWidth, 30)];
    self.price_lable.textColor = [UIColor redColor];
    self.price_lable.textAlignment =NSTextAlignmentCenter;
    [self.backScrollView addSubview:self.title_lable];
    [self.backScrollView addSubview:self.price_lable];
    
    
    //设置滚动视图
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, 200)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.bounces  =NO;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    [self.backScrollView addSubview:self.scrollView];
    
    //网页
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 290, kScreenWidth, kScreenHeight - 290)];
    self.webView.delegate = self;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scrollView.delegate  =self;
    [self.backScrollView addSubview:self.webView];





}


#pragma mark -----------------网络请求
-(void)requestData
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showDeterminateProgressWithTitle:@"加载中" status:@"loading"];

    [AppManger requestDataWithUrl:self.url Success:^{
        
            [self reloadViews];
        

    } Failure:^{
        
    } withBool:NO Type:kDetailType];



}
#pragma mark ----------------界面数据更新
-(void)reloadViews
{
    AppModel *model = [AppStore sharedInstance].detailYouhuiData[0];
    
    
    self.title_lable.text = model.article_title;
    self.price_lable.text = model.article_price;
    
    
    
    if (model.article_product_focus_pic_url.count == 0) {
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        [view setImageWithURL:[NSURL URLWithString:model.article_pic] placeholderImage:[UIImage imageNamed:@"de_pic_mode_coupon"]];
        [self.scrollView addSubview:view];
        
    }else{
        
        self.scrollView.contentSize = CGSizeMake([[AppStore sharedInstance].detailYouhuiData[0] article_product_focus_pic_url].count *self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        
        for (NSInteger i = Zero; i  <[[AppStore sharedInstance].detailYouhuiData[0] article_product_focus_pic_url].count; i++) {
            
            
            UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(i *self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
            
            [view setImageWithURL:[NSURL URLWithString:[[AppStore sharedInstance].detailYouhuiData[0] article_product_focus_pic_url][i][@"pic"]] placeholderImage:[UIImage imageNamed:@"de_pic_mode_coupon"]];
            
            [self.scrollView addSubview:view];
            [self createPageControlWith:model];
        }
    }
    
    
    
    
    [self.webView loadHTMLString:[[AppStore sharedInstance].detailYouhuiData[0] html5_content] baseURL:nil];



}
#pragma mark ----------------pageControl
-(void)createPageControlWith:(AppModel *)model
{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,self.scrollView.frame.size.height - 20, kScreenWidth, 20)];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.numberOfPages =model.article_product_focus_pic_url.count;
    [self.backScrollView addSubview:self.pageControl];

}

#pragma mark ---------------网页代理

-(void)webViewDidFinishLoad:(UIWebView *)webView
{

    if (webView == self.webView) {
        CGFloat height = self.webView.scrollView.contentSize.height;
        
        CGRect frame = self.webView.frame;
        
        frame.size.height = height;
        
        self.webView.frame = frame;
        
        
        self.backScrollView.contentSize = CGSizeMake(kScreenWidth, 290+height);
        [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载完成"];

    }
}

#pragma mark --------------滚动视图代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        self.pageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}
@end
