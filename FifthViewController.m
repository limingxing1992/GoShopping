//
//  FifthViewController.m
//  什么值得买
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "FifthViewController.h"
#import "MyHeader.h"
#import "ComentCollectionViewCell.h"

#import "AppManger.h"
#import "AppModel.h"
#import "AppStore.h"

#import <MJRefresh.h>

#import "ComentSquareTableViewController.h"

#import "Detail_comentViewController.h"
#import <MMProgressHUD.h>

@interface FifthViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic) BOOL isRefreshing;

@property (nonatomic) BOOL isLoading;

@property (nonatomic,assign)NSInteger offset;


@end

@implementation FifthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customCollectionView];
    [self addRefresh];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    self.tabBarController.tabBar.hidden = NO;


}

-(UICollectionViewLayout *)layOut
{
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth/2, 200);
    layout.minimumInteritemSpacing =0;
    layout.minimumLineSpacing = 0;
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, 50);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    
    return layout;


}

-(void)customCollectionView
{
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:[self layOut]];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1.0];
    [self.view addSubview:self.collectionView];
    
    
    
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ComentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Coment"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];

}
#pragma mark - 代理

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return [AppStore sharedInstance].comentAllData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ComentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Coment" forIndexPath:indexPath];
    [cell updateWith:[AppStore sharedInstance].comentAllData[indexPath.row]];
    return cell;

}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{

    UICollectionReusableView *supplementaryView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
        
        CGFloat width = (supplementaryView.frame.size.width-9)/2;
        CGFloat height = supplementaryView.frame.size.height - 8;
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(2, 5, width, height)];
        button1.layer.cornerRadius = 7;
        button1.clipsToBounds = YES;
        button1.backgroundColor = [UIColor whiteColor];
        [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button1 setTitle:@"评测广场" forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(pushComentSquare) forControlEvents:UIControlEventTouchUpInside];
        button1.showsTouchWhenHighlighted = YES;
        [supplementaryView addSubview:button1];
        
        UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(7+width, 5, width, height)];
        button2.layer.cornerRadius = 7;
        button2.clipsToBounds = YES;
        button2.backgroundColor = [UIColor whiteColor];
        [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button2 setTitle:@"我的众测" forState:UIControlStateNormal];
        [supplementaryView addSubview:button2];
        
    }
    return supplementaryView;




}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    AppModel *model = [AppStore sharedInstance].comentAllData[indexPath.row];
    Detail_comentViewController *dvc = [[Detail_comentViewController alloc] init];
    dvc.Id = model.probation_id;
    [self.navigationController pushViewController:dvc animated:YES];

}

#pragma mark -网络请求

-(void)request
{

    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleSwingLeft];
    [MMProgressHUD showDeterminateProgressWithTitle:@"加载中" status:@"loading"];

    NSString *url = [NSString stringWithFormat:kComentAllUrl,self.offset];
    [AppManger requestDataWithUrl:url Success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            [MMProgressHUD dismissWithSuccess:@"ok" title:@"加载成功"];
            [self endRefresh];
        });
    } Failure:^{
        [MMProgressHUD dismissWithError:@"加载失败"];
        [self endRefresh];
    } withBool:self.isRefreshing Type:kComentAllType];



}

-(void)addRefresh
{
    __weak typeof(self)weakself = self;
    
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if (weakself.isRefreshing) {
            return ;
        }
        weakself.isRefreshing = YES;
        weakself.offset = 0;
        [weakself request];
        
    }];
    
    [self.collectionView.header beginRefreshing];
    
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
 
        if (weakself.isLoading) {
            return ;
        }
        weakself.isLoading =YES;
        [weakself request];
        
    }];
    
    [self.collectionView.footer beginRefreshing];
    


}

-(void)endRefresh
{
    if (self.isRefreshing) {
        
        self.isRefreshing = NO;
        [self.collectionView.header endRefreshing];
        
    }
    if (self.isLoading) {
        
        self.isLoading = NO;
        [self.collectionView.footer endRefreshing];
    }


}

#pragma mark - 评测广场
-(void)pushComentSquare
{
    ComentSquareTableViewController *cvc = [[ComentSquareTableViewController alloc] init];
    
    [self.navigationController pushViewController:cvc animated:YES];
}
@end
