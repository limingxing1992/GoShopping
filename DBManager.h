//
//  DBManager.h
//  WorthToBuy
//
//  Created by qianfeng on 15/11/19.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppModel.h"

@interface DBManager : NSObject

+(instancetype)manager;

//功能
- (void)add:(AppModel *)model;

- (void)deletewithTitle:(NSString *)title;

-(NSArray *)getAllInfo;

-(BOOL)selectWithTitle:(NSString *)ID;

@end
