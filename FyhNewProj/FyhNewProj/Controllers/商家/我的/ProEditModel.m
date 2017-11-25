//
//  ProEditModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/16.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ProEditModel.h"

@implementation ProEditModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"ProId":@"id"};
}

+(NSDictionary *)mj_objectClassInArray{
    
    
    return @{
             @"items":@"GItemModel",
             @"itemsInCurrentSpecification":@"GItemModel",
             @"attributes":@"AttributesModel"
             };
}

@end
