//
//  FanDataBase.m
//  FanProduct
//
//  Created by 99epay on 2019/7/3.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanDataBase.h"


@interface FanDataBase ()
@property (nonatomic ,strong) FMDatabase *database;
@end
@implementation FanDataBase

+ (instancetype)shareInstance{
    static FanDataBase *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[FanDataBase alloc] init];
    });
    return tool;
}
#pragma mark - 初始化数据库
-(instancetype)init{
    self = [super init];
    if (self) {
        NSString *filePath = [self getFilePathWithFileName:@"TheTicket.db"];
        self.database = [[FMDatabase alloc]initWithPath:filePath];
        if ([self.database open]) {
            [self initCollectTable];
            [self initHistoryTable];
            DEF_DEBUG(@">>TheTicket.db Open the database successfully");
        }else{
            DEF_DEBUG(@">>TheTicket.db Open the database fail");
        }
    }
    return self;
}
#pragma mark - 获取数据库的路径
- (NSString *)getFilePathWithFileName:(NSString *)fileName{
    NSString *path = NSHomeDirectory();
    NSString *documentsPath = [path stringByAppendingPathComponent:@"/Documents"];
    DEF_DEBUG(@"路径为:%@",documentsPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:documentsPath]) {
        return [documentsPath stringByAppendingFormat:@"/%@",fileName];
    }else{
        DEF_DEBUG(@"路径不存在");
        return nil;
    }
}


#pragma mark -- 收藏
- (void)initCollectTable{
    NSString *sql = @"create table if not exists CollectTable (id integer not null primary key autoincrement,collectid text,title text, picture text ,url text,star text ,sellCount text,distance text ,score text,recommend text ,price text)";
    BOOL isSuccess = [self.database executeUpdate:sql];
    if (isSuccess) {
        DEF_DEBUG(@"create CollectTable success ！");
    }else
        DEF_DEBUG(@"create CollectTable failed %@ ！",[self.database lastError]);
}
- (BOOL)selectedCollectWidthId:(NSString *)collectId{
    if (![self.database open]) {
        DEF_DEBUG(@">>FirstGold Open the database fail");
        return NO;
    }
    BOOL isCollect = NO;
    NSString *sql = @"select * from CollectTable where collectid = ?";
    if ([self.database open]) {
        FMResultSet *set = [self.database executeQuery:sql,collectId];
        while ([set next]) {
            isCollect = YES;
        }
        [set close];//关闭结果集
    }
    return isCollect;
}
- (BOOL)insertCollectWidthId:(NSString *)collectId title:(nonnull NSString *)title picture:(nonnull NSString *)picture url:(nonnull NSString *)url star:(nonnull NSString *)star sellCount:(nonnull NSString *)sellCount distance:(nonnull NSString *)distance score:(nonnull NSString *)score recommend:(nonnull NSString *)recommend price:(nonnull NSString *)price{
    
    if (![self.database open]) {
        DEF_DEBUG(@">> Open the database fail");
        return NO;
    }
    NSString *sql = @"insert into CollectTable (collectid,title,picture,url,star,sellCount,distance,score,recommend,price) values(?,?,?,?,?,?,?,?,?,?)";
    BOOL isSuccess = [self.database executeUpdate:sql,collectId,title,picture,url,star,sellCount,distance,score,recommend,price];
    if (isSuccess) {
        DEF_DEBUG(@"insert success ! ! !");
        return YES;
    }else{
        DEF_DEBUG(@"insert failed ! %@",[self.database lastError]);
        return NO;
    }
}
- (BOOL)deleteCollectWidthId:(NSString *)collectId{
    if (![self.database open]) {
        DEF_DEBUG(@">>Open the database fail");
        return NO;
    }
    BOOL success =  [self.database executeUpdate:@"DELETE FROM CollectTable  WHERE collectid = ? ",collectId];
    if (success) {
        DEF_DEBUG(@"删除成功!");
        return YES;
    }else{
        DEF_DEBUG(@"删除失败!");
        return NO;
    }
}
- (NSArray *)selectAllCollect{
    if (![self.database open]) {
        DEF_DEBUG(@">> Open the database fail");
        return @[];
    }
    NSMutableArray *arr = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM CollectTable"];
    FMResultSet *set = [self.database executeQuery:sql];
    while ([set next]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"id"] = [set stringForColumn:@"collectid"];
        dict[@"title"] = [set stringForColumn:@"title"];
        dict[@"picture"] = [set stringForColumn:@"picture"];
        dict[@"url"] = [set stringForColumn:@"url"];
        dict[@"star"] = [set stringForColumn:@"star"];
        dict[@"sellCount"] = [set stringForColumn:@"sellCount"];
        dict[@"distance"] = [set stringForColumn:@"distance"];
        dict[@"score"] = [set stringForColumn:@"score"];
        dict[@"recommend"] = [set stringForColumn:@"recommend"];
        dict[@"price"] = [set stringForColumn:@"price"];
        [arr addObject:dict];
    }
    return arr;
}
- (BOOL)deleteAllCollect{
    if (![self.database open]) {
        DEF_DEBUG(@">>Open the database fail");
        return NO;
    }
    NSString *deleteSql = @"delete from CollectTable";
    BOOL isSuccess = [self.database executeUpdate:deleteSql];
    if (isSuccess) {
        NSLog(@"delete from CollectTable 成功" );
        return YES;
    }else{
        NSLog(@"delete from CollectTable 失败");
        return NO;
    }
}


