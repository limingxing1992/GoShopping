//
//  AppStore.m
//  什么值得买
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "AppStore.h"

@implementation AppStore

+(instancetype)sharedInstance
{
    static AppStore *store = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [[AppStore alloc] init];
    });
    
    return store;
}


-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.mainScroll = [[NSMutableArray alloc] init];
        self.threeView = [[NSMutableArray alloc] init];
        self.mainData = [[NSMutableArray alloc] init];
        
        self.youhuiTableData = [[NSMutableArray alloc] init];
        self.youhuiViewData = [[NSMutableArray alloc] init];
        
        self.haitaoTableData = [[NSMutableArray alloc] init];
        self.haitaoViewData = [[NSMutableArray alloc] init];
        
        self.EssenceData = [[NSMutableArray alloc] init];
        self.YCData = [[NSMutableArray alloc] init];
        
        self.comentAllData = [[NSMutableArray alloc] init];
        self.comentSquareData = [[NSMutableArray alloc] init];
        
        self.informationData = [[NSMutableArray alloc] init];
        
        self.searchCollectionData = [[NSMutableArray alloc] init];
        self.searchScrollData = [[NSMutableArray alloc] init];
        
        self.detailYouhuiData = [[NSMutableArray alloc] init];
        self.detailYC_ProData = [[NSMutableArray alloc] init];
        
        self.detailComentData = [[NSMutableArray alloc] init];
        
        self.dayBaicaiData = [[NSMutableArray alloc] init];
        
        self.daySortData = [[NSMutableArray alloc] init];
        
        self.dayValueData = [[NSMutableArray alloc] init];
    }
    
    return self;

}
@end
