//
//  AppStore.h
//  什么值得买
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppStore : NSObject


//首页滚动视图
@property(nonatomic,strong)NSMutableArray *mainScroll;
//三个view
@property(nonatomic,strong)NSMutableArray *threeView;
//表示图数据源
@property(nonatomic,strong)NSMutableArray *mainData;


//国内页
@property(nonatomic,strong)NSMutableArray *youhuiViewData;
@property(nonatomic,strong)NSMutableArray *youhuiTableData;


//海淘页
@property(nonatomic,strong)NSMutableArray *haitaoViewData;
@property(nonatomic,strong)NSMutableArray *haitaoTableData;


//原创页数据
//精华界面数据源
@property(nonatomic,strong)NSMutableArray *EssenceData;
//其他分类数据源
@property(nonatomic,strong)NSMutableArray *YCData;


//众测页
//众测界面数据源
@property(nonatomic,strong)NSMutableArray *comentAllData;
//评测广场数据源
@property(nonatomic,strong)NSMutableArray *comentSquareData;


//资讯界面数据源
@property(nonatomic,strong)NSMutableArray *informationData;


//发现界面数据源
@property(nonatomic,strong)NSMutableArray *searchScrollData;

@property(nonatomic,strong)NSMutableArray *searchCollectionData;

//详细页面数据
@property(nonatomic,strong)NSMutableArray *detailYouhuiData;
//详细页原创和资讯数据
@property(nonatomic,strong)NSMutableArray *detailYC_ProData;

//众测页面详细数据源
@property(nonatomic,strong)NSMutableArray *detailComentData;

//每日白菜页面数据源
@property(nonatomic,strong)NSMutableArray *dayBaicaiData;

//每日排行数据源
@property(nonatomic,strong)NSMutableArray *daySortData;

//每日超值单品数据源
@property(nonatomic,strong)NSMutableArray *dayValueData;

+(instancetype)sharedInstance;

@end