#pragma mark -- 浏览记录
/**创建记录表*/
- (void)initHistoryTable{
    NSString *sql = @"create table if not exists HistoryTable (id integer not null primary key autoincrement,o_id text,title text, picture text ,url text,star text ,sellCount text,distance text ,score text,recommend text ,price text)";
    BOOL isSuccess = [self.database executeUpdate:sql];
    if (isSuccess) {
        DEF_DEBUG(@"create HistoryTable success ！");
    }else
        DEF_DEBUG(@"create HistoryTable failed %@ ！",[self.database lastError]);
}
/**查询记录*/
- (BOOL)selectedHistoryWidthId:(NSString *)Id{
    if (![self.database open]) {
        DEF_DEBUG(@">>FirstGold Open the database fail");
        return NO;
    }
    BOOL isCollect = NO;
    NSString *sql = @"select * from HistoryTable where o_id = ?";
    if ([self.database open]) {
        FMResultSet *set = [self.database executeQuery:sql,Id];
        while ([set next]) {
            isCollect = YES;
        }
        [set close];//关闭结果集
    }
    return isCollect;
}
/**取消记录*/
- (BOOL)deleteHistoryWidthId:(NSString *)Id{
    if (![self.database open]) {
        DEF_DEBUG(@">>Open the database fail");
        return NO;
    }
    BOOL success =  [self.database executeUpdate:@"DELETE FROM HistoryTable  WHERE o_id = ? ",Id];
    if (success) {
        DEF_DEBUG(@"删除成功!");
        return YES;
    }else{
        DEF_DEBUG(@"删除失败!");
        return NO;
    }
}
/**加入记录*/
- (BOOL)insertHistoryWidthId:(NSString *)Id
                       title:(NSString *)title
                     picture:(NSString *)picture
                         url:(NSString *)url
                        star:(NSString *)star
                   sellCount:(NSString *)sellCount
                    distance:(NSString *)distance
                       score:(NSString *)score
                   recommend:(NSString *)recommend
                       price:(NSString *)price{
    if (![self.database open]) {
        DEF_DEBUG(@">> Open the database fail");
        return NO;
    }
    NSString *sql = @"insert into HistoryTable (o_id,title,picture,url,star,sellCount,distance,score,recommend,price) values(?,?,?,?,?,?,?,?,?,?)";
    BOOL isSuccess = [self.database executeUpdate:sql,Id,title,picture,url,star,sellCount,distance,score,recommend,price];
    if (isSuccess) {
        DEF_DEBUG(@"insert success ! ! !");
        return YES;
    }else{
        DEF_DEBUG(@"insert failed ! %@",[self.database lastError]);
        return NO;
    }
}
/**删除所有的记录*/
- (BOOL)deleteAllHistory{
    if (![self.database open]) {
        DEF_DEBUG(@">>Open the database fail");
        return NO;
    }
    NSString *deleteSql = @"delete from HistoryTable";
    BOOL isSuccess = [self.database executeUpdate:deleteSql];
    if (isSuccess) {
        NSLog(@"delete from HistoryTable 成功" );
        return YES;
    }else{
        NSLog(@"delete from HistoryTable 失败");
        return NO;
    }
}
/**读取所有记录*/
- (NSArray *)selectAllHistory{
    if (![self.database open]) {
        DEF_DEBUG(@">> Open the database fail");
        return @[];
    }
    NSMutableArray *arr = [NSMutableArray array];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM HistoryTable"];
    FMResultSet *set = [self.database executeQuery:sql];
    while ([set next]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"id"] = [set stringForColumn:@"o_id"];
        dict[@"title"] = [set stringForColumn:@"title"];
        dict[@"picture"] = [set stringForColumn:@"picture"];
        dict[@"url"] = [set stringForColumn:@"url"];
        dict[@"star"] = [set stringForColumn:@"star"];
        dict[@"sellCount"] = [set stringForColumn:@"sellCount"];
        dict[@"distance"] = [set stringForColumn:@"distance"];
        dict[@"score"] = [set stringForColumn:@"score"];
        dict[@"recommend"] = [set stringForColumn:@"recommend"];
        dict[@"price"] = [set stringForColumn:@"price"];
        [arr addObject:dict];
    }
    return arr;
}
@end
