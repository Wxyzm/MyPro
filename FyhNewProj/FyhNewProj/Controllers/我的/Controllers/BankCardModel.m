//
//  BankCardModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BankCardModel.h"

@implementation BankCardModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"cardId": @"id"};
}
@end
