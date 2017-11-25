//
//  PayPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/3.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayPL : NSObject



/**
 对某个商品结算创建订单-立即购买
 
 @param dic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)payAtOnceWithId:(NSString *)proId andDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;

/**
 从购物车开始结算创建订单
 
 @param dic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)payForShopCartWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;

/**
 支付宝支付

 @param orderId orderid
 @param returnBlock success
 @param errorBlick error
 */
+ (void)ailPayWithOrderId:(NSString *)orderId andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;

/**
 微信支付
 
 @param orderId orderid
 @param returnBlock success
 @param errorBlick error
 */
+ (void)weixinPayWithOrderId:(NSString *)orderId andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;


@end
