//
//  ComentSquareTableViewController.m
//  什么值得买
//
//  Created by qianfeng on 15/11/13.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "ComentSquareTableViewController.h"
#import "MyHeader.h"


#import "AppManger.h"
#import "AppStore.h"
#import "AppModel.h"

#import <MJRefresh.h>

#import "Detail_comentViewController.h"
#import "SquareTableViewCell.h"
#import <MMProgressHUD.h>

@interface ComentSquareTableViewController ()


@property(nonatomic,copy)NSString *lastTime;

@property (nonatomic) BOOL isRefreshing;

@property (nonatomic) BOOL isLoading;




@end

@implementation ComentSquareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SquareTableViewCell" bundle:nil] forCellReuseIdentifier:@"Square"];
    
    [self addRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    //在这里定义每一页的导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"btn_bg_red"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setHidden:NO];
    self.tabBarController.tabBar.hidden = NO;
    
    
}

#pragma mark -代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [AppStore sharedInstance].comentSquareData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SquareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Square" forIndexPath:indexPath];
    
    [cell updateWith:[AppStore sharedInstance].comentSquareData[indexPath.row]];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppModel *model = [AppStore sharedInstance].comentAllData[indexPath.row];
    Detail_comentViewController *dvc = [[Detail_comentViewController alloc] init];
    dvc.Id = model.probation_id;
    [self.navigationController pushViewController:dvc animated:YES];

}

#pragma mark -网络
-(void)addRefresh
{
    
    __weak typeof(self) weakself = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakself.isRefreshing) {
            return ;
        }
        weakself.isRefreshing = YES;
        
        weakself.lastTime = nil;
        [weakself request];
        
    }];
    [self.tableView.header beginRefreshing];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakself.isLoading) {
            return ;
        }
        
        weakself.isLoading = YES;
        
        weakself.lastTime = [[[AppStore sharedInstance].comentSquareData lastObject] article_date];
        
        [weakself request];
        
    }];
    
    [self.tableView.footer beginRefreshing];
    
    
}
-(void)request
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showDeterminateProgressWithTitle:@"加载中" status:@"loading"];

    
        NSString *url = nil;
        
        if (self.lastTime == nil) {
            url = kComentSquareClearUrl;
        }else{
            url = [NSString stringWithFormat:kComentSquareUrl,self.lastTime];
        }
        
        
        [AppManger requestDataWithUrl:url Success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载完成"];

                [self endRefresh];
                
            });
        } Failure:^{
            [MMProgressHUD dismissWithError:@"加载失败"];
            [self endRefresh];
            
        } withBool:self.isRefreshing Type:kComentSquareType];

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
