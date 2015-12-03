//
//  DetailTableViewCell.h
//  什么值得买
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"

@interface DetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iv;
@property (strong, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) IBOutlet UILabel *price;

@property (strong, nonatomic) IBOutlet UILabel *mall;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *comment;
@property (strong, nonatomic) IBOutlet UILabel *value;

@property (strong, nonatomic) IBOutlet UILabel *small_tag;

-(void)updateWithModel:(AppModel *)model;

@end
