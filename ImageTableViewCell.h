//
//  ImageTableViewCell.h
//  什么值得买
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"

typedef void(^MyBlock)(NSString *Id,NSString *channalId);


@interface ImageTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *Big;
@property (strong, nonatomic) IBOutlet UIImageView *smallUp;
@property (strong, nonatomic) IBOutlet UIImageView *smallDown;
@property(nonatomic,copy)MyBlock block;
@property (strong,nonatomic)NSArray *arry;


-(void)updateWithModel:(NSMutableArray *)arr;


@end
