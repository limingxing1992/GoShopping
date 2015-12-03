//
//  DayValueTableViewController.m
//  WorthToBuy
//
//  Created by qianfeng on 15/11/17.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "DayValueTableViewController.h"
#import "AppManger.h"
#import "AppModel.h"
#import "AppStore.h"

#import "MyHeader.h"

#import "DetailTableViewCell.h"

#import "DetailViewController.h"

#import <MJRefresh.h>
#import <MMProgressHUD.h>

@interface DayValueTableViewController ()
@property(nonatomic,copy)NSString *lastTime;
@property (nonatomic) BOOL isRefreshing;

@property (nonatomic) BOOL isLoading;

@end

@implementation DayValueTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"Detail"];
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

#pragma mark -代理

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [AppStore sharedInstance].dayValueData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Detail" forIndexPath:indexPath];
    
    
    [cell updateWithModel:[AppStore sharedInstance].dayValueData[indexPath.row]];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppModel *model = [AppStore sharedInstance].dayValueData[indexPath.row];
    DetailViewController *dvc = [[DetailViewController alloc] init];
    dvc.type_id = @"2";
    dvc.Id = model.article_id;
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
        
        weakself.lastTime = [[[AppStore sharedInstance].dayValueData lastObject] article_date];
        
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
            url = kDayValueClearUrl;
        }else{
            url = [NSString stringWithFormat:kDayValueUrl,self.lastTime];
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

        } withBool:self.isRefreshing Type:kDayValueType];
    
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
