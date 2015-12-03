//
//  SortTableViewController.m
//  什么值得买
//
//  Created by qianfeng on 15/11/12.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "SortTableViewController.h"

#import "MyHeader.h"

#import "OriginalTableViewCell.h"

#import "AppManger.h"
#import "AppStore.h"
#import "AppModel.h"

#import <MJRefresh.h>

#import "Detail_yc_proViewController.h"

#import <MMProgressHUD.h>

@interface SortTableViewController ()
@property (nonatomic) BOOL isRefreshing;

@property (nonatomic) BOOL isLoading;

@end

@implementation SortTableViewController

- (void)viewDidLoad {
    
    [[AppStore sharedInstance].YCData removeAllObjects];
    
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OriginalTableViewCell" bundle:nil] forCellReuseIdentifier:@"Original"];
    
    [self addRefresh];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    //在这里定义每一页的导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"btn_bg_red"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setHidden:NO];
    self.tabBarController.tabBar.hidden = NO;
    
    
}


#pragma mark - 代理


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [AppStore sharedInstance].YCData.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OriginalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Original"];
    
    [cell updateWith:[AppStore sharedInstance].YCData[indexPath.row]];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 395;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppModel *model = [AppStore sharedInstance].YCData[indexPath.row];
    Detail_yc_proViewController *dvc= [[Detail_yc_proViewController alloc] init];
    dvc.type  = @"yuanchuang";
    dvc.Id = model.article_id;
    dvc.channal_id = @"11";
    [self.navigationController pushViewController:dvc animated:YES];
    
}

#pragma mark -网络请求

-(void)addRefresh
{
    
    __weak typeof(self) weakself = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakself.isRefreshing) {
            return ;
        }
        weakself.isRefreshing = YES;
        
        weakself.offset = 0;
        [weakself request];
        
    }];
    [self.tableView.header beginRefreshing];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakself.isLoading) {
            return ;
        }
        
        weakself.isLoading = YES;
        
        weakself.offset += 20;
        
        [weakself request];
        
    }];
    
    [self.tableView.footer beginRefreshing];
    
    
}
-(void)request
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showDeterminateProgressWithTitle:@"加载中" status:@"loading"];

        NSString *url = [NSString stringWithFormat:kSortUrl,self.type_name,self.offset];
        
        
        [AppManger requestDataWithUrl:url Success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载完成"];

                [self endRefresh];
                
            });
        } Failure:^{
            [MMProgressHUD dismissWithError:@"加载失败"];
            [self endRefresh];
            
        } withBool:self.isRefreshing Type:kYCType];

}

-(void)endRefresh
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
