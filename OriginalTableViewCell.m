//
//  OriginalTableViewCell.m
//  什么值得买
//
//  Created by qianfeng on 15/11/12.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "OriginalTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface OriginalTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *topPic;
@property (strong, nonatomic) IBOutlet UILabel *time;

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *article;
@property (strong, nonatomic) IBOutlet UIImageView *smallPic;
@property (strong, nonatomic) IBOutlet UILabel *author;
@property (strong, nonatomic) IBOutlet UILabel *type;
@property (strong, nonatomic) IBOutlet UILabel *coment;
@property (strong, nonatomic) IBOutlet UILabel *favorite;

@end


@implementation OriginalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateWith:(AppModel *)model
{
    self.smallPic.layer.cornerRadius = 25;
    self.smallPic.clipsToBounds = YES;
    [self.topPic sd_setImageWithURL:[NSURL URLWithString:model.article_pic]];
    [self.smallPic sd_setImageWithURL:[NSURL URLWithString:model.article_avatar]];
    self.time.text = model.article_format_date;
    self.title.text = model.article_title;
    self.article.text = model.article_filter_content;
    self.author.text = model.article_referrals;
    self.type.text = model.article_type_name;
    self.coment.text = model.article_comment;
    self.favorite.text = model.article_favorite;
}

@end
