//
//  GProductItemModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/23.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "GProductItemModel.h"
#import "UnitModel.h"

@implementation GProductItemModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ProductItemid": @"id"
             };
}
+ (NSDictionary *)objectClassInArray{
    return @{
             @"specificationValues" : @"UnitModel",
             };
}
@end
