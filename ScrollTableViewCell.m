//
//  ScrollTableViewCell.m
//  什么值得买
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "ScrollTableViewCell.h"

#import <UIImageView+WebCache.h>
#import "MyHeader.h"

@interface ScrollTableViewCell ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong,nonatomic)NSArray *arry;
@property (strong,nonatomic)UIPageControl  *pageControl;

@end

@implementation ScrollTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)updateWithModel:(NSMutableArray *)arr
{

    self.arry = [NSArray arrayWithArray:arr];
    CGSize size = self.scrollView.frame.size;
    
    self.scrollView.contentSize = CGSizeMake( kScreenWidth* arr.count, size.height);
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    for (NSInteger i = 0; i <arr.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i *kScreenWidth, 0, kScreenWidth, size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[arr[i] img]]];
        
        
        imageView.userInteractionEnabled  =YES;
        imageView.tag = i;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
        ges.numberOfTapsRequired = 1;
        [imageView addGestureRecognizer:ges];
        
        [self.scrollView addSubview:imageView];
    }
    
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
    }else if ([type_ID isEqualToString:@"news"]){
        channal_id = @"6";
    }else if ([type_ID isEqualToString:@"yuanchuang"]){
        channal_id = @"11";
    }
    
    if (self.block&&channal_id) {
        self.block(Id,channal_id);
    }
}

-(void)customPageControl
{
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height -20, self.frame.size.width, 20)];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.numberOfPages = self.arry.count;
    [self addSubview:self.pageControl];
}

#pragma mark ----------滚动代理

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
    
}
@end
