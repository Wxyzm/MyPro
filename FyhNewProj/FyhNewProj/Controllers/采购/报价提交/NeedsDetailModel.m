//
//  NeedsDetailModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/18.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "NeedsDetailModel.h"

@implementation NeedsDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"needid": @"id",@"NeedsDescription":@"description"};
}

@end
