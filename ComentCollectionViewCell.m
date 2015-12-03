//
//  ComentCollectionViewCell.m
//  什么值得买
//
//  Created by qianfeng on 15/11/13.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "ComentCollectionViewCell.h"
#import <UIImageView+WebCache.h>

@interface ComentCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *type_name;
@property (strong, nonatomic) IBOutlet UIImageView *iv;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *num;

@end


@implementation ComentCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}


-(void)updateWith:(AppModel *)model
{
    
    self.type_name.text = model.probation_status_name;
    [self.iv sd_setImageWithURL:[NSURL URLWithString:model.probation_img]];
    self.title.text = model.probation_title;
    self.price.text = model.probation_need_point;
    self.num.text = model.probation_product_num;
}
@end
