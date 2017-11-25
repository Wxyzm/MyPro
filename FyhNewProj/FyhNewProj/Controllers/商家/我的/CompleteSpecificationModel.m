//
//  CompleteSpecificationModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "CompleteSpecificationModel.h"
#import "SpecificationModel.h"
@implementation CompleteSpecificationModel

+ (NSDictionary *)objectClassInArray

{
    
    return @{@"specification":[SpecificationModel class],
             @"specificationValueList":[SpecificationModel class]};
    
}
@end
