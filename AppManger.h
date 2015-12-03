//
//  AppManger.h
//  什么值得买
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppManger : NSObject

//首页，海淘，国内请求方法
+(void)requestDataWithUrl:(NSString *)url Success:(void(^)())success Failure:(void(^)())failure withBool:(BOOL)refresh Type:(NSString *)type;




@end
