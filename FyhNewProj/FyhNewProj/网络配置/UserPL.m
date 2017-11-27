//
//  UserPL.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UserPL.h"
#import "Token.h"
#import "User.h"
@interface UserPL()
@property (nonatomic,strong)User *user;

@end

@implementation UserPL
static UserPL *sharedManager = nil;
+(UserPL *)shareManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc]init];
        sharedManager.user = [[User alloc]init];
        sharedManager.token = [[Token alloc] init];
        [sharedManager registerDefaults];
    });
    return sharedManager;
    
}

/**
 *  初始化 registerDefaults方法调用时会check NSUserDefaults里是否已经存在了相同的key，如果有则不会把其覆盖。
 */
- (void)registerDefaults{
    NSDictionary *dictionary = @{FYH_USER_ID:@"",FYH_USER_NAME:@"",FYH_USER_ACCOUNT:@"",FYH_USER_PASSWORD:@"",FYHSessionId:@"",FYH_SING_IN:@""};
    [[NSUserDefaults standardUserDefaults]registerDefaults:dictionary];
    
}


/**
 *  加载本地用户数据
 */
- (void)loadUser {
    _user.username  = [[NSUserDefaults standardUserDefaults]objectForKey:FYH_USER_ACCOUNT];
    _user.password  = [[NSUserDefaults standardUserDefaults]objectForKey:FYH_USER_PASSWORD];
}



/**
 *  存入本地
 */
- (void)writeUser{
    [[NSUserDefaults standardUserDefaults]setObject:_token.sessionId forKey:FYHSessionId];
    [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:FYH_SING_IN];
    [[NSUserDefaults standardUserDefaults]setObject:_user.username forKey:FYH_USER_ACCOUNT];
    [[NSUserDefaults standardUserDefaults]setObject:_user.password forKey:FYH_USER_PASSWORD];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

/**
 退出登录
 */
- (void)logout{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FYHSessionId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FYH_SING_IN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FYH_USER_ACCOUNT];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FYH_USER_PASSWORD];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FYH_RC_Token];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FYH_USER_ID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FYHSubSession];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FYHLoginSubSession];

    [[RCIM sharedRCIM]disconnect:NO];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


-(void)userLoginWithReturnBlock:(PLReturnValueBlock)returnBlock withErrorBlock:(PLErrorCodeBlock)errorBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    [client userLoginName:_user.username Password:_user.password withReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
        if ([dic[@"code"] intValue]==-1) {
           
            NSDictionary *dataDic = dic[@"data"];
            _token.sessionId = dataDic[@"sessionId"];
            [self writeUser];
//            [GlobalMethod connectRongCloud];
            returnBlock(@"");
        }else {
           errorBlock(dic[@"message"]);
        }
    } andErrorBlock:^(NSString *msg) {
        errorBlock(@"出错啦，请稍后再试");  
    }];
}
-(void)registMenberWithInfoDic:(NSDictionary *)infoDic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
//    HTTPClient *client = [HTTPClient sharedHttpClient];
//    [client POST:@"/gateway?api=userRegister" dict:infoDic success:^(NSDictionary *resultDic) {
//        //  NSLog(@"注册成功%@",resultDic[@"data"]);
//        if ([resultDic[@"code"] intValue]==0) {
//            User *user = [User mj_objectWithKeyValues:resultDic[@"data"]];
//            _userName = infoDic[@"mobile"];
//            _userpwd = infoDic[@"password"];
//            [self setUser:user];
//            NSLog(@"sessionId==========%@",user.sessionId);
//            NSLog(@"sessionCookieOption==========%@",user.sessionCookieOption);
//            [self writeUser];
//            returnBlock(resultDic[@"data"]);
//        }else{
//            errorBlock(resultDic[@"message"]);
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        errorBlock(@"网络错误请稍后再试");
//    }];
    
    
}


/**
 通过短信验证那登录
 
 @param codeDic 短信验证码
 @param returnBlock returnBlock description
 @param errorBlock errorBlock description
 */
- (void)userLoginWithCodeDic:(NSDictionary *)codeDic andReturnBlock:(PLReturnValueBlock)returnBlock withErrorBlock:(PLErrorCodeBlock)errorBlock{
     HTTPClient *client = [HTTPClient sharedHttpClient];
    [client userCodeLoginWithDic:codeDic hReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
        if ([dic[@"code"] intValue]==-1) {
            
            NSDictionary *dataDic = dic[@"data"];
            _token.sessionId = dataDic[@"sessionId"];
            [[NSUserDefaults standardUserDefaults]setObject:_token.sessionId forKey:FYHSessionId];
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:FYH_SING_IN];
            [[NSUserDefaults standardUserDefaults]setObject:codeDic[@"mobileNumber"] forKey:FYH_USER_ACCOUNT];
            [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"password"] forKey:FYH_USER_PASSWORD];
            [[NSUserDefaults standardUserDefaults]synchronize];
            returnBlock(@"");
        }else {
            errorBlock(dic[@"message"]);
        }
    } andErrorBlock:^(NSString *msg) {
        errorBlock(msg);
   
    }];
    
    
    
    
}


- (NSString*)getToken {
    return _token.sessionId;
}


- (void)setUserData:(User *)user
{
    
    _user = user;
    
}

-(User *)getLoginUser{
    User *user = [[User alloc]init];
    user.username = [[NSUserDefaults standardUserDefaults]objectForKey:FYH_USER_ACCOUNT];
    user.password = [[NSUserDefaults standardUserDefaults]objectForKey:FYH_USER_PASSWORD];
    return user;
}

- (BOOL)userIsLogin{

    NSUserDefaults *userdefauls =[NSUserDefaults standardUserDefaults];
    if ([userdefauls objectForKey:FYHSessionId]&&![[userdefauls objectForKey:FYHSessionId] isEqualToString:@""]&&![[userdefauls objectForKey:FYHSessionId] isEqualToString:@"xxx"]) {
        NSLog(@"FYHSessionId:%@",[userdefauls objectForKey:FYHSessionId]);
        return YES;
    }else{
        NSLog(@"FYHSessionId:%@",[userdefauls objectForKey:FYHSessionId]);
        return NO;
    }
}


@end
