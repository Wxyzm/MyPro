//
//  MyNeedsModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyNeedsModel.h"

@implementation MyNeedsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"needsId": @"id",@"goodsDescription":@"description"};
}

@end
