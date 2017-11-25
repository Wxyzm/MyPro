//
//  ComponentModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/8.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ComponentModel.h"

@implementation ComponentModel
-(instancetype)init{
    
    self = [super init];
    if (self) {
        if (!_chenfenArr) {
            _chenfenArr = [NSMutableArray arrayWithCapacity:0];
        }
    }
    return self;
}

@end
