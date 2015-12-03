//
//  SearchCollectionViewCell.m
//  什么值得买
//
//  Created by qianfeng on 15/11/13.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "SearchCollectionViewCell.h"
#import <UIImageView+WebCache.h>


@interface SearchCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *iv;

@property (strong, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) IBOutlet UILabel *price;

@property (strong, nonatomic) IBOutlet UILabel *small;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *coment;

@end

@implementation SearchCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)updateWithModel:(AppModel *)model
{
//    [self.iv setImageWithURL:[NSURL URLWithString:model.article_pic] placeholderImage:[UIImage imageNamed:@"de_pic_mode_coupon"]];
    [self.iv sd_setImageWithURL:[NSURL URLWithString:model.article_pic]];
    
    self.title.text = model.article_title;
    self.price.text = model.article_price;
    self.small.text = model.article_mall;
    self.date.text = model.article_format_date;
    self.coment.text = model.article_comment;
}
@end
