//
//  YzmPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/3/6.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YzmPL : NSObject


/**
 发送注册短信请求

 @param phoneNumber 电话
 @param returnBlock 成功回调
 @param errorBlock 失败回调
 */
- (void)sentSMSWithPhoneNumber:(NSString *)phoneNumber withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

/**
 发送找回密码短信请求
 
 @param phoneNumber 电话
 @param returnBlock 成功回调
 @param errorBlock 失败回调
 */
- (void)sentSMSForLookBacrPassWordWithPhoneNumber:(NSString *)phoneNumber withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;



@end
