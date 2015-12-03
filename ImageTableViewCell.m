//
//  ImageTableViewCell.m
//  什么值得买
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "ImageTableViewCell.h"
#import <UIImageView+WebCache.h>


@implementation ImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)updateWithModel:(NSMutableArray *)arr
{

    if (arr.count < 3) {
        return;
    }
    
    self.arry = [NSArray arrayWithArray:arr];
    
//    [self.Big setImageWithURL:[NSURL URLWithString:[arr[0] img]] placeholderImage:[UIImage imageNamed:@"de_pic_mode_coupon"]];
    [self.Big sd_setImageWithURL:[NSURL URLWithString:[arr[0] img]] placeholderImage:[UIImage imageNamed:@"de_pic_mode_coupon"]];
    self.Big.userInteractionEnabled = YES;
    self.Big.tag = 0;
    
    UITapGestureRecognizer *ges1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
    ges1.numberOfTapsRequired = 1;
    [self.Big addGestureRecognizer:ges1];
    
//    [self.smallUp setImageWithURL:[NSURL URLWithString:[arr[1] img]] placeholderImage:[UIImage imageNamed:@"de_pic_mode_coupon"]];
    [self.smallUp sd_setImageWithURL:[NSURL URLWithString:[arr[1] img]]];

    self.smallUp.userInteractionEnabled = YES;
    self.smallUp.tag = 1;
    
    UITapGestureRecognizer *ges2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
    ges2.numberOfTapsRequired = 1;
    [self.smallUp addGestureRecognizer:ges2];

    
    
    [self.smallDown sd_setImageWithURL:[NSURL URLWithString:[arr[2] img]]];
    self.smallDown.userInteractionEnabled = YES;
    self.smallDown.tag = 2;
    
    UITapGestureRecognizer *ges3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClick:)];
    ges3.numberOfTapsRequired = 1;
    [self.smallDown addGestureRecognizer:ges3];

    
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

@end
