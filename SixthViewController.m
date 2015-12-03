//
//  SixthViewController.m
//  什么值得买
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "SixthViewController.h"

#import "MyHeader.h"
#import "AppStore.h"
#import "AppManger.h"
#import "AppModel.h"

#import "DetailTableViewCell.h"

#import <MJRefresh.h>


#import <UIKit+AFNetworking.h>
#import "Detail_yc_proViewController.h"
#import <MMProgressHUD.h>


@interface SixthViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,copy)NSString *lastTime;

@property (nonatomic) BOOL isRefreshing;

@property (nonatomic) BOOL isLoading;


@end

@implementation SixthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

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
    return [AppStore sharedInstance].informationData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Detail" forIndexPath:indexPath];
    
    
    [cell updateWithModel:[AppStore sharedInstance].informationData[indexPath.row]];
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppModel *model = [AppStore sharedInstance].informationData[indexPath.row];
    Detail_yc_proViewController *dvc= [[Detail_yc_proViewController alloc] init];
    dvc.type  = @"news";
    dvc.Id = model.article_id;
    dvc.channal_id = @"6";
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
        
        weakself.lastTime = [[[AppStore sharedInstance].informationData lastObject] article_date];
        
        [weakself request];
        
    }];
    
    [self.tableView.footer beginRefreshing];
    
    
}
-(void)request
{
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showDeterminateProgressWithTitle:@"加载中" status:@"loading"];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *url = nil;
        if (self.lastTime == nil) {
            url = kInformationClearUrl;
        }else{
            url = [NSString stringWithFormat:kInformationUrl,self.lastTime];
        }
        
        
        [AppManger requestDataWithUrl:url Success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载成功"];
                [self endRefresh];
                
            });
        } Failure:^{
            [MMProgressHUD dismissWithError:@"加载失败"];
            [self endRefresh];
            
        } withBool:self.isRefreshing Type:kInformationType];
    });


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
