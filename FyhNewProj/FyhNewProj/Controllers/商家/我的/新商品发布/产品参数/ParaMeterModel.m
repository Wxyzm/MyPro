//
//  ParaMeterModel.m
//  FyhNewProj
//
//  Created by yh f on 2017/10/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ParaMeterModel.h"
#import "ComponentModel.h"
@implementation ParaMeterModel

-(instancetype)init{
    
    self = [super init];
    if (self) {
        if (!_ParaNameArr) {
            _ParaNameArr = [NSMutableArray arrayWithCapacity:0];
        }
        if (!_componentModel) {
            _componentModel = [[ComponentModel alloc]init];
        }
        if (!_ParaKind) {
            _ParaKind = @"";
            
        }
        if (!_inputValue) {
            _inputValue = @"";
        }
        if (!_twoValue) {
            _twoValue = @"";
        }
        if (!_twoUnit) {
            _twoUnit = @"";
        }
    }
    return self;
}


@end
