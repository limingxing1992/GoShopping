//
//  Detail_comentViewController.m
//  WorthToBuy
//
//  Created by qianfeng on 15/11/16.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "Detail_comentViewController.h"

#import "AppManger.h"
#import "AppModel.h"
#import "AppStore.h"
#import "MyHeader.h"
#import "DateManager.h"

#import <UIKit+AFNetworking.h>
#import <MMProgressHUD.h>
#import "UMSocial.h"

@interface Detail_comentViewController ()<UIWebViewDelegate,UIAlertViewDelegate>

//二个网页
@property(nonatomic,strong)UIWebView *webView_content;
@property(nonatomic,strong)UIWebView *webView_rule;

//每个网页的头
//商品介绍
@property(nonatomic,strong)UILabel *lable_goodsDescri;
//活动说明与流程
@property(nonatomic,strong)UILabel *lable_acitonSteps;





//滚动视图
@property(nonatomic,strong)UIScrollView *topScrollView;



//lable
@property(nonatomic,strong)UILabel *lable_title;
//详细
@property(nonatomic,strong)UILabel *lable_need;
@property(nonatomic,strong)UILabel *lable_num;
@property(nonatomic,strong)UILabel *lable_price;
@property(nonatomic,strong)UILabel *lable_people;
//time
@property(nonatomic,strong)UILabel *lable_time;


//背景滚动视图
@property(nonatomic,strong)UIScrollView *scrollView_back;


@end

@implementation Detail_comentViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self customViews];
    [self addButton];
    
        [self requestData];
        



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets  = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:YES];

}

#pragma mark -设置分享，购买，以及返回按钮
-(void)addButton
{
    UIView *back_view = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50, kScreenWidth, 50)];
    back_view.backgroundColor = [UIColor redColor];
    [self.view addSubview:back_view];
    
    //分享按钮
    UIButton *button_share = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 50, 50)];
    [button_share setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button_share.showsTouchWhenHighlighted = YES;
    [button_share setTitle:@"分享" forState:UIControlStateNormal];
    [button_share addTarget:self action:@selector(onShare) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:button_share];
    
    //返回按钮
    UIButton *button_back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    button_back.center = CGPointMake(kScreenWidth/2, 25);
    [button_back setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button_back.showsTouchWhenHighlighted = YES;
    [button_back setTitle:@"返回" forState:UIControlStateNormal];
    
    [button_back addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:button_back];
    
    //申请链接
    UIButton *button_apply = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth -100, 0, 100, 50)];
    [button_apply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button_apply.showsTouchWhenHighlighted = YES;
    [button_apply setTitle:@"我要申请" forState:UIControlStateNormal];
    [button_apply addTarget:self action:@selector(onApply) forControlEvents:UIControlEventTouchUpInside];
    [back_view addSubview:button_apply];

}

-(void)onBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onShare
{
    
    AppModel *model = [AppStore sharedInstance].detailComentData[0];
    
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatTimeline,UMShareToWechatSession]];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"564986a4e0f55a15e0001aa8" shareText:model.share_title shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.share_pic]]] shareToSnsNames:@[UMShareToSina,UMShareToTencent,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQzone,UMShareToQQ] delegate:nil];
    

}
-(void)onApply
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"你还没有登陆" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"注册账号", nil];
    [alert show];
}
#pragma mark - 警告框
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //
}
#pragma mark -布局界面
-(void)customViews
{
//背景滚动视图
    self.scrollView_back = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight-20)];
    self.scrollView_back.bounces = NO;
    self.scrollView_back.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
    [self.view addSubview:self.scrollView_back];
    
//顶部滚动视图
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    self.topScrollView.bounces = NO;
    [self.scrollView_back addSubview:self.topScrollView];
    
//标题
    self.lable_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, kScreenWidth, 50)];
    self.lable_title.adjustsFontSizeToFitWidth = YES;
    self.lable_title.numberOfLines = 0;
    self.lable_title.font = [UIFont boldSystemFontOfSize:30];
    [self.scrollView_back addSubview:self.lable_title];
    
//详细
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 250, kScreenWidth, 300)];
    view.backgroundColor = [UIColor whiteColor];
    [self.scrollView_back addSubview:view];
    
//金币
    UILabel *lable_gold = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 60)];
    lable_gold.adjustsFontSizeToFitWidth = YES;
    lable_gold.text = @"需金币：";
    [view addSubview:lable_gold];
    self.lable_need = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 50, 60)];
    self.lable_need.textColor = [UIColor redColor];
    [view addSubview:self.lable_need];

