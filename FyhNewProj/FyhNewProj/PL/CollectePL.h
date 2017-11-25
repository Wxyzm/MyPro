//
//  CollectePL.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/5.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectePL : NSObject

/**
 收藏某个店铺

 @param dic 店铺的卖家sellerIdDic
 @param returnBlock 成功
 @param errorBlick 失败
 */
+ (void)userCollecteShopWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;

/**
 取消收藏某个店铺
 
 @param dic 店铺的卖家sellerIdDic
 @param returnBlock 成功
 @param errorBlick 失败
 */
+ (void)userCancleCollecteShopWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;

/**
 获取用户的商品收藏
 

 
 @param dic 店铺的卖家sellerIdDic
 @param returnBlock 成功
 @param errorBlick 失败
 */
+ (void)GetUserGoodsCollecteShopWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;





/**
 收藏某个商品

 @param goodId 商品id
 @param returnBlock 成功
 @param errorBlick 失败
 */
+ (void)userCollectGoodsWithGoodsId:(NSString *)goodId ndReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;

/**
 删除某个收藏商品
 
 @param goodId 商品id
 @param returnBlock 成功
 @param errorBlick 失败
 */
+ (void)userCancleCollectGoodsWithGoodsId:(NSString *)goodId ndReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;


/**
 获取用户收藏的店铺


@param dic 店铺的卖家sellerIdDic
@param returnBlock 成功
@param errorBlick 失败
*/
+ (void)GetUserShopsCollecteShopWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;





@end
