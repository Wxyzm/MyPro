//
//  AdressModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "AdressModel.h"

@implementation AdressModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"addressid": @"id"};
}
@end
