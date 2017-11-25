//
//  MasterProModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/13.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MasterProModel.h"
#import "GItemModel.h"
@implementation MasterProModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"masterId":@"id"};
}

+(NSDictionary *)mj_objectClassInArray{
    
    
    return @{
             @"itemList":@"GItemModel"
             
             };
}

@end
