//
//  FavoriteCollectionViewCell.m
//  WorthToBuy
//
//  Created by qianfeng on 15/11/19.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "FavoriteCollectionViewCell.h"
#import <UIImageView+WebCache.h>


@interface FavoriteCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *title_lable;

@end

@implementation FavoriteCollectionViewCell

- (void)awakeFromNib {
    self.deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.deleteImageView.image = [UIImage imageNamed:@"cross"];
    self.deleteImageView.center = CGPointMake(self.iv.frame.size.width/2, self.iv.frame.size.height /2);
}

-(void)updateWithModel:(AppModel *)model
{
    [self.iv sd_setImageWithURL:[NSURL URLWithString:model.article_pic]];
    self.title_lable.numberOfLines = 0;
    self.title_lable.text = model.article_title;
}

@end
