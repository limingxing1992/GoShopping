//
//  AppModel.h
//  什么值得买
//
//  Created by qianfeng on 15/11/11.
//  Copyright (c) 2015年 李明星. All rights reserved.
//
/**
 "article_channel_id":"5",
 "article_channel_name":"海淘",
 "article_id":"357757",
 "article_url":"http://haitao.smzdm.com/p/357757",
 "article_title":"PFU Happy Hacking Keyboard Professional 2 静电容键盘",
 "article_price":"19444日元",
 "article_date":"2015-11-11 16:44:38",
 "article_format_date":"16:44",
 "article_referrals":"KenC",
 "article_tag":"",
 "article_link":"http://www.smzdm.com/URL/AE/HT/B9331EA3C57B5706",
 "article_link_type":"1",
 "article_link_list":[
 
 ],
 "article_pic":"http://y.zdmimg.com/201507/17/55a89c407713f.jpg_d320.jpg",
 "article_worthy":"0",
 "article_unworthy":"0",
 "article_is_sold_out":"",
 "article_is_timeout":"",
 "article_collection":"1",
 "article_comment":"0",
 "article_mall":"日本亚马逊",
 "article_top":"0",
 "time_sort":"144723147867",
 "matches_rules":""
 },
 */
#import <Foundation/Foundation.h>

@interface AppModel : NSObject


//滚动视图
@property(nonatomic,copy)NSString *img;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *link;
@property(nonatomic,strong)NSMutableDictionary *redirect_data;

//表视图
@property(nonatomic,copy)NSString *article_channel_name;
@property(nonatomic,copy)NSString *article_title;
@property(nonatomic,copy)NSString *article_url;
@property(nonatomic,copy)NSString *article_id;
@property(nonatomic,copy)NSString *article_price;
@property(nonatomic,copy)NSString *article_mall;
@property(nonatomic,copy)NSString *article_format_date;
@property(nonatomic,copy)NSString *article_pic;
@property(nonatomic,copy)NSString *article_comment;
@property(nonatomic,copy)NSString *article_worthy;
@property(nonatomic,copy)NSString *article_unworthy;
@property(nonatomic,copy)NSString *time_sort;
@property(nonatomic,copy)NSString *article_date;
@property(nonatomic,copy)NSString *article_channel_id;
@property(nonatomic,copy)NSString *article_link;
//原创界面

@property(nonatomic,copy)NSString *article_avatar;
@property(nonatomic,copy)NSString *article_referrals;
@property(nonatomic,copy)NSString *article_favorite;
@property(nonatomic,copy)NSString *article_type_name;
@property(nonatomic,copy)NSString *article_filter_content;

//众测界面数据

@property(nonatomic,copy) NSString *probation_title;
@property(nonatomic,copy) NSString *probation_need_point;
@property(nonatomic,copy) NSString *probation_status_name;
@property(nonatomic,copy) NSString *probation_product_num;
@property(nonatomic,copy) NSString *probation_img;
@property(nonatomic,copy) NSString *probation_url;
@property(nonatomic,copy) NSString *probation_id;

//资讯界面数据
@property(nonatomic,copy) NSString *article_rzlx;

//详细页面数据

//仅限于海淘，国内，发现三种cell使用
@property(nonatomic,strong)NSMutableArray *article_product_focus_pic_url;
@property(nonatomic,copy) NSString *html5_content;

//原创和资讯cell使用
@property(nonatomic,copy)NSString *share_title;
@property(nonatomic,copy)NSString *share_pic;

//众测界面cell使用

@property(nonatomic,copy)NSString *probation_content;
@property(nonatomic,copy)NSString *probation_rule;
@property(nonatomic,copy)NSString *redirect_link;
@property(nonatomic,strong)NSMutableArray *probation_banner;

@property(nonatomic,copy)NSString *probation_need_gold;
@property(nonatomic,copy)NSString *probation_product_price;
@property(nonatomic,copy)NSString *apply_num;
@property(nonatomic,copy)NSString *apply_end_date;

@end
