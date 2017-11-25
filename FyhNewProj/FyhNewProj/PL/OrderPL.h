//
//  OrderPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/13.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderPL : NSObject


/**
 买家获取他的ItemOrder

 @param infoDic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BuyersGetItemOrderWithinfoDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;

/**
 买家获取他的UserOrder
 
 @param infoDic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BuyersGetUserOrderWithinfoDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;

/**
 买家获取他按照卖家分组后的ItemOrder
 
 @param infoDic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BuyersGetgroupitemordersWithinfoDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;


/**
 买家获取相关商品订单数目数据
 
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BuyersGetordercountsWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;




/**
 买家取消某个UserOrder
 
 
 
 @param orderId 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BuyersCancleOrderWithorderID:(NSString *)orderId
                         ReturnBlock:(PLReturnValueBlock)returnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorBlick;

/**
 买家批量确认收货

 @param infoDic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BuyersmakeSureAcceptedGoodsWithinfoDic:(NSDictionary *)infoDic
                                   ReturnBlock:(PLReturnValueBlock)returnBlock
                                 andErrorBlock:(PLErrorCodeBlock)errorBlick;

/**
 买家删除某个UserOrder
 
 @param orderId 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BuyersDeleteOrderWithorderID:(NSString *)orderId
                         ReturnBlock:(PLReturnValueBlock)returnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorBlick;
#pragma mark ======= 卖家


/**
 卖家获取相关商品订单数目数据
 
 @param returnBlock success
 @param errorBlick error
 */
+ (void)SellerGetordercountsWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;

/**
 卖家获取分组后的商品订单
 
 @param infoDic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)SellerGetGroupItemOrderWithinfoDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;


/**
 卖家添加物流信息并发货
 
 @param infoDic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)SellerupdatelogisticsItemWithinfoDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;




@end
