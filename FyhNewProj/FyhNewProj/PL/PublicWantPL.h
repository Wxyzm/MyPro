//
//  PublicWantPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicWantPL : NSObject

#pragma mark - 公共页面查看采购需求
+ (void)PublicgetPurchasingNeedlistWithdic:(NSDictionary *)dic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 公共页面查看采购需求详情
+ (void)PublicgetGtPurchasingNeedDetailWithneedId:(NSString *)needId ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark - 供应商创建报价
+ (void)PublicSellerSubmitPriceWithDic:(NSDictionary *)dic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;


#pragma mark - 用户查看采购需求详情包括供应商的报价
+ (void)UserLookHisNeedwithPricewithId:(NSString *)needId
                       WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                         andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


#pragma mark - 采购者接受供应商的报价
+ (void)UserAcceptNeedwithPricewithId:(NSString *)needId
                      WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                        andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 供应商获取他报过的价
+ (void)SellerLookHisNeedwithPricewithDic:(NSDictionary *)infoDic
                          WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                            andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 供应商删掉他已经被接受的报价
+ (void)SellerDeleteHisNeedwithPricewithDic:(NSString *)needId
                            WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;

#pragma mark - 供应商获取他某个报价详情
+ (void)SellerGetHisNeedDetailwithDic:(NSString *)needId
                            WithReturnBlock:(PLReturnValueBlock)ReturnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;



@end
