//
//  SecondViewController.m
//  什么值得买
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "SecondViewController.h"

#import "MyHeader.h"
#import "AppStore.h"
#import "AppManger.h"
#import "AppModel.h"

#import "ImageTableViewCell.h"
#import "DetailTableViewCell.h"

#import <MJRefresh.h>
#import "DetailViewController.h"

#import <MMProgressHUD.h>
#import <UIKit+AFNetworking.h>



@interface SecondViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,copy)NSString *lastTime;

@property (nonatomic) BOOL isRefreshing;

@property (nonatomic) BOOL isLoading;


@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self customTableView];
    
    

    [self addRefresh];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreate
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    self.tabBarController.tabBar.hidden = NO;


}


#pragma mark - 自定义tableView
-(void)customTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerNib:[UINib nibWithNibName:@"ImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"Image"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"Detail"];

    
}


#pragma mark -网络请求相关
-(void)requestData
{
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showDeterminateProgressWithTitle:@"加载中" status:@"loading"];

    [AppManger requestDataWithUrl:kYouhuilUrl Success:^{
        [AppManger requestDataWithUrl:kYouhuiTableDownUrl Success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载成功"];
                [self endRefresh];
                
            });
        } Failure:^{
            [MMProgressHUD dismissWithError:@"加载失败"];
            [self endRefresh];
        } withBool:self.isRefreshing Type:kYouhuiType];
    } Failure:^{
        
    } withBool:self.isRefreshing Type:kYouhuiType];

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

    self.lastTime= [[[AppStore sharedInstance].youhuiTableData lastObject] article_date];
    
    NSString *url = [NSString stringWithFormat:kYouhuiTableUpUrl,self.lastTime];

    
    [AppManger requestDataWithUrl:url Success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载成功"];
            [self.tableView reloadData];
            [self endRefresh];
        });
    } Failure:^{
        [MMProgressHUD dismissWithError:@"加载失败"];
        [self endRefresh];
    }withBool:self.isRefreshing Type:kYouhuiType];
    

}
//停止刷新
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


#pragma mark - tableView代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count1 = [AppStore sharedInstance].youhuiTableData.count;
    NSInteger count2 = [AppStore sharedInstance].youhuiViewData.count;
    if (count1 >0 &&count2 >0) {
        return 2;
    }
    return 0;


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return [AppStore sharedInstance].youhuiTableData.count;
    }
    return 0;
    

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section ==0) {
        ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Image"];
        
        cell.block = ^(NSString *Id,NSString *channalId){
            DetailViewController *dvc = [[DetailViewController alloc] init];
            
            dvc.Id = Id;
            dvc.type_id = channalId;
            [self.navigationController pushViewController:dvc animated:YES];
            
        };

        
        
        [cell updateWithModel:[AppStore sharedInstance].youhuiViewData];
        return cell;
    }else if (indexPath.section == 1){
        DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Detail"];
        [cell updateWithModel:[AppStore sharedInstance].youhuiTableData[indexPath.row]];
        return cell;
    }
    return nil;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

#pragma mark -详情页面
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==1) {
        AppModel *model = [AppStore sharedInstance].youhuiTableData[indexPath.row];
        
        
            DetailViewController *dvc = [[DetailViewController alloc] init];
            dvc.type_id = @"1";
            dvc.Id = model.article_id;
            [self.navigationController pushViewController:dvc animated:YES];
            
        
    }
    
}

@end
