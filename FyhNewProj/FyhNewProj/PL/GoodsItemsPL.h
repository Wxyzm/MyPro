//
//  GoodsItemsPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/22.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsItemsPL : NSObject

#pragma mark - 公共页面获取已经上架的商品
+ (void)GETGoodsIetmsWithDic:(NSDictionary *)dic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 公共页面获取某个的商品数据
+ (void)GETGoodsDetailWithGoodsId:(NSString *)GoodsId ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 添加一个商品到购物车
+ (void)AddGoodsIntoBuyCartWithGoodsInfo:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;


#pragma mark - 获取用户创建的商品
+ (void)UserGetCreatedGppdsWithGoodsInfo:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;


#pragma mark - 删除创建的商品
+ (void)userDeleteGoodsWithGoodsid:(NSString *)goodsId ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 修改商品上架
+ (void)userUpGoodsWithGoodsid:(NSString *)goodsId ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 修改商品下架
+ (void)userDownGoodsWithGoodsid:(NSString *)goodsId ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 获取要被修改更新的商品数据
+ (void)getEditGoodsInfoWithId:(NSString *)goodsId andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 获取用户创建的商品
+ (void)UserGetHisMasterProWithGoodsInfo:(NSDictionary *)infoDic
                             ReturnBlock:(PLReturnValueBlock)returnBlock
                           andErrorBlock:(PLErrorCodeBlock)errorBlock;
#pragma mark - 获取库存警报的产品
+ (void)UserGetHisInventoryAlertProductwithInfoDic:(NSDictionary *)infodic
                                    ReturnBlock:(PLReturnValueBlock)ReturnBlock
                                  andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 产品上架
+ (void)UserOnSaleProductwithIProId:(NSString *)ProId
                        ReturnBlock:(PLReturnValueBlock)ReturnBlock
                    andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark -产品下架
+ (void)UserNotSaleProductwithIProId:(NSString *)ProId
                        ReturnBlock:(PLReturnValueBlock)ReturnBlock
                      andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark -产品删除
+ (void)UserDeleteProductwithIProId:(NSString *)ProId
                         ReturnBlock:(PLReturnValueBlock)ReturnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 批量产品加入样品间
+ (void)UserbatchsetissamplewithInfo:(NSDictionary *)infoDic
                        ReturnBlock:(PLReturnValueBlock)ReturnBlock
                      andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 批量产品移出样品间
+ (void)UserbatchsetnotsamplewithInfo:(NSDictionary *)infoDic
                          ReturnBlock:(PLReturnValueBlock)ReturnBlock
                        andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;
#pragma mark - 获取某个产品信息
+ (void)UserGetHisMasterProDETAILWithProId:(NSString *)proId
                               ReturnBlock:(PLReturnValueBlock)returnBlock
                             andErrorBlock:(PLErrorCodeBlock)errorBlock;

@end
