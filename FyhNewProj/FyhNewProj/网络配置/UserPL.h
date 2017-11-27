//
//  UserPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/3/4.
//  Copyright © 2017年 fyh. All rights reserved.
//



//用户登录session管理类
#import <Foundation/Foundation.h>
@class User;
@class Token;

@interface UserPL : NSObject


@property (nonatomic, strong) Token *token;                     //sessionid


/**
 *  创建单利管理类
 */
+ (UserPL *)shareManager;

/**
 *  设置用户数据
 *
 *  @param user user description
 */
- (void)setUserData:(User *)user;

/**
 *  用户登录
 */
- (void)userLoginWithReturnBlock:(PLReturnValueBlock)returnBlock withErrorBlock:(PLErrorCodeBlock)errorBlock;


/**
 通过短信验证那登录

 @param codeDic 短信验证码
 @param returnBlock returnBlock description
 @param errorBlock errorBlock description
 */
- (void)userLoginWithCodeDic:(NSDictionary *)codeDic andReturnBlock:(PLReturnValueBlock)returnBlock withErrorBlock:(PLErrorCodeBlock)errorBlock;

/**
 *  向本地写入用户信息
 */
- (void)writeUser;
/**
 *  用户注销
 */
- (void)logout;
/**
 *  获取登录的用户信息
 *
 *  @return 登录的用户
 */
- (User*)getLoginUser;
/**
 *  获取token
 *
 *  @return token
 */
- (NSString*)getToken;

/**
 注册用户
 
 @param infoDic 用户信息
 @param returnBlock 成功回调
 @param errorBlock 失败回调
 */
- (void)registMenberWithInfoDic:(NSDictionary *)infoDic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;


/**
 判断是否登录

 @return 是 或否
 */
- (BOOL)userIsLogin;


@end
