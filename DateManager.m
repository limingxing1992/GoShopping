//
//  DateManager.m
//  WorthToBuy
//
//  Created by qianfeng on 15/11/17.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "DateManager.h"

@implementation DateManager

+(NSArray *)dateSinceFromNowWithNs:(NSString *)endDate
{
    //获取系统时区
    NSTimeZone *tz = [NSTimeZone systemTimeZone];
    //返回tz时区与GMT的时间差
    NSInteger sub = [tz secondsFromGMT];
    NSDate *current = [[NSDate date] dateByAddingTimeInterval:sub];
    
    
    //将一个字符串转换为时间
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSDate *date2 = [format dateFromString:endDate];
    
    
    NSTimeZone *tzf = [NSTimeZone systemTimeZone];
    NSInteger gm = [tzf secondsFromGMT];
    
    NSDate *date3 = [date2 dateByAddingTimeInterval:gm];
    NSTimeInterval val = [date3 timeIntervalSinceDate:current];
    NSInteger day = val/60/60/24;
    NSInteger hour_all = val/60/60;
    NSInteger hour_lis = hour_all %24;
    
    NSInteger min = val /60;
    NSInteger min_lis = min %60;
    NSInteger second = (NSInteger)val %60;

    NSString *day_time = [NSString stringWithFormat:@"%ld",day];
    NSString *hour_time = [NSString stringWithFormat:@"%ld",hour_lis];
    NSString *min_time = [NSString stringWithFormat:@"%ld",min_lis];
    NSString *second_time = [NSString stringWithFormat:@"%ld",second];
    return @[day_time,hour_time,min_time,second_time];
}

@end
