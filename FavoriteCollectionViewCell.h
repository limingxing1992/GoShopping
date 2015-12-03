//
//  FavoriteCollectionViewCell.h
//  WorthToBuy
//
//  Created by qianfeng on 15/11/19.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppModel.h"

@interface FavoriteCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iv;

@property(nonatomic,strong)UIImageView *deleteImageView;

-(void)updateWithModel:(AppModel *)model;

@end
