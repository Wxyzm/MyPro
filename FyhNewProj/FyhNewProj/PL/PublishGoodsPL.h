//
//  PublishGoodsPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishGoodsPL : NSObject


/**
 批量创建规格

 @param infoDic json格式的规格数据
 @param returnBlock 成功
 @param errorBlock 失败
 */
+ (void)batchspecificationWithInfoDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;



/**
 创建商品

 @param infoDic 数据字典
 @param returnBlock 成功
 @param errorBlock 失败
 */
+ (void)newProductWithInfoDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;


/**
 从产品根据规格组合批量创建商品

 @param infoDic 数据字典
 @param returnBlock 成功
 @param errorBlock 失败
 */
+ (void)GenerateitemsWithInfoDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;


/**
 编辑产品

 @param infoDic 数据字典
 @param returnBlock 成功
 @param errorBlock 失败
 */
+ (void)changeProductWithInfoDic:(NSDictionary *)infoDic andid:(NSString *)itenId ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 修改更新商品数据
+ (void)updataGoodsInfoWithId:(NSString *)goodsId WithGoodsInfo:(NSDictionary *)infoDic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;
@end
