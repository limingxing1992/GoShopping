//
//  SearchViewController.m
//  什么值得买
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "SearchViewController.h"
#import "MyHeader.h"

#import "AppManger.h"
#import "AppModel.h"
#import "AppStore.h"

#import <MJRefresh.h>

#import "SearchCollectionReusableView.h"
#import "SearchCollectionViewCell.h"

#import "DetailViewController.h"

#import "DayBaicaiTableViewController.h"
#import "EveryDayViewController.h"
#import "DayValueTableViewController.h"
#import "LuckyViewController.h"
#import <MMProgressHUD.h>

@interface SearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,copy)NSString *lastTime;

@property (nonatomic) BOOL isRefreshing;

@property (nonatomic) BOOL isLoading;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavi];
    
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


#pragma mark -定制导航栏
-(void)customNavi
{
    
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"btn_bg_red"] forBarMetrics:UIBarMetricsDefault];

}
#pragma mark -创建集合视图

-(UICollectionViewLayout *)layout
{
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(kScreenWidth/2, 200);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 200);
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
    [self.collectionView registerClass:[SearchCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SearchHeader"];
    
    [self.view addSubview:self.collectionView];

}
#pragma mark -代理

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [AppStore sharedInstance].searchCollectionData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchCollection" forIndexPath:indexPath];
    [cell updateWithModel:[AppStore sharedInstance].searchCollectionData[indexPath.row]];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SearchCollectionReusableView *view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SearchHeader" forIndexPath:indexPath];
        view.block = ^(NSString *Id,NSString *channalId){
            
            DetailViewController *dvc = [[DetailViewController alloc] init];
            
            dvc.Id = Id;
            dvc.type_id = channalId;
            [self.navigationController pushViewController:dvc animated:YES];

        };
        view.baicaiBlock = ^(NSString *type){
            if ([type isEqualToString:kDayBaicaiType]) {
                DayBaicaiTableViewController *dbc = [[DayBaicaiTableViewController alloc] init];
                [self.navigationController pushViewController:dbc animated:YES];
            }
            if ([type isEqualToString:kDaySortType]) {
                EveryDayViewController *evc =[[EveryDayViewController alloc] init];
                [self.navigationController pushViewController:evc animated:YES];
            }
            if ([type isEqualToString:kDayValueType]) {
                DayValueTableViewController *dvc =[[DayValueTableViewController alloc] init];
                [self.navigationController pushViewController:dvc animated:YES];
            }
            if ([type isEqualToString:kLuckyType]) {
                LuckyViewController *luckyvc = [[LuckyViewController alloc] init];
                [self.navigationController pushViewController:luckyvc animated:YES];
            }
        };
        
        [view upadateWith:[AppStore sharedInstance].searchScrollData];
    }
    return view;


}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppModel *model = [AppStore sharedInstance].searchCollectionData[indexPath.row];
    
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
        weakself.lastTime = nil;
        weakself.isRefreshing = YES;
        [weakself requestRefresh];
    }];
    [self.collectionView.header beginRefreshing];
    
    self.collectionView.footer =[MJRefreshAutoNormalFooter  footerWithRefreshingBlock:^{
        if (weakself.isLoading) {
            return ;
        }
        weakself.lastTime = [[[AppStore sharedInstance].searchCollectionData lastObject] article_date];
        weakself.isLoading = YES;
        [weakself requestLoad];
    }];
    [self.collectionView.footer beginRefreshing];

}
-(void)requestRefresh
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showDeterminateProgressWithTitle:@"加载中" status:@"loading"];

    [AppManger requestDataWithUrl:kSearchViewUrl Success:^{
        
        [AppManger requestDataWithUrl:kSearchClearUrl Success:^{
            [self.collectionView reloadData];
            [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载完成"];

            [self endRefresh];
        } Failure:^{
            [MMProgressHUD dismissWithError:@"加载失败"];
            [self endRefresh];

        } withBool:self.isRefreshing Type:kSearchType];
        
    } Failure:^{
        
    } withBool:self.isRefreshing Type:kSearchType];

}
-(void)requestLoad
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showDeterminateProgressWithTitle:@"加载中" status:@"loading"];

    NSString *url = [NSString stringWithFormat:kSearchUrl,self.lastTime];
    [AppManger requestDataWithUrl:url Success:^{
        [self.collectionView reloadData];
        [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载完成"];

        [self endRefresh];
    } Failure:^{
        [MMProgressHUD dismissWithError:@"加载失败"];
        [self endRefresh];

    } withBool:self.isRefreshing Type:kSearchType];

}
-(void)endRefresh
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
