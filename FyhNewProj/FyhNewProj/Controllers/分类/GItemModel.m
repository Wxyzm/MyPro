//
//  GItemModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/23.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "GItemModel.h"

@implementation GItemModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"itemID": @"id"};
}

+(NSDictionary *)mj_objectClassInArray{
    
    
    return @{
             @"specificationValues":@"SpecificationModel"

             };
}


@end
