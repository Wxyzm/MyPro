//
//  GoodsPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/3.
//  Copyright © 2017年 fyh. All rights reserved.
//

//商品相关

#import <Foundation/Foundation.h>

@interface GoodsPL : NSObject

//分类商品分类类目
+ (void)getGoodsCategorywithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;

//发布商品分类类目
+ (void)getFabuGoodsCategorywithReturnBlock:(PLReturnValueBlock)ReturnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorCodeBlock;


@end
