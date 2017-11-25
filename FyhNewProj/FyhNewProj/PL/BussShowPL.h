//
//  BussShowPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BussShowPL : NSObject

/**
 买家查看店铺信息
 @param shopId 参数id
 @param returnBlock success
 @param errorBlick error
 */
+ (void)GetShopInfoWithShopID:(NSString *)shopId andDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;

@end
