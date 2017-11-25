//
//  GoodsLvTwoModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/3.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "GoodsLvTwoModel.h"
#import "GoodsLvThreeModel.h"

@implementation GoodsLvTwoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"categoryId": @"id"};
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"threeModelArr":@"GoodsLvThreeModel",
           
             };
}
@end
