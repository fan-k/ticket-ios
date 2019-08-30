//
//  UserInfo.m
//  FanProduct
//
//  Created by 99epay on 2019/6/12.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (instancetype)shareInstance{
    static UserInfo *userinfo;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userinfo = [UserInfo new];
    });
    return userinfo;
}
- (instancetype)init{
    self = [super init];
    self.userModel = [UserInfo readUserInfo];
    return self;
}
- (BOOL)isLogin{
    return [UserInfo shareInstance].userModel;
}
- (NSString *)token{
    return [UserInfo shareInstance].userModel.token;
}

+ (UserModel *)readUserInfo{
    // 从本地获取.
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfoModelpath"];
    
    // data.
    NSData *data = [NSData dataWithContentsOfFile:file];
    
    // 反归档.
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    // 获取@"model" 所对应的数据
    UserModel *models = [unarchiver decodeObjectForKey:@"userModel"];
    
    // 反归档结束.
    [unarchiver finishDecoding];
    if (models) {
        return models;
    }else
        return nil;
}
+ (void)saveUserInfo{
    if ([UserInfo shareInstance].userModel) {
        // 创建归档时所需的data 对象.
        NSMutableData *data = [NSMutableData data];
        
        // 归档类.
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        
        // 开始归档（@"model" 是key值，也就是通过这个标识来找到写入的对象）.
        [archiver encodeObject:[UserInfo shareInstance].userModel forKey:@"userModel"];
        
        // 归档结束.
        [archiver finishEncoding];
        
        // 写入本地（@"weather" 是写入的文件名.
        NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfoModelpath"];
        BOOL ddd = [data writeToFile:file atomically:YES];
        if (ddd) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserInfoChanged object:nil];
        }
        [FanWallet updateWalletWithCompleteBlock:nil];
    }
}
+ (void)clearUserInfo{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfoModelpath"];
    [defaultManager removeItemAtPath:file error:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationUserInfoChanged object:nil];
}
+ (void)logout{
    [UserInfo shareInstance].userModel = nil;
    [UserInfo clearUserInfo];
}
+ (BOOL)VerificationLogin:(void (^)())loginBlock closeblock:(void (^)())closeBlock animate:(BOOL)animate{
    if ([UserInfo shareInstance].isLogin) {
        if (loginBlock) {
            loginBlock();
        }
        return YES;
    }else{
        //去登陆
        [MainRootViewController() presentViewControllerWithUrl:@"ticket://LoginController" transferData:nil hander:^(id obj, int idx) {
            if (idx == cat_login_success) {
                if (loginBlock) {
                    loginBlock();
                }
            }else{
                if (closeBlock) {
                    closeBlock();
                }
            }
           
        }];
        return NO;
    }
}
+ (void)updateUserInfoWithCompleteBlock:(void(^)())completeBlock{
    //已登录的情况下去更新用户  未登录不更新
    if ([UserInfo shareInstance].isLogin) {
        FanRequestItem *item = [FanRequestItem new];
        item.url = FanUrlUserDetail;
        item.params[@"token"] = [UserInfo shareInstance].userModel.token;
        item.completeBlock = ^(FanRequestItem *complteItem) {
            //code 10001 用户信息失效
            if ([DICTION_OBJECT(complteItem.responseObject, @"code") isEqualToString:@"1001"]) {
                [UserInfo logout];
            }else if ([DICTION_OBJECT(complteItem.responseObject, @"code") isEqualToString:@"1"]){
                UserModel *model = [UserModel modelWithJson:DICTION_OBJECT(complteItem.responseObject, @"data")];
                if (model) {
                    [UserInfo shareInstance].userModel = model;
                    [UserInfo saveUserInfo];
                    //更新钱包信息
                    [FanWallet updateWalletWithCompleteBlock:nil];
                }
            }
            if (completeBlock) {
                completeBlock();
            }
        };
        [item startRequest];
       
    }else{
        if (completeBlock) {
            completeBlock();
        }
    }
}
@end


@implementation UserModel

+ (instancetype)subModelWithJson:(NSDictionary *)json{
    UserModel *model = [UserModel new];
    model.userId = DICTION_OBJECT(json, @"userId");
    model.token = DICTION_OBJECT(json, @"token");
    model.name = DICTION_OBJECT(json, @"name");
    model.photo = DICTION_OBJECT(json, @"photo");
    model.sex = DICTION_OBJECT(json, @"sex");
    model.adress = DICTION_OBJECT(json, @"adress");
    model.phone = DICTION_OBJECT(json, @"phone");
    model.birthday = DICTION_OBJECT(json, @"birthday");
    return model;
}

@end
