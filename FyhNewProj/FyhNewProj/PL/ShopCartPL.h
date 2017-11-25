//
//  ShopCartPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/27.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCartPL : NSObject

#pragma mark - 获取购物车数据
+ (void)getUserShopCartDataswithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark -删除购物车里的某个商品
+ (void)DeleteShopCartItemsWithItemId:(NSString *)itemId andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark -修改购物车某个商品的数量
+ (void)ChangeShopCartItemsWithItemId:(NSString *)itemStr andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;



@end
