
//
//  UserInfo.h
//  FanProduct
//
//  Created by 99epay on 2019/6/12.
//  Copyright © 2019 樊康鹏. All rights reserved.
//

#import "FanObject.h"

NS_ASSUME_NONNULL_BEGIN

@class UserModel;

@interface UserInfo : FanObject
+ (instancetype)shareInstance;
@property (nonatomic ,assign) BOOL isLogin;
@property (nonatomic ,copy) NSString * token;
@property (nonatomic ,strong) UserModel *userModel;

+ (UserModel *)readUserInfo;
+ (void)saveUserInfo;
+ (void)clearUserInfo;
+ (void)logout;

/**
 验证登录 -- 未登录 直接跳转到登录 -- 登录后的回调
 
 @param loginBlock 登录成功的回调
 */
+ (BOOL)VerificationLogin:(void(^)())loginBlock closeblock:(void(^)())closeBlock animate:(BOOL)animate;

/**更新用户信息*/
+ (void)updateUserInfoWithCompleteBlock:(void(^)())completeBlock;
@end



@interface UserModel : FanModel
@property (nonatomic ,copy) NSString *token;
@property (nonatomic ,copy) NSString *userId;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *photo;
@property (nonatomic ,copy) NSString *sex;
@property (nonatomic ,copy) NSString *birthday;
@property (nonatomic ,copy) NSString *adress;
@property (nonatomic ,copy) NSString *phone;

/**本地照片*/
@property (nonatomic ,copy) NSString *photo_str;


/**用户绑定的游客信息*/
@property (nonatomic ,strong) NSMutableArray *TouristInfos;
@end
NS_ASSUME_NONNULL_END
