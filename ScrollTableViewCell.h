//
//  ScrollTableViewCell.h
//  什么值得买
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppModel.h"


typedef void(^MyBlock)(NSString *Id,NSString *channalId);

@interface ScrollTableViewCell : UITableViewCell

-(void)updateWithModel:(NSMutableArray *)arr;


@property(nonatomic,copy)MyBlock block;

@end
