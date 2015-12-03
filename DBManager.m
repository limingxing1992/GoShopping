//
//  DBManager.m
//  WorthToBuy
//
//  Created by qianfeng on 15/11/19.
//  Copyright (c) 2015年 李明星. All rights reserved.
//

#import "DBManager.h"
#import <FMDB.h>
@interface DBManager ()

@property(nonatomic,strong)FMDatabase *fm;

@end


@implementation DBManager

+(instancetype)manager
{
    static DBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBManager alloc] init];
    });
    return manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        NSString *path = [NSString stringWithFormat:@"%@/Documents/Model.sqlite",NSHomeDirectory()];
        
        self.fm = [[FMDatabase alloc] initWithPath:path];
        
        if (self.fm) {
            [self.fm open];
            [self createTable];
        }

        
    }
    return self;
}

-(void)createTable
{
    NSString *sql = @"create table if not exists appInfo(serial integer  Primary Key Autoincrement,appName Varchar(1024),iconUrl Varchar(1024),appID Varchar(1024),appChanalID Varchar(1024))";
    
    
    [self.fm executeUpdate:sql];

}

#pragma mark ---------------------功能
- (void)add:(AppModel *)model
{
    NSString *sql = @"insert into appInfo(appName,iconUrl,appID,appChanalID) values (?,?,?,?)";
    
    [self.fm executeUpdate:sql,model.article_title,model.article_pic,model.article_id,model.article_channel_id];
}

-(void)deletewithTitle:(NSString *)ID
{
    NSString *sql  =@"delete from appInfo where appID = ?";
    [self.fm executeUpdate:sql,ID];
}

-(NSArray *)getAllInfo
{
    FMResultSet *result = [self.fm executeQuery:@"select * from appInfo"];
    NSMutableArray *allAry = [[NSMutableArray alloc] init];
    while ([result next]) {
        AppModel *model = [[AppModel alloc] init];
        model.article_title = [result stringForColumn:@"appName"];
        model.article_pic = [result stringForColumn:@"iconUrl"];
        model.article_id = [result stringForColumn:@"appID"];
        model.article_channel_id= [result stringForColumn:@"appChanalID"];
        [allAry addObject:model];
    }
    return  allAry;
}

-(BOOL)selectWithTitle:(NSString *)title
{
    NSString *sql = @"select * from appInfo where appName = ?";
    FMResultSet *result = [self.fm executeQuery:sql,title];
    if ([result next]) {
        return YES;
    }else{
        return NO;
    }
}
@end
