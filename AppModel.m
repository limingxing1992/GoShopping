//
//  AppModel.m
//  什么值得买
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}
-(instancetype)init
{
    self =[super init];
    if (self) {
        self.article_product_focus_pic_url = [[NSMutableArray alloc] init];
        self.redirect_data = [[NSMutableDictionary alloc] init];
        self.probation_banner = [[NSMutableArray alloc] init];
    }
    return self;
}
@end
