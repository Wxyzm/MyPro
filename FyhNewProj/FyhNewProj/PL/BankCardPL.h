//
//  BankCardPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/9/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankCardPL : NSObject

/**
 获取用户银行卡

 @param returnBlock returnBlock description
 @param errorBlcok errorBlcok description
 */
+ (void)userGetBankCardWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok;

/**
 添加银行卡

 @param dic 参数
 @param returnBlock returnBlock description
 @param errorBlcok errorBlcok description
 */
+ (void)userAddBankCardWithinfoDic:(NSDictionary *)dic WithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok;

/**
 删除用户银行卡
 
 @param returnBlock returnBlock description
 @param errorBlcok errorBlcok description
 */
+ (void)userDeleteHisBankCardWithId:(NSString *)cardId WithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok;


/**
 获取账单
 
 @param returnBlock returnBlock description
 @param errorBlcok errorBlcok description
 */
+ (void)userGetbillrecordWithinfoDic:(NSDictionary *)dic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok;


/**
 获取余额
 
 @param returnBlock returnBlock description
 @param errorBlcok errorBlcok description
 */
+ (void)userGetbalanceWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok;


/**
用户发起提现请求
 
 @param returnBlock returnBlock description
 @param errorBlcok errorBlcok description
 */
+ (void)userDrawalRequestWithDic:(NSDictionary *)dic withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok;

/**
 用户查看提现请求记录
 
 @param returnBlock returnBlock description
 @param errorBlcok errorBlcok description
 */
+ (void)userCheckDrawalRequestListWithDic:(NSDictionary *)dic withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok;




@end
