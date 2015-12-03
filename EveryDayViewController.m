//
//  EveryDayViewController.m
//  WorthToBuy
//
//  Created by qianfeng on 15/11/17.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "EveryDayViewController.h"
#import "MyHeader.h"
#import "AppManger.h"
#import "AppModel.h"
#import "AppStore.h"
#import <MJRefresh.h>
#import "SearchCollectionViewCell.h"
#import "DetailViewController.h"

#import <MMProgressHUD.h>

@interface EveryDayViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,assign)NSInteger offset;

@property (nonatomic) BOOL isRefreshing;

@property (nonatomic) BOOL isLoading;


@end

@implementation EveryDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createCollectionView];
    [self addRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -viewWillAppear

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    self.tabBarController.tabBar.hidden = NO;
    
}
#pragma mark -创建集合视图

-(UICollectionViewLayout *)layout
{
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(kScreenWidth/2, 200);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    return layout;
    
}

-(void)createCollectionView
{
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) collectionViewLayout:[self layout]];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SearchCollection"];
    
    [self.view addSubview:self.collectionView];
    
}
#pragma mark -代理

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [AppStore sharedInstance].daySortData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchCollection" forIndexPath:indexPath];
    [cell updateWithModel:[AppStore sharedInstance].daySortData[indexPath.row]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppModel *model = [AppStore sharedInstance].daySortData[indexPath.row];
    
    DetailViewController *dvc = [[DetailViewController alloc] init];
    
    dvc.Id = model.article_id;
    dvc.type_id = @"2";
    [self.navigationController pushViewController:dvc animated:YES];
}


#pragma mark -网络请求
-(void)addRefresh
{
    __weak typeof(self)weakself = self;
    
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakself.isRefreshing) {
            return ;
        }
        weakself.offset = 0;
        weakself.isRefreshing = YES;
        [weakself requestLoad];
    }];
    [self.collectionView.header beginRefreshing];
    
    self.collectionView.footer =[MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        if (weakself.isLoading) {
            return ;
        }
        weakself.offset += 20;
        weakself.isLoading = YES;
        [weakself requestLoad];
    }];
    [self.collectionView.footer beginRefreshing];
    
}
-(void)requestLoad
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showDeterminateProgressWithTitle:@"加载中" status:@"loading"];

    NSString *url  =[NSString stringWithFormat:kDaySortUrl,self.offset];

    
        [AppManger requestDataWithUrl:url Success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
                [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载完成"];

                [self enRefresh];
            });
        } Failure:^{
            [MMProgressHUD dismissWithError:@"加载失败"];
            [self enRefresh];

        } withBool:self.isRefreshing Type:kDaySortType];
    
}
-(void)enRefresh
{
    if (self.isRefreshing) {
        self.isRefreshing =NO;
        [self.collectionView.header endRefreshing];
    }
    
    if (self.isLoading) {
        self.isLoading = NO;
        [self.collectionView.footer endRefreshing];
    }
    
}
@end
