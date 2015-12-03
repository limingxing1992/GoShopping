//
//  SquareTableViewCell.m
//  什么值得买
//
//  Created by qianfeng on 15/11/13.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "SquareTableViewCell.h"
#import <UIImageView+WebCache.h>


@interface SquareTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *iv;
@property (strong, nonatomic) IBOutlet UIImageView *smallPic;
@property (strong, nonatomic) IBOutlet UILabel *author;

@property (strong, nonatomic) IBOutlet UILabel *comment;
@property (strong, nonatomic) IBOutlet UILabel *title;
@end

@implementation SquareTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateWith:(AppModel *)model
{
//    [self.iv setImageWithURL:[NSURL URLWithString:model.article_pic] placeholderImage:[UIImage imageNamed:@"de_pic_mode_coupon"]];
    
    [self.iv sd_setImageWithURL:[NSURL URLWithString:model.article_pic]];
    
    self.smallPic.layer.cornerRadius = 10;
    self.smallPic.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];;
    self.smallPic.clipsToBounds = YES;
//    [self.smallPic setImageWithURL:[NSURL URLWithString:model.article_avatar] placeholderImage:[UIImage imageNamed:@"de_pic_mode_coupon"]];
    [self.smallPic sd_setImageWithURL:[NSURL URLWithString:model.article_avatar]];
    
    self.title.text = model.article_title;
    self.title.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    self.author.text = model.article_referrals;

    self.comment.text = model.article_comment;

    

}
@end
