//
//  AcceptAdressPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/3.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AcceptAdressPL : NSObject


/**
 新增地址
 @param adressDic 地址字典
 @param returnBlock success
 @param errorBlock flase
 */
+ (void)addAcceptAdressWithDic:(NSDictionary *)adressDic withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;


/**
 获取所有地址

 @param returnBlock 成功
 @param errorBlock 失败
 */
+ (void)getUserAllAdresswithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

/**
 设置某个地址为默认地址
 @param adressId 地址id
 @param returnBlock success
 @param errorBlock flase
 */
+ (void)defaultAcceptAdressWithAdressid:(NSString *)adressId withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

/**
 删除某收货地址
 @param adressId 地址id
 @param returnBlock success
 @param errorBlock flase
 */
+ (void)deleteAcceptAdressWithAdressid:(NSString *)adressId withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

/**
 更新收货地址
 @param adressId 地址id
 @param returnBlock success
 @param errorBlock flase
 */
+ (void)editAcceptAdressWithAdressid:(NSString *)adressId andDic:(NSDictionary *)dic withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;


@end