//提供
    UILabel *lable_product = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 50, 60)];
    lable_product.adjustsFontSizeToFitWidth = YES;
    lable_product.text = @"提供数：";
    [view addSubview:lable_product];
    
    self.lable_num = [[UILabel alloc] initWithFrame:CGRectMake(50, 60, 50, 60)];
    self.lable_num.textColor = [UIColor redColor];
    [view addSubview:self.lable_num];
    
//价格
    UILabel *lable_shop = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 50, 60)];
    lable_shop.adjustsFontSizeToFitWidth = YES;
    lable_shop.text = @"市场价：";
    [view addSubview:lable_shop];
    
    self.lable_price = [[UILabel alloc] initWithFrame:CGRectMake(50, 120, 50, 60)];
    self.lable_price.textColor = [UIColor redColor];
    [view addSubview:self.lable_price];
    
//申请数
    self.lable_people = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 0, kScreenWidth/2, 120)];
    self.lable_people.font = [UIFont boldSystemFontOfSize:35];
    self.lable_people.textAlignment = NSTextAlignmentCenter;
    self.lable_people.textColor = [UIColor redColor];
    [view addSubview:self.lable_people];
    
    UILabel *lable_apply = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2, 120, kScreenWidth/2, 60)];
    lable_apply.text = @"人已申请";
    lable_apply.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lable_apply];
//时间显示
    self.lable_time = [[UILabel alloc] initWithFrame:CGRectMake(0, 180, kScreenWidth, 80)];
    [view addSubview:self.lable_time];
    
//商品介绍
    self.lable_goodsDescri = [[UILabel alloc] initWithFrame:CGRectMake(0, 550, kScreenWidth, 30)];
    self.lable_goodsDescri.text = @"商品介绍";
    [self.scrollView_back addSubview:self.lable_goodsDescri];
//网页
    self.webView_content = [[UIWebView alloc] initWithFrame:CGRectMake(0, 580, kScreenWidth, 100)];
    self.webView_content.delegate = self;
    self.webView_content.scrollView.scrollEnabled = NO;
    [self.scrollView_back addSubview:self.webView_content];
//网页规则
//    self.webView_rule = [[UIWebView alloc] initWithFrame:CGRectMake(0, 680, kScreenWidth, 100)];
//    self.webView_rule.delegate = self;
//    self.webView_rule.scrollView.scrollEnabled = NO;
//    [self.scrollView_back addSubview:self.webView_rule];
    
    


}
#pragma makr - 数据请求
-(void)requestData
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showDeterminateProgressWithTitle:@"加载中" status:@"loading"];

    NSString *url = [NSString stringWithFormat:kDetailComentUrl,self.Id];
    [AppManger requestDataWithUrl:url Success:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadViews];
        });
        
    } Failure:^{
        
    } withBool:NO Type:kDetailComentType];

}
#pragma makr - 界面数据更新
-(void)reloadViews
{
    AppModel *model = [AppStore sharedInstance].detailComentData[0];
    
    //更新滚动视图
    self.topScrollView.contentSize = CGSizeMake(kScreenWidth *model.probation_banner.count, self.topScrollView.frame.size.height);
    for (NSInteger i = Zero; i <model.probation_banner.count; i ++) {
        UIImageView *imagView = [[UIImageView alloc] initWithFrame:CGRectMake(i *kScreenWidth, 0, kScreenWidth, self.topScrollView.frame.size.height)];
        [imagView setImageWithURL:[NSURL URLWithString:model.probation_banner[i]] placeholderImage:[UIImage imageNamed:@"de_pic_mode_coupon"]];
        [self.topScrollView addSubview:imagView];
    }
    //更新标题
    self.lable_title.text =model.probation_title;
    //更新详细
    self.lable_need.text = model.probation_need_point;
    self.lable_num.text = model.probation_product_num;
    self.lable_price.text = model.probation_product_price;
    self.lable_people.text = model.apply_num;
    //更新时间
    NSArray *arry = [DateManager dateSinceFromNowWithNs:model.apply_end_date];
    self.lable_time.text = [NSString stringWithFormat:@"距离申请结束 %@  天 %@ 小时 %@ 分钟 %@ 秒",arry[0],arry[1],arry[2],arry[3]];
    //加载俩web
    [self.webView_content loadHTMLString:model.probation_content baseURL:nil];
    


}
#pragma mark -网页代理
-(void)webViewDidFinishLoad:(UIWebView *)webView
{

    if (webView == self.webView_content) {

        CGFloat height = self.webView_content.scrollView.contentSize.height;
        CGRect frame =  self.webView_content.frame;
        frame.size.height += height;
        self.webView_content.frame = frame;
        CGSize size = self.scrollView_back.contentSize;
        size.height +=height;
        
        
        self.scrollView_back.contentSize = size;
        [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载完成"];


    }
}
@end
