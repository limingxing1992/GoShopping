//
//  UserViewController.m
//  什么值得买
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "UserViewController.h"
#import "MyHeader.h"
#import <SDWebImage/SDImageCache.h>
@interface UserViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *data;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    [self createDataSoure];
    
}

- (void)createDataSoure
{
    _data = [NSMutableArray array];
    
    NSArray *arr1 = [NSArray arrayWithObjects:@"推送设置",@"开启推送通知",@"开启关注通知",@"清除缓存", nil];
    [_data addObject:arr1];
    
    NSArray *arr2 = [NSArray arrayWithObjects:@"推荐值得买",@"官方推荐",@"官方微博", nil];
    [_data addObject:arr2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"btn_bg_red"] forBarMetrics:UIBarMetricsDefault];
}
#pragma mark - table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _data.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1 || indexPath.row == 2) {
            UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(200, 5, 100, 30)];
            [cell.contentView addSubview:sw];
        }
        if (indexPath.row == 3) {
            double size = [[SDImageCache sharedImageCache] getSize]/pow(10, 6);
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
            lable.text = [NSString stringWithFormat:@"%.2fMB",size];
            cell.accessoryView = lable;
        }
    }
    
    cell.textLabel.text = _data[indexPath.section][indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"⚠️" message:@"确定要清除缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alerView show];
        }
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/ai-xian-mian-re-men-ying-yong/id468587292?mt=8"]];
        }else if (indexPath.row == 1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/ai-xian-mian-re-men-ying-yong/id468587292?mt=8"]];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/candou"]];
        }
        
    }
}
#pragma mark ----警告视图的分发

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //清除缓存处理
        //清除内存图片缓存
        [[SDImageCache sharedImageCache] clearMemory];
        //清除磁盘图片缓存
        [[SDImageCache sharedImageCache] clearDisk];
        [self.tableView reloadData];
    }
}
@end
