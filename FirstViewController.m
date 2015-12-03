//
//  FirstViewController.m
//  什么值得买
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "FirstViewController.h"
#import "MyHeader.h"
#import "AppStore.h"
#import "AppManger.h"
#import "AppModel.h"

#import "ScrollTableViewCell.h"
#import "ImageTableViewCell.h"
#import "DetailTableViewCell.h"

#import <MJRefresh.h>

#import "DetailViewController.h"
#import "Detail_yc_proViewController.h"

#import <MMProgressHUD.h>

#import <UIKit+AFNetworking.h>

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,copy)NSString *lastTime;

@property (nonatomic) BOOL isRefreshing;

@property (nonatomic) BOOL isLoading;


@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    [self.tableView registerNib:[UINib nibWithNibName:@"ScrollTableViewCell" bundle:nil] forCellReuseIdentifier:@"Scroll"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"Image"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"Detail"];

    [self addRefresh];


}

-(void)viewWillAppear:(BOOL)animated
{
    //在这里定义每一页的导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"btn_bg_red"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setHidden:NO];
    self.tabBarController.tabBar.hidden = NO;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -tableView代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count1 = [AppStore sharedInstance].mainData.count;
    NSInteger count2 = [AppStore sharedInstance].mainScroll.count;
    NSInteger count3 = [AppStore sharedInstance].threeView.count;
    if (count1 >0 && count2 >0 && count3 > 0) {
        return 3;
    }
    return 0;


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==2) {
        return [AppStore sharedInstance].mainData.count;
    }else if (section == 0 || section ==1){
        return 1;
    }
    return 0;


}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0 ) {
        ScrollTableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"Scroll"];
        
        cell.block = ^(NSString *Id,NSString *channalId){
            
            if ([channalId isEqualToString:@"6"]) {
                Detail_yc_proViewController *dvc = [[Detail_yc_proViewController alloc] init];
                dvc.Id = Id;
                dvc.channal_id = channalId;
                dvc.type = @"news";
                [self.navigationController pushViewController:dvc animated:YES];
            }else if ([channalId isEqualToString:@"11"]){
                Detail_yc_proViewController *dvc = [[Detail_yc_proViewController alloc] init];
                dvc.Id = Id;
                dvc.channal_id = channalId;
                dvc.type = @"yuanchuang";
                [self.navigationController pushViewController:dvc animated:YES];
            }else{
                DetailViewController *dvc = [[DetailViewController alloc] init];
                
                dvc.Id = Id;
                dvc.type_id = channalId;
                [self.navigationController pushViewController:dvc animated:YES];

            }
            
            
            
            
            
        };
        
        [cell updateWithModel:[AppStore sharedInstance].mainScroll];
        return cell;
    }else if (indexPath.section == 1){
        ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Image"];
        [cell updateWithModel:[AppStore sharedInstance].threeView];

        cell.block = ^(NSString *Id,NSString *channalId){
            DetailViewController *dvc = [[DetailViewController alloc] init];
            
            dvc.Id = Id;
            dvc.type_id = channalId;
            [self.navigationController pushViewController:dvc animated:YES];
            
        };

        return cell;
    }else if(indexPath.section == 2){
        
        DetailTableViewCell *cell  =[tableView dequeueReusableCellWithIdentifier:@"Detail"];
        [cell updateWithModel:[AppStore sharedInstance].mainData[indexPath.row]];
        return cell;
    }
    return nil;


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        return 170;
    }
    return 110;
}
//设置分区间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}


#pragma mark -详细页面

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    

    
    if (indexPath.section ==2) {
        AppModel *model = [AppStore sharedInstance].mainData[indexPath.row];
        NSString *icd = model.article_channel_id;
        if ([icd isEqualToString:@"1"] || [icd isEqualToString:@"2"] || [icd isEqualToString:@"5"]) {
            
            DetailViewController *dvc = [[DetailViewController alloc] init];
            dvc.type_id = model.article_channel_id;
            dvc.Id = model.article_id;
            [self.navigationController pushViewController:dvc animated:YES];

        }else if ([icd isEqualToString:@"11"] || [icd isEqualToString:@"4"] || [icd isEqualToString:@"3"]){
            Detail_yc_proViewController *dvc = [[Detail_yc_proViewController alloc] init];
            dvc.type =@"yuanchuang";
            dvc.Id = model.article_id;
            dvc.channal_id = @"11";
            
            [self.navigationController pushViewController:dvc animated:YES];
        
        }else if ([icd isEqualToString:@"6"]){
            Detail_yc_proViewController *dvc = [[Detail_yc_proViewController alloc] init];
            dvc.type =@"news";
            dvc.Id = model.article_id;
            dvc.channal_id = @"6";
            
            [self.navigationController pushViewController:dvc animated:YES];
        }
        
    }
    


}


#pragma mark -网络请求
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
        
        weakself.lastTime = [[[AppStore sharedInstance].mainData lastObject] time_sort];
        
        [weakself request];
        

    }];
    [self.tableView.footer beginRefreshing];



}

-(void)requestData
{
    
    //    isrefresh下拉刷新
    //isLoading上啦加载
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showDeterminateProgressWithTitle:@"加载中" status:@"loading"];

    NSString *url = [NSString stringWithFormat:kMainNewUrl];
    
    
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [AppManger requestDataWithUrl:KMainViewUrl Success:^{
                [AppManger requestDataWithUrl:url Success:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载成功"];

                        [self endRefresh];
                        
                    });
                } Failure:^{
                    [MMProgressHUD dismissWithError:@"加载失败"];
                    [self endRefresh];
                } withBool:self.isRefreshing Type:kHomeType];
            } Failure:^{
                
            } withBool:self.isRefreshing Type:kHomeType];

        });
    
    
    


}

-(void)request
{
    NSString *url = nil;
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showDeterminateProgressWithTitle:@"加载中" status:@"loading"];
    if (self.lastTime) {
       url = [NSString stringWithFormat:KMainDataUrl,self.lastTime];
    }else{
        url = kMainNewUrl;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [AppManger requestDataWithUrl:url Success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载成功"];
                [self.tableView reloadData];
                [self endRefresh];
            });
        } Failure:^{
            [MMProgressHUD dismissWithError:@"加载失败"];
            [self endRefresh];
        }withBool:self.isRefreshing Type:kHomeType];

    });




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

#pragma mark ------------活动指示器
@end
