//
//  SpecificationListEditModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "SpecificationListEditModel.h"

@implementation SpecificationListEditModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"SpecificationListEditId":@"id"};
}

+(NSDictionary *)mj_objectClassInArray{
    
    
    return @{
           
             @"specificationValues":@"SpecificationModel"
             };
}
@end
