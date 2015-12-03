//
//  AllSubjectViewController.m
//  什么值得买
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "AllSubjectViewController.h"
#import "MyHeader.h"
#import "DBManager.h"
#import "AppModel.h"
#import "FavoriteCollectionViewCell.h"
#import "DetailViewController.h"

@interface AllSubjectViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    BOOL _rightButtonEdit;
}

@property(nonatomic,strong)UICollectionView *collectionView;

@end

@implementation AllSubjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //按钮状态
    _rightButtonEdit = NO;
    
    [self createCollectionView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.collectionView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:NO];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"btn_bg_red"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(onDelete:)];
}

-(void)onDelete:(UIBarButtonItem *)item
{
    if (_rightButtonEdit == NO) {
        item.title = @"完成";
        _rightButtonEdit = YES;
        [self.collectionView reloadData];
    }else if (_rightButtonEdit == YES){
        item.title = @"删除";
        _rightButtonEdit = NO;
        [self.collectionView reloadData];
    }
}
#pragma mark -构造视图
-(UICollectionViewLayout *)makeLayout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth /2 -5, 200);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    return layout;
    

}

-(void)createCollectionView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 113) collectionViewLayout:[self makeLayout]];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FavoriteCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Favorite"];
    [self.view addSubview:self.collectionView];
}


#pragma mark -代理
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[DBManager manager] getAllInfo].count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FavoriteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Favorite" forIndexPath:indexPath];

    [cell updateWithModel:[[DBManager manager] getAllInfo][indexPath.row]];
    if (_rightButtonEdit == YES) {
        [cell.iv addSubview:cell.deleteImageView];
    }else{
        [cell.deleteImageView removeFromSuperview];
    }
    return cell;

}
#pragma mark -选中
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppModel *model = [[DBManager manager] getAllInfo][indexPath.row];
    if (_rightButtonEdit == YES) {
        [[DBManager manager] deletewithTitle:model.article_id];
        [self.collectionView reloadData];
    }else{
        NSString *icd = model.article_channel_id;
        if ([icd isEqualToString:@"1"] || [icd isEqualToString:@"2"] || [icd isEqualToString:@"5"]) {
            
            DetailViewController *dvc = [[DetailViewController alloc] init];
            dvc.type_id = model.article_channel_id;
            dvc.Id = model.article_id;
            [self.navigationController pushViewController:dvc animated:YES];
            
        }
    }
}
@end
