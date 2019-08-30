//
//  FanDataBase.h
//  FanProduct
//
//  Created by 99epay on 2019/7/3.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface FanDataBase : NSObject

//单例
+ (instancetype)shareInstance;

#pragma mark -- 收藏
/**创建收藏表*/
- (void)initCollectTable;
/**查询收藏*/
- (BOOL)selectedCollectWidthId:(NSString *)collectId;
/**取消收藏*/
- (BOOL)deleteCollectWidthId:(NSString *)collectId;
/**加入收藏*/
- (BOOL)insertCollectWidthId:(NSString *)collectId
                       title:(NSString *)title
                     picture:(NSString *)picture
                         url:(NSString *)url
                        star:(NSString *)star
                   sellCount:(NSString *)sellCount
                    distance:(NSString *)distance
                       score:(NSString *)score
                   recommend:(NSString *)recommend
                       price:(NSString *)price;
/**删除所有的收藏*/
- (BOOL)deleteAllCollect;
/**读取所有收藏*/
- (NSArray *)selectAllCollect;

#pragma mark -- 浏览记录
/**创建记录表*/
- (void)initHistoryTable;
/**查询记录*/
- (BOOL)selectedHistoryWidthId:(NSString *)Id;
/**取消记录*/
- (BOOL)deleteHistoryWidthId:(NSString *)Id;
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
                       price:(NSString *)price;
/**删除所有的记录*/
- (BOOL)deleteAllHistory;
/**读取所有记录*/
- (NSArray *)selectAllHistory;


@end

NS_ASSUME_NONNULL_END
