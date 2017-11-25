//
//  ShopCartDataModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/27.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ShopCartDataModel.h"
#import "ShopCartModel.h"

@implementation ShopCartDataModel

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"cartItems":@"ShopCartModel",
             
             };
}

-(instancetype)init{

    self = [super init];
    if (self) {
        if (!_cartItems) {
            _cartItems = [NSMutableArray arrayWithCapacity:0];
        }
    }
    return self;
}

@end
