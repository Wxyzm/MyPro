//
//  YzmPL.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/6.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "YzmPL.h"
#import "UserPL.h"
@implementation YzmPL

-(void)sentSMSWithPhoneNumber:(NSString *)phoneNumber withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:FYHSessionId];
    HTTPClient *client = [HTTPClient sharedHttpClient];
//    NSDictionary *phonedic = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"mobile", nil] ;
    [client POST:@"/gateway?api=sendUserRegisterSMS" dict:@{@"mobile":phoneNumber} success:^(NSDictionary *resultDic) {
        NSLog(@"短信发送接口调用成功%@",resultDic[@"data"]);
        if ([resultDic[@"code"] intValue]==0) {
            
            returnBlock(resultDic[@"data"]);
        }else{
            errorBlock(resultDic[@"message"]);
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(@"网络错误请稍后再试");
    }];

}


/**
 发送找回密码短信请求
 
 @param phoneNumber 电话
 @param returnBlock 成功回调
 @param errorBlock 失败回调
 */
- (void)sentSMSForLookBacrPassWordWithPhoneNumber:(NSString *)phoneNumber withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
   // [[NSUserDefaults standardUserDefaults]setObject:nil forKey:FYHSessionId];
    HTTPClient *client = [HTTPClient sharedHttpClient];
    //    NSDictionary *phonedic = [NSDictionary dictionaryWithObjectsAndKeys:phoneNumber,@"mobile", nil] ;
    [client POST:@"/gateway?api=sendUserResetPasswordSMS" dict:@{@"mobile":phoneNumber} success:^(NSDictionary *resultDic) {
        NSLog(@"短信发送接口调用成功%@",resultDic[@"data"]);
        if ([resultDic[@"code"] intValue]==0) {
            
            returnBlock(resultDic[@"data"]);
        }else{
            errorBlock(resultDic[@"message"]);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        errorBlock(@"网络错误请稍后再试");
    }];
    
}



@end
