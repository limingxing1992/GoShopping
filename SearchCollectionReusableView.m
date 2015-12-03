//
//  SearchCollectionReusableView.m
//  什么值得买
//
//  Created by qianfeng on 15/11/13.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "SearchCollectionReusableView.h"
#import "AppModel.h"
#import <UIImageView+WebCache.h>
#import "MyHeader.h"

@interface SearchCollectionReusableView ()<UIScrollViewDelegate>

@property(nonatomic,strong)NSArray *arry;

@property(nonatomic,strong)UIPageControl *pageControl;
@end

@implementation SearchCollectionReusableView


-(void)upadateWith:(NSArray *)arry
{
    self.backgroundColor = [UIColor whiteColor];
    if (arry.count ==0) {
        return;
    }
    
    self.arry = [NSArray arrayWithArray:arry];
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    
    for (NSInteger i= 0; i <4; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(i * width/4+10, height/5*3+5, width/4-18, height/5*2-20);
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        //添加按钮
        UITapGestureRecognizer *ges  =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onEnt:)];
        
        [imageView addGestureRecognizer:ges];
        
        
        
        AppModel *model = arry[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*width/4, height-20, width/4, 20)];
        label.font =[UIFont systemFontOfSize:10];
        label.text = model.title;
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:imageView];
        [self addSubview:label];
        
    }
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height/5*3)];
    scrollView.showsHorizontalScrollIndicator =NO;
    scrollView.contentOffset = CGPointMake(0, 0);
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(width *(arry.count-4), height/5*3);
    scrollView.pagingEnabled = YES;
    scrollView.bounces =NO;
    CGFloat width_scro = scrollView.frame.size.width;
    CGFloat height_scro = scrollView.frame.size.height;
    for (NSInteger i= 4; i <arry.count ; i++) {
        AppModel *model = arry[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i-4)* width_scro, 0, width_scro, height_scro)];
//        [imageView setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"de_pic_mode_coupon"]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"de_pic_mode_coupon"]];
        imageView.userInteractionEnabled  =YES;
        imageView.tag = i;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
        ges.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:ges];

        
        
        [scrollView addSubview:imageView];
    }
    
    [self addSubview:scrollView];
    
    [self customPageControl];

}

-(void)onClick:(UITapGestureRecognizer *)ges
{
    
    NSInteger flag = ges.view.tag;
    
    AppModel *model = self.arry[flag];
    
    
    NSString *Id = model.redirect_data[@"link_val"];
    NSString *type_ID = model.redirect_data[@"link_type"];
    NSString *channal_id = nil;
    if ([type_ID isEqualToString:@"haitao"]) {
        channal_id = @"5";
    }else if ([type_ID isEqualToString:@"youhui"]){
        channal_id = @"1";
    }else if ([type_ID isEqualToString:@"faxian"]){
        channal_id = @"2";
    }
    
    if (self.block&&channal_id) {
        self.block(Id,channal_id);
    }

}

-(void)onEnt:(UITapGestureRecognizer *)ges
{
    NSInteger flag = ges.view.tag;
    if (flag == 0) {
        if (self.baicaiBlock) {
            self.baicaiBlock(kDayBaicaiType);
        }
    }
    if (flag == 1) {
        if (self.baicaiBlock) {
            self.baicaiBlock(kDaySortType);
        }
    }
    if (flag == 2) {
        if (self.baicaiBlock) {
            self.baicaiBlock(kDayValueType);
        }
    }
    if (flag == 3) {
        if (self.baicaiBlock) {
            self.baicaiBlock(kLuckyType);
        }
    }
}

-(void)customPageControl
{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height/5*3 -20, self.frame.size.width, 20)];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.numberOfPages = self.arry.count -4;
    [self addSubview:self.pageControl];
}

#pragma mark ------------代理
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x/ scrollView.frame.size.width;
}

@end
