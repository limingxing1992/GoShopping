//
//  MyHeader.h
//  什么值得买
//
//  Created by qianfeng on 15/11/10.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#ifndef ______MyHeader_h
#define ______MyHeader_h


#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define Zero 0


//首页界面类型
#define kHomeType @"home"

//国内界面类型
#define kYouhuiType @"youhui"

//海淘界面类型

#define kHaitaoType @"haitao"

//原创界面之精华界面类型
#define kEssenceType @"essence"
//分类界面类型
#define kYCType @"YC"


//众测界面类型
#define kComentAllType @"comentAll"
//评测广场界面类型
#define kComentSquareType @"comentSquare"

//资讯界面类型
#define kInformationType @"information"


//详细页面类型
#define kDetailType @"detail"

//详细页原创和咨询
#define kDetail_yc_proType @"yc_pro"

//发现界面
#define kSearchType @"search"

//众测详细类型
#define kDetailComentType @"detail_coment"

//每日白菜类型
#define kDayBaicaiType @"baicai"

//每日排行类型
#define kDaySortType @"daySort"

//每日超值单品类型
#define kDayValueType @"value"

//幸运屋类型
#define kLuckyType @"lucky"

//------------------------------------------------------------------------


//首页滚动视图接口
#define KMainViewUrl @"https://api.smzdm.com/v2/util/banner/?type=home&f=android"
//首页表示图上拉接口
#define KMainDataUrl @"https://api.smzdm.com/v1/home/articles/?limit=20&have_zhuanti=1&time_sort=%@&f=android"
//首页表示图下拉接口
#define kMainNewUrl @"https://api.smzdm.com/v1/home/articles/?limit=20&time_sort=&f=android"

//------------------------------------------------------------------------


//国内滚动视图接口
#define kYouhuilUrl @"https://api.smzdm.com/v2/util/banner/?type=youhui&f=android"

//国内表示图上拉接口
#define kYouhuiTableUpUrl @"https://api.smzdm.com/v1/youhui/articles/?limit=20&article_date=%@&f=android"

#define kYouhuiTableDownUrl @"https://api.smzdm.com/v1/youhui/articles/?limit=20&article_date=&f=android"


//------------------------------------------------------------------------

//海淘界面视图接口
#define kHaitaoUrl @"https://api.smzdm.com/v2/util/banner/?type=haitao&f=android"

//海淘上拉接口
#define kHaitaoTableUpUrl @"https://api.smzdm.com/v1/haitao/articles/?limit=20&article_date=%@&f=android"

//海淘下拉接口

#define kHaitaoTableDownUrl @"https://api.smzdm.com/v1/haitao/articles/?limit=20&article_date=&f=android"

//------------------------------------------------------------------------

//原创界面
//精华下拉刷新接口
#define kEssenceDownUrl @"https://api.smzdm.com/v1/yuanchuang/articles/?limit=20&article_date=&f=android"
//精华上拉加载接口
#define kEssenceUpUrl @"https://api.smzdm.com/v1/yuanchuang/articles/?limit=20&article_date=%@&f=android"


//原创中开箱等接口
#define kYCUrl @"https://api.smzdm.com/v1/yuanchuang/articles/?limit=20&article_date=%@&article_type=%@&f=android"

//原创全部，排行等接口
#define kSortUrl @"https://api.smzdm.com/v1/yuanchuang/articles/?limit=20&filter=%@&offset=%ld&f=android"

//----------------------------------------------------------------------------
//众测界面接口
#define kComentAllUrl @"https://api.smzdm.com/v1/test/probation/?limit=20&offset=%ld&f=android"

//评测广场界面接口
#define kComentSquareUrl @"https://api.smzdm.com/v1/pingce/articles/?limit=20&article_date=%@&f=android"

#define kComentSquareClearUrl @"https://api.smzdm.com/v1/pingce/articles/?limit=20&article_date=&f=android"

//----------------------------------------------------------------------------
//资讯界面接口

#define kInformationClearUrl @"https://api.smzdm.com/v1/news/articles/?limit=20&article_date=&f=android"

#define kInformationUrl @"https://api.smzdm.com/v1/news/articles/?limit=20&article_date=%@&f=android"

//----------------------------------------------------------------------------
//发现界面接口

//滚动视图接口
#define kSearchViewUrl @"https://api.smzdm.com/v2/util/banner/?type=faxian&f=android"

//集合视图接口
#define kSearchUrl @"https://api.smzdm.com/v1/faxian/articles/?limit=20&article_date=%@"

#define kSearchClearUrl @"https://api.smzdm.com/v1/faxian/articles/?limit=20&article_date="

//----------------------------------------------------------------------------

//详细页面接口

#define kDetailUrl @"https://api.smzdm.com/v2/youhui/articles/%@?channel_id=%@"

//详细页原创和资讯接口
#define kDetai_yc_pro_url @"https://api.smzdm.com/v2/%@/articles/%@?channel_id=%@"

//众测也详细接口
#define kDetailComentUrl @"https://api.smzdm.com/v1/test/probation/%@"


//----------------------------------------------------------------------------
//每日白菜页面接口
#define kDayBaicaiUrl @"https://api.smzdm.com/v1/faxian/articles/?limit=20&tag=322337&article_date=%@"
#define kDayBaicaiClearUrl @"https://api.smzdm.com/v1/faxian/articles/?limit=20&tag=322337&article_date="

//发现接口
#define kDaySortUrl @"https://api.smzdm.com/v1/faxian/articles/?limit=20&offset=%ld&filter=hot_1&get_total=1&f=android"

//超值单品接口
#define kDayValueUrl @"https://api.smzdm.com/v1/faxian/articles/?limit=20&tag=297943&article_date=%@"
#define kDayValueClearUrl @"https://api.smzdm.com/v1/faxian/articles/?limit=20&tag=297943&article_date="

//幸运物网址
#define kLuckyUrl @"http://zhiyou.smzdm.com/user/crowd"

#endif
