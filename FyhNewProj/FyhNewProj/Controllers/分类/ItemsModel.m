//
//  ItemsModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/22.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ItemsModel.h"

@implementation ItemsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"itemId": @"id"};
}

@end
