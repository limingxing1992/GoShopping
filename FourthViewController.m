//
//  FourthViewController.m
//  什么值得买
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "FourthViewController.h"

#import "MyHeader.h"

#import "OriginalTableViewCell.h"

#import "AppManger.h"
#import "AppStore.h"
#import "AppModel.h"

#import <MJRefresh.h>
#import "YCTableViewController.h"
#import "SortTableViewController.h"

#import "Detail_yc_proViewController.h"

#import <MMProgressHUD.h>

@interface FourthViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,copy)NSString *lastTime;

@property (nonatomic) BOOL isRefreshing;

@property (nonatomic) BOOL isLoading;

@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customTableView];
    [self addRefresh];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    self.tabBarController.tabBar.hidden = NO;


}

#pragma mark -定义tableView
-(void)customTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OriginalTableViewCell" bundle:nil] forCellReuseIdentifier:@"Original"];
    self.tableView.tableHeaderView = [self createHeader];
}

-(UIView *)createHeader
{
    UIImageView *imageViewBack  =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 55)];
    imageViewBack.userInteractionEnabled = YES;
    CGFloat widthLong = (kScreenWidth-25)/4;
    CGFloat widthshort = (kScreenWidth -30)/5;
    imageViewBack.image = [UIImage imageNamed:@"default_HomeBannerLeft@3x"];
    
    NSArray *arry = @[@[@"开箱晒物",@"1"],@[@"使用评测",@"2"],@[@"购物攻略",@"5"],@[@"生活记录",@"4"],@[@"精华",@"19"],@[@"全部",@"0"],@[@"日排行",@"11"],@[@"周排行",@"17"],@[@"月排行",@"130"],];
    
    for (NSInteger i =Zero; i <4; i ++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(i *(widthLong +5)+5, 5, widthLong, 20)];
        
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 20)];
        
        imageview.image = [UIImage imageNamed:@"nighttagBgPress"];
        imageview.userInteractionEnabled = YES;
        [view addSubview:imageview];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 20)];
        
        label.text = [arry[i] firstObject];
        
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;

        //每个label上添加button
        UIButton *button = [[UIButton alloc] initWithFrame:label.frame];
        button.backgroundColor = [UIColor clearColor];
        NSInteger tag = [[arry[i] lastObject] integerValue];
        button.tag = tag;
        [button addTarget:self action:@selector(pushViewControllerWithNum:) forControlEvents:UIControlEventTouchUpInside];
        button.showsTouchWhenHighlighted = YES;
        [label addSubview:button];
        [imageview addSubview:label];
        
        [imageViewBack addSubview:view];
    }
    for (NSInteger i =4; i <arry.count; i ++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((i -4) *(widthshort +5)+5, 30, widthshort, 20)];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 20)];
        imageview.image = [UIImage imageNamed:@"nighttagBgPress"];
        imageview.userInteractionEnabled = YES;

        [view addSubview:imageview];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 20)];
        
        label.text = [arry[i] firstObject];
        label.userInteractionEnabled = YES;
        
        UIButton *button = [[UIButton alloc] initWithFrame:label.frame];
        button.backgroundColor = [UIColor clearColor];
        NSInteger tag = [[arry[i] lastObject] integerValue];
        button.tag = tag;
        [button addTarget:self action:@selector(pushViewControllerWithNum:) forControlEvents:UIControlEventTouchUpInside];
        button.showsTouchWhenHighlighted = YES;
        [label addSubview:button];
        [imageview addSubview:label];
        
        
        
        if (i== 4) {
            label.textColor = [UIColor redColor];
        }
        label.textAlignment = NSTextAlignmentCenter;
        [imageview addSubview:label];
        [imageViewBack addSubview:view];
    }
    
    return imageViewBack;

}

#pragma mark -排行
//点击进入下一页面例如排行
-(void)pushViewControllerWithNum:(UIButton *)num
{
    YCTableViewController *ycv = [[YCTableViewController alloc] init];
    
    ycv.num_Type = [NSString stringWithFormat:@"%ld",num.tag];
    
    if (num.tag ==19) {
        return;
    }
    
    if (num.tag ==0) {
        SortTableViewController *svc = [[SortTableViewController alloc] init];
        svc.type_name = @"all";
        [self.navigationController pushViewController:svc animated:YES];
        return;
    }else if (num.tag ==11){
    
        SortTableViewController *svc = [[SortTableViewController alloc] init];
        svc.type_name = @"all_hot_1";
        [self.navigationController pushViewController:svc animated:YES];
        return;

    }else if (num.tag == 17){
    
        SortTableViewController *svc = [[SortTableViewController alloc] init];
        svc.type_name = @"all_hot_7";
        [self.navigationController pushViewController:svc animated:YES];
        return;

    
    }else if (num.tag == 130){
        SortTableViewController *svc = [[SortTableViewController alloc] init];
        svc.type_name = @"all_hot_30";
        [self.navigationController pushViewController:svc animated:YES];
        return;

    }
    
    
    [self.navigationController pushViewController:ycv animated:YES];
    
}

#pragma mark -代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [AppStore sharedInstance].EssenceData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OriginalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Original"];
    [cell updateWith:[AppStore sharedInstance].EssenceData[indexPath.row]];
    return cell;

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 395;
}

#pragma mark  -详情页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppModel *model = [AppStore sharedInstance].EssenceData[indexPath.row];
    Detail_yc_proViewController *dvc= [[Detail_yc_proViewController alloc] init];
    dvc.type  = @"yuanchuang";
    dvc.Id = model.article_id;
    dvc.channal_id = @"11";
    [self.navigationController pushViewController:dvc animated:YES];

}

#pragma mark -数据请求
-(void)requestData
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showDeterminateProgressWithTitle:@"加载中" status:@"loading"];

    [AppManger requestDataWithUrl:kEssenceDownUrl Success:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载成功"];
            [self endRefresh];
        });
        
    } Failure:^{
        [MMProgressHUD dismissWithError:@"加载失败"];
        [self endRefresh];

    } withBool:self.isRefreshing Type:kEssenceType];

}

-(void)addRefresh
{
    __weak typeof(self) weakself = self;
    
    //添加下拉刷新视图
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakself.isRefreshing) {
            return ;
        }
        self.lastTime = nil;
        weakself.isRefreshing = YES;
        [weakself requestData];
        
    }];
    [self.tableView.header beginRefreshing];
    
    //添加上拉下载刷新视图
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakself.isLoading) {
            return ;
        }
        
        weakself.isLoading = YES;
        
        [weakself request];
        
    }];
    [self.tableView.footer beginRefreshing];
    


}

-(void)request
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showDeterminateProgressWithTitle:@"加载中" status:@"loading"];

    self.lastTime = [[[AppStore sharedInstance].EssenceData lastObject] article_date];
    
    NSString *url = [NSString stringWithFormat:kEssenceUpUrl,self.lastTime];
    [AppManger requestDataWithUrl:url Success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载成功"];
            [self endRefresh];

        });
    } Failure:^{
        [MMProgressHUD dismissWithError:@"加载失败"];
        [self endRefresh];

    } withBool:self.isRefreshing Type:kEssenceType];
    
    
    


}

- (void)endRefresh
{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.tableView.header endRefreshing];
    }
    
    if (self.isLoading) {
        self.isLoading = NO;
        [self.tableView.footer endRefreshing];
    }


}

@end
