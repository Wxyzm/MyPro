//
//  UserWantPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserWantPL : NSObject

#pragma mark - 获取采购需求的类目
+ (void)getUserCategorylistwithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 用户创建采购需求
+ (void)addGoodsWithDic:(NSDictionary *)goodsDic withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 用户查看他创建的采购
+ (void)userLookPurchasingneedWithDic:(NSDictionary *)needsDic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;
#pragma mark - 用户获取被编辑采购需求的数据
+ (void)userGetNeedWithNeedId:(NSString *)needId andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 用户删除他的采购需求
+ (void)userDeleteNeedWithNeedId:(NSString *)needId andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 用户编辑采购需求
+ (void)userEditNeedWithNeedId:(NSString *)needId andDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark -收藏某个采购需求
+ (void)userCollectNeedWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;
#pragma mark - 取消收藏某个采购需求
+ (void)userCancleCollectNeedWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;
#pragma mark - 获取用户收藏的采购需求
+ (void)getUserCollectNeedWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;
@end
