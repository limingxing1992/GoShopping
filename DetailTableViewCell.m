//
//  DetailTableViewCell.m
//  什么值得买
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "DetailTableViewCell.h"
#import <UIImageView+WebCache.h>

@interface DetailTableViewCell ()



@end
@implementation DetailTableViewCell


- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateWithModel:(AppModel *)model
{
//    [self.iv setImageWithURL:[NSURL URLWithString:model.article_pic] placeholderImage:[UIImage imageNamed:@"de_pic_mode_coupon"]];
    [self.iv sd_setImageWithURL:[NSURL URLWithString:model.article_pic]];
    self.title.text = model.article_title;
    self.price.text = model.article_price;
    if (model.article_rzlx) {
        self.mall.text = model.article_rzlx;
    }else{
        self.mall.text = model.article_mall;
    }
    self.date.text = model.article_format_date;
    self.comment.text = model.article_comment;
    
    if (model.article_channel_name ) {
        self.small_tag.text =model.article_channel_name;
    }else if([model.article_channel_name isEqualToString:@"资讯"]){
        [self.small_tag removeFromSuperview];
    }else{
        [self.small_tag removeFromSuperview];
    }
    
    //计算百分比
    float f1 = [model.article_worthy floatValue];
    float f2 = [model.article_unworthy floatValue];
    float sum = f1 + f2;
    float result = f1/sum * 100;
    self.value.text = [NSString stringWithFormat:@"%.2f%@",result,@"%"];
    
    
}

@end
