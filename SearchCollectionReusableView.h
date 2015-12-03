//
//  SearchCollectionReusableView.h
//  什么值得买
//
//  Created by qianfeng on 15/11/13.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(NSString *Id,NSString *channalId);

typedef void(^BaicaiBlock)(NSString *type);

@interface SearchCollectionReusableView : UICollectionReusableView

@property(nonatomic,copy)MyBlock block;

@property(nonatomic,copy)BaicaiBlock  baicaiBlock;

-(void)upadateWith:(NSArray *)arry;

@end
