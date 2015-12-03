//
//  AppManger.m
//  什么值得买
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "AppManger.h"
#import <AFNetworking.h>
#import "AppModel.h"
#import "AppStore.h"
#import "MyHeader.h"

@implementation AppManger

+(void)requestDataWithUrl:(NSString *)url Success:(void(^)())success Failure:(void(^)())failure withBool:(BOOL)refresh Type:(NSString *)type
{
    AFHTTPRequestOperationManager *manager  = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dict = dic[@"data"];
        NSArray *arry1 = dict[@"rows"];
        
        
        //首页数据请求--------------------------------
        
        
        if ([type isEqualToString:kHomeType]) {
            if (refresh && [url isEqualToString:kMainNewUrl]) {
                [[AppStore sharedInstance].mainData removeAllObjects];
            }
            //首页滚动视图请求
            if ([url isEqualToString:KMainViewUrl]) {
                
                [[AppStore sharedInstance].mainScroll removeAllObjects];
                [[AppStore sharedInstance].threeView removeAllObjects];
                
                NSArray *arry2 = dict[@"little_banner"];
                for (NSDictionary *new in arry1) {
                    AppModel *model = [[AppModel alloc] init];
                    [model setValuesForKeysWithDictionary:new];
                    [[AppStore sharedInstance].mainScroll addObject:model];
                }
                for (NSDictionary *three in arry2) {
                    AppModel *model = [[AppModel alloc] init];
                    [model setValuesForKeysWithDictionary:three];
                    [[AppStore sharedInstance].threeView addObject:model];
                }
            }else{
                for (NSDictionary *new in arry1) {
                    
                    AppModel *model = [[AppModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:new];
                    [[AppStore sharedInstance].mainData addObject:model];
                }
            }
        }
        
        
        //国内页数据请求-----------------------------------
        
        if ([type isEqualToString:kYouhuiType]) {
            
            if (refresh &&[url isEqualToString:kYouhuiTableDownUrl]) {
                [[AppStore sharedInstance].youhuiTableData removeAllObjects];
            }
            
            
            
            
            if ([url isEqualToString:kYouhuilUrl]) {
                [[AppStore sharedInstance].youhuiViewData removeAllObjects];
                NSArray *arry2 = dict[@"little_banner"];
                for (NSDictionary *three in arry2) {
                    AppModel *model = [[AppModel alloc] init];
                    [model setValuesForKeysWithDictionary:three];
                    [[AppStore sharedInstance].youhuiViewData addObject:model];
                }
            }else{
                
                for (NSDictionary *new in arry1) {
                    
                    AppModel *model = [[AppModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:new];
                    [[AppStore sharedInstance].youhuiTableData addObject:model];
                }
                
            }
            
        }
        
        //海淘页数据请求-----------------------------------
        
        if ([type isEqualToString:kHaitaoType]) {
            
            if (refresh &&[url isEqualToString:kHaitaoTableDownUrl]) {
                [[AppStore sharedInstance].haitaoTableData removeAllObjects];
            }
            
            if ([url isEqualToString:kHaitaoUrl]) {
                [[AppStore sharedInstance].haitaoViewData removeAllObjects];
                NSArray *arry2 = dict[@"little_banner"];
                for (NSDictionary *three in arry2) {
                    AppModel *model = [[AppModel alloc] init];
                    [model setValuesForKeysWithDictionary:three];
                    [[AppStore sharedInstance].haitaoViewData addObject:model];
                }
            }else{
                
                for (NSDictionary *new in arry1) {
                    
                    AppModel *model = [[AppModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:new];
                    [[AppStore sharedInstance].haitaoTableData addObject:model];
                }
                
            }
            
        }
        
        //精华界面请求--------------------------------------------------------
        if ([type isEqualToString:kEssenceType]) {
            
            if (refresh &&[url isEqualToString:kEssenceDownUrl]) {
                [[AppStore sharedInstance].EssenceData removeAllObjects];
            }
            
            for (NSDictionary *new in arry1) {
                
                AppModel *model = [[AppModel alloc] init];
                
                [model setValuesForKeysWithDictionary:new];
                [[AppStore sharedInstance].EssenceData addObject:model];
            }
            
        }
        //原创界面请求------------------------------------------------
        if ([type isEqual:kYCType]) {
            if (refresh) {
                
                [[AppStore sharedInstance].YCData removeAllObjects];
                
            }
            
            for (NSDictionary *new in arry1) {
                
                AppModel *model = [[AppModel alloc] init];
                
                [model setValuesForKeysWithDictionary:new];
                [[AppStore sharedInstance].YCData addObject:model];
            }

        }
        //评测界面请求------------------------------------------------

        if ([type isEqualToString:kComentAllType]) {
            
            if (refresh) {
                [[AppStore sharedInstance].comentAllData removeAllObjects];
            }
            
            for (NSDictionary *new in arry1) {
                
                AppModel *model = [[AppModel alloc] init];
                
                [model setValuesForKeysWithDictionary:new];
                [[AppStore sharedInstance].comentAllData addObject:model];
            }
            
        }
        
        if ([type isEqualToString:kComentSquareType]) {
            
            if (refresh) {
                [[AppStore sharedInstance].comentSquareData removeAllObjects];
            }
            
            for (NSDictionary *new in arry1) {
                
                AppModel *model = [[AppModel alloc] init];
                
                [model setValuesForKeysWithDictionary:new];
                [[AppStore sharedInstance].comentSquareData addObject:model];
            }

        }
        
        //资讯界面请求------------------------------------------------

        
        if ([type isEqualToString:kInformationType]) {

            if (refresh) {
                [[AppStore sharedInstance].informationData removeAllObjects];
            }
            
            for (NSDictionary *new in arry1) {
                
                AppModel *model = [[AppModel alloc] init];
                
                [model setValuesForKeysWithDictionary:new];
                [[AppStore sharedInstance].informationData addObject:model];
            }

        }
        
        //发现界面请求----------------------------------------------------
        if ([type isEqualToString:kSearchType]) {
            
            if (refresh &&[url isEqualToString:kSearchClearUrl]) {
                [[AppStore sharedInstance].searchCollectionData removeAllObjects];
            }
            if ([url isEqualToString:kSearchViewUrl]) {
                [[AppStore sharedInstance].searchScrollData removeAllObjects];
                
                NSArray *arry2 = dict[@"little_banner"];
                for (NSDictionary *little in arry2) {
                    AppModel *model = [[AppModel alloc] init];
                    [model setValuesForKeysWithDictionary:little];
                    [[AppStore sharedInstance].searchScrollData addObject:model];
                }
                
                for (NSDictionary *row in arry1) {
                    AppModel *model = [[AppModel alloc] init];
                    [model setValuesForKeysWithDictionary:row];
                    [[AppStore sharedInstance].searchScrollData addObject:model];
                }
            }else{
            
                for (NSDictionary *new in arry1) {
                    
                    AppModel *model = [[AppModel alloc] init];
                    [model setValuesForKeysWithDictionary:new];
                    [[AppStore sharedInstance].searchCollectionData addObject:model];
                }

            }
            
        }
        //详细界面请求----------------------------------------------------
        if ([type isEqualToString:kDetailType]) {
            [[AppStore sharedInstance].detailYouhuiData removeAllObjects];
            
            AppModel *model =[[AppModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [[AppStore sharedInstance].detailYouhuiData addObject:model];
        }
        
        //详细 原创和资讯界面请求------------------------------------------------
        if ([type isEqualToString:kDetail_yc_proType]) {
            
            [[AppStore sharedInstance].detailYC_ProData removeAllObjects];
            AppModel *model = [[AppModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [[AppStore sharedInstance].detailYC_ProData addObject:model];
            
        }
        //详细 --众测界面请求------------------------------------------------
        if ([type isEqualToString:kDetailComentType]) {
            [[AppStore sharedInstance].detailComentData removeAllObjects];
            
            AppModel *model = [[AppModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [[AppStore sharedInstance].detailComentData addObject:model];
        }
        
        //白菜界面请求------------------------------------------------
        if ([type isEqualToString:kDayBaicaiType]) {
            
            if (refresh) {
                [[AppStore sharedInstance].dayBaicaiData removeAllObjects];
            }
            
            for (NSDictionary *new in arry1) {
                
                AppModel *model = [[AppModel alloc] init];
                
                [model setValuesForKeysWithDictionary:new];
                [[AppStore sharedInstance].dayBaicaiData addObject:model];
            }
            
        }

        //每日排行界面请求------------------------------------------------
        if ([type isEqualToString:kDaySortType]) {
            
            if (refresh) {
                [[AppStore sharedInstance].daySortData removeAllObjects];
            }
            
            for (NSDictionary *new in arry1) {
                
                AppModel *model = [[AppModel alloc] init];
                
                [model setValuesForKeysWithDictionary:new];
                [[AppStore sharedInstance].daySortData addObject:model];
            }

        }
        
        //每日超值界面请求------------------------------------------------
        if ([type isEqualToString:kDayValueType]) {
            if (refresh) {
                [[AppStore sharedInstance].dayValueData removeAllObjects];
            }
            
            for (NSDictionary *new in arry1) {
                
                AppModel *model = [[AppModel alloc] init];
                
                [model setValuesForKeysWithDictionary:new];
                [[AppStore sharedInstance].dayValueData addObject:model];
            }

        }

        
        success();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"EERROR = %@",error.localizedDescription);
        failure();
    }];
    

}



@end
